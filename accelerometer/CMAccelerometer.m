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
@end

@implementation CMAccelerometer
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"myDB.sql"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

            NSString *xyz = [NSString stringWithFormat:@"%.2f,%.2f,%.2f)", x, y, z];
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
            
            NSString *date = [DateFormatter stringFromDate:[NSDate date]];
            
            NSString *query = @"insert into accel_data values('";
            query = [query stringByAppendingString:date];
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
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
    
    NSString *date = [DateFormatter stringFromDate:[NSDate date]];
    
    NSString *query = @"insert into touch_data values('";
    query = [query stringByAppendingString:date];
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
