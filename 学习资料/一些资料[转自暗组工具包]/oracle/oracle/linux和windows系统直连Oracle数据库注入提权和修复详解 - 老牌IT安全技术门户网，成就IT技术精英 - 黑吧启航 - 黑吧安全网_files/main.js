document.charset = "GB2312";
var startTime,endTime;
var d=new Date();
startTime=d.getTime();

function ResumeError() {
	return true;
}
//window.onerror = ResumeError;
function $(id) {
	return document.getElementById(id);
}
Array.prototype.push = function(value) {
	this[this.length] = value;
	return this.length;
}
var xmlhttp = HttpAXObj();

function HttpAXObj(){
	var xmlhttp = null;
	try{
		xmlhttp= new ActiveXObject('Msxml2.XMLHTTP');
	}catch(e){
		try{
			xmlhttp= new ActiveXObject('Microsoft.XMLHTTP');
		}catch(e){
			try{
				xmlhttp= new XMLHttpRequest();
			}catch(e){
				try{
					xmlhttp= window.createRequest();
				}catch(e){}
			}
		}
	}
	if (xmlhttp) return xmlhttp;
}
function loadAjaxData(strUrl,sid) {
	var xmlhttp = HttpAXObj();
	try{
		xmlhttp.onreadystatechange=function(){
			if(xmlhttp.readyState==4){
				if(xmlhttp.status==200){
					var response = xmlhttp.responseText;
					if (!sid){
						eval(response);
					}else{
						var innerEl = document.getElementById(sid);
						if(typeof(innerEl)=='object'){
							innerEl.innerHTML = response;
							innerEl.style.display='';
						}
					}
				}else{}
			}
		}
		xmlhttp.open("GET",strUrl.replace("&&","&"),true);
		//xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlhttp.send("");
	}catch(e){}
	delete xmlhttp;
}

function loadNewsContent(strUrl,e,sid) {
	if (!e) return false;
	var xmlhttp = HttpAXObj();
	try{
		xmlhttp.onreadystatechange=function(){
			if(xmlhttp.readyState==4){
				if(xmlhttp.status==200){
					var response = xmlhttp.responseText;
					if (!sid){
						sid='mainNewsContent';
					}
					var innerEl = document.getElementById(sid);
					if(typeof(innerEl)=='object'){
						innerEl.innerHTML = response;
						innerEl.style.display='';
					}
				}
			}
		}
		xmlhttp.open("GET",strUrl.replace("&&","&"),true);
		xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlhttp.send("");
	}catch(e){}
	delete xmlhttp;
}

function bbimg(o){
	var zoom=parseInt(o.style.zoom, 10)||100;zoom+=event.wheelDelta/12;if (zoom>0) o.style.zoom=zoom+'%';
	return false;
}
function imgzoom(img,maxsize){
	var a=new Image();
	a.src=img.src
	if(a.width > maxsize * 4)
	{
		img.style.width=maxsize;
	}
	else if(a.width >= maxsize)
	{
		img.style.width=Math.round(a.width * Math.floor(4 * maxsize / a.width) / 4);
	}
	return false;
}
//图片自动调整的模式，1为按比例调整 ，2 按大小调整。
var resizemode=1
function imgresize(o){
	 if (resizemode==2 || o.onmousewheel){
	 	if(o.width > 500 ){
				o.style.width='500px';
			}
			if(o.height > 800){
				o.style.height='800px';
			}
		}else{
		var parentNode=o.parentNode.parentNode
		if (parentNode){
		if (o.offsetWidth>=parentNode.offsetWidth) o.style.width='98%';
		}else{
		var parentNode=o.parentNode
		if (parentNode){
			if (o.offsetWidth>=parentNode.offsetWidth) o.style.width='98%';
			}
		}
	}
}
//运行代码
function runEx(cod1)  {
	 cod=document.getElementById(cod1)
	  var code=cod.value;
	  if (code!=""){
		  var newwin=window.open('','','');  
		  newwin.opener = null 
		  newwin.document.write(code);  
		  newwin.document.close();
	}
}
//复制代码
function doCopy(ID) { 
	if (document.all){
		 textRange = document.getElementById(ID).createTextRange(); 
		 textRange.execCommand("Copy"); 
	}
	else{
		 //alert("此功能只能在IE上有效");
		 copyToClipboard(document.getElementById(ID).value);
	}
}
//另存为代码
function saveCode(cod1) {
	cod=document.getElementById(cod1)
	var code=cod.value;
	if (code!=""){
        var winname = window.open('', '_blank', 'top=10000');
        winname.document.open('text/html', 'replace');
        winname.document.write(code);
        winname.document.execCommand('saveas','','code.htm');
        winname.close();
	}
}
function copyToClipboard(txt) {
     if(window.clipboardData) {
             window.clipboardData.clearData();
             window.clipboardData.setData("Text", txt);
     } else if(navigator.userAgent.indexOf("Opera") != -1) {
          window.location = txt;
     } else if (window.netscape) {
          try {
               netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
          } catch (e) {
               alert("被浏览器拒绝！\n请在浏览器地址栏输入'about:config'并回车\n然后将'signed.applets.codebase_principal_support'设置为'true'");
          }
          var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
          if (!clip)
               return;
          var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
          if (!trans)
               return;
          trans.addDataFlavor('text/unicode');
          var str = new Object();
          var len = new Object();
          var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
          var copytext = txt;
          str.data = copytext;
          trans.setTransferData("text/unicode",str,copytext.length*2);
          var clipid = Components.interfaces.nsIClipboard;
          if (!clip)
               return false;
          clip.setData(trans,null,clipid.kGlobalClipboard);
     }
}
function showElement(sid) {
	var whichEl = document.getElementById(sid);
	if (whichEl!=null) {
		if (whichEl.style.display == "none"){
			whichEl.style.display='';
		}else{
			whichEl.style.display='none';
		}
	}
}
function getElementsByClassName(strClassName, strTagName, oElm){
    var arrElements = (strTagName == "*" && document.all)? document.all : oElm.getElementsByTagName(strTagName);
    var arrReturnElements = new Array();
    strClassName = strClassName.replace(/\-/g, "\\-");
    var oRegExp = new RegExp("(^|\\s)" + strClassName + "(\\s|$)");
    var oElement;
    for(var i=0; i<arrElements.length; i++){
        oElement = arrElements[i];      
        if(oRegExp.test(oElement.className)){
            arrReturnElements.push(oElement);
        }   
    }
    return (arrReturnElements)
}
//文章内容字体控制
var initial_fontsize    = 10;
var initial_lineheight  = 18;
function newasp_fontsize(type,objname){
	var whichEl = document.getElementById(objname);
	if (whichEl!=null) {
		if (type==1){
			if(initial_fontsize<64){
				whichEl.style.fontSize=(++initial_fontsize)+'pt';
				whichEl.style.lineHeight=(++initial_lineheight)+'pt';
			}
		}else {
			if(initial_fontsize>8){
				whichEl.style.fontSize=(--initial_fontsize)+'pt';
				whichEl.style.lineHeight=(--initial_lineheight)+'pt';
			}
		}
	}
}
var MediaTemp=new Array()
function MediaShow(strType,strID,strURL,intWidth,intHeight,strPath)
{
	var tmpstr
	if (MediaTemp[strID]==undefined) MediaTemp[strID]=false; else MediaTemp[strID]=!MediaTemp[strID];
	if(MediaTemp[strID]){
			if ( document.all )	{
	         	document.getElementById(strID).outerHTML = '<div id="'+strID+'"></div>'
			}
			else
			{
	         	document.getElementById(strID).innerHTML = ''
			}

		document.images[strID+"_img"].src=strPath+"mm_snd.gif" 		
		document.getElementById(strID+"_text").innerHTML="在线播放"	
	}else{
		document.images[strID+"_img"].src=strPath+"mm_snd_stop.gif" 		
		document.getElementById(strID+"_text").innerHTML="关闭在线播放"
		switch(strType){
			case "flash":
				tmpstr='<div style="height:6px;overflow:hidden"></div><object codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+intWidth+'" height="'+intHeight+'"><param name="movie" value="'+strURL+'" /><param name="quality" value="high" /><param name="AllowScriptAccess" value="never" /><embed src="'+strURL+'" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="'+intWidth+'" height="'+intHeight+'" /></object>';
				break;
			case "wma":
				tmpstr='<div style="height:6px;overflow:hidden"></div><object classid="CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95"  id="MediaPlayer" width="450" height="70"><param name=""howStatusBar" value="-1"><param name="AutoStart" value="True"><param name="Filename" value="'+strURL+'"></object>';
				break;
			case "wmv":
				tmpstr='<div style="height:6px;overflow:hidden"></div><object classid="clsid:22D6F312-B0F6-11D0-94AB-0080C74C7E95" codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=6,0,02,902" type="application/x-oleobject" standby="Loading..." width="'+intWidth+'" height="'+intHeight+'"><param name="FileName" VALUE="'+strURL+'" /><param name="ShowStatusBar" value="-1" /><param name="AutoStart" value="true" /><embed type="application/x-mplayer2" pluginspage="http://www.microsoft.com/Windows/MediaPlayer/" src="'+strURL+'" autostart="true" width="'+intWidth+'" height="'+intHeight+'" /></object>';
				break;
			case "rm":
				tmpstr='<div style="height:6px;overflow:hidden"></div><object classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA" width="'+intWidth+'" height="'+intHeight+'"><param name="SRC" value="'+strURL+'" /><param name="CONTROLS" VALUE="ImageWindow" /><param name="CONSOLE" value="one" /><param name="AUTOSTART" value="true" /><embed src="'+strURL+'" nojava="true" controls="ImageWindow" console="one" width="'+intWidth+'" height="'+intHeight+'"></object>'+
                '<br/><object classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA" width="'+intWidth+'" height="32" /><param name="CONTROLS" value="StatusBar" /><param name="AUTOSTART" value="true" /><param name="CONSOLE" value="one" /><embed src="'+strURL+'" nojava="true" controls="StatusBar" console="one" width="'+intWidth+'" height="24" /></object>'+'<br /><object classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA" width="'+intWidth+'" height="32" /><param name="CONTROLS" value="ControlPanel" /><param name="AUTOSTART" value="true" /><param name="CONSOLE" value="one" /><embed src="'+strURL+'" nojava="true" controls="ControlPanel" console="one" width="'+intWidth+'" height="24" autostart="true" loop="false" /></object>';
				break;
			case "ra":
				tmpstr='<div style="height:6px;overflow:hidden"></div><object classid="clsid:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA" id="RAOCX" width="450" height="60"><param name="_ExtentX" value="6694"><param name="_ExtentY" value="1588"><param name="AUTOSTART" value="true"><param name="SHUFFLE" value="0"><param name="PREFETCH" value="0"><param name="NOLABELS" value="0"><param name="SRC" value="'+strURL+'"><param name="CONTROLS" value="StatusBar,ControlPanel"><param name="LOOP" value="0"><param name="NUMLOOP" value="0"><param name="CENTER" value="0"><param name="MAINTAINASPECT" value="0"><param name="BACKGROUNDCOLOR" value="#000000"><embed src="'+strURL+'" width="450" autostart="true" height="60"></embed></object>';
				break;
			case "qt":
				tmpstr='<div style="height:6px;overflow:hidden"></div><embed src="'+strURL+'" autoplay="true" loop="false" controller="true" playeveryframe="false" cache="false" scale="TOFIT" bgcolor="#000000" kioskmode="false" targetcache="false" pluginspage="http://www.apple.com/quicktime/" />';
		}
		document.getElementById(strID).innerHTML = tmpstr;
	}
		document.getElementById(strID+"_href").blur()
}
function storePage() {
	d=document;
	t=d.selection?(d.selection.type!='None'?d.selection.createRange().text:''):(d.getSelection?d.getSelection():'');
	void(vivi=window.open('http://vivi.sina.com.cn/collect/icollect.php?pid=newasp.net&title='+escape(d.title)+'&url='+escape(d.location.href)+'&desc='+escape(t),'vivi','scrollbars=no,width=480,height=480,left=75,top=20,status=no,resizable=yes'));
	vivi.focus();
}

function urlencode(str) {
	var ns = (navigator.appName=="Netscape") ? 1 : 0;
	if (ns) { return escape(str); }
	var ms = "%25#23 20+2B?3F<3C>3E{7B}7D[5B]5D|7C^5E~7E`60";
	var msi = 0;
	var i,c,rs,ts ;
	while (msi < ms.length) {
		c = ms.charAt(msi);
		rs = ms.substring(++msi, msi +2);
		msi += 2;
		i = 0;
		while (true)	{ 
			i = str.indexOf(c, i);
			if (i == -1) break;
			ts = str.substring(0, i);
			str = ts + "%" + rs + str.substring(++i, str.length);
		}
	}
	return str;
}

function getCookie(Name) { 
	var search = Name + "=" ;
	var returnvalue = ""; 
	if (document.cookie.length > 0) { 
		offset = document.cookie.indexOf(search);
		if (offset != -1) {offset += search.length ;end = document.cookie.indexOf(";", offset); 
			if (end == -1) end = document.cookie.length; returnvalue=unescape(document.cookie.substring(offset, end)) ;
			} 
		} 
		return returnvalue; 
} 

function setCookie(name,value){
	var exp  = new Date();    
  exp.setTime(exp.getTime() + 24*60*60*1000);
	var nameString = name + "=" + value;
	var expiryString = " ;expires = "+ exp.toGMTString();
	var pathString = " ;path = /; domain="+document.domain;
	document.cookie = nameString + expiryString + pathString ;
}

function setInnerHTML(e,content){
	var element = document.getElementById(e)
	if(typeof(element)=='object')
	element.innerHTML = content;
}