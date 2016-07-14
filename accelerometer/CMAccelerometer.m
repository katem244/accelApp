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
#import "DBManager.h"

@interface CMAccelerometer ()
@property (nonatomic, strong) CMMotionManager * motionManager;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSManagedObject *object;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, readwrite, strong) DBManager *dbManager;
//@property double x;
//@property double y;
//@property double z;
@property double oldX;
@property double oldY;
@property double oldZ;
//@property double kUpdateFrequency;
//@property double cutOffFrequency;
//@property double dt;
//@property double RC;
//@property double alpha;
@end


@implementation CMAccelerometer
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"myDB.sql"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//- (id)init: (CMMotionManager *) manager{
//    self.motionManager = manager;
////    _x = 0.0;
////    _y = 0.0;
////    _z = 0.0;
////    _lastX = 0.0;
////    _lastY = 0.0;
////    _lastZ = 0.00;
//    self.kUpdateFrequency = 60.0;
//    self.cutOffFrequency = 5.0;
//    self.dt = 1.0 / _kUpdateFrequency;
//    self.RC = 1.0 / _cutOffFrequency;
//    self.alpha = _RC / (_dt+_RC);
////    return 0;
//}

- (IBAction)toggleButton:(id)sender {
    if (!toggleIsOn) {
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        toggleIsOn = YES;
        
        _motionManager = [[CMMotionManager alloc] init];
        
        NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
        
        _motionManager.accelerometerUpdateInterval = 0.02;
        
        [_motionManager startAccelerometerUpdatesToQueue:theQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            double x = _motionManager.accelerometerData.acceleration.x;
            double y = _motionManager.accelerometerData.acceleration.y;
            double z = _motionManager.accelerometerData.acceleration.z;
            
            
            NSLog(@"X: %.20f, Y: %.20f, Z: %.20f", x, y, z);

            NSString *xyz = [NSString stringWithFormat:@" %.7f , %.7f , %.7f)", x, y, z];
            
            NSTimeInterval timestamp =[[NSDate date] timeIntervalSince1970];
            
            NSString *query = @"insert into accel_data values('";
            query = [query stringByAppendingString:[NSString stringWithFormat:@"%.3f", timestamp]];
            query = [query stringByAppendingString:@"',"];
            query = [query stringByAppendingString:xyz];
            
            [self.dbManager executeQuery:query];

            if (self.dbManager.affectedRows != 0) {
                NSLog(@"%lld", self.dbManager.lastInsertedRowID);
                [self.dbManager copyDatabaseIntoDocumentsDirectory];
            }
            else{
                NSLog(@"Could not execute the query.");
            }

        }];
        
        
    } else {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        toggleIsOn = NO;
        
        [_motionManager stopAccelerometerUpdates];
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSTimeInterval timestamp =[[NSDate date] timeIntervalSince1970];
    
    NSString *query = @"insert into touch_data values('";
    query = [query stringByAppendingString:[NSString stringWithFormat:@"%.3f", timestamp]];
             
    query = [query stringByAppendingString:@"')"];
  
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"%lld", self.dbManager.lastInsertedRowID);
        [self.dbManager copyDatabaseIntoDocumentsDirectory];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

- (IBAction)deleteTouchData:(id)sender {
    NSString *query = [NSString stringWithFormat:@"Delete from touch_data"];
    [self.dbManager executeQuery:query];
}

- (IBAction)deleteAccelData:(id)sender {
    NSString *query = [NSString stringWithFormat:@"Delete from accel_data"];
    [self.dbManager executeQuery:query];
}



@end
