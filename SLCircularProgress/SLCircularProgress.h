/*
 // SLCircularProgress.h
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

#import <UIKit/UIKit.h>

@protocol SLCircularProgressDelegate <NSObject>

@optional

-(void)moveThresholdEnd:(float)percentage;

@end

@interface SLCircularProgress : UIControl


@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) float pathWidth;
@property (nonatomic, assign) float progressWidth;
@property (nonatomic, assign) float percentage;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) float thresholdPercentage;


@property (nonatomic, weak) id<SLCircularProgressDelegate> delegate;

@end
