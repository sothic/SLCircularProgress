//
//  ViewController.h
//  SLCircularProgressDemo
//
//  Created by sothic on 10/23/13.
//
//

#import <UIKit/UIKit.h>
#import "SLCircularProgress.h"

@interface ViewController : UIViewController<SLCircularProgressDelegate>
- (IBAction)addPercentage:(id)sender;

@end
