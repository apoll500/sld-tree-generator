/*******************************************************************************
*                                                                              *
*  treepars.js                                                                 *
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
// Setup zum Parsen von Termen von SLD-Baumen.

//--------------------------------------------------------
// Globale Variablen:
//--------------------------------------------------------
var global_token_name="";
var global_variable_name="";
var processing_object;

//--------------------------------------------------------
// Handling von Dfa-Events:
//--------------------------------------------------------
function node_func(s,context)
{
    return 0;
}

function link_append_item(jump_info,context)
{
    global_token_name+=jump_info.token;
    return 0;
}

function link_end_item(jump_info,context,type)
{
    switch(type)
    {
        case "functor":
            processing_object.addFunctor(global_token_name);
            break;
        case "variable":
            processing_object.addVariable(global_token_name);
            break;
        case "literal":
            processing_object.addLiteral(global_token_name);
            break;
        case "cnumber":
            processing_object.addCNumber(global_token_name);
            global_token_name="";
            return 0;
            break;
        case "null":
            //dieses Tolen ignorieren.
            global_token_name="";
            return 0;
            break;
        case "operator":
            break;
        case "variable_name":
            global_variable_name=global_token_name;
            global_token_name="";
            return 0;
            break;
        case "variable_index":
            processing_object.addVariable(global_variable_name,global_token_name);
            global_token_name="";
            return 0;
            break;
        default:
            processing_object.addText(global_token_name);
            break;
    }
    global_token_name="";
    processing_object.addOperator(jump_info.token);
    return 0;
}

//Standard Fehler Funktion.
function err_func(info,context)
{
    document.write("<hr>FAIL: "+info.fromNode+" --["+info.token+"]-->     --- [Status: "+info.status_desc+"]");
    return 0;
}

// Standard Event-Handling.
function info_func(a,b)
{
    document.write("<hr>"+a+" "+b+"<br>");
}

//--------------------------------------------------------
// Interface:
//--------------------------------------------------------
function createDfa_TermParse()
{
    var dfa=new Dfa();
    dfa.setOwnerCallback(function(a,b){info_func(a,b);});
    dfa.setNewStartNode("N1");
    dfa.addNode("N1",function(a,b){node_func(a,b);});
    dfa.addNode("N2",function(a,b){node_func(a,b);});
    dfa.addNode("N3",function(a,b){node_func(a,b);});
    dfa.addNode("N4",function(a,b){node_func(a,b);});
    dfa.addNode("N5",function(a,b){node_func(a,b);});
    dfa.addNode("V1",function(a,b){node_func(a,b);});
    dfa.addNode("V2",function(a,b){node_func(a,b);});
    dfa.addNode("V3",function(a,b){node_func(a,b);});
    dfa.addNode("V4",function(a,b){node_func(a,b);});
    dfa.addNode("V5",function(a,b){node_func(a,b);});
    dfa.addNode("V6",function(a,b){node_func(a,b);});
    dfa.addNode("V7",function(a,b){node_func(a,b);});
    dfa.addNode("V8",function(a,b){node_func(a,b);});
    dfa.addNode("A1",function(a,b){node_func(a,b);});
    dfa.addNode("A2",function(a,b){node_func(a,b);});
    
    var smallLetters=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u',    'w','x','y','z'];
    var bigletters=  ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    var operators=   ['(',')','+','-','<','>',':','/',',',';','.','[',']','\"','\'','=','\n',' ','%','|'];
    var cnumberop=   ['$'];
    
    dfa.addLink_ssaf("N1","N1",operators,   function(a,b){link_end_item(a,b,"operator");});
    dfa.addLink_ssaf("N1","N2",smallLetters,function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("N1","N3",bigletters,  function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("N1","N3",'_',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("N1","N5",'$',         function(a,b){});
    dfa.addLink_ssf ("N1","N4",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssf ("N2","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssf ("N3","N3",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssf ("N4","N4",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssf ("N5","N5",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("N5","N1",')',         function(a,b){link_end_item(a,b,"cnumber");});
    dfa.addLink_ssaf("N2","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssaf("N3","N1",operators,   function(a,b){link_end_item(a,b,"variable");});
    dfa.addLink_ssaf("N4","N1",operators,   function(a,b){link_end_item(a,b,"literal");});
    dfa.addLink_ssif("N1","V1",'v',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V1","V2",'a',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V2","V3",'r',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V3","V4",'i',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V4","V5",'a',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V5","V6",'b',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V6","V7",'l',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V7","V8",'e',         function(a,b){link_append_item(a,b);});
    dfa.addLink_ssf ("V1","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V1","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V2","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V2","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V3","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V3","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V4","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V4","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V5","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V5","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V6","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V6","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V7","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssaf("V7","N1",operators,   function(a,b){link_end_item(a,b,"functor");});
    dfa.addLink_ssf ("V8","N2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("V8","A1",'(',         function(a,b){link_end_item(a,b,"null");});
    dfa.addLink_ssf ("A1","A1",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("A1","A1",'\'',        function(a,b){});
    dfa.addLink_ssif("A1","A2",',',         function(a,b){link_end_item(a,b,"variable_name");});
    dfa.addLink_ssf ("A2","A2",             function(a,b){link_append_item(a,b);});
    dfa.addLink_ssif("A2","N1",')',         function(a,b){link_end_item(a,b,"variable_index");});
    return dfa;
}

function parseString(dfa,str,obj)
{
    dfa.reset();
    processing_object=obj;
    dfa.parseStr(str);
}
