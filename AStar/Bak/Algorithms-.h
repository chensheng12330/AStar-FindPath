#pragma once

#ifndef ALGORITHMS_H
#define ALGORITHMS_H
// CAlgorithms
	enum{LENGTH=40,WIDE=40};//���������С
	enum{VIABLE, WALL, INOPEN, INCLOSE, STARTPOINT, DESTINATION};
struct Node
{
	//char perperty;// ���ԣ� ��ǽ��������������
	int    flag; //��־λ 0 Ϊ���ߣ� 1 Ϊǽ��  2 ��penlist  
					//3 �� closelist�� 4 Ϊ��� 5 Ϊ�յ�
	unsigned int location_x;
	unsigned int location_y; 
	unsigned int value_h;
	unsigned int value_g;
	unsigned int value_f;
	Node* parent;
	Node();
};


/////////////////////////////////////////////////////////////
//   ���� closelist
////////////////////////////////////////////////////////////
struct CloseList
{
	Node *closenode;
	CloseList* next;
	CloseList(){ next=NULL;};
};

///////////////////////////////////////////////////////////////
// ���� openlist
//////////////////////////////////////////////////////////////
struct OpenList
{
	Node *opennode;
	OpenList* next;
	OpenList(){next= NULL;};
};
class CAlgorithms : public CWnd
{
	DECLARE_DYNAMIC(CAlgorithms)
public:
	int startpoint_x;
	int startpoint_y;
	int endpoint_x;
	int endpoint_y;

public:
	CAlgorithms();
	virtual ~CAlgorithms();
	public:
	Node m_node[LENGTH][WIDE];

	void InitNodeMap( char aa[][WIDE], OpenList *open);
	bool FindDestinnation(OpenList* open,CloseList* close, char aa[][WIDE]);
	OpenList* FindMinInOpen(OpenList* open);
	bool Insert2OpenList(OpenList* , int x, int y);
	bool IsInOpenList(OpenList*, int x, int y);
	bool IsInCloseList(OpenList*, int x, int y);
	void IsChangeParent(OpenList*, int x, int y);
	bool IsAviable(OpenList* , int x, int y);
	unsigned int DistanceManhattan(int d_x, int d_y, int x, int y);

	unsigned int  Euclidean_dis(int sx,int sy,int ex,int ey);//ŷ�����

	unsigned int  Chebyshev_dis(int sx,int sy,int ex,int ey);//�б�ѩ��
	unsigned int  CAlgorithms::jiaquan_Manhattan(int sx,int sy,int ex,int ey);//��Ȩ������   //better

private:
	unsigned int steps;
protected:
	DECLARE_MESSAGE_MAP()
};

#endif
