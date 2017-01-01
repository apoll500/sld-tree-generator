/*******************************************************************************
*                                                                              *
*  http.js                                                                     *
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
//a counter identifying each http-request and incremented by every http-request
//to allow identifying the reply of the latest request, while discarding all
//other replies.
var pagecount=0;

//------------------------------------------------------------------------------
// Some functions useful for debugging, may be deleted
//------------------------------------------------------------------------------
function receive(text)
{
    alert(text);
}

function about()
{
    httpSend("event(65)",alert);
}

function showprog()
{
    httpSend("event(100)",alert);
}

//------------------------------------------------------------------------------
// Anfragen an Prolog senden.
//------------------------------------------------------------------------------
function askProlog(question,param)
{
    var prog=program;
    while(prog.search("\n")!=-1)
    {
        prog=prog.replace("\n","\\n");
    }
    switch(question)
    {
        case "asciiTree":
            this.document.getElementById("Out").innerHTML="<pre>?- "+goal+"</pre>";
            httpSendData("event("+question+",goal('"+goal+"'),program('"+prog+"'),depth("+depth+"))",receiveTree_ascii);
            break;
        case "jsonTree":
            httpSendData("event("+question+",goal('"+goal+"'),program('"+prog+"'),depth("+depth+"))",receiveTree_json);
            break;
        case "jsonSubTree":
            pagecount++;
            globalSelectedSubtreeRequest=globalSelectedSubtree;
            httpSendData("event("+question+",tree("+globalSelectedSubtree.parenttree.prologTerm.str+"),node(id("+globalSelectedSubtree.parenttree.node.id%10000+","+Math.floor(globalSelectedSubtree.parenttree.node.id/10000)+")),program('"+prog+"'),depth("+depth+"))",receiveSubTree_json);
            break;
        case "jsonParentTree":
            httpSendData("event("+question+",tree("+globalRootTree.prologTerm.str+"),node(id("+globalRootTree.node.id%10000+","+Math.floor(globalRootTree.node.id/10000)+")),program('"+prog+"'),depth("+depth+"))",receiveParentTree_json);
            break;
        case "getClauseList":
            httpSendData("event("+question+",program('"+prog+"'))",receiveClauseList);
            break;
        case "prologAnswer":
            pagecount++;
            if(!globalRootTree){alert("No tree generated jet. Generate a tree first.");return;}
            if(!globalSelectedSubtree){alert("No node selected, Select node first.");return;}
            globalSelectedSubtreeRequest=globalSelectedSubtree;
            httpSendData("event("+question+",tree("+globalSelectedSubtree.prologTerm.str+"),node(id("+globalSelectedSubtree.node.id%10000+","+Math.floor(globalSelectedSubtree.node.id/10000)+")))",receivePrologAnswer);
            break;
        default:
            alert("Unknown Question: "+question);
    }
}

//------------------------------------------------------------------------------
// URLs for sending http-requests to prolog
//------------------------------------------------------------------------------
function makePrologURL()
{
    return "http://"+this.location.host+"/prolog";
}

function makeGetURL(eventTerm)
{
    return makePrologURL()+"?e="+encodeURIComponent(eventTerm);
}

//------------------------------------------------------------------------------
// http-requests with GET data
//------------------------------------------------------------------------------
function httpSend(eventTerm,callback)
{
    httpGetAsync(makeGetURL(eventTerm),callback);
}

function httpGetAsync(url,callback)
{
    var r=new XMLHttpRequest();
    var pc=pagecount;
    r.onreadystatechange=
            function()
            {
                if(r.readyState==4)
                    if(r.status==200)
                        if(pc==pagecount)
                            callback(r.responseText);
                        else{}
                    else if(r.status==414)
                        show_server_error(r.responseText);
                    else if(r.status==500)
                        show_server_error(r.responseText);
                    else
                        callback("fail.");
            }
    r.open("GET",url+"&pc="+pc,true);
    r.send(null);
}

//------------------------------------------------------------------------------
// http-requests with POST data
//------------------------------------------------------------------------------
function httpSendData(data,callback)
{
    httpPostAsync(makePrologURL(),data,callback);
}

function httpPostAsync(url,data,callback)
{
    var r=new XMLHttpRequest();
    var pc=pagecount;
    r.onreadystatechange=
            function()
            {
                if(r.readyState==4)
                    if(r.status==200)
                        if(pc==pagecount)
                            callback(r.responseText);
                        else{}
                    else if(r.status==500)
                        show_server_error(r.responseText);
                    else
                        callback("fail.");
            }
    r.open("POST",url,true);
    //For application/x-www-form-urlencoded data needs to be a pair (or a list
    //of pairs) in the form of name=value. The data would need to be in the form
    //e=event(...). Using application/x-prolog allows data to be a prolog term.
    //So we can send the term event(...) without the 'e='.
    r.setRequestHeader("Content-type","application/x-prolog");
    //alert(data.substr(0,data.length-1)+","+pc+")\n\n");
    r.send(data.substr(0,data.length-1)+","+pc+")\n\n");
}
