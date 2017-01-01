/*******************************************************************************
*                                                                              *
*  loadjson.js                                                                 *
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
// Global variables:
//--------------------------------------------------------

//Reference of the runntime instance of processing.
var theProcessingObject;
var theClistProcessingObject;
//Reference of the root of the currently displayed tree.
var globalRootTree=null;
//Reference of the currently selected subtree.
var globalSelectedSubtree=null;
var globalSelectedSubtreeRequest=null;
var globalSelectedSubstSubtree=null;
//Reference of the object holding global drawing parameters.
var globalGraphicParameter=null;

//This function should be called from processing to pass a reference of itself to JavaScript.
function setProcessing(p)
{
    theProcessingObject=p;
    // -- This could also be done by Processing.getInstanceById().
    //var processingInstance=Processing.getInstanceById("main_canvas");
    //if(processingInstance==theProcessingObject)alert("same reference");
}

function load_json_object(o)
{
    //prolog tree
    var prologTerm=new theProcessingObject.PrologTerm(o["PrologTerm"]);
    //Root-Tree
    globalRootTree=load_json_tree(o["Tree"],prologTerm,globalGraphicParameter,null);
    globalSelectedSubtree=globalRootTree;
    new theProcessingObject.MyWalker().posNodes(globalRootTree,true);
}

function append_json_object(o)
{
	if(globalSelectedSubtreeRequest)
	{
		globalSelectedSubtree=globalSelectedSubtreeRequest;
	}
    //prolog tree
    var prologTerm=new theProcessingObject.PrologTerm(o["PrologTerm"]);
    //Root-Tree
    var ptree=load_json_tree(o["Tree"],prologTerm,globalGraphicParameter,null);
    globalSelectedSubtree.parenttree.subtrees=ptree.subtrees;
    for(var i=0;i<ptree.subtrees.length;i++)
    {
        ptree.subtrees[i].parenttree=globalSelectedSubtree.parenttree;
    }
    globalSelectedSubtree=globalSelectedSubtree.parenttree;
    new theProcessingObject.MyWalker().posNodes(globalRootTree,true);
}

function goup_json_object(o)
{
    //prolog tree
    var prologTerm=new theProcessingObject.PrologTerm(o["PrologTerm"]);
    //Root-Tree
    var ptree=load_json_tree(o["Tree"],prologTerm,globalGraphicParameter,null);
    globalRootTree=ptree;
    globalSelectedSubtree=ptree;
    new theProcessingObject.MyWalker().posNodes(globalRootTree,true);
}

function load_json_tree(tree,prologTerm,gp,pt)
{
    //Node
    var pnode=load_json_node(tree["Node"],gp);
    //Tree
    var ptree=new theProcessingObject.Tree(pnode,prologTerm,gp,pt);
    //Subtrees
    load_json_subtrees(tree["SubTrees"],prologTerm,gp,ptree);
    return ptree;
}

function load_json_subtrees(subtrees,prologTerm,gp,pt)
{
    if(Object.getOwnPropertyNames(subtrees)[0]=="this")return null;
    var n=Object.keys(subtrees).length;
    for(var i=0;i<n;i++)
    {
        var tree=subtrees["Tree["+i+"]"];
        load_json_tree(tree,prologTerm,gp,pt);
    }
}

function load_json_node(node,gp)
{
    var slist=load_json_substitutions(node["Unificator"]);
    var plist=load_json_properties(node["Properties"]);
    var vlist=load_json_variables(node["Variables"]);
    var pnode=new theProcessingObject.Node(node["Id"],node["Goal"],node["Cid"],node["Clause"],slist,plist,vlist,gp);
    return pnode;
}

function load_json_substitutions(s)
{
    var slist=[];
    if(Object.getOwnPropertyNames(s)[0]=="this")return null;
    var n=Object.keys(s).length;
    for(var i=0;i<n;i++)
    {
        var name=s["Substitution["+i+"]"].Variable.Name;
        var index=s["Substitution["+i+"]"].Variable.Index;
        var term=s["Substitution["+i+"]"].Term;
        var substitution=new theProcessingObject.Substitution(name,index,term);
        slist.push(substitution);
    }
    return slist;
}

function load_json_properties(p)
{
    return null;
}

function load_json_variables(v)
{
    var vlist=[];
    if(Object.getOwnPropertyNames(v)[0]=="this")return null;
    var n=Object.keys(v).length;
    for(var i=0;i<n;i++)
    {
        var name=v["Variable["+i+"]"].Name;
        var index=v["Variable["+i+"]"].Index;
        var variable=new theProcessingObject.Variable(name,index);
        vlist.push(variable);
    }
    return vlist;
}
