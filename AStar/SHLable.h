//
//  SHLable.h
//  AStar
//
//  Created by sherwin.chen on 14-8-23.
//  Copyright (c) 2014年 sherwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLable : UILabel

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

@property (nonatomic,assign)  char chart;

-(void) addActionEvnForTarget:(id) target Action:(SEL) action;
@end
