/*******************************************************************************
*                                                                              *
*  receive.js                                                                  *
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
//--------------------------------------------------------
// Globale Variablen:
//--------------------------------------------------------

var global_DOM_clauses_div=null;
var global_DOM_clauses_win=null;
var global_DOM_main_canvas=null;
//--------------------------------------------------------
// Setup:
//--------------------------------------------------------

//--------------------------------------------------------
// Empfangen von http-Antworten von Prolog
//--------------------------------------------------------

function receiveTree_ascii(tree)
{
    this.document.getElementById("Out").innerHTML="<pre>"+tree+"</pre>";
}

function receiveTree_json(tree)
{
    //alert(tree);
    tree=decodeURIComponent(tree);
    //alert(tree);
    tree=checkTree(tree);
    this.document.getElementById("Out").innerHTML="<pre>Output</pre>";
    //this.document.getElementById("Out").innerHTML="<pre>"+tree+"</pre>";
    var o=JSON.parse(tree);
    //this.document.getElementById("Out").innerHTML="<pre>"+o+"</pre>";
    //alert(o);
    //alert(JSON.stringify(o));
    //var ele=Object.keys(o);
    //var el=Object.getOwnPropertyNames(o);
    //walki(el,o);
	scroll_to_home();
    load_json_object(o);
}

function receiveSubTree_json(tree)
{
    if(globalSelectedSubtreeRequest==null)
        alert(tree);
    else
    {
		tree=checkTree(tree);
		this.document.getElementById("Out").innerHTML="<pre>Output</pre>";
		var o=JSON.parse(tree);
		append_json_object(o);
	}
}

function receiveParentTree_json(tree)
{
    tree=checkTree(tree);
    this.document.getElementById("Out").innerHTML="<pre>Output</pre>";
    var o=JSON.parse(tree);
    goup_json_object(o);
}

function receiveClauseList(clauseList)
{
    //if(global_DOM_clauses_div)global_DOM_clauses_div.innerHTML="<pre>"+clauseList+"</pre>";
    //if(global_DOM_clauses_div)global_DOM_clauses_div.innerHTML="<div style='font-family:courier;'>"+clauseList+"</div>";
    //if(global_DOM_clauses_div)global_DOM_clauses_div.innerHTML=clauseList;
    theClistProcessingObject.setList(clauseList);
}

function receivePrologAnswer(answer)
{
    if(globalSelectedSubtreeRequest==null)
        alert(answer);
    else
    {
        globalGraphicParameter.iwin.answer=new theProcessingObject.Term(answer);
        globalGraphicParameter.iwin.visible=true;
        globalGraphicParameter.iwin.refX=globalSelectedSubtreeRequest.node.getX()+globalSelectedSubtreeRequest.node.getH()+globalGraphicParameter.scrollx;
        globalGraphicParameter.iwin.refY=globalSelectedSubtreeRequest.node.getY()+globalSelectedSubtreeRequest.node.getH()+globalGraphicParameter.scrolly;
        globalGraphicParameter.iwin.posX=globalSelectedSubtreeRequest.node.getX()+globalGraphicParameter.scrollx;
        globalGraphicParameter.iwin.posY=globalSelectedSubtreeRequest.node.getY()+globalSelectedSubtreeRequest.node.getH()*1.5+globalGraphicParameter.scrolly;
        //globalSelectedSubtreeRequest=null;
    }
}

//--------------------------------------------------------
// onFail:
//--------------------------------------------------------

function checkTree(tree)
{
    if(tree=="fail.")
    {
        var goal1=goal;
        if(goal.charAt(goal.length-1)=='.')goal1=goal.substr(0,goal.length-1);
        tree='{"PrologTerm":"tree(node(0,goal('+goal1+'),cl(0,variant(true)),[],[loc(0,0),[p(goal('+goal1+'),[],[])]],[]),[tree(node(1,goal(fail),cl(0,variant(fail)),[],[loc(0,1)],[]),[])])","Tree":{"Node":{"Id":0,"Goal":"'+goal1+'","Cid":0,"Clause":"true","Unificator":{"this":null},"Properties":{"Location":{"Pid":0,"Depth":0},"Path":{"PathNode[1]":{"Goal":"goal('+goal1+')","Variables":{"this":null},"Unificator":{"this":null}}}},"Variables":{"this":null}},"SubTrees":{"Tree[0]":{"Node":{"Id":1,"Goal":"fail","Cid":0,"Clause":"fail","Unificator":{"this":null},"Properties":{"Location":{"Pid":0,"Depth":1}},"Variables":{"this":null}},"SubTrees":{"this":null}}}}}';
    }
    return tree;
}

var lastErrorDocument="";

function show_server_error(response)
{
    lastErrorDocument=response;
    var d=openbox("Info","dialogue/error.html",64,64,320,460,"#4C391E","#CCCCCC","#CCCCCC","#CCCCCC");
    centerbox(d);
}

function getErrorDocument()
{
        return lastErrorDocument;
}

//{"PrologTerm":"tree(node(0,goal(p(1)),cl(0,variant(true)),[],[loc(0,0),[p(goal(p(1)),[],[])]],[]),[tree(node(1,goal(true),cl(1,variant((p(1):-true))),[],[loc(0,1)],[]),[])])","Tree":{"Node":{"Id":0,"Goal":"p(1)","Cid":0,"Clause":"true","Unificator":{"this":null},"Properties":{"Location":{"Pid":0,"Depth":0},"Path":{"PathNode[1]":{"Goal":"goal(p(1))","Variables":{"this":null},"Unificator":{"this":null}}}},"Variables":{"this":null}},"SubTrees":{"Tree[0]":{"Node":{"Id":1,"Goal":"true","Cid":1,"Clause":"p(1):-true","Unificator":{"this":null},"Properties":{"Location":{"Pid":0,"Depth":1}},"Variables":{"this":null}},"SubTrees":{"this":null}}}}}

//--------------------------------------------------------
// Debug:
//--------------------------------------------------------

// durchlaufe alle Eigenschaften
function walki(el,o)
{
    for(var i=0;i<el.length;i++)
    {
        alert(el[i]+"="+o[el[i]]);
        if(o[el[i]]!==null && typeof o[el[i]]==='object')
            walki(Object.getOwnPropertyNames(o[el[i]]),o[el[i]]);
    }
}
