//
//  SHViewController.h
//  AStar
//
//  Created by sherwin on 14-8-14.
//  Copyright (c) 2014年 sherwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHViewController : UIViewController

- (IBAction)setStartNode:(UIButton *)sender;

- (IBAction)setEndNode:(UIButton *)sender;
- (IBAction)setWallNode:(UIButton *)sender;
- (IBAction)begainFindPath:(UIButton *)sender;
- (IBAction)clearAllNode:(UIButton *)sender;

@end
