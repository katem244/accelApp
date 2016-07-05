//
//  CMAccelerometer.m
//  CoreMotion
//
//  Created by Katerina on 6/27/16.
//  Copyright © 2016 Katerina Prastakou. All rights reserved.
//

#import "CMAccelerometer.h"
@import CoreMotion;
@import UIKit;
@import Foundation;
@import CoreData;

@interface CMAccelerometer ()
@property (nonatomic, strong) CMMotionManager * motionManager;
@property(readonly) CMAccelerometerData *returnedData;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation CMAccelerometer



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.motionManager.accelerometerUpdateInterval = 0.01;
//    [scroller1 setScrollEnabled:YES];
//    [scroller1 setContentSize:CGSizeMake(600, 600)];
//    NSLog(_textf.text);
//    [[NSFileManager defaultManager] createFileAtPath:@"/hi.txt" contents:nil attributes:nil];
//    NSString *str = @"hi";
//    [str writeToFile:@"/hi.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    if (![self.fileManager createFileAtPath:@"/foobar.txt" contents:nil attributes:nil])
//    {
//        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toggleButton:(id)sender {
    if (!toggleIsOn) {
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        toggleIsOn = YES;
        
        _motionManager = [[CMMotionManager alloc] init];
        
        NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
        
        [_motionManager startAccelerometerUpdatesToQueue:theQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            double x = _motionManager.accelerometerData.acceleration.x;
            double y = _motionManager.accelerometerData.acceleration.y;
            double z = _motionManager.accelerometerData.acceleration.z;
            
            NSLog(@"X: %.2f, Y: %.2f, Z: %.2f", x, y, z);
        }];
        
        
    } else {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        toggleIsOn = NO;
        
        [_motionManager stopAccelerometerUpdates];
        
        
    }
}

//- (IBAction)submit:(id)sender {
//    NSLog(_textf.text);
//}

-(void)logTouchesFor: (UIEvent*)event {
    int count = 1;
    
    for (UITouch* touch in event.allTouches) {
        CGPoint location = [touch locationInView: self.view];
        NSLog(@"%d: (%.0f, %.0f) \r", count, location.x, location.y);
        count++;
    }
}
//
//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *touch in touches) {
//        for (UITouch* coalescedTouch in [event coalescedTouchesForTouch:touch]) {
//            CGPoint newPoint = [coalescedTouch locationInView:self];
//        }
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
//    UITouch *touch = [touches allObjects];
    
//    CGPoint touchLocation = [touch locationInView:self];
    
//    NSLog(@"touch location is %f", touchLocation.x);
    NSLog(@"Hi");
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_textf resignFirstResponder];
    }
    //writing to a file
    
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
//    if (commonDictionaryPath = [thisBundle pathForResource:@"CommonDictionary" ofType:@"plist"])  {
//        theDictionary = [[NSDictionary alloc] initWithContentsOfFile:commonDictionaryPath];
//    }
    
    
    NSString *pathOfFile = [thisBundle pathForResource:@"myFile" ofType:@"txt"];
    NSString *dummyString = @"Hello World!!\n";
    NSFileManager *filemanager;
    
    filemanager = [NSFileManager defaultManager];
    
    //entering the first condition so I assured that the file do exists
//    if ([filemanager fileExistsAtPath:pathOfFile] == YES)
//        NSLog (@"File do exist !!!");
//    else
//        NSLog (@"File not found !!!");
//    
//    
//    BOOL writingStatus = [dummyString writeToFile:pathOfFile atomically:YES encoding:NSUnicodeStringEncoding error:nil];
    
    //Not entering this condition so I am assuming that writing process is successful but when I open the file I can't find the string hello world and file size shows 0 bytes
//    if(!writingStatus)
//    {
//        NSLog(@"Error: Could not write to the file");
//    }
    
}


@end
