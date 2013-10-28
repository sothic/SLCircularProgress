SLCircularProgress
==================

One circular progress with setting the threshold value

It provide to customize the line path color/width, progress path color/width, display title and draggable point which can control the threshold value in progress path.


![alt tag](https://raw.github.com/sothic/SLCircularProgress/master/SLCircularProgressDemo/SLCircularProgressDemo/capture.png)


## Installation

* Drag the `SLCircularProgress` folder into your project.
* Add the **QuartzCore** framework to your project.
* Import `SLCircularProgress.h`

## Usage

(see sample Xcode project in `/SLCircularProgressDemo`)

### Init the SLCircularProgress

```objective-c
SLCircularProgress *cir = [[SLCircularProgress alloc] initWithFrame:CGRectMake(20, 100, 280 ,280)];
```

### Set the thresholdPercentage and some properties in viewDidLoad

```objective-c
float progress = 0.1;
cir.pathColor = [UIColor lightGrayColor];
cir.progressColor = [UIColor greenColor];
cir.percentage = progress;
cir.title =[NSString stringWithFormat:@"%.f%%",progress*100];
cir.pathWidth = 3.0f;
cir.progressWidth = 4.0f;
cir.thresholdPercentage = 0.9f;
cir.delegate = self;
```

### Add protocal and delegate method in your viewcontroller
```objective-c
@interface ViewController : UIViewController<SLCircularProgressDelegate>
@end
```
```objective-c
-(void)moveThresholdEnd:(float)percentage
{
    NSLog(@"Percentage is %f", percentage);
}
```

