//
//  SHLable.m
//  AStar
//
//  Created by sherwin.chen on 14-8-23.
//  Copyright (c) 2014年 sherwin. All rights reserved.
//

#import "SHLable.h"

@implementation SHLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.x = 0;
        self.y = 0;
        
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}

-(void) addActionEvnForTarget:(id) target Action:(SEL) action
{
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    
    [self addGestureRecognizer:tapG];
    
    [tapG release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
