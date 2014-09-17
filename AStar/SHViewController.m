//
//  SHViewController.m
//  AStar
//
//  Created by sherwin on 14-8-14.
//  Copyright (c) 2014年 sherwin. All rights reserved.
//

#import "SHViewController.h"

#import "SHLable.h"
#import "aStart.h"

#define TagMonster 2014915

//#import "SHAlgorithms.h"

#define AST_WIDE     WIDE
#define AST_LENGTH   LENGTH

char nodeMap[AST_WIDE][AST_LENGTH];

@interface SHViewController ()

@property (nonatomic,retain) NSMutableArray *nodeViewMap;

@property (nonatomic, assign) char curMode; //1=>起点   2=>终点  3=>墙  0=>清空

@property (assign) float cellWidth;
@property (assign) float cellHeight;

@property (assign) float CanvasWidth;
@property (assign) float CanvasHeight;

@end

@implementation SHViewController

-(SHLable*) getViewSharpForFrame:(CGRect) frame
{
    SHLable *subView = [[SHLable alloc] initWithFrame:frame];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.borderWidth = 1;
    subView.layer.borderColor = [UIColor blackColor].CGColor;
    [subView addActionEvnForTarget:self Action:@selector(viewTapEvent:)];
    return [subView autorelease];
}

-(void) viewTapEvent:(UITapGestureRecognizer*) tapGes
{
    SHLable *lab = (SHLable*)tapGes.view;
    
    //怪物图形处理
    if (self.curMode == 'm') {
        
        NSLog(@"%@",NSStringFromCGPoint(lab.center));
        
        float fwidth = [self.tfWidth.text  floatValue];
        float fheight= [self.tfHeight.text floatValue];
         
        UIButton *Xbutton = [UIButton buttonWithType:0];
        Xbutton.tag = TagMonster;
        [Xbutton setFrame:CGRectMake(0, 0, fwidth, fheight)];
        Xbutton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.5];
        Xbutton.layer.borderWidth = 1;
        Xbutton.layer.borderColor = [UIColor greenColor].CGColor;
        [Xbutton setCenter:lab.center];
        [Xbutton addTarget:self action:@selector(deleteMonster:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:Xbutton];
        
        return;
    }
    ///搞完
    
    char charMode = self.curMode;
    
    if (self.curMode == nodeMap[lab.x][lab.y] && self.curMode !='.') {
       charMode = '.';
    }
    else
    {
        
    }
    
    nodeMap[lab.x][lab.y] = charMode;
    lab.chart = charMode;
    
    if (lab.chart=='.') {
        lab.backgroundColor = [UIColor whiteColor];
    }
    else if (lab.chart=='s')
    {
        lab.backgroundColor = [UIColor greenColor];
    }
    else if (lab.chart=='d')
    {
        lab.backgroundColor = [UIColor blueColor];
    }
    else if (lab.chart=='x')
    {
        lab.backgroundColor = [UIColor grayColor];
    }
    
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.curMode = '.';
    
    self.nodeViewMap = [[[NSMutableArray alloc] init] autorelease];
    
    self.CanvasWidth= (self.view.frame.size.width-20);
    self.CanvasHeight=(self.view.frame.size.height-60);
    
    float viewW = self.CanvasWidth/AST_WIDE;
    float viewH = self.CanvasHeight/AST_LENGTH;
    
    self.cellHeight = viewH;
    self.cellWidth  = viewW;
    
    
    float addX = 10;
    float addY = 60;
    
    for (int i=0; i< AST_WIDE; i++) {
        
        NSMutableArray *arViews = [[NSMutableArray alloc] init];
        for (int j=0; j< AST_LENGTH; j++) {
            
            nodeMap[i][j] = '.';
        
            SHLable *tView = [self getViewSharpForFrame:CGRectMake(addX, addY, viewW, viewH)];
            [self.view addSubview:tView];
            
            tView.x = i;
            tView.y = j;
            tView.text = [NSString stringWithFormat:@"(%d,%d)",j,i];
            tView.textAlignment = NSTextAlignmentCenter;
            
            tView.chart = '.';
            
            [arViews addObject:tView];
            
            addX += viewW;
        }
        
        [self.nodeViewMap addObject:arViews];
        [arViews release];
        addY += viewH;
        addX  = 10;
    }
    
    return;
    
    /*
    //起点
    nodeMap[0][0] = 's';
    
    UIView *sView = self.nodeViewMap[0][0];
    sView.backgroundColor = [UIColor greenColor];
    
    //终点
    nodeMap[AST_LENGTH-1][AST_WIDE-1] = 'd';
    UIView *dView = self.nodeViewMap[9][9];
    dView.backgroundColor = [UIColor blueColor];
    
    //设置wall
   
    for (int i=1; i<AST_LENGTH; i++) {
        nodeMap[1][i] = 'x';
        UIView *subView = self.nodeViewMap[1][i];
        subView.backgroundColor = [UIColor grayColor];
    }
    
    
    for (int i=0; i<AST_LENGTH-1; i++) {
        nodeMap[4][i] = 'x';
        UIView *subView = self.nodeViewMap[4][i];
        subView.backgroundColor = [UIColor grayColor];
    }
    
    
     for (int i=1; i<AST_LENGTH; i++) {
     nodeMap[8][i] = 'x';
     UIView *subView = self.nodeViewMap[8][i];
     subView.backgroundColor = [UIColor grayColor];
     }
    
 
    
    
    
    
    //return;
    
    
    OpenList *sopenList   = malloc(sizeof(OpenList));
    CloseList *scloseList = malloc(sizeof(CloseList));
    
    InitNodeMap(nodeMap, sopenList);
    
    if(FindDestinnation(sopenList, scloseList, nodeMap))
    {
        Node tempnode = m_node[endpoint_x][endpoint_y];
        
        if (tempnode.parent==NULL) {
            
            NSLog(@"查找失败");
            return;
        }
        
        while(tempnode.parent!=NULL && tempnode.flag!=STARTPOINT && tempnode.flag!=ENAMETOOLONG)
        {
            NSLog(@"x: %d , y:%d",tempnode.location_x,tempnode.location_y);
            
            UIView *subView = self.nodeViewMap[tempnode.location_x][tempnode.location_y];
            subView.backgroundColor = [UIColor redColor];
            
            tempnode = *tempnode.parent;
        }
    }
    
    return;
    
    
    *
    for (int i=0; i< AST_WIDE; i++) {
        
        for (int j=0; j< AST_LENGTH; j++) {
        }
    }
     */
    
    return;
}

- (IBAction)clearAllNode:(UIButton *)sender {
    self.curMode = '.';
    
    for (int i=0; i< AST_WIDE; i++) {
        
        NSMutableArray *arViews = self.nodeViewMap[i];
        
        for (int j=0; j< AST_LENGTH; j++) {
            
            nodeMap[i][j] = '.';
            
            SHLable *tView = arViews[j];
            
            [tView setBackgroundColor:[UIColor whiteColor]];
            
            tView.chart = '.';
        }
    }
}

- (IBAction)setMonster:(UIButton *)sender {
    self.curMode = 'm'; //怪物
}

- (IBAction)setStartNode:(UIButton *)sender {
    self.curMode = 's';
}

- (IBAction)setEndNode:(UIButton *)sender {
    self.curMode = 'd';
}

- (IBAction)setWallNode:(UIButton *)sender {
    self.curMode = 'x';
}

- (IBAction)showMoGrap:(id)sender {
    float addX = 10;
    float addY = 60;
    
    //处理怪物图形
    for (UIView *view in self.view.subviews) {
        if (view.tag != TagMonster) { continue; }
        
        //怪物空间
        float moW = view.frame.size.width;
        float moH = view.frame.size.height;
        
        float moOrX = view.frame.origin.x;
        float moOrY = view.frame.origin.y;
        
        float moButX = moOrX+moW;
        float moButY = moOrY+moH;
        //
        
        //网络用整形，减少CPU开支
        //墙下标值
        int lbx,lby; lbx=lby=0;
        
        for (float i=(moOrX); ; i+=self.cellWidth) {
            
            //特殊判断 【半部分在矩形内】
            if (i>=moButX && (i-self.cellWidth)>moButX) {
                
                break;
            }
            
            //执行下标计算
            lbx = (i-addX)/self.cellWidth;
            
            
            // 抛弃多余
            if (moButX< ((lbx)*self.cellWidth+addX)) {
                break;
            }
            
            
            if (lbx>=WIDE) { //数组越界，放弃
                break;
            }
            
            
            for (float j=(moOrY); ; j+=self.cellHeight) {
                
                if (j>moButY) {
                    break;
                }
                
                lby = (j-addY)/self.cellHeight;
                
                // 抛弃多余
                if (moButY< ((lby)*self.cellHeight+addY)) {
                    break;
                }
                
                if (lby>=LENGTH) { //数组越界，放弃
                    break;
                }
                
                UIView *bkView = self.nodeViewMap[lby][lbx];
                bkView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
                nodeMap[lbx][lby] = 'x';
                
                NSLog(@"x[%d] y[%d]",lbx,lby);
                
                UIView *ppView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)] autorelease];
                [ppView setCenter:CGPointMake(i, j)];
                ppView.backgroundColor = [UIColor redColor];
                [self.view addSubview:ppView];
                
            }
        }
    }
}

//开始查找
- (IBAction)begainFindPath:(UIButton *)sender {
    
    
    /*
    SHAlgorithms *stateMap = [[SHAlgorithms alloc] init];
    
    [stateMap InitNodeMap:nodeMap];
    
    if([stateMap FindDestinnation])
    {
        Node *tempnode = stateMap.m_node[(int)stateMap.endPoint.x][(int)stateMap.endPoint.y];
        
        if (tempnode.parent==NULL) {
            
            NSLog(@"查找失败");
            return;
        }
        
        while(tempnode.parent!=NULL && tempnode.parent.flag!=STARTPOINT)
        {
            NSLog(@"x: %d , y:%d",tempnode.location_x,tempnode.location_y);
            
            UIView *subView = self.nodeViewMap[tempnode.location_x][tempnode.location_y];
            subView.backgroundColor = [UIColor redColor];
            
            tempnode=tempnode.parent;
        }
    }
     */
    
    
    
    //c版本
    
    OpenList *sopenList   = malloc(sizeof(OpenList));
    sopenList->next = NULL;
    sopenList->opennode =NULL;
    
    
    CloseList *scloseList = malloc(sizeof(CloseList));
    scloseList->next = NULL;
    scloseList->closenode=NULL;
    
    InitNodeMap(nodeMap, sopenList);
    
    if(FindDestinnation(sopenList, scloseList, nodeMap))
    {
        Node tempnode = m_node[endpoint_x][endpoint_y];
        
        if (tempnode.parent==NULL) {
            
            NSLog(@"查找失败");
            return;
        }
        
        while(tempnode.parent!=NULL && tempnode.flag!=STARTPOINT )
        {
            
            
            if (tempnode.flag!=DESTINATION) {
                UIView *subView = self.nodeViewMap[tempnode.location_x][tempnode.location_y];
                subView.backgroundColor = [UIColor redColor];
            }
            NSLog(@"x: %d , y:%d",tempnode.location_x,tempnode.location_y);
            
            
            
            tempnode = *tempnode.parent;
        }
    }
}


- (void)dealloc {
    [_tfWidth release];
    [_tfHeight release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) deleteMonster:(UIButton*) sender
{
    [sender removeFromSuperview];
    return;
}
@end
