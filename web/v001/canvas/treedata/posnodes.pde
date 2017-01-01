/*******************************************************************************
*                                                                              *
*  posnodes.pde                                                                *
*                                                                              *
*  This file is part of "sld-tree-generator". (this program)                   *
*                                                                              *
*  Copyright (C) 2016 by Andreas Pollhammer                                    *
*                                                                              *
*  Email: apoll500@gmail.com                                                   *
*  Web:   http://www.andreaspollhammer.com                                     *
*                                                                              *
*******************************************************************************/
/*******************************************************************************
*                                                                              *
*  Licensed under GPLv3:                                                       *
*                                                                              *
*  This program is free software: you can redistribute it and/or modify        *
*  it under the terms of the GNU General Public License as published by        *
*  the Free Software Foundation, either version 3 of the License, or           *
*  (at your option) any later version.                                         *
*                                                                              *
*  This program is distributed in the hope that it will be useful,             *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of              *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               *
*  GNU General Public License for more details.                                *
*                                                                              *
*  You should have received a copy of the GNU General Public License           *
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.       *
*                                                                              *
*******************************************************************************/
interface PositioningAlgo
{
    void posNodes(Tree t);
}

class SetAllNull implements PositioningAlgo
{
    void posNodes(Tree t,boolean animate)
    {
        setAllNull(t);
        startAnimRev(t);
        if(!animate)endanim(t);
    }
    void setAllNull(Tree t)
    {
        t.node.pos.set(0,0);
        for(var i=0;i<t.subtrees.length;i++)
        {
            setAllNull(t.subtrees[i]);
        }
    }
    void startAnimRev(Tree t)
    {
        t.node.pos.x.startAnimRev(500);
        t.node.pos.y.startAnimRev(500);
        for(int i=0;i<t.subtrees.length;i++)
            startAnimRev(t.subtrees[i]);
    }
}

class NaiveAlgo extends SetAllNull
{
    int[] xpos=[];
    void posNodes(Tree t,boolean animate)
    {
        globalGraphicParameter.setTextSize();
        t.draw_nodes();
        naivePos(t,0);
        startAnimRev(t);
        if(!animate)endanim(t);
    }
    void naivePos(Tree t,int level)
    {
        if(xpos.length<level+1)append(xpos,0);
        t.node.pos.set(xpos[level],level);
        xpos[level]+=t.node.width+globalGraphicParameter.xspacing*globalGraphicParameter.scale;
        for(int i=0;i<t.subtrees.length;i++)
        {
            naivePos(t.subtrees[i],level+1);
        }
    }
    void endanim(Tree t)
    {
        t.node.pos.x.animRunning=false;
        t.node.pos.y.animRunning=false;
        for(int i=0;i<t.subtrees.length;i++)
        {
            endanim(t.subtrees[i]);
        }
    }
    void anim(Tree t,int level)
    {
        t.node.anim();
        for(int i=0;i<t.subtrees.length;i++)
        {
            anim(t.subtrees[i],level+1);
        }
    }
}

class MyWalker extends NaiveAlgo
{
    Tree[] ltr=[];

    int debug_max_steps=0;
    int debug_step_count=0;
    
    void posNodes_debug_reset()
    {
        debug_max_steps=0;
    }
    void posNodes_debugStep(Tree t,boolean animate)
    {
		global_DOM_main_canvas.focus();
        debug_max_steps++;
        debug_step_count=0;
        posNodes(t,animate);
    }
    void posNodes_debug(Tree t,boolean animate,int steps)
    {
		global_DOM_main_canvas.focus();
        debug_max_steps=steps;
        debug_step_count=0;
        posNodes(t,animate);
    }
    
    void initialize(Tree t)
    {
        t.subTreeHeight=0;
        for(int i=0;i<t.subtrees.length;i++)
        {
            int h=initialize(t.subtrees[i]);
            t.subTreeHeight=max(t.subTreeHeight,h+1);
            t.left_neighbour=null;
            t.right_neighbour=null;
        }
        return t.subTreeHeight;
    }
    
    void initialize(Tree t)
    {
        t.subTreeHeight=0;
        t.left_neighbour=null;
        t.right_neighbour=null;
        for(int i=0;i<t.subtrees.length;i++)
        {
            int h=initialize(t.subtrees[i]);
            t.subTreeHeight=max(t.subTreeHeight,h+1);
        }
        return t.subTreeHeight;
    }

    void findNeighbours(Tree t)
    {
        ltr=new Tree[0];
        findNeighbours(t,0);
    }
    
    void findNeighbours(Tree t,int level)
    {
        if(ltr.length<level+1)append(ltr,null);
        for(int i=0;i<t.subtrees.length;i++)
        {
            findNeighbours(t.subtrees[i],level+1);
        }
        if(ltr[level]!=null)
        {
            ltr[level].right_neighbour=t;
            t.left_neighbour=ltr[level];
        }
        ltr[level]=t;
        t.node.new_x=0;//t.node.getX();
        t.node.new_y=0;//level;
    }
    
    void posNodes(Tree t,boolean animate)
    {
        ltr=[];
        globalGraphicParameter.setTextSize();
        t.draw_nodes();
        store_old(t);
        initialize(t);
        findNeighbours(t);
        myWalkerAlgo(t,0);
        anim(t,0);
        if(!animate)endanim(t);
    }
    
	/*
    void myWalkerAlgo_start(Tree t)
	{
		myWalkerAlgo(t,0);
	}
	*/
	
    void myWalkerAlgo(Tree t,int level)
    {
        //--DEBUG--
        //if(debug_max_steps && debug_step_count++>debug_max_steps)return;
    
        //position all subtrees (from left to right)
        for(int i=0;i<t.subtrees.length;i++)
        {
            positionSubtree(t.subtrees[i],level+1);
        }
		//inner subtree spreading
		compactingSubtrees(t);
		//subtreeReposToRight(t);
		//subtreeReposToLeft(t);
		//
        //position node upon subtrees
        positionParentNode(t,level);
    }
	
	void subtreeReposToRight(Tree t)
	{
		if(t.subtrees.length>2)
		{
			Tree rightSub=rightmostChild(t);
			Tree leftSub=leftmostChild(t);
			centerSubtreesBetweenToRight(leftSub,rightSub);
		}
	}
	
	void subtreeReposToLeft(Tree t)
	{
		if(t.subtrees.length>2)
		{
			Tree rightSub=rightmostChild(t);
			Tree leftSub=leftmostChild(t);
			centerSubtreesBetweenToLeft(leftSub,rightSub);
		}
	}
	
	void centerSubtreesBetweenToRight(Tree leftSub,Tree rightSub)
	{
		if(countSubtreesBetween(leftSub,rightSub)<1)return;
		
		Tree mSub=leftSibling(rightSub);
		while(mSub!=leftSub && mSub.subTreeHeight<rightSub.subTreeHeight)
		{
			mSub=leftSibling(mSub);
			//if(mSub==null){console.log("HAALO");return;}
		}
		moveSubtreesBetweenToRight(mSub,rightSub);
		if(mSub!=leftSub)
		{
			centerSubtreesBetweenToRight(leftSub,mSub);
		}
	}
	
	void centerSubtreesBetweenToLeft(Tree leftSub,Tree rightSub)
	{
		if(countSubtreesBetween(leftSub,rightSub)<1)return;
		
		moveSubtreesBetweenToLeft(leftSub,rightSub);
		return;
		
		Tree mSub=rightSibling(leftSub);
		while(mSub!=rightSub && mSub.subTreeHeight<leftSub.subTreeHeight)
		{
			mSub=rightSibling(mSub);
			//if(mSub==null){console.log("HAALO");return;}
		}
		moveSubtreesBetweenToLeft(leftSub,mSub);
		if(mSub!=rightSub)
		{
			//console.log("split");
			centerSubtreesBetweenToLeft(mSub,rightSub);
		}
	}
	
	void moveSubtreesBetweenToRight(Tree leftSub,Tree rightSub)
	{
		int n=countSubtreesBetween(leftSub,rightSub);
		if(n<1)return;
		
		float spacing=globalGraphicParameter.xspacing*globalGraphicParameter.scale;
		float maxSpaceBetween=rightSub.node.new_x-leftSub.node.new_x-leftSub.node.width;
		float availableSpaceBetween=maxSpaceBetween;
		
		Tree mSub=leftSibling(rightSub);
		while(mSub!=leftSub)
		{
			availableSpaceBetween-=mSub.node.width;
			mSub.node.prevRightDist=0;
			mSub=leftSibling(mSub);
			//if(mSub==null){console.log("HAALO2");return;}
		}
		
		float idealDist=availableSpaceBetween/(n+1)-spacing;
		
		moveSubtreesBetweenDistToRight(leftSub,rightSub,idealDist,n);
	}
	
	void moveSubtreesBetweenToLeft(Tree leftSub,Tree rightSub)
	{
		int n=countSubtreesBetween(leftSub,rightSub);
		if(n<1)return;
		
		float spacing=globalGraphicParameter.xspacing*globalGraphicParameter.scale;
		float maxSpaceBetween=rightSub.node.new_x-leftSub.node.new_x-leftSub.node.width;
		float availableSpaceBetween=maxSpaceBetween;
		
		Tree mSub=leftSibling(rightSub);
		while(mSub!=leftSub)
		{
			availableSpaceBetween-=mSub.node.width;
			mSub.node.prevRightDist=0;
			mSub=leftSibling(mSub);
			//if(mSub==null){console.log("HAALO2");return;}
		}
		
		float idealDist=availableSpaceBetween/(n+1)-spacing;
		
		moveSubtreesBetweenDistToLeft(leftSub,rightSub,idealDist,n);
	}
	
	void moveSubtreesBetweenDistToRight(Tree leftSub,Tree rightSub,float idealDist,int n)
	{
		if(countSubtreesBetween(leftSub,rightSub)<1)return;

		Tree mSub=leftSibling(rightSub);
		while(mSub!=leftSub)
		{
			float rightDist=rightDistance(mSub);
			float rightNodeDist=rightSibling(mSub).node.new_x-mSub.node.new_x-mSub.node.width-globalGraphicParameter.xspacing*globalGraphicParameter.scale;
			if(rightNodeDist<idealDist)
			{
				while(mSub.subTreeHeight<=leftSibling(mSub).subTreeHeight)
				{
					while(mSub!=leftSub && mSub.subTreeHeight<=leftSibling(mSub).subTreeHeight)
					{
						mSub=leftSibling(mSub);
					}
					if(mSub==leftSub)mSub=rightSibling(mSub);
				}
				moveSubtreesBetweenToRight(leftSub,mSub);
				moveSubtreesBetweenToRight(mSub,rightSub);
				break;
			}
			else if(idealDist<rightDist)
			{
				//move to ideal position
				moveSubtree(mSub,rightDist-idealDist);
			}
			else if(idealDist==rightDist)
			{
				//nothing.
			}
			else
			{
				//move as far as possible
				moveSubtree(mSub,rightDist);
				//new idealDist
				if(rightDist>mSub.node.prevRightDist)
				{
					mSub.node.prevRightDist=rightDist;
					//recalculate idealDist
					idealDist=(idealDist*(n+1)-(rightDist-idealDist))/(n+1);
					//restart
					moveSubtreesBetweenDistToRight(leftSub,rightSub,idealDist,n);
					break;
				}
			}
			mSub=leftSibling(mSub);
			//if(mSub==null){console.log("HAALO3");return;}
		}
	}
	
	void moveSubtreesBetweenDistToLeft(Tree leftSub,Tree rightSub,float idealDist,int n)
	{
		if(countSubtreesBetween(leftSub,rightSub)<1)return;

		//console.log(idealDist);
		Tree mSub=rightSibling(leftSub);
		while(mSub!=rightSub)
		{
			float leftDist=leftDistance(mSub);
			float leftNodeDist=mSub.node.new_x-leftSibling(mSub).node.new_x-leftSibling(mSub).node.width-globalGraphicParameter.xspacing*globalGraphicParameter.scale;
			//console.log("leftNodeDist="+leftNodeDist+",leftDist="+leftDist+",idealDist="+idealDist+" --> "+(leftNodeDist<idealDist));
			if(leftNodeDist<idealDist)
			{
				if(mSub.subTreeHeight<=rightSibling(mSub).subTreeHeight)
				{
					while(mSub!=rightSub && mSub.subTreeHeight<=rightSibling(mSub).subTreeHeight)
					{
						//console.log(".");
						mSub=rightSibling(mSub);
					}
					if(mSub==rightSub)mSub=leftSibling(mSub);
				}
				moveSubtreesBetweenToLeft(leftSub,mSub);
				moveSubtreesBetweenToLeft(mSub,rightSub);
				break;
			}
			else if(idealDist<leftDist)
			{
				//move to ideal position
				moveSubtree(mSub,-(leftDist-idealDist));
			}
			else if(idealDist==leftDist)
			{
				//nothing
			}
			else
			{
				//move as far as possible
				moveSubtree(mSub,-leftDist);
				//new idealDist
				if(leftDist>mSub.node.prevRightDist)
				{
					mSub.node.prevRightDist=leftDist;
					//recalculate idealDist
					idealDist=(idealDist*(n+1)-(leftDist-idealDist))/(n+1);
					//restart
					//console.log("RETRY");
					moveSubtreesBetweenDistToLeft(leftSub,rightSub,idealDist,n);
					break;
				}
			}
			mSub=rightSibling(mSub);
			//if(mSub==null){console.log("HAALO3");return;}
		}
	}
	
	int countSubtreesBetween(Tree leftSub,Tree rightSub)
	{
		int n=-1;
		Tree s=rightSub;
		while(s!=leftSub)
		{
			n++;
			s=leftSibling(s);
			//if(s==null){console.log("HAALOs");return;}
		}
		return n;
	}
	
	void compactingSubtrees(Tree t)
	{
		//compacting to right
		Tree rightSub=rightmostChild(t);
		if(rightSub)
		{
			compactingSubtreesToRight(rightSub);
		}
		//compacting to left
		/*
		Tree leftSub=leftmostChild(t);
		if(leftSub)
		{
			compactingSubtreesToLeft(leftSub);
		}
		//*/
		//centerInnerSubtrees(t);
		//subtreeReposToRight(t);
		subtreeReposToLeft(t);
	}
	
	void compactingSubtreesToRight(Tree t)
	{
		Tree leftSib=leftSibling(t);
		if(leftSib)
		{
			allignSubtreeToRight(leftSib);
			compactingSubtreesToRight(leftSib);
		}
	}
	
	void compactingSubtreesToLeft(Tree t)
	{
		Tree rightSib=rightSibling(t);
		if(rightSib)
		{
			allignSubtreeToLeft(rightSib);
			compactingSubtreesToLeft(rightSib);
		}
	}
	
	void allignSubtreeToRight(Tree leftSub)
	{
		float rdist=rightDistance(leftSub);
		if(rdist>1)
		{
			moveSubtree(leftSub,rdist);
		}
	}
	
	void allignSubtreeToLeft(Tree rightSub)
	{
		float ldist=leftDistance(rightSub);
		if(ldist>1)
		{
			moveSubtree(rightSub,-ldist);
		}
	}
	
	void centerInnerSubtrees(Tree t)
	{
		if(t.subtrees.length<3)return;
		
		float spacing=0;
		Tree left=leftmostChild(t);
		while(rightSibling(left))
		{
			spacing+=rightNodeDist(left);
			left=rightSibling(left);
		}
		spacing=spacing/(t.subtrees.length-1);
		
		left=leftmostChild(t);
		while(left)
		{
			Tree right=rightSibling(left);
			if(right && rightSibling(right))
			{
				float rdist=leftDistance(right);
				if(rdist>1)
				{
					if(rdist>spacing)
					{
						moveSubtree(right,-(rdist-spacing));
					}
					else
					{
						moveSubtree(right,-rdist);
					}
				}
			}
			left=rightSibling(left);
		}
	}
	
	Tree leftSibling(Tree t)
	{
		if(t.left_neighbour && t.parenttree==t.left_neighbour.parenttree)
		{
			return t.left_neighbour;
		}
		else return null;
	}
	
	Tree rightSibling(Tree t)
	{
		if(t.right_neighbour && t.parenttree==t.right_neighbour.parenttree)
		{
			return t.right_neighbour;
		}
		else return null;
	}
    
    void positionParentNode(Tree t,int level)
    {
        //--DEBUG--
        //if(debug_max_steps && debug_step_count++>debug_max_steps)return;
    
        if(t.subtrees.length==0)
        {
            positionNode(t,level);
        }
        else
        {
            positionNode(t,level);
            float bmid=t.subtrees[0].node.new_x+t.subtrees[0].new_widthOfBlock()/2;
            float pmid=t.node.new_x+t.node.width/2;
            if(bmid<pmid)
            {
                //move subtrees
                moveSubtrees(t,pmid-bmid);
            }
            else
            {
                //move node
                moveNode(t,bmid-pmid);
                //spread
				/*
                if(t.parenttree)
                {
                    int i=0;
                    int left=-1;
                    //find current node (and first smaller tree in left neighbourhood of siblings)
                    for(i=1;i<t.parenttree.subtrees.length;i++)
                    {
                        if(t.parenttree.subtrees[i]==t)
                        {
                            break;
                        }
                        if(left==-1)
                        {
                            left=i;
                        }
                        if(t.parenttree.subtrees[i] && t.parenttree.subtrees[i].subTreeHeight>=t.subTreeHeight)
                        {
                            left=-1;
                        }
                    }
                    //position (spread) subtrees from left to i.
                    if(left!=-1 && i-left>0) //case i==left is not possible
                    {
						//check min distance to left neighbour
						float tl_dist=rightNodeDist(t.parenttree.subtrees[i-1]);
						float dist=rightDistance(t.parenttree.subtrees[i-1]);
						//check width from left-1 to i
						float maxw=t.node.new_x+t.node.width-t.parenttree.subtrees[left-1].node.new_x;
						float minw=0;
						for(int j=left-1;j<=i;j++)
						{
							if(t.parenttree.subtrees[j])
							{
								minw+=t.parenttree.subtrees[j].node.width+globalGraphicParameter.xspacing*globalGraphicParameter.scale;
							}
							else
							{
								//println("i="+i+" j="+j);
							}
						}
						minw-=globalGraphicParameter.xspacing*globalGraphicParameter.scale;
						float spac=maxw-minw;
						float mspa=spac/(i-left+1);
						float m=tl_dist-mspa;
						if(dist<tl_dist)m=min(dist,tl_dist-mspa);
						else m=tl_dist-mspa;
						if(m<0)return;
						//spread
						for(int j=left;j<i;j++)
						{
							moveSubtree(t.parenttree.subtrees[j],m);
						}
                    }
                }
				*/
            }
        }
    }
	
	Tree leftmostChild(Tree t)
	{
		if(t.subtrees.length!=0)
		{
			return t.subtrees[0];
		}
		return null
	}
	
	Tree rightmostChild(Tree t)
	{
		if(t.subtrees.length!=0)
		{
			return t.subtrees[t.subtrees.length-1];
		}
		return null
	}
    
    float rightNodeDist(Tree t)
    {
        if(t.right_neighbour==null)
        {
            return 0;
        }
        return t.right_neighbour.node.new_x-t.node.new_x-t.node.width-globalGraphicParameter.xspacing*globalGraphicParameter.scale;
    }
	
    float leftNodeDist(Tree t)
    {
        if(t.left_neighbour==null)
        {
            return 0;
        }
        return t.node.new_x-t.left_neighbour.node.new_x-t.left_neighbour.node.width-globalGraphicParameter.xspacing*globalGraphicParameter.scale;
    }
    
    float rightDistance(Tree t)
    {
		int gosub=0;
        float dist=rightNodeDist(t);
        while(t.subtrees.length>0)
        {
            while(t.subtrees.length>0)
            {
                t=t.subtrees[t.subtrees.length-1];
				gosub++;
                dist=min(dist,rightNodeDist(t));
            }
            while(t.subtrees.length==0)
            {
				Tree subroot_t=t;
				Tree subroot_n=t.left_neighbour;
				if(subroot_n==null)break;
				for(int i=0;i<gosub;i++)
				{
					subroot_t=subroot_t.parenttree;
					subroot_n=subroot_n.parenttree;
				}
                if(t.left_neighbour && subroot_n==subroot_t)
                {
                    t=t.left_neighbour;
                }
                /*
				if(t.left_neighbour && t.parenttree==t.left_neighbour.parenttree)
                {
                    t=t.left_neighbour;
                }
				*/
                else
                {
                    break;
                }
            }
        }
        return dist;
    }
    
    float leftDistance(Tree t)
    {
		int gosub=0;
        float dist=leftNodeDist(t);
        while(t.subtrees.length>0)
        {
            while(t.subtrees.length>0)
            {
                t=t.subtrees[0];
				gosub++;
                dist=min(dist,leftNodeDist(t));
            }
            while(t.subtrees.length==0)
            {
				Tree subroot_t=t;
				Tree subroot_n=t.right_neighbour;
				if(subroot_n==null)break;
				for(int i=0;i<gosub;i++)
				{
					subroot_t=subroot_t.parenttree;
					subroot_n=subroot_n.parenttree;
				}
                if(t.right_neighbour && subroot_n==subroot_t)
                {
                    t=t.right_neighbour;
                }
				/*
                if(t.right_neighbour && t.parenttree==t.right_neighbour.parenttree)
                {
                    t=t.right_neighbour;
                }
				*/
                else
                {
                    break;
                }
            }
        }
        return dist;
    }
    
    void moveNode(Tree t,float m)
    {
        //--DEBUG--
        if(debug_max_steps && debug_step_count++>debug_max_steps)return;
    
        t.node.new_x+=m;
    }

    void moveSubtrees(Tree t,float m)
    {
        for(int i=0;i<t.subtrees.length;i++)
        {
            moveSubtree(t.subtrees[i],m);
        }
    }

    void moveSubtree(Tree t,float m)
    {
        //move node
        moveNode(t,m);
        //move subtrees
        moveSubtrees(t,m);
    }
    
    void positionSubtree(Tree t,int level)
    {
        if(t.subtrees.length==0) //if the subtree is a leaf
        {
            //position node right of left neighbour
            positionNode(t,level);
        }
        else //if the subtree is not a leaf
        {
            //do the walker algorithm for this subtree
            myWalkerAlgo(t,level);
        }
    }

    void positionNode(Tree t,int level)
    {
        //--DEBUG--
        if(debug_max_steps && debug_step_count++>debug_max_steps)return;
    
        //position node right of left neighbour
        if(t.left_neighbour==null)
        {
            t.node.new_x=globalGraphicParameter.left-30*globalGraphicParameter.scale;
        }
        else
        {
            t.node.new_x=t.left_neighbour.node.new_x+t.left_neighbour.node.width+globalGraphicParameter.xspacing*globalGraphicParameter.scale;
        }
        t.node.new_y=level;
    }

    void store_old(Tree t)
    {
        t.node.old_x=t.node.getX();
        t.node.old_y=t.node.pos.getY();
        //t.node.new_x=t.node.old_x;
        //t.node.new_y=t.node.old_y;
        for(int i=0;i<t.subtrees.length;i++)
        {
            store_old(t.subtrees[i]);
        }
    }
}

class MyCenterAlgo extends MyWalker
{
    void posNodes(Tree t,boolean animate)
    {
        globalGraphicParameter.setTextSize();
        t.draw_nodes();
        store_old(t);
        naivePos(t,0);
        startAnimRev(t);
        endanim(t);
        findNeighbours(t);
        myCenterAlgo();
        anim(t,0);
        if(!animate)endanim(t);
    }
    
    void myCenterAlgo()
    {
        for(int level=ltr.length-1;level>0;level--)
        {
            myCenterAlgo_level(ltr[level].leftmost(),level);
        }
    }
    
    void myCenterAlgo_level(Tree a,int level)
    {
        //*
        if(debug_step_count)
        {
            if(debug_step_count>=debug_step_count)
            {
                return;
            }
            debug_step_count++;
        }
        //*/
        
        float bmid=a.firstSibling().node.new_x+a.new_widthOfBlock()/2;//first sibling of a should be a itselfe.
        float pmid=a.parenttree.node.new_x+a.parenttree.node.width/2;
        if(bmid<pmid)
        {
            //move block
            a.move_tree_right(pmid-bmid);
            //spread nodes equally
            //--TODO--
            //a.spread_block();
        }
        else
        {
            //move parent
            a.parenttree.move_node_right(bmid-pmid);
        }
        Tree next=a.lastSibling().right_neighbour;
        if(next)myCenterAlgo_level(next);
    }
    
    void findNeighbours(Tree t,int level)
    {
        if(ltr.length<level+1)append(ltr,null);
        if(ltr[level])
        {
            ltr[level].right_neighbour=t;
            t.left_neighbour=ltr[level];
        }
        ltr[level]=t;
        t.node.new_x=t.node.getX();
        
        //Also set y coordinate here.
        t.node.new_y=level;
        
        for(int i=0;i<t.subtrees.length;i++)
        {

            findNeighbours(t.subtrees[i],level+1);
        }
    }
}

















/*
class vpos
{
    Tree[] tl=[];
}

class NaiveAlgoEx extends SetAllNull
{
    vpos[] vp=[];
    void posNodes(Tree t)
    {
        vpos=[];
        naivePos(t,0);
        startAnimRev(t);
    }
    void naivePos(Tree t,int level)
    {
        if(vp.length<level+1)append(vp,new vpos());
        t.node.pos.set(vp[level].tl.length,level);
        t.hpos=vp[level].tl.length;
        append(vp[level].tl,t);
        for(var i=0;i<t.subtrees.length;i++)
        {
            naivePos(t.subtrees[i],level+1);
        }
    }
}

class WalkerAlgo extends NaiveAlgoEx
{
    void posNodes(Tree t)
    {
        naivePos(t,0);
        setAllNull(t);
        walkerPos(t,0);
        startAnimRev(t);
    }
    void walkerPos(Tree t,int level)
    {
        t.node.pos.set(0,level);
        if(t.subtreespos>0)
        {
            t.node.pos.setX(t.parenttree.subtrees[t.subtreespos-1].node.pos.getX0()+1);
        }
        if(t.subtrees.length>0)
        {
            for(int i=0;i<t.subtrees.length;i++)
            {
                walkerPos(t.subtrees[i],level+1);
            }
            float mitte=(t.subtrees[0].node.pos.getX0()+t.subtrees[t.subtrees.length-1].node.pos.getX0())/2;
            if(t.subtreespos>0)
            {
                t.walker_offset=t.node.pos.getX0()+mitte;
                //t.node.pos.x.setEndParameter(t.node.pos.x.getEndParameter()+mitte);
                apportion(t,level);
            }
            else
            {
                t.node.pos.setX(mitte);
            }
        }
    }
    Tree leftNeighbour(Tree t)
    {
    }
    void apportion(t,level)
    {
        Tree linkestes=t.subtrees[0];
        Tree nachbar=null;
        if(linkestes.hpos>0)nachbar=vpos[level].tl[linkestes.hpos];
        int tiefe=1;
        while(linkestes!=null && nachbar!=null)
        {
            rechtePosition = linkestes.position(tiefe);
            linkePosition = nachbar.position(tiefe);
            vorfahrNachbar = nachbar.Vorfahr(tiefe);
            float abstand=rechtePosition+1-linkePosition;
            if(abstand>0)
            {
                int linkeSchw=vorfahrNachbar.subtreespos;
                if(linkeSchw>0)
                {
                    float teil=abstand/linkeSchw;
                    for(int i=t.subtreespos;i<vorfahrNachbar.subtreespos;i++)
                    {
                        t.subtrees[i].node.pos.setX(t.subtrees[i].node.pos.get0()+abstand);
                        t.subtrees[i].walker_offset+=abstand;
                        abstand=abstand-teil;
                    }
                }
            }
            if(linkestes.subtrees.length==0)
            {
                linkestes=knoten.holLinkestes(knoten, 0, tiefe);
            }
            else
            {
                linkestes=linkestes.subtrees[0];
            }
        }
    }
}
*/