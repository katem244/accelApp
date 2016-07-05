//
//  CMAccelerometer.h
//  CoreMotion
//
//  Created by Katerina on 6/27/16.
//  Copyright © 2016 Katerina Prastakou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

BOOL toggleIsOn;

@interface CMAccelerometer : UIViewController
@property (nonatomic, readonly, strong) DBManager *dbManager;

- (IBAction)toggleButton:(id)sender;

@end


