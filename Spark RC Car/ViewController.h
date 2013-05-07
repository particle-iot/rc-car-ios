//
//  ViewController.h
//  Spark RC Car
//
//  Created by Zachary Crockett on 5/7/13.
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UISlider *leftSlider;
@property IBOutlet UISlider *rightSlider;

- (IBAction)leftValueChanged:(id)sender;
- (IBAction)rightValueChanged:(id)sender;

@end
