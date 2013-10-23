/*
// SLCircularProgress.m
// Created by sothic on 10/23/13.
//
// SLCircularProgress https://github.com/sothic/SLCircularProgress
//
// The MIT License (MIT)
//
// Copyright (c) 2013 sothic
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SLCircularProgress.h"
#import <CoreGraphics/CoreGraphics.h>

#define kRadiusOffset 10

#define CIRCULAR_FONT 50

#define FONT_ENGLISH @"HelveticaNeue-Light"


/** Math Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )



@interface SLCircularProgress ()
{
    UILabel *titleLabel;
}

@end

@implementation SLCircularProgress


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //Define the Font
        UIFont *font = [UIFont fontWithName:FONT_ENGLISH size:CIRCULAR_FONT];
        //Calculate font size needed to display percentage
        NSString *str = @"100%%";
        
        CGSize fontSize;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            
            fontSize = [str sizeWithFont:font];
        } else {
            fontSize = [str sizeWithAttributes:[NSDictionary dictionaryWithObject: font forKey: NSFontAttributeName]];
        }


        
      
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width  - fontSize.width) /2,
                                                                    (frame.size.height - fontSize.height) /2,
                                                                    fontSize.width,
                                                                    fontSize.height)];
        
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = font;

        [self addSubview:titleLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /***Drawing code***/
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    /*** draw the path***/
    
    //set the line width and cap
    CGContextSetLineWidth(context, self.pathWidth);
    CGContextSetLineCap(context, kCGLineCapButt);

    //define the middle point and radius
    CGPoint middlePoint;
	middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
	middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2;

    //define the path
	CGFloat radius = self.bounds.size.width/2 - kRadiusOffset ;
    CGContextAddArc(context, middlePoint.x, middlePoint.y, radius, 0, M_PI *2, 1);
    
    //Set the stroke color
    [self.pathColor setStroke];
    
    
    //draw
    CGContextDrawPath(context, kCGPathStroke);
    
    
    /***draw the progress***/
    
    //set the line width and cap
    CGContextSetLineWidth(context, self.progressWidth);
    CGContextSetLineCap(context, kCGLineCapButt);

    //define the draw track, start from the top
    CGContextAddArc(context, middlePoint.x, middlePoint.y, radius, -M_PI_2, self.percentage*M_PI*2 - M_PI_2, 0);

    //Set the stroke color
    [self.progressColor setStroke];
    
    //draw
    CGContextDrawPath(context, kCGPathStroke);
     
    
    //draw handle
    [self drawTheHandle:context];
}


-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //draw the shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    
    //Get the handle position
    CGPoint handleCenter =  [self pointFromAngle: self.thresholdPercentage * 360];
    handleCenter.x = handleCenter.x-self.progressWidth*2;
    handleCenter.y = handleCenter.y-self.progressWidth*2;
    
    //define the color to red
    [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] set];
    
    //draw handle
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, self.progressWidth*4, self.progressWidth*4));
    
    CGContextRestoreGState(ctx);
}


- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}


#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
    CGPoint endPoint = [touch locationInView:self];
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, endPoint, NO);
    int angle = floor(currentAngle)+90; //start from top, need add 90 degree
    
    //perform the delegate to store the threshold if needed
    if ([self.delegate respondsToSelector:@selector(moveThresholdEnd:)]) {
        [self.delegate moveThresholdEnd:angle/360.0f];
    }
}



#pragma mark - Math -
/** Move the Handle **/

-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angle = floor(currentAngle)+90;//start from top, need add 90 degree
    
    //Redraw
    self.thresholdPercentage = angle / 360.0f;
    [self setNeedsDisplay];
}

/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt{
    
    CGFloat radius = self.bounds.size.width/2 - kRadiusOffset ;
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y - radius * cos(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * sin(ToRad(angleInt)));
    
    return result;
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(v.x*v.x + v.y*v.y), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end


