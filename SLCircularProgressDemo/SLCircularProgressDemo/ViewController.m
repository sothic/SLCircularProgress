//
//  ViewController.m
//  SLCircularProgressDemo
//
//  Created by sothic on 10/23/13.
//
//

#import "ViewController.h"
#import "SLCircularProgress.h"

#define BACKGROUND_COLOR [UIColor colorWithRed:67/255.0f green:74/255.0f blue:87/255.0f alpha:1.0f]
#define LINE_COLOR [UIColor colorWithRed:89/255.0f green:206/255.0f blue:254/255.0f alpha:1.0f]
#define PATH_COLOR [UIColor colorWithRed:84/255.0f green:90/255.0f blue:101/255.0f alpha:1.0f]


@interface ViewController ()
{
    SLCircularProgress *cir;
    float progress;

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = BACKGROUND_COLOR;
 
    progress = 0.1;
    
    cir = [[SLCircularProgress alloc] initWithFrame:CGRectMake(20, 100, 280 ,280)];
    cir.backgroundColor = [UIColor clearColor];
    cir.pathColor = PATH_COLOR;
    cir.progressColor = LINE_COLOR;
    
    cir.percentage = progress;
    cir.title =[NSString stringWithFormat:@"%.f%%",progress*100];
    cir.pathWidth = 3.0f;
    cir.progressWidth = 4.0f;
    cir.thresholdPercentage = 0.9f;
    [self.view addSubview:cir];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPercentage:(id)sender {
    if (progress >= 1.0) {
        progress = 0;
    }
    
    progress = progress + 0.1f;
    
    cir.percentage = progress;
    
    cir.pathColor = PATH_COLOR;

    if (progress >= 0.8f) {
        cir.progressColor = [UIColor orangeColor];
        
    }else{
        cir.progressColor = LINE_COLOR;
    }
    cir.title =[NSString stringWithFormat:@"%.f%%",progress*100];
    cir.pathWidth = 3.0f;
    cir.progressWidth = 4.0f;
    cir.thresholdPercentage = 0.9f;
    
    [cir setNeedsDisplay];
    

}
@end
