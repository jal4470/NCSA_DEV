<!--- 
	FileName:	adverts_add.cfm
	Created on: 1/24/2011
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<cfif isdefined("form.save")>
	<!--- insert ad --->
	<cfset href="">
	<cfset customContent="">
	<cfif isdefined("form.action")>
		<cfif form.action EQ "link">
			<cfset href=form.href>
		<cfelseif form.action EQ "customPage">
			<cfset customContent=form.customPage>
		</cfif>
	</cfif>
	<cfinvoke
		component="#application.sitevars.cfcpath#.ad"
		method="createAd"
		title="#form.title#"
		description="#form.description#"
		beginDate="#form.beginDate# #form.beginTime#"
		endDate="#form.endDate# #form.endTime#"
		href="#href#"
		customContent="#customContent#"
		returnvariable="ad_id">
		
	<!--- link either text or image --->
	<cfif not isdefined("form.type") OR form.type EQ "text">
		<cfinvoke
			component="#application.sitevars.cfcpath#.ad"
			method="setText"
			ad_id="#ad_id#"
			text="#form.text#">
	<cfelse>
		<cfif form.filename NEQ "">
			<!--- upload file to temp folder --->
			<cffile action="UPLOAD" destination="#application.sitevars.tempPath#" nameconflict="MAKEUNIQUE" filefield="form.filename">
			<cfimage 
				action="resize"
				width="170"
				height=""
				source="#application.sitevars.tempPath#\#cffile.serverfile#"
				destination="#application.sitevars.tempPath#\#cffile.serverfile#"
				overwrite="yes">
			<!--- read file back into variable --->
			<cffile action="READBINARY" file="#application.sitevars.tempPath#\#cffile.serverfile#" variable="binContent">
			
			<cfinvoke
				component="#application.sitevars.cfcpath#.ad"
				method="setImage"
				ad_id="#ad_id#"
				content="#binContent#"
				filename="#cffile.clientfilename#"
				extension="#cffile.clientfileext#">
				
			<!--- delete temp file --->
			<cffile action="DELETE" file="#application.sitevars.tempPath#\#cffile.serverfile#">
		</cfif>
	</cfif>
	
	<cflocation url="adverts.cfm" addtoken="No">
</cfif>






<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Add Advertisement</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<link rel="stylesheet" href="assets/themes/ui-1.8.5/cupertino/jquery-ui-1.8.5.custom.css" type="text/css">
<link rel="stylesheet" href="assets/jquery.clockpick.1.2.4/clockpick.1.2.4.css">
<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.2.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.8.5.custom.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery.clockpick.1.2.4/jquery.clockpick.1.2.4.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/tiny_mce/tiny_mce.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		tinyMCE.init({
			mode : "specific_textareas",
			editor_selector : "mceEditor",
			theme : "advanced",
			skin:'default_nopadding',
			plugins : "media,visualchars,advlink,advimage",
			theme_advanced_buttons1 : "bold,italic,underline,|,justifyleft,justifycenter,justifyright,|,image",
			theme_advanced_buttons2 : "fontselect,fontsizeselect",
			theme_advanced_buttons3 : "undo,redo,|,link,unlink,|,forecolor,backcolor",      
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_resizing : false,
			width:"190",
			height:"270",
			dialog_type:"modal",
			document_base_url : "#application.sitevars.homehttp#/",
			file_browser_callback : 'myFileBrowser',
			
			force_p_newlines : false,
			force_br_newlines : true
		});
		
		tinyMCE.init({
			mode : "specific_textareas",
			editor_selector : "mceEditor2",
			theme : "advanced",
			plugins : "media,visualchars,advlink,advimage",
			theme_advanced_buttons1 : "bold,italic,underline,|,justifyleft,justifycenter,justifyright,|,,sub,sup,|,formatselect,fontselect,fontsizeselect,forecolorpicker,backcolorpicker,charmap",
			theme_advanced_buttons2 : "undo,redo,|,link,unlink,|,forecolor,backcolor,|,bullist,numlist,|,image,media,|,code,visualaid",
			theme_advanced_buttons3 : "",      
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_resizing : true,
			width:"700",
			height:"460",
			dialog_type:"modal",
			document_base_url : "#application.sitevars.homehttp#/",
			file_browser_callback : 'myFileBrowser'
		});
		
		$('input[name=beginDate],input[name=endDate]').datepicker({
			buttonImage:'assets/images/calendar.gif',
			buttonImageOnly:true,
			showOn:'button'
		});
		$('input[name=beginTime],input[name=endTime]').clockpick({
			starthour:0,
			endhour:23,
			minutedivisions:12
		});
		
		$('input[name=type]').click(changeType);
		changeType();
		
		$('input[name=action]').click(changeAction);
		changeAction();

	});
	
	function changeType()
	{
		//get type
		if($('input[name=type]:checked').val() == 'text')
		{
			$('##typeText').show();
			$('##typeImage').hide();
		}
		else
		{
			$('##typeText').hide();
			$('##typeImage').show();
		}
	}
	
	function changeAction()
	{
		//get action
		if($('input[name=action]:checked').val() == 'link')
		{
			$('##actionLink').show();
			$('##actionCustom').hide();
		}
		else if($('input[name=action]:checked').val() == 'customPage')
		{
			$('##actionLink').hide();
			$('##actionCustom').show();
		}
		else
		{
			$('##actionLink').hide();
			$('##actionCustom').hide();
		}
	}
	function myFileBrowser (field_name, url, type, win) {
		
		// alert("Field_Name: " + field_name + "nURL: " + url + "nType: " + type + "nWin: " + win); // debug/testing
		//console.log("Field_Name: " + field_name + "nURL: " + url + "nType: " + type + "nWin: " + win);
		
		/* If you work with sessions in PHP and your client doesn't accept cookies you might need to carry
		the session name and session ID in the request string (can look like this: "?PHPSESSID=88p0n70s9dsknra96qhuk6etm5").
		These lines of code extract the necessary parameters and add them back to the filebrowser URL again. */
		
		/*var cmsURL = window.location.toString();    // script URL - use an absolute path!
		if (cmsURL.indexOf("?") < 0) {
			//add the type as the only query parameter
			cmsURL = cmsURL + "?type=" + type;
		}
		else {
			//add the type as an additional query parameter
			// (PHP session ID is now included if there is one at all)
			cmsURL = cmsURL + "&type=" + type;
		}*/
		//var cmsURL='../../../../tinymce_upload.cfm';
		var cmsURL = '#Application.sitevars.docPath#/cffm-1.323/cffm.cfm?editorType=mce&EDITOR_RESOURCE_TYPE=' + type;
		tinyMCE.activeEditor.windowManager.open({
			file : cmsURL,
			title : 'My File Browser',
			width : 520,  // Your dimensions may differ - toy around with them!
			height : 450,
			resizable : "yes",
			scrollbars : "yes",
			inline : "yes",  // This parameter only has an effect if you use the inlinepopups plugin!
			close_previous : "no"
		}, {
			window : win,
			input : field_name
		});
		return false;
	}
</script>



<h2>
	Add Adverisement
</h2>

<form action="adverts_add.cfm" method="post" enctype="multipart/form-data">
	<table border="0" cellpadding="5" cellspacing="0">
		<tr>
			<td align="right">
				<b>Title</b>
			</td>
			<td>
				<input name="title" type="Text">
			</td>
		</tr>
		<tr>
			<td align="right">
				<b>Description</b>
			</td>
			<td>
				<input name="description" type="Text">
			</td>
		</tr>
		<tr>
			<td align="right">
				<b>Content</b>
			</td>
			<td>
				<b>Type: </b><input type="Radio" name="type" value="text" checked="checked">Text&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="type" value="image">Image<br>
				<div id="guidelines">
					<h3>Advertisment Guidelines</h3>
					<ul>
						<li>Maximum <strong>width</strong> of side bar advertisment: <strong>186px</strong></li>
						<li>After selecting image file, go to Appearance tab, and type <strong>186</strong> in first dimensions box.</li>
						<li>Image files types that are supported: <strong>JPEG, JPG, GIF, TIFF, PNG, and BMP</strong></li>
						<li>Images uploaded will be resized to fit the maximum width, while maintaining proportions.</li>
					</ul>
				</div>
				<div id="typeText">
					<textarea name="text" class="mceEditor"></textarea>
				</div>
				<Div id="typeImage">
					<input type="File" name="filename">
				</DIV>
			</td>
		</tr>
		<tr>
			<td align="right">
				<b>Begin Date/time</b>
			</td>
			<td>
				<input name="beginDate" type="Text" style="width:100px;"> <input type="text" name="beginTime" style="width:75px;">
			</td>
		</tr>
		<tr>
			<td align="right">
				<b>End Date/time</b>
			</td>
			<td>
				<input name="endDate" type="Text" style="width:100px;"> <input type="text" name="endTime" style="width:75px;">
			</td>
		</tr>
		<tr>
			<td align="right">
				<b>Action</b>
			</td>
			<td>
				
				<input type="radio" name="action" value="link" checked="checked">Link&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="action" value="customPage">Custom Page&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="action" value="none">None<br>
				<div id="actionLink">
					<input type="text" name="href" style="width:400px;">
				</div>
				<div id="actionCustom">
					<textarea name="customPage" class="mceEditor2"></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<td align="right">
				
			</td>
			<td>
				<input type="Button" value="Back" onclick="history.go(-1);"> <input type="Submit" name="save" value="Save">
			</td>
		</tr>
	</table>
</form>




</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 
