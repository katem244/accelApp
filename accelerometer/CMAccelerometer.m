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
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

//#import <XCTest/XCTest.h>



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
@property FMDatabaseQueue *queue;
@end


@implementation CMAccelerometer
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"myDB.sql"];
//    FMDatabase *db = [FMDatabase databaseWithPath:@"myDB.sql"];
    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:@"myDB.sql"];
//    [[NSFileManager defaultManager] createFileAtPath:@"/Users/kat/Documents/XCODE/adhd/accelerometer/accelerometer/touches.txt" contents:nil attributes:nil];
//
    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"myfile.txt"];

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
            
//            NSLog(@"X: %.20f, Y: %.20f, Z: %.20f", x, y, z);

            NSString *xyz = [NSString stringWithFormat:@" %.7f , %.7f , %.7f)", x, y, z];
            
            NSTimeInterval timestamp =[[NSDate date] timeIntervalSince1970];
            
            NSString *query = @"insert into accel_data values('";
            query = [query stringByAppendingString:[NSString stringWithFormat:@"%.3f", timestamp]];
            query = [query stringByAppendingString:@"',"];
            query = [query stringByAppendingString:xyz];
            
            [self.dbManager executeQuery:query];

            if (self.dbManager.affectedRows != 0) {
//                NSLog(@"%lld", self.dbManager.lastInsertedRowID);
                [self.dbManager copyDatabaseIntoDocumentsDirectory];
            }
            else{
                NSLog(@"Could not execute the query.");
            }

        }];
        
        
        
        // First, make your queue.
        
//        
//        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];
//        Then use it like so:
//        
//        [queue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
//            
//            FMResultSet *rs = [db executeQuery:@"select * from foo"];
//            while ([rs next]) {
//                …
//            }
//        }];
//        // An easy way to wrap things up in a transaction can be done like this:
//        
//        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
//            
//            if (whoopsSomethingWrongHappened) {
//                *rollback = YES;
//                return;
//            }
//            // etc…
//            [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:4]];
//        }];
//        
        
        
        
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
    query = [query stringByAppendingString:@"/n"];

//    sleep(1);
    
    
//    NSString *query = @"insert into touch_data values('";
//    query = [query stringByAppendingString:[NSString stringWithFormat:@"%.3f", timestamp]];
//             
//    query = [query stringByAppendingString:@"')"];
//  
//    [self.dbManager executeQuery:query];
//    
//    if (self.dbManager.affectedRows != 0) {
//        NSLog(@"%lld", self.dbManager.lastInsertedRowID);
//        [self.dbManager copyDatabaseIntoDocumentsDirectory];
////        if(err)
////        NSLog(@"hello there");
//    }
//    else{
//        NSLog(@"Could not execute the query.");
//    }
    
    NSError *error;
//    NSString *stringToWrite = @"";
//    static dispatch_once_t pred;
//    dispatch_once(&pred, ^{
//        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"myfile.txt"];
//    });

    
//    NSString *searchFilename = @"hello.pdf"; // name of the PDF you are searching for
////    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [paths objectAtIndex:0];
//    
//    
//    
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.lastPathComponent == %@", searchFilename];
//    NSArray *matchingPaths = [[[NSFileManager defaultManager] supbathsAtPath:filePath] filterUsingPredicate:predicate];
//    
//    NSLog(@"%@", matchingPaths);
//
    
//    NSString *searchFilename = @"myfile.txt"; // name of the PDF you are searching for
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *filePath = [documentsDirectory stringByAppendingString:@"/myfile.txt"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"myfile.txt"];
//        NSString *savedString = textview.text;
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
//    
//    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
//    
//    NSString *documentsSubpath;
//    while (documentsSubpath = [direnum nextObject])
//    {
//        if (![documentsSubpath.lastPathComponent isEqual:searchFilename]) {
//            continue;
//        }
//        
//        NSLog(@"found %@", documentsSubpath);
//        NSLog(@"%@",documentsDirectory);
//    }

    
//   [query writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
//    NSString *str = [NSString stringWithContentsOfFile:myHandle encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"%@", str);
    
}

- (IBAction)deleteTouchData:(id)sender {
    NSString *query = [NSString stringWithFormat:@"Delete from touch_data"];
    [self.dbManager executeQuery:query];
}

- (IBAction)deleteAccelData:(id)sender {
    NSString *query = [NSString stringWithFormat:@"Delete from accel_data"];
    [self.dbManager executeQuery:query];
}


//- (void)testQueueSelect {
//    [self.queue inDatabase:^(FMDatabase *adb) {
//        int count = 0;
//        FMResultSet *rsl = [adb executeQuery:@"select * from qfoo where foo like 'h%'"];
//        while ([rsl next]) {
//            count++;
//        }
//        
////        XCTAssertEqual(count, 2);
//        
//        count = 0;
//        rsl = [adb executeQuery:@"select * from qfoo where foo like ?", @"h%"];
//        while ([rsl next]) {
//            count++;
//        }
//        
////        XCTAssertEqual(count, 2);
//    }];
//}
//
//
//-(void) writeToDB {
//    
//    
//}


@end
