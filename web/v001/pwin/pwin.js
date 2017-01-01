/*******************************************************************************
*                                                                              *
*  pwin.js                                                                     *
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
var global_pwin_maxrc=10;

function write_box(id,title,location,left,top,width,height,visibility,color)
{
    write_box2(id,title,location,left,top,width,height,visibility,color,"new");
}

function write_box2(id,title,location,left,top,width,height,visibility,color,style)
{
    this.document.write("<div id='BOXO_"+id+"' style='z-Index:"+(500+id)+";visibility:"+visibility+";position:absolute;top:0px;left:0px;margin-left:"+left+"px;margin-top:"+top+"px;width:"+width+"px;height:"+height+"px;font-family:arial;font-size:11pt;color:#EEEEEE;border:solid 0px #000000;'>\n\
\n\
<div style='width:100%;height:21px;display:none;' id='block_a_"+id+"'>\n\
\n\
<!--Titelleiste-->\n\
<table width='100%' height='21px' border='0' cellpadding='0' cellspacing='0'>\n\
<tr>\n\
\n\
<td width='7px' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t0.png'></td>\n\
<td width='17px' bgcolor='"+color+"' id='BOXO_r0a_"+id+"' style='height:21px;overflow:hidden;font-size:1pt;'><a href='JavaScript:rollup("+id+")'><img src='pwin/images/"+style+"/t1_0.png' border='0'></a></td>\n\
<td width='7px' bgcolor='"+color+"' id='BOXO_t0a_"+id+"' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t2.png'></td>\n\
\n\
<td bgcolor='"+color+"' id='BOXO_t1a_"+id+"' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><div style=\"height:21px;font-family:arial;font-size:12pt;color:#552200;background:url('pwin/images/"+style+"/t3.png');background-repeat:repeat-x;\">\n\
<div id='BOXO_titlea_"+id+"' style='padding-top:3px;' style='height:21px;overflow:hidden;font-size:1pt;'><nobr>"+title+"</nobr></div>\n\
</div></td>\n\
\n\
<td width='6px' bgcolor='"+color+"' id='BOXO_t2a_"+id+"' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t4.png'></td>\n\
<td width='100%' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><div style=\"background:url('pwin/images/"+style+"/t5.png');background-repeat:repeat-x;\"><img src='pwin/images/"+style+"/t5.png'></div></td>\n\
<td width='11px' bgcolor='"+color+"' id='BOXO_x0a_"+id+"' style='height:21px;overflow:hidden;font-size:1pt;'><a href='JavaScript:hidebox2_"+id+"()'><img src='pwin/images/"+style+"/t6.png' border='0'></a></td>\n\
<td width='11px' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t7.png'></td>\n\
\n\
</tr>\n\
</table>\n\
\n\
</div>\n\
\n\
\n\
<div style='width:100%;height:100%;display:block;' id='block_b_"+id+"'>\n\
<table width='100%' height='100%' border='0' cellpadding='0' cellspacing='0'>\n\
<tr><td height='21px'>\n\
\n\
<!--Titelleiste-->\n\
<table width='100%' height='21px' border='0' cellpadding='0' cellspacing='0'>\n\
<tr>\n\
\n\
<td width='7px' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t0.png'></td>\n\
<td width='17px' bgcolor='"+color+"' id='BOXO_r0_"+id+"' style='height:21px;overflow:hidden;font-size:1pt;'><a href='JavaScript:rollup("+id+")'><img src='pwin/images/"+style+"/t1_1.png' border='0'></a></td>\n\
<td width='7px' bgcolor='"+color+"' id='BOXO_t0_"+id+"' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t2.png'></td>\n\
\n\
<td bgcolor='"+color+"' id='BOXO_t1_"+id+"' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><div style=\"height:21px;font-family:arial;font-size:12pt;color:#552200;background:url('pwin/images/"+style+"/t3.png');background-repeat:repeat-x;\">\n\
<div id='BOXO_titleb_"+id+"' style='padding-top:3px;overflow:hidden;height:18px;'><nobr>"+title+"</nobr></div>\n\
</div></td>\n\
\n\
<td width='6px' bgcolor='"+color+"' id='BOXO_t2_"+id+"' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t4.png'></td>\n\
<td width='100%' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><div style=\"background:url('pwin/images/"+style+"/t5.png');background-repeat:repeat-x;\"><img src='pwin/images/"+style+"/t5.png'></div></td>\n\
<td width='11px' bgcolor='"+color+"' id='BOXO_x0_"+id+"' style='height:21px;overflow:hidden;font-size:1pt;'><a href='JavaScript:hidebox2_"+id+"()'><img src='pwin/images/"+style+"/t6.png' border='0'></a></td>\n\
<td width='11px' onMousemove='movecontrol2_"+id+"(event)' onMouseDown='mbuttondown2_"+id+"(event)' onMouseUp='mbuttonup2(event)' style='height:21px;overflow:hidden;font-size:1pt;'><img src='pwin/images/"+style+"/t7.png'></td>\n\
\n\
</tr>\n\
</table>\n\
\n\
</td></tr><tr><td height='5px' bgcolor='"+color+"' id='BOXO_e0_"+id+"'>\n\
\n\
<!--Abstand-->\n\
<div style=\"width:100%;height:5px;background:url('pwin/images/"+style+"/i0.png');font-size:1pt;\">\n\
<div style=\"float:left;\"><img src='pwin/images/"+style+"/l0.png'></div>\n\
<div style=\"float:right;\"><img src='pwin/images/"+style+"/r0.png'></div>\n\
</div>\n\
\n\
</td></tr><tr><td bgcolor='"+color+"' id='BOXO_e1_"+id+"'>\n\
\n\
<!--Inhalt-->\n\
<table width='100%' height='100%' border='0' cellpadding='0' cellspacing='0'>\n\
<tr><td width='5px' width='100%' height='100%'>\n\
<div style=\"width:5px;height:100%;font-family:arial;font-size:4pt;padding:0px;margin:0px;background:url('pwin/images/"+style+"/l0.png');background-repeat:repeat-y;\">&nbsp;</div>\n\
</td><td width='100%' width='100%'>\n\
<div id='BOXO_IDIV_"+id+"' style=\"width:100%;height:100%;visibility:visible;background:url('pwin/images/"+style+"/ibg.png');background-repeat:repeat;\">\n\
<iframe src='"+location+"' name='INFOBOX_"+id+"' width='100%' height='100%' frameborder='0' scrolling='auto' style='width:100%;height:100%;'>NO IFRAME?</iframe>\n\
</div>\n\
</td><td width='5px' width='100%'>\n\
<div style=\"width:5px;height:100%;font-family:arial;font-size:4pt;padding:0px;margin:0px;background:url('pwin/images/"+style+"/r0.png');background-repeat:repeat-y;\">&nbsp;</div>\n\
</td></tr></table>\n\
\n\
</td></tr><tr><td height='14px' bgcolor='"+color+"' id='BOXO_e2_"+id+"'>\n\
\n\
<!--Rand unten-->\n\
<div style=\"width:100%;height:14px;clear:both;background:url('pwin/images/"+style+"/b1x.png');background-repeat:repeat-x;\">\n\
<div style=\"float:left;height:14px;overflow:hidden;font-size:1pt;\"><img src='pwin/images/"+style+"/b0x.png'></div>\n\
<div style=\"width:14px;height:14px;float:right;font-family:arial;font-size:4pt;padding:0px;margin:0px;background:url('pwin/images/"+style+"/b2.png');background-repeat:no-repeat;\" onMouseDown='mbuttondown2r_"+id+"(event)'>&nbsp;</div>\n\
</div>\n\
\n\
</td></tr></table>\n\
</div>\n\
\n\
</div>");
}

function ini_boxes(maxrc,style)
{
    var id;
    global_pwin_maxrc=maxrc;
    for(id=0;id<maxrc;id++)
    {
        write_box2(id,"unbenannt","pwin/blanc.html",10,10,200,200,"hidden","#C0D0FF",style);
    }
    write_gboxscript();
    for(id=0;id<maxrc;id++)
    {
        write_boxscript(id,10,10,200,200,"hidden");
    }
    //write_boxstart();
    
    this.document.writeln("<script>\nfunction boxini()\n{\n");
    for(id=0;id<maxrc;id++)
    {
        this.document.writeln("ini_box_"+id+"();\n");
    }
    this.document.writeln("}</script>");

    start(maxrc);
}

function write_gboxscript()
{
    this.document.writeln("\n\
            <script>\n\
            var resizemod=0;//Resize Modus\n\
            var inbox=0;\n\
            mbutton=new Array(global_pwin_maxrc);\n\
            inimbutton();\n\
            var mymousexs=0;\n\
            var mymouseys=0;\n\
            var mymousex=0;\n\
            var mymousey=0;\n\
            var isloaded=0;\n\
            var rccount=0;\n\
            //var i;\n\
            f=new Array(global_pwin_maxrc);\n\
            for(i=0;i<global_pwin_maxrc;i++)\n\
            {\n\
                f[i]=new Array(6);\n\
                f[i][5]=0;\n\
            }\n\
            function start(maxrc)\n\
            {\n\
                isloaded=1;\n\
                rccount=maxrc;\n\
                boxini();\n\
            }\n\
            function inimbutton()\n\
            {\n\
                var i;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    mbutton[i]=0;\n\
                }\n\
            }\n\
            function mbuttonup2(evt)\n\
            {\n\
                var i;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    mbutton[i]=0;\n\
                    if(document.getElementById(\"block_a_\"+i).style.display=='none' && document.getElementById(\"BOXO_\"+i).style.visibility=='visible')\n\
                    {\n\
                        showidiv(i);\n\
                    }\n\
                }\n\
            }\n\
            function posbox2(id)\n\
            {\n\
                document.getElementById(\"BOXO_\"+id).style.marginLeft=f[id][0]+\"px\";\n\
                document.getElementById(\"BOXO_\"+id).style.marginTop=f[id][1]+\"px\";\n\
                document.getElementById(\"BOXO_\"+id).style.width=f[id][2]+\"px\";\n\
                document.getElementById(\"BOXO_\"+id).style.height=f[id][3]+\"px\";\n\
            }\n\
            function showidiv(id)\n\
            {\n\
                document.getElementById(\"BOXO_IDIV_\"+id).style.visibility=\"visible\";\n\
            }\n\
            function hideidiv(id)\n\
            {\n\
                document.getElementById(\"BOXO_IDIV_\"+id).style.visibility=\"hidden\";\n\
            }\n\
            function movecontrol2(evt)\n\
            {\n\
                if(isloaded==0){return true;}\n\
                mymousexs=mymousex;\n\
                mymouseys=mymousey;\n\
                mymousex=evt.clientX+document.body.scrollLeft;\n\
                mymousey=evt.clientY+document.body.scrollTop;\n\
                movecontrol2_move();\n\
            }\n\
            function movecontrol2_sub(x,y)\n\
            {\n\
                if(isloaded==0){return true;}\n\
                mymousexs=mymousex;\n\
                mymouseys=mymousey;\n\
                mymousex=x;\n\
                mymousey=y;\n\
                movecontrol2_move();\n\
            }\n\
            function movecontrol2_move()\n\
            {\n\
            ");
            
    var id;
    for(id=0;id<global_pwin_maxrc;id++)
    {
        this.document.writeln("\n\
                if(mbutton["+id+"]==1){movebox2_"+id+"(mymousexs-mymousex,mymouseys-mymousey);}\n\
                if(mbutton["+id+"]==2){resizebox2_"+id+"(mymousexs-mymousex,mymouseys-mymousey);}\n\
                ");
    }
            
    this.document.writeln("\n\
                return true;\n\
            }\n\
            function hidebox(i)\n\
            {\n\
            ");
                
    for(id=0;id<global_pwin_maxrc;id++)
    {
        this.document.writeln("if(i=="+id+"){hidebox2_"+id+"();return;}");
    }
    
    this.document.writeln("\n\
            }\n\
            function reopenbox(title,location,x,y,xx,yy,bgcol,rcol,xcol,txtcol)\n\
            {\n\
                var i;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    if(f[i][5]==1)\n\
                    {\n\
                        if(document.getElementById(\"BOXO_titlea_\"+i).textContent==title || document.getElementById(\"BOXO_titlea_\"+i).innerText==title)\n\
                        {\n\
                            hidebox(i);\n\
                            i=global_pwin_maxrc;\n\
                        }\n\
                    }\n\
                }\n\
                return openbox(title,location,x,y,xx,yy,bgcol,rcol,xcol,txtcol)\n\
            }\n\
            function openbox(title,location,x,y,xx,yy,bgcol,rcol,xcol,txtcol)\n\
            {\n\
                var i;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    if(f[i][5]==1)\n\
                    {\n\
                        if(document.getElementById(\"BOXO_titlea_\"+i).textContent==title || document.getElementById(\"BOXO_titlea_\"+i).innerText==title)\n\
                        {\n\
                            f[i][0]=x;\n\
                            f[i][1]=y;\n\
                            f[i][2]=xx;\n\
                            f[i][3]=yy;\n\
                            f[i][4]=yy;\n\
                            posbox2(i);\n\
                            showbox(i);\n\
                            return i;\n\
                        }\n\
                    }\n\
                }\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    if(f[i][5]==0)\n\
                    {\n\
                        return openbox_i(i,title,location,x,y,xx,yy,bgcol,rcol,xcol,txtcol);\n\
                    }\n\
                }\n\
                alert(\"Bitte schließen Sie einige Box-Objekte bevor Sie weitere Box-Objekte erzeugen.\");\n\
            }\n\
            function openbox_i(i,title,location,x,y,xx,yy,bgcol,rcol,xcol,txtcol)\n\
            {\n\
                f[i][0]=x;\n\
                f[i][1]=y;\n\
                f[i][2]=xx;\n\
                f[i][3]=yy;\n\
                f[i][4]=yy;\n\
                f[i][5]=1;\n\
                document.getElementById(\"BOXO_titlea_\"+i).innerHTML='<nobr>'+title+'</nobr>';\n\
                document.getElementById(\"BOXO_titleb_\"+i).innerHTML='<nobr>'+title+'</nobr>';\n\
                if(rcol==''){rcol=bgcol;}\n\
                if(xcol==''){xcol=bgcol;}\n\
                if(bgcol!='')\n\
                {\n\
                    document.getElementById(\"BOXO_e0_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_e1_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_e2_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_t0_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_t1_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_t2_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_t0a_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_t1a_\"+i).style.backgroundColor=bgcol;\n\
                    document.getElementById(\"BOXO_t2a_\"+i).style.backgroundColor=bgcol;\n\
                }\n\
                if(rcol!='')\n\
                {\n\
                    document.getElementById(\"BOXO_r0_\"+i).style.backgroundColor=rcol;\n\
                    document.getElementById(\"BOXO_r0a_\"+i).style.backgroundColor=rcol;\n\
                }\n\
                if(xcol!='')\n\
                {\n\
                    document.getElementById(\"BOXO_x0_\"+i).style.backgroundColor=xcol;\n\
                    document.getElementById(\"BOXO_x0a_\"+i).style.backgroundColor=xcol;\n\
                }\n\
                if(txtcol!='')\n\
                {   \n\
                    document.getElementById(\"BOXO_titleb_\"+i).style.color=txtcol;\n\
                    document.getElementById(\"BOXO_titlea_\"+i).style.color=txtcol;\n\
                }\n\
                else\n\
                {\n\
                    document.getElementById(\"BOXO_titleb_\"+i).style.color='000000';\n\
                    document.getElementById(\"BOXO_titlea_\"+i).style.color='000000';\n\
                }\n\
            ");
      
	for(id=0;id<global_pwin_maxrc;id++)
	{
        this.document.writeln("if(i=="+id+"){this.INFOBOX_"+id+".location=location;}");
	}
      
	this.document.writeln("\n\
                posbox2(i);\n\
                showbox(i);\n\
                return i;\n\
            }\n\
            function showbox(id)\n\
            {\n\
                bringtotop2(id);\n\
                rollup_down(id);\n\
                document.getElementById(\"BOXO_\"+id).style.visibility=\"visible\";\n\
                showidiv(id);\n\
            }\n\
            function bringtotop2(id)\n\
            {\n\
                var i;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    if(document.getElementById(\"BOXO_\"+i).style.zIndex>document.getElementById(\"BOXO_\"+id).style.zIndex)\n\
                    {\n\
                        document.getElementById(\"BOXO_\"+i).style.zIndex=document.getElementById(\"BOXO_\"+i).style.zIndex-1;\n\
                    }\n\
                }\n\
                document.getElementById(\"BOXO_\"+id).style.zIndex=500+global_pwin_maxrc;\n\
            }\n\
            function centerbox(id)\n\
            {\n\
                if(f[id][2]>window.innerWidth)\n\
                {\n\
                    f[id][2]=window.innerWidth;\n\
                }\n\
                if(f[id][3]>window.innerHeight)\n\
                {\n\
                    f[id][3]=window.innerHeight;\n\
                }\n\
                f[id][0]=(window.innerWidth-f[id][2])/2;\n\
                f[id][1]=(window.innerHeight-f[id][3])/2;\n\
                posbox2(id);\n\
            }\n\
            function fillright(id)\n\
            {\n\
                f[id][0]=window.innerWidth-f[id][2];\n\
                f[id][1]=0;\n\
                f[id][3]=window.innerHeight;\n\
                posbox2(id);\n\
            }\n\
            function fillleft(id)\n\
            {\n\
                f[id][0]=0;\n\
                f[id][1]=0;\n\
                f[id][3]=window.innerHeight;\n\
                posbox2(id);\n\
            }\n\
            function fillfull(id)\n\
            {\n\
                f[id][0]=0;\n\
                f[id][1]=0;\n\
                f[id][2]=window.innerWidth;\n\
                f[id][3]=window.innerHeight;\n\
                posbox2(id);\n\
            }\n\
            function fillcenter(id)\n\
            {\n\
                if(f[id][2]>window.innerWidth)\n\
                {\n\
                    f[id][2]=window.innerWidth;\n\
                }\n\
                f[id][0]=(window.innerWidth-f[id][2])/2;\n\
                f[id][1]=0;\n\
                f[id][3]=window.innerHeight;\n\
                posbox2(id);\n\
            }\n\
            function fillcenter_maxh(id,maxh)\n\
            {\n\
                if(f[id][2]>window.innerWidth)\n\
                {\n\
                    f[id][2]=window.innerWidth;\n\
                }\n\
                f[id][3]=Math.min(maxh,window.innerHeight);\n\
                f[id][0]=(window.innerWidth-f[id][2])/2;\n\
                f[id][1]=(window.innerHeight-f[id][3])/2;\n\
                posbox2(id);\n\
            }\n\
            function rollup(id)\n\
            {\n\
                if(document.getElementById(\"BOXO_titlea_\"+id).textContent==\"KKlauseln\")\n\
                {\n\
                    if(f[id][3]!=160)\n\
                    {\n\
                        f[id][4]=f[id][3];\n\
                        f[id][3]=160;\n\
                    }\n\
                    else\n\
                    {\n\
                        f[id][3]=f[id][4];\n\
                    }\n\
                }\n\
                else if(document.getElementById(\"block_a_\"+id).style.display=='none')\n\
                {\n\
                    document.getElementById(\"block_a_\"+id).style.display='block';\n\
                    document.getElementById(\"block_b_\"+id).style.display='none';\n\
                    f[id][4]=f[id][3];\n\
                    f[id][3]=16;\n\
                    hideidiv(id);\n\
                }\n\
                else\n\
                {\n\
                    document.getElementById(\"block_a_\"+id).style.display='none';\n\
                    document.getElementById(\"block_b_\"+id).style.display='block';\n\
                    f[id][3]=f[id][4];\n\
                    showidiv(id);\n\
                }\n\
                posbox2(id);\n\
            }\n\
            function rollup_up(id)\n\
            {\n\
                if(document.getElementById(\"block_a_\"+id).style.display=='none')\n\
                {\n\
                    document.getElementById(\"block_a_\"+id).style.display='block';\n\
                    document.getElementById(\"block_b_\"+id).style.display='none';\n\
                    f[id][4]=f[id][3];\n\
                    f[id][3]=16;\n\
                    posbox2(id);\n\
                    hideidiv(id);\n\
                }\n\
            }\n\
            function rollup_down(id)\n\
            {\n\
                if(document.getElementById(\"block_a_\"+id).style.display=='block')\n\
                {\n\
                    document.getElementById(\"block_a_\"+id).style.display='none';\n\
                    document.getElementById(\"block_b_\"+id).style.display='block';\n\
                    f[id][3]=f[id][4];\n\
                    posbox2(id);\n\
                    showidiv(id);\n\
                }\n\
            }\n\
            </script>\n\
            ");
}

function write_boxscript(id,left,top,width,height,visibility)
{
    this.document.writeln("\n\
            <script>\n\
            function ini_box_"+id+"()\n\
            {\n\
                f["+id+"][0]="+left+";\n\
                f["+id+"][1]="+top+";\n\
                f["+id+"][2]="+width+";\n\
                f["+id+"][3]="+height+";\n\
                f["+id+"][4]="+height+";\n\
            }\n\
            function mbuttondown2_"+id+"(evt)\n\
            {\n\
                mbutton["+id+"]=1;\n\
                bringtotop2("+id+");\n\
                var i;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    hideidiv(i);\n\
                }\n\
            }\n\
            function mbuttondown2r_"+id+"(evt)\n\
            {\n\
                mbutton["+id+"]=2;\n\
                for(i=0;i<global_pwin_maxrc;i++)\n\
                {\n\
                    hideidiv(i);\n\
                }\n\
            }\n\
            function mbuttonup2_"+id+"(evt)\n\
            {\n\
                mbutton["+id+"]=0;\n\
                showidiv("+id+");\n\
            }\n\
            function hidebox2_"+id+"()\n\
            {\n\
                window.INFOBOX_"+id+".location='pwin/blanc.html';\n\
                document.getElementById(\"BOXO_"+id+"\").style.visibility=\"hidden\";\n\
                hideidiv("+id+");\n\
                f["+id+"][5]=0;\n\
            }\n\
            function showbox2_"+id+"()\n\
            {\n\
                document.getElementById(\"BOXO_"+id+"\").style.visibility=\"visible\";\n\
                showidiv("+id+");\n\
            }\n\
            function loaddocinbox2_"+id+"(a)\n\
            {\n\
                showbox2_"+id+"();\n\
                window.INFOBOX_"+id+".location='infobox.html?d='+a;\n\
            }\n\
            function movecontrol2_"+id+"(evt)\n\
            {\n\
                if(isloaded==0){return true;}\n\
                mymousexs=mymousex;\n\
                mymouseys=mymousey;\n\
                mymousex=evt.clientX+document.body.scrollLeft;\n\
                mymousey=evt.clientY+document.body.scrollTop;\n\
                if(mbutton["+id+"]==1)\n\
                {\n\
                  movebox2_"+id+"(mymousexs-mymousex,mymouseys-mymousey);\n\
                }\n\
                if(mbutton["+id+"]==2)\n\
                {\n\
                  resizebox2_"+id+"(mymousexs-mymousex,mymouseys-mymousey);\n\
                }\n\
                return true;\n\
            }\n\
            function movebox2_"+id+"(x,y)\n\
            {\n\
                f["+id+"][0]=f["+id+"][0]-x;\n\
                f["+id+"][1]=f["+id+"][1]-y;\n\
                if(f["+id+"][0]<-16){f["+id+"][0]=-16;}\n\
                if(f["+id+"][1]<-16){f["+id+"][1]=-16;}\n\
                posbox2("+id+");\n\
            }\n\
            function resizebox2_"+id+"(x,y)\n\
            {\n\
                f["+id+"][2]=f["+id+"][2]-x;\n\
                f["+id+"][3]=f["+id+"][3]-y;\n\
                if(f["+id+"][2]<160){f["+id+"][2]=160;}\n\
                if(f["+id+"][3]<200){f["+id+"][3]=200;}\n\
                posbox2("+id+");\n\
            }\n\
            function resizebox2abs_"+id+"(x,y)\n\
            {\n\
                f["+id+"][2]=x;\n\
                f["+id+"][3]=y;\n\
                if(f["+id+"][2]<16){f["+id+"][2]=16;}\n\
                if(f["+id+"][3]<16){f["+id+"][3]=16;}\n\
                posbox2("+id+");\n\
            }\n\
            ");
    
    if(visibility=="hidden")
    {
        this.document.writeln("hidebox2_"+id+"();");
    }
    else
    {
        this.document.writeln("showbox2_"+id+"();");
    }
    this.document.writeln("</script>");
}
