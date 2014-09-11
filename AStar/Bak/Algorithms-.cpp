// Algorithms.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "AStar.h"
#include "Algorithms.h"
#include<math.h>
using namespace std;
// CAlgorithms

IMPLEMENT_DYNAMIC(CAlgorithms, CWnd)

CAlgorithms::CAlgorithms()
{
		steps=0;
	startpoint_x = -1;
	startpoint_y = -1;
	endpoint_y = -1; 
	endpoint_x = -1;
}

CAlgorithms::~CAlgorithms()
{
}


BEGIN_MESSAGE_MAP(CAlgorithms, CWnd)
END_MESSAGE_MAP()

///////////////////////////////////////////////////////////
//			A*�㷨  ����Ѱ·�㷨
//			�㷨��һ�־�̬·����������·����Ч���㷨
//				1����ʽ��ʾΪ�� f(n)=g(n)+h(n),
//				2�� ��������·������
//						���ĳ�����ڵķ����Ѿ��� open list �У���������·���Ƿ���ţ�
//						Ҳ����˵���ɵ�ǰ���� ( ����ѡ�еķ��� ) �����Ǹ������Ƿ���и�С�� G ֵ��
//						���û�У������κβ�����
//												���ߣ�һ·����
//															2013, 5,10
/////////////////////////////////////////////////////////

const int DISTANCE=10;
const int direction[8][2]={{-1,-1},{-1,0},{-1,1},{0,-1},{0,1},{1,-1},{1,0},{1,1}};// ����

Node::Node()
{
	flag=0;
	value_h= 0;
	value_g= 0;
	value_f =  0;
	parent= NULL;
}
void AddNode2Open(OpenList* openlist, Node* node)
{
	if(openlist ==NULL)
	{
		//MessageBox("û��");//no data in openlist!

		return;
	}
	if(node->flag!=STARTPOINT)
	{
		node->flag= INOPEN;
	}
	OpenList* temp =  new OpenList;
	temp->next=NULL;
	temp->opennode = node;

//	if(openlist->next==NULL)
//	{openlist->next = temp;return;}

	while(openlist->next != NULL)
	{
		if(node->value_f < openlist->next->opennode->value_f)
		{
			OpenList* tempadd= openlist->next;
			temp->next= tempadd;
			openlist->next = temp;
			break;
		}
		else
			openlist= openlist->next;
	}
	openlist->next = temp;

}

// openlist �˴�����Ϊָ�������
void AddNode2Close(CloseList* close, OpenList* &open)
{
	if(open==NULL)
	{
//		cout<<"no data in openlist!"<<endl;
		return;
	}
	if(open->opennode->flag != STARTPOINT)
		open->opennode->flag =INCLOSE;

	if(close->closenode == NULL)
	{	
		close->closenode = open->opennode;
		OpenList* tempopen=open;
		open=open->next;
		//open->opennode=NULL;
	//	open->next=NULL;
		delete tempopen;
		return;
	}
	while(close->next!= NULL)
		close= close->next;

	CloseList* temp= new CloseList;
	temp->closenode = open->opennode;
	temp->next=NULL;
	close->next= temp;

	OpenList* tempopen=open;
	open=open->next;
	delete tempopen;
}

////////////////////////////////////////////////////////
//   ������
///////////////////////////////////////////////////////

bool CAlgorithms::FindDestinnation(OpenList* open,CloseList* close, char aa[][WIDE])
{
	Insert2OpenList(open,startpoint_x,startpoint_y);// ���
	AddNode2Close(close,open);// ���ŵ� close��

	while(!Insert2OpenList(open, open->opennode->location_x, open->opennode->location_y))
	{
		AddNode2Close(close,open);
		if(open==NULL)
		{
			MessageBox("δ�ҵ����ڣ���ͼ����");
			return false;
		}
	}
	return true;
	/*
	Node *tempnode = &m_node[endpoint_x][endpoint_y];
	while(tempnode->parent->flag!=STARTPOINT)
	{
		tempnode=tempnode->parent;
		aa[tempnode->location_x][tempnode->location_y]='@';
	}
	*/

}
//////////////////////////////////////////////////////////////////////////
//  ���ٽ��Ľڵ���� openlist��
//				0      1      2  
//				3      S      4
//				5      6      7
/////////////////////////////////////////////////////////////////////////////
bool CAlgorithms::Insert2OpenList(OpenList* open,int center_x, int center_y)
{
	int i=0;
	//while()
	//int counts
	//static int counts=0;
	//counts++;
	for(; i<8 ; i++)
	{
		int new_x=center_x + direction[i][0];
		int new_y=center_y+ direction[i][1];

		if(new_x>=0 && new_y>=0 && new_x<LENGTH &&
			new_y<WIDE &&
			IsAviable(open, new_x, new_y))// 0
		{
			if(	m_node[new_x][new_y].flag==DESTINATION)
			{
				m_node[new_x][new_y].parent = &m_node[center_x][center_y];
				return true;
			}
			m_node[new_x][new_y].flag =INOPEN;
			m_node[new_x][new_y].parent = &m_node[center_x][center_y];
			m_node[new_x][new_y].value_h = 
				DistanceManhattan(endpoint_x, endpoint_y, new_x,new_y);//�����پ���

			if(0==i || 2==i||5==i||7==i)
				m_node[new_x][new_y].value_g = m_node[center_x][center_y].value_g+14;
			else
				m_node[new_x][new_y].value_g = m_node[center_x][center_y].value_g+10;

			m_node[new_x][new_y].value_f = m_node[new_x][new_y].value_g+m_node[new_x][new_y].value_h;

			AddNode2Open(open, &m_node[new_x][new_y]);// ���뵽 openlist��
		}
	}
	IsChangeParent(open, center_x,  center_y);
	//if(counts>1000)
	//	return true;
	//else
	return false;
}
// �Ƿ��и��õ�·��
void CAlgorithms::IsChangeParent(OpenList* open,int center_x, int center_y)
{
	int i=0;
	for(; i<8 ; i++)
	{
		int new_x=center_x + direction[i][0];
		int new_y=center_y+ direction[i][1];
		if(new_x>=0 && new_y>=0 && new_x<LENGTH &&
			new_y<WIDE &&
			IsInOpenList(open, new_x, new_y))// 0
		{

			if(0==i|| 2==i|| 5==i|| 7==i)
			{
				if(m_node[new_x][new_y].value_g >  m_node[center_x][center_y].value_g+14)
				{
					m_node[new_x][new_y].parent = &m_node[center_x][center_y];
					m_node[new_x][new_y].value_g =   m_node[center_x][center_y].value_g+14;
				}
			}
			else
			{
				if(m_node[new_x][new_y].value_g >   m_node[center_x][center_y].value_g+10)
				{
					m_node[new_x][new_y].parent = &m_node[center_x][center_y];
					m_node[new_x][new_y].value_g =   m_node[center_x][center_y].value_g+10;
				}
			}
		}
	}
}

bool CAlgorithms::IsAviable(OpenList* open, int x, int y)
{
	if(IsInOpenList( open, x, y))
		return false;
	if(IsInCloseList( open, x, y))
		return false;
	if(m_node[x][y].flag == WALL )
		return false;
	else 
		return true;
}
bool CAlgorithms::IsInOpenList(OpenList* openlist, int x,int y)
{
	if(m_node[x][y].flag == INOPEN)
		return true;
	else 
		return false;
}

bool CAlgorithms::IsInCloseList(OpenList* openlist, int x,int y)
{
	if(m_node[x][y].flag == INCLOSE|| m_node[x][y].flag==STARTPOINT)
		return true;
	else 
		return false;
}
//��ʾ��ͼ
void DisplayMap(char aa[][WIDE] )
{
	for(int i=0; i< LENGTH ;i++)
	{
		for(int j=0; j<WIDE; j++)
			//cout<<aa[i][j];
		//cout<<endl;
		;
	}
}
////////////////////////////////////////////////////////
//         ѡ��������ķ��� 
//         Ĭ��ѡ��  ����ٷ���
//			�������޸�
////////////////////////////////////////////////////////
unsigned int CAlgorithms::DistanceManhattan(int d_x, int d_y, int x, int y)
{
	unsigned int temp=(abs(d_x - x) + abs(d_y-y))*DISTANCE;
	return temp;
}

unsigned int  CAlgorithms::Euclidean_dis(int sx,int sy,int ex,int ey){//ŷ�����
	double nn;
	nn=sqrt(double((sx-ex)*(sx-ex)+(sy-ey)*(sy-ey)));
	return nn;
}

unsigned int  CAlgorithms::Chebyshev_dis(int sx,int sy,int ex,int ey){//�б�ѩ��
	double nn;
	nn=max(abs(sx-ex),abs(sy-ey));
	return nn;
}

unsigned int  CAlgorithms::jiaquan_Manhattan(int sx,int sy,int ex,int ey){//��Ȩ������   //better
	double nn,dx,dy;
	dx=abs(sx-ex);
	dy=abs(sy-ey);
	if(dx>dy)
		nn=10*dx+6*dy;
	else
		nn=6*dx+10*dy;
	return nn;
}


//��ʼ�� node
void CAlgorithms::InitNodeMap( char aa[][WIDE], OpenList * openlist)
{
	for(int i=0; i< LENGTH; i++)
	{
		for(int j=0; j< WIDE; j++)
		{	
			m_node[i][j].location_x = i;
			m_node[i][j].location_y = j;
			m_node[i][j].parent = NULL;		
			switch(aa[i][j])
			{
			case '.':
				m_node[i][j].flag = VIABLE;		
				break;
			case 'x':
				m_node[i][j].flag = WALL;
				break;
			case 's':
				m_node[i][j].flag = STARTPOINT;	
				openlist->next=NULL;
				openlist->opennode= &m_node[i][j];//  �����ŵ� OPenList��		
				startpoint_x= i;
				startpoint_y=j;
				break;
			case 'd':
				m_node[i][j].flag = DESTINATION;
				endpoint_x= i;
				endpoint_y=j;
				break;
			}
		}
	}
}

