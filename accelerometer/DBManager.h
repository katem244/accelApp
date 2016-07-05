//
//  DBManager.h
//  accelerometer
//
//  Created by Katerina on 6/30/16.
//  Copyright © 2016 Katerina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(void)copyDatabaseIntoDocumentsDirectory;

@end
