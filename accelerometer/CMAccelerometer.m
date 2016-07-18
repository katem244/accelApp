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
    
    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"touchData.txt"];

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
        
        _motionManager.accelerometerUpdateInterval = 0.02;
        
        [_motionManager startAccelerometerUpdatesToQueue:theQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            double x = _motionManager.accelerometerData.acceleration.x;
            double y = _motionManager.accelerometerData.acceleration.y;
            double z = _motionManager.accelerometerData.acceleration.z;
            
//            NSLog(@"X: %.20f, Y: %.20f, Z: %.20f", x, y, z);

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
    NSString *query = [NSString stringWithFormat:@"%.3f", timestamp];
    query = [query stringByAppendingString:@" "];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"touchData.txt"];
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
    [myHandle seekToEndOfFile];
    [myHandle writeData:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"touch");
    
}

- (IBAction)deleteTouchData:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;

    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"touchData.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&error];
    }
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];

}

- (IBAction)deleteAccelData:(id)sender {
    NSString *query = [NSString stringWithFormat:@"Delete from accel_data"];
    [self.dbManager executeQuery:query];
}



@end
