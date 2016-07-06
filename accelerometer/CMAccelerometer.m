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
        }];
        
        
    } else {
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        toggleIsOn = NO;
        
        [_motionManager stopAccelerometerUpdates];
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"Hi");
//    NSString *insert = @"insert into touch_data values";
//    NSString *concat = [insert stringByAppendingString:NSLog(
    NSString *query = [NSString stringWithFormat:@"insert into touch_data values", [self timeStamp]];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        NSLog(@"%lld", self.dbManager.lastInsertedRowID);
        [self.dbManager copyDatabaseIntoDocumentsDirectory];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *todaysDate = [NSDate date];
    NSLog(@"Todays date is %@",[formatter stringFromDate:todaysDate]);
   
    

    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    
    
    
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
    NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
    
    
    NSLog([self timeStamp]);
    
}

- (NSString *) timeStamp {
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}

@end
