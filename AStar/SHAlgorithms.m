//
//  SHAlgorithms.m
//  AStar
//
//  Created by sherwin on 14-8-14.
//  Copyright (c) 2014年 sherwin. All rights reserved.
//
///////////////////////////////////////////////////////////
//			A*算法  最优寻路算法
//			算法是一种静态路网中求解最短路最有效的算法
//				1）公式表示为： f(n)=g(n)+h(n),
//				2） 加入最优路径修正
//						如果某个相邻的方格已经在 open list 中，则检查这条路径是否更优，
//						也就是说经由当前方格 ( 我们选中的方格 ) 到达那个方格是否具有更小的 G 值。
//						如果没有，不做任何操作。
//												作者：一路向南
//															2013, 5,10
/////////////////////////////////////////////////////////

/*
 
 
 一个记录下所有被考虑来寻找最短路径的方块（称为open 列表）
 一个记录下不会再被考虑的方块（成为closed列表）
 
 */
#import "SHAlgorithms.h"

#define DireNum 8

/*
0   1   2
3   S   4
5   6   7
---------------
x点为原点 [0,0] 共 8个方向可探索路径
可以设置 对角方向不可探索，即只有4个方向 [1,4,6,3]
*/

const int DISTANCE=10;
const int direction[DireNum][2]={{-1,-1},{-1,0},{-1,1},{0,-1},{0,1},{1,-1},{1,0},{1,1}};// 方向


@implementation Node
- (instancetype)init
{
    self = [super init];
    if (self) {
        _flag=0;
        _value_h = 0;
        _value_g = 0;
        _value_f =  0;
        _parent  = NULL;
    }
    return self;
}

- (void)dealloc
{
    self.parent = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@" X:%d y:%d flag:%d, h:%d, g:%d,f:%d parent:%d",self.location_x,self.location_y,self.flag, self.value_h,self.value_g,self.value_f,self.parent==NULL?0:1];
}

@end

@implementation CloseList
- (void)dealloc
{
    self.closenode = nil;
    self.next      = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@, %@", self.closenode, self.next];
}

@end


@implementation OpenList
- (void)dealloc
{
    self.opennode = nil;
    self.next     = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@, %@", self.opennode, self.next];
}
@end

////////////////////////////////////
@implementation SHAlgorithms
@synthesize startPoint;
@synthesize endPoint;

- (instancetype)init
{
    self = [super init];
    if (self) {
        startPoint = CGPointMake(-1, -1);
        endPoint   = CGPointMake(-1, -1);
    }
    return self;
}

-(void) InitNodeMap:(char [][AST_WIDE] ) grid2D
{
    self.m_node = [NSMutableArray arrayWithCapacity:AST_LENGTH];
    self.openlist = [[[OpenList alloc] init] autorelease];
    self.closelist= [[[CloseList alloc] init] autorelease];
    
    //id aa =self.m_node[0][0] ;
    
    for(int i=0; i< AST_LENGTH; i++)
	{
        NSMutableArray * tempWD = [NSMutableArray arrayWithCapacity:AST_LENGTH];
		for(int j=0; j< AST_WIDE; j++)
		{
            Node *node = [[Node alloc] init];
            node.location_x = i;
            node.location_y = j;
            node.parent     = NULL;
            
            switch(grid2D[i][j])
			{
                case '.':
                    node.flag = VIABLE;
                    break;
                case 'x':
                    node.flag = WALL;
                    break;
                case 's':
                    node.flag = STARTPOINT;
                    
                    self.openlist.next=NULL;
                    self.openlist.opennode = node;//  将起点放到 OPenList中
                    
                    startPoint = CGPointMake(i, j);
                    break;
                case 'd':
                    node.flag  = DESTINATION;
                    endPoint = CGPointMake(i, j);
                    break;
			}
            [tempWD addObject:node];
            [node release];
        }
        
        [self.m_node addObject:tempWD];
        [tempWD release];
    }
    return;
}


//加入到openlist队列中

-(void) addNode2Open:(Node*) node
{
	if(self.openlist ==NULL)
	{
		//MessageBox("没有");//no data in openlist!
        NSLog(@"++++++++++++++++ ERROR :no data in openlist!");
        
		return;
	}
	if(node.flag!=STARTPOINT)
	{
		node.flag= INOPEN;
	}
    
	OpenList* temp = [[OpenList alloc] init];
	temp.next=NULL;
	temp.opennode = node;
    
    //	if(openlist->next==NULL)
    //	{openlist->next = temp;return;}
    
	while(self.openlist.next != NULL)
	{
		if(node.value_f < self.openlist.next.opennode.value_f)
		{
            //链表插入
			OpenList* tempadd= self.openlist.next;
			temp.next= tempadd;
			self.openlist.next = temp;
			break;
		}
		else
        {
            OpenList* tempadd= self.openlist.next;
            self.openlist = tempadd;
        }
			
	}
	self.openlist.next = temp;
    
    //[temp release];
}

// openlist 此处必须为指针的引用
-(void) addNode2Close
{
	if(self.openlist==NULL)
	{
        //		cout<<"no data in openlist!"<<endl;
        NSLog(@"no data in openlist!");
		return;
	}
    
	if(self.openlist.opennode.flag != STARTPOINT)
    {
        self.openlist.opennode.flag =INCLOSE;
    }
		
    
	if(self.closelist.closenode == NULL)
	{
		self.closelist.closenode = self.openlist.opennode;
		OpenList* tempopen = self.openlist;
        
		self.openlist      = self.openlist.next;
        
        tempopen.next = nil;
        [tempopen release];
		return;
	}
    
	while(self.closelist.next!= NULL)
    {
       self.closelist = self.closelist.next; //移动链表到链表头
    }
    
	CloseList* temp=  [[CloseList alloc] init];
	temp.closenode = self.openlist.opennode;
	temp.next=NULL;
	self.closelist.next= temp;
    
    //切换Openlist链表指针到下一节点
    OpenList* tempopen = self.openlist;
    self.openlist = self.openlist.next;
    tempopen.next = nil;
    [tempopen release];
    
    return;
}

-(bool) FindDestinnation
{
    [self Insert2OpenListForX:startPoint.x Y:startPoint.y];// 起点
    
	[self addNode2Close];// 起点放到 close中
    
    while (![self Insert2OpenListForX:self.openlist.opennode.location_x Y:self.openlist.opennode.location_y]) {
        
        [self addNode2Close];
        
        if (self.openlist==NULL) {
            NSLog(@"未找到出口！地图有误");
            return false;
        }
        
        NSLog(@"查找中...");
    }
    
    return true;
    
    /*
	while(!Insert2OpenList(open, open->opennode->location_x, open->opennode->location_y))
	{
		AddNode2Close(close,open);
		if(open==NULL)
		{
			MessageBox("未找到出口！地图有误");
			return false;
		}
	}
	return true;
    */
    
    return YES;
}

-(bool) Insert2OpenListForX:(NSInteger) center_x Y:(NSInteger) center_y
{
    NSLog(@"InsertCenter-X: %d Y:%d",center_x,center_y);
    
    for(int i=0; i<DireNum ; i++)
	{
		NSInteger new_x=center_x + direction[i][0];
		NSInteger new_y=center_y + direction[i][1];
        
		if(new_x>=0 && new_y>=0 && new_x<AST_LENGTH &&
           new_y<AST_WIDE &&[self IsAviable:new_x Y:new_y])// 0
		{
            
            Node *newNode = (Node*)self.m_node[new_x][new_y];
            Node *cenNode = (Node*)self.m_node[center_x][center_y];
            
            
			if(newNode.flag==DESTINATION)
			{
				newNode.parent = cenNode;  //找到终点
				return true;
			}
            
			newNode.flag    = INOPEN;
			newNode.parent  = cenNode;
			newNode.value_h = DistanceManhattan(endPoint.x, endPoint.y, new_x,new_y);//曼哈顿距离
            
			if(0==i || 2==i||5==i||7==i)
				newNode.value_g = cenNode.value_g+14;  //斜角
			else
				newNode.value_g = cenNode.value_g+10;  //正方向
            
			newNode.value_f = newNode.value_g + newNode.value_h;
            
			[self addNode2Open:newNode];// 加入到 openlist中
		}
	}
    
    [self IsChangeParent:center_x Y:center_y];
    
	//IsChangeParent(open, center_x,  center_y);
	//if(counts>1000)
	//	return true;
	//else
    return false;
}



// 是否有更好的路径
-(void) IsChangeParent:(NSInteger) center_x Y:(NSInteger) center_y
{
	for(int i=0; i<DireNum; i++)
	{
		NSInteger new_x=center_x + direction[i][0];
		NSInteger new_y=center_y + direction[i][1];
        
		if(new_x>=0 && new_y>=0 && new_x<AST_LENGTH && new_y<AST_WIDE && [self IsInOpenListForX:new_x Y:new_y])// 0
		{
            
            Node *newNode = (Node*)self.m_node[new_x][new_y];
            Node *cenNode = (Node*)self.m_node[center_x][center_y];
            
			if(0==i|| 2==i|| 5==i|| 7==i)
			{
				if(newNode.value_g >  (cenNode.value_g+14) )
				{
					newNode.parent  = cenNode;
					newNode.value_g = cenNode.value_g+14;
				}
			}
			else
			{
				if(newNode.value_g > (cenNode.value_g+10))
				{
					newNode.parent  = cenNode;
					newNode.value_g = cenNode.value_g+10;
				}
			}
		}
	}
    return;
}

//是否可达。
-(bool) IsAviable:(NSInteger) x Y:(NSInteger) y
{
    if([self IsInOpenListForX:x Y:y])
		return false;
    
	if([self IsInCloseListForX:x Y:y])
		return false;
    
    Node *node = self.m_node[x][y];
	if(node.flag == WALL )
		return false;
	else
		return true;
    
    return YES;
}

-(bool) IsInOpenListForX:(NSInteger) x Y:(NSInteger) y
{
    Node *node = self.m_node[x][y];
    if (node.flag == INOPEN) {
        return true;
    }
    return false;
}

-(bool) IsInCloseListForX:(NSInteger) x Y:(NSInteger) y
{
    Node *node = self.m_node[x][y];
    if (node.flag == INOPEN || node.flag == STARTPOINT) {
        return true;
    }
    return false;
}

@end


#pragma mark - Math Method

/*
////////////////////////////////////////////////////////
//         选择计算距离的方法
//         默认选择  麦哈顿方法
//			可自行修改
////////////////////////////////////////////////////////
long DistanceManhattan(int d_x, int d_y, int x, int y)
{
	long temp=(abs(d_x - x) + abs(d_y-y))*DISTANCE;
	return temp;
}

unsigned int  Euclidean_dis(int sx,int sy,int ex,int ey){//欧几里德
	double nn;
	nn=sqrt((double)((sx-ex)*(sx-ex)+(sy-ey)*(sy-ey)));
	return nn;
}

unsigned int  Chebyshev_dis(int sx,int sy,int ex,int ey){//切比雪夫
	double nn;
    
	nn= fmax(abs(sx-ex),abs(sy-ey));
	return nn;
}

unsigned int  jiaquan_Manhattan(int sx,int sy,int ex,int ey){//加权曼哈顿   //better
	double nn,dx,dy;
	dx=abs(sx-ex);
	dy=abs(sy-ey);
	if(dx>dy)
		nn=10*dx+6*dy;
	else
		nn=6*dx+10*dy;
	return nn;
}

*/
