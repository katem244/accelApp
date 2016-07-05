//
//  CMAccelerometer.h
//  CoreMotion
//
//  Created by Katerina on 6/27/16.
//  Copyright © 2016 Katerina Prastakou. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL toggleIsOn;

@interface CMAccelerometer : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textf;

- (IBAction)toggleButton:(id)sender;

- (IBAction)submit:(id)sender;

@end


