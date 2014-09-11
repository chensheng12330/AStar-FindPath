//
//  SHAlgorithms.h
//  AStar
//
//  Created by sherwin on 14-8-14.
//  Copyright (c) 2014年 sherwin. All rights reserved.
//

#import <Foundation/Foundation.h>



// CAlgorithms
enum{AST_LENGTH=10,AST_WIDE=10};//定义2D数组大小

enum{VIABLE=0, WALL, INOPEN, INCLOSE, STARTPOINT, DESTINATION};


@interface Node : NSObject
{
    @public
	//char perperty;// 属性， 是墙还是起点或是其他
	/*int    flag; 
     标志位 0 为可走， 
     1 为墙壁  
     2 在penlist
     3 在 closelist中 
     4 为起点 
     5 为终点
     */

}
@property (nonatomic, retain) Node* parent;

@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger location_x;
@property (nonatomic, assign) NSInteger location_y;

@property (nonatomic, assign) NSInteger value_h;
@property (nonatomic, assign) NSInteger value_g;
@property (nonatomic, assign) NSInteger value_f;
@end

/////////////////////////////////////////////////////////////
//   创建 closelist
////////////////////////////////////////////////////////////
@interface CloseList : NSObject

@property (nonatomic, retain) Node *closenode;
@property (nonatomic, assign) CloseList* next;

@end
///////////////////////////////////////////////////////////////
// 创建 openlist
//////////////////////////////////////////////////////////////

@interface OpenList : NSObject

@property (nonatomic, retain) Node* opennode;
@property (nonatomic, assign) OpenList* next;

@end


/////逻辑处理类
@interface SHAlgorithms : NSObject
{
    
    
}

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, assign) OpenList  *openlist;
@property (nonatomic, assign) CloseList *closelist;

@property (nonatomic, retain) NSMutableArray *m_node; //all节点网格

/*!
 初使化函数
 对传入的 2维数组进行对象化处理
 
 @param grid2D
 
 字符定义
 [.]  =>  VIABLE
 [x]  =>  WALL
 [s]  =>  STARTPOINT
 [d]  =>  DESTINATION
 
 @return void
 */
-(void) InitNodeMap:(char [][AST_WIDE] ) grid2D;


-(bool) FindDestinnation;

//////////////////////////////////////////////////////////////////////////
//  将临近的节点加入 openlist中
//				0      1      2
//				3      S      4
//				5      6      7
/////////////////////////////////////////////////////////////////////////////
-(bool) Insert2OpenListForX:(NSInteger) center_x Y:(NSInteger) center_y;

-(bool) IsInOpenListForX:(NSInteger) x  Y:(NSInteger) y;


-(bool) IsInCloseListForX:(NSInteger) x Y:(NSInteger) y;

// 是否有更好的路径
-(void) IsChangeParent:(NSInteger) center_x Y:(NSInteger) center_y;


-(bool) IsAviable:(NSInteger) x Y:(NSInteger) y;

@end



long  DistanceManhattan(int d_x, int d_y, int x, int y);
unsigned int  Euclidean_dis(int sx,int sy,int ex,int ey);//欧几里德
unsigned int  Chebyshev_dis(int sx,int sy,int ex,int ey);//切比雪夫
unsigned int  jiaquan_Manhattan(int sx,int sy,int ex,int ey);//加权曼哈顿   //better
