/*******************************************************************************
*                                                                              *
*  dfa.js                                                                      *
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
//Modelliert einen endlichen deterministischen Automaten.

function DfaNode(dfa,name)
{
    this.name=name;
    this.dfa=dfa;
    this.func=0;
    this.defaultLink=0;
    this.endStatus=false;
    this.links=[];
    this.addLink=function(tok,node,callback)
    {
        this.links.push(new DfaLink(dfa,tok,node,callback));
    }
    this.addDefaultLink=function(node,callback)
    {
        this.defaultLink=new DfaLink(dfa,[],node,callback);
    }
    this.feed=function(token)
    {
        this.dfa.msg_info.fromNode=this.name;
        this.dfa.msg_info.toNode=0;
        this.dfa.msg_info.token=token;
        this.dfa.msg_info.status_id="DFA_STATUSID_INV";
        this.dfa.msg_info.status_desc="DFA_STATUS_INV";
        //walk through all links
        for(var i=0;i<this.links.length;i++)
        {
            //walk through all tokens for each link
            for(var j=0;j<this.links[i].token.length;j++)
            {
                //if the token matches, then jump
                if(this.links[i].token[j]==token)
                {
                    this.links[i].jump(token);
                    return this.dfa.msg_info.status_id;
                }
            }
        }
        //jump default link if set
        if(this.defaultLink!=0)
        {
            this.defaultLink.jump(token);
            return this.dfa.msg_info.status_id;
        }
        //call error function
        if(this.dfa.errfunc)
        {
            this.dfa.errfunc(this.dfa.msg_info,this.dfa.context);
        }
        //return status
        return dfa.msg_info.status_id;
    }
}

function DfaLink(dfa,tok,node,callback)
{
    this.dfa=dfa;
    this.token=tok;
    this.toNode=node;
    this.func=callback;
    this.jump=function(token)
    {
        this.dfa.msg_info.fromNode=this.dfa.currentNode.name;
        this.dfa.msg_info.toNode=this.toNode.name;
        this.dfa.msg_info.token=token;
        this.dfa.msg_info.status_id="DFA_STATUSID_NOR";
        this.dfa.msg_info.status_desc="DFA_STATUS_NOR";
        //jumping, setting the new current node
        this.dfa.currentNode=this.toNode;
        //if position reached with no outgoing links
        if(this.dfa.currentNode.links.length==0 && this.dfa.currentNode.defaultLink==0)
        {
            this.dfa.msg_info.status_id="DFA_STATUSID_IPE";
            this.dfa.msg_info.status_desc="DFA_STATUS_IPE";
        }
        //if node represents valid end status
        if(this.dfa.currentNode.endStatus)
        {
            this.dfa.msg_info.status_id="DFA_STATUSID_END";
            this.dfa.msg_info.status_desc="DFA_STATUS_END";
        }
        //executing link function
        if(this.func!=0)
        {
            this.func(this.dfa.msg_info,this.dfa.context);
        }
        //also executing node function of reached node
        if(this.dfa.currentNode.func!=0)
        {
            this.dfa.currentNode.func(this.dfa.currentNode.name,this.dfa.context);
        }
    }
}

function Dfa()
{
    this.context=0;
    this.startNode=0;
    this.currentNode=0;
    this.errfunc=0;
    this.callOwner=0;
    this.msg_info={fromNode:0,toNode:0,token:0,status_id:0,status_desc:0};
    this.allNodes={};
    this.setContext=function(c)
    {
        this.context=c;
    }
    this.setOwnerCallback=function(callback)
    {
        this.callOwner=callback;
    }
    this.setErrorCallback=function(callback)
    {
        this.errfunc=callback;
    }
    this.feed=function(token)
    {
        if(this.currentNode!=0)
        {
            return this.currentNode.feed(token);
        }
        return -1;
    }
    this.reset=function()
    {
        this.currentNode=this.startNode;
    }
    this.setPos_n=function(node)
    {
        this.currentNode=node;
    }
    this.setPos_s=function(name)
    {
        var i=Object.keys(this.allNodes).indexOf(name);
        if(i!=-1)
        {
            this.currentNode=this.allNodes[name];
            return true;
        }
        else
        {
            return false;
        }
    }
    this.setEndStatus=function(name,status)
    {
        var i=Object.keys(this.allNodes).indexOf(name);
        if(i!=-1)
        {
            this.allNodes[name].endStatus=status;
            return true;
        }
        else
        {
            return false;
        }
    }
    this.setStartNode=function(node)
    {
        this.startNode=node;
    }
    this.setNewStartNode=function(name)
    {
        this.startNode=this.addNode(name);
    }
    this.addNode=function(name)
    {
        var i=Object.keys(this.allNodes).indexOf(name);
        if(i!=-1)return this.allNodes[name];
        node=new DfaNode(this,name);
        this.allNodes[name]=node;
        return node;
    }
    this.addLink_nnaf=function(fromNode,toNode,tok,callback)
    {
        fromNode.addLink(tok,toNode,callback);
    }
    this.addLink_nnf=function(fromNode,toNode,callback)
    {
        fromNode.addDefaultLink(toNode,callback);
    }
    this.addLink_ssaf=function(from,to,tok,callback)
    {
        var fromNode;
        var toNode;
        var i=Object.keys(this.allNodes).indexOf(from);
        if(i!=-1)
        {
            fromNode=this.addNode(from);
        }
        else
        {
            fromNode=this.allNodes[from];
        }
        var j=Object.keys(this.allNodes).indexOf(to);
        if(j!=-1)
        {
            toNode=this.addNode(to);
        }
        else
        {
            toNode=this.allNodes[to];
        }
        this.addLink_nnaf(fromNode,toNode,tok,callback);
        return true;
    }
    this.addLink_ssif=function(from,to,tok,callback)
    {
        return this.addLink_ssaf(from,to,[tok],callback);
    }
    this.addLink_ssi=function(from,to,tok)
    {
        return this.addLink_ssaf(from,to,[tok],0);
    }
    this.addLink_ssa=function(from,to,tok)
    {
        return this.addLink_ssaf(from,to,tok,0);
    }
    this.addLink_ssf=function(from,to,callback)
    {
        var fromNode;
        var toNode;
        var i=Object.keys(this.allNodes).indexOf(from);
        if(i!=-1)
        {
            fromNode=this.addNode(from);
        }
        else
        {
            fromNode=this.allNodes[from];
        }
        var j=Object.keys(this.allNodes).indexOf(to);
        if(j!=-1)
        {
            toNode=this.addNode(to);
        }
        else
        {
            toNode=this.allNodes[to];
        }
        this.addLink_nnf(fromNode,toNode,callback);
        return true;
    }
    this.parseStr=function(a)
    {
        var r=new Reader(a,a.length);
        var ch;
        var status="DFA_STATUSID_NOR";
        while(status=="DFA_STATUSID_NOR" && ch!=-1)
        {
            ch=r.get();
            if(ch!=-1)status=this.feed(ch);
        }
        return status;
    }
}
