/*******************************************************************************
*                                                                              *
*  varparsq.js                                                                 *
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
// Test-Setup zur Ersetzung von Variablen der Form variables $[name].

//--------------------------------------------------------
// Globale Variablen:
//--------------------------------------------------------
var global_varpar_variable_name="";
var global_varpar_output="";

//--------------------------------------------------------
// Handling Dfa-events:
//--------------------------------------------------------
//Standard Node-Event Funktion.
function node_func(s,context)
{
    return 0;
}

//Standard Link-Event Funktion.
function link_func(jump_info,context)
{
    return 0;
}

//Ausgabe und Variablen-Ersetzung.
function link_func_char(jump_info,context)
{
    global_varpar_output+=jump_info.token;
    return 0;
}
function link_func_var(jump_info,context)
{
    global_varpar_variable_name+=jump_info.token;
    return 0;
}
function link_func_printvar(jump_info,context)
{
    var str;
    try
    {
        str=eval(global_varpar_variable_name);
    }
    catch(e)
    {
        str="undefined";
    }
    global_varpar_output+=str;
    global_varpar_variable_name="";
    return 0;
}

//Standard Fehler Funktion.
function err_func(info,context)
{
    document.write("<hr>FAIL: "+info.fromNode+" --["+info.token+"]-->     --- [Status: "+info.status_desc+"]");
    return 0;
}

// Standard Event-Handling Funktion.
function info_func(a,b)
{
    document.write("<hr>"+a+" "+b+"<br>");
}

//--------------------------------------------------------
// Interface:
//--------------------------------------------------------
function createDfa()
{
    var dfa=new Dfa();
    dfa.setOwnerCallback(function(a,b){info_func(a,b);});
    dfa.setNewStartNode("Char");
    dfa.addNode("Char",function(a,b){node_func(a,b);});
    dfa.addNode("V0",function(a,b){node_func(a,b);});
    dfa.addNode("V1",function(a,b){node_func(a,b);});
    dfa.addNode("V2",function(a,b){node_func(a,b);});
    dfa.addNode("VChar",function(a,b){node_func(a,b);});
    dfa.addLink_ssf("Char","Char",function(a,b){link_func_char(a,b);});
    dfa.addLink_ssif("Char","V0",'$',function(a,b){link_func(a,b);});
    dfa.addLink_ssif("V0","V1",'[',function(a,b){link_func(a,b);});
    dfa.addLink_ssif("V1","V2",']',function(a,b){link_func(a,b);});
    dfa.addLink_ssf("V1","VChar",function(a,b){link_func_var(a,b);});
    dfa.addLink_ssf("VChar","VChar",function(a,b){link_func_var(a,b);});
    dfa.addLink_ssif("VChar","V2",']',function(a,b){link_func_printvar(a,b);});
    dfa.addLink_ssf("V2","Char",function(a,b){link_func_char(a,b);});
    dfa.addLink_ssif("V2","V0",'$',function(a,b){link_func(a,b);});
    return dfa;
}

function parseStr(dfa,str)
{
    global_varpar_output="";
    dfa.reset();
    dfa.parseStr(str);
}

function getOutput()
{
    return global_varpar_output;
}

//--------------------------------------------------------
// Test:
//--------------------------------------------------------
var global_varpar_name="ANDY";
function test()
{
    var dfa=createDfa();
    parseStr(dfa,"Hallo $[global_varpar_name]!");
    document.write(getOutput());
    document.write("<hr>fertig!");
}
