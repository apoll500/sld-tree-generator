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
function receive(text)
{
    alert(text);
}

function about()
{
    httpGetAsync("http://"+this.location.host+"/prolog?e=event(65)",alert);
}

function goalButtonSubmit()
{
    var goal=this.document.f1.goal.value;
    var depth=this.document.f1.depth.value;
    var program=this.document.f1.program.value;
    this.document.getElementById("Out").innerHTML="<pre>?- "+goal+"</pre>";
    while(program.search("\n")!=-1)
    {
        program=program.replace("\n","\\n");
    }
    httpGetAsync("http://"+this.location.host+"/prolog?e=event(asciiTree,goal('"+goal+"'),program('"+program+"'),depth("+depth+"),0)",showTree);
}

function showTree(tree)
{
    this.document.getElementById("Out").innerHTML="<pre>"+tree+"</pre>";
}

//SYNCH
//function httpGetSynch(url)
//{
//    var r=new XMLHttpRequest();
//    r.open("GET",url,false);
//    r.send(null);
//    return r.responseText;
//}

//ASYNCH
function httpGetAsync(url,callback)
{
    var r=new XMLHttpRequest();
    r.onreadystatechange=
            function()
            {
                if(r.readyState==4 && r.status==200)
                    callback(r.responseText);
            }
    r.open("GET",url,true);
    r.send(null);
}
