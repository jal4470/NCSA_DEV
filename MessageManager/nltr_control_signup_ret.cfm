<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------------->
<!--- Local variables --->
<!----------------------->
<CFSET ret_sub_account_add_instructions = "">
<CFSET ret_sub_message = "">
<CFSET ret_sub_image = "">

<!---------------->
<!--- Get data --->
<!---------------->
<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#GetOrgInfo" method="GetOrgSignupInfo" returnvariable="orgsignup">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization Signup.">			
	</CFCATCH>			
</CFTRY>

<CFSET ret_sub_account_add_instructions = "#orgsignup.ret_sub_account_add_instructions#">
<CFSET ret_sub_message = "#orgsignup.ret_sub_message#">
<CFSET ret_sub_image = "#orgsignup.ret_sub_asset_id#">

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Community Pass</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >


	<!-- tinyMCE -->
	<script language="javascript" type="text/javascript" src="assets/jscripts/tiny_mce/tiny_mce.js"></script>
	<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "textareas",
		editor_selector : "mceEditor",
		theme : "advanced",
		plugins : "preview",
		theme_advanced_buttons1 : ",fontselect,fontsizeselect,bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright,justifyfull,bullist,numlist,|,outdent,indent,|,preview,|,forecolor,backcolor,|,undo,redo,link,unlink",
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
	});
	</script>
	<!-- /tinyMCE -->
	
	<script language="javascript">
	<!--
	 function popup(item){
		gostring = "<CFOUTPUT>nltr_view_item.cfm?s=#securestring#&organization_id=#organization_id#&item=</CFOUTPUT>" + item;
		sciwin= window.open(gostring, 'edit','width=550,height=400,screenX=20,screenY=40,left=20,top=40,scrollbars=auto,status=no,location=no,resizable=no,')
	  }
	//-->
	</script>
	<script language="javascript">
	<!--
	 function popupimage(image){
		gostring = "<CFOUTPUT>nltr_view_image.cfm?s=#securestring#&organization_id=#organization_id#&image=</CFOUTPUT>" + image;
		sciwin= window.open(gostring, 'edit','width=700,height=400,screenX=20,screenY=40,left=20,top=40,scrollbars=auto,status=no,location=no,resizable=no,')
	  }
	//-->
	</script>
	
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="header_nltr.cfm">
<!--- Header
<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Newsletter Management - Messages</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>
 --->

<!--- BODY --->
<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="admin" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="350" align="left" valign="middle" style="background-image: url(assets/images/emailbarback.jpg);background-repeat:repeat-x;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="350" align="left" valign="middle" class="bartitle">Administration - Returning Subscriber Sign-Up</td>
							</tr>
						</table>
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				
				<table border="0" cellspacing="2" cellpadding="4" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_control_signup_ret_action.cfm?s=#securestring#" ENCTYPE="multipart/form-data">
					<tr>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwhfull" valign="top" style="padding-left:20px;">Returning Subscriber Form Image:<img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"></td>
					</tr>
					<tr>
						<td class="formitemwh" style="padding-left:20px;"><input type="file" name="ret_sub_image" class="imagefield" size="30" value="#ret_sub_image#"> <CFIF ret_sub_image IS NOT ""><a href="javascript:popupimage('#ret_sub_image#')" class="formlink">View Current</a></CFIF></td>
					</tr>
					<CFIF ret_sub_image IS NOT "">
					<tr>
						<td class="formitemwh" style="padding-left:20px;"><input type="checkbox" name="ret_sub_image_remove" value="1"> Remove Current Image</td>
					</tr>
					</CFIF>
					<tr>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwhfull" valign="top" style="padding-left:20px;">Returning Subscriber Sign-Up Instructions:<img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"></td>
					</tr>
					<tr>
						<td class="formitemwh" style="padding-left:20px;"><textarea name="ret_sub_account_add_instructions" class="mceEditor" style="width:700px;height:150px;">#ret_sub_account_add_instructions#</textarea></td>
					</tr>
					<tr>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwhfull" valign="top" style="padding-left:20px;">Returning Subscriber Select Topic Instructions:<img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"></td>
					</tr>
					<tr>
						<td class="formitemwh" style="padding-left:20px;"><textarea name="ret_sub_message" class="mceEditor" style="width:700px;height:150px;">#ret_sub_message#</textarea></td>
					</tr>
					<tr>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td class="formitemwh" style="padding-left:20px;"><img src="assets/images/but_email_cancel.gif"  width="72" height="17" onclick="location.href='nltr_admin.cfm?s=#securestring#'" border="0" style="cursor: pointer;"> 
						<input type="image" name="Submit" value="Submit" src="assets/images/but_email_save.gif"  width="72" height="17"></td>
					</tr>
					<tr>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
					</form>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!--- END BODY --->

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td height="26" align="right" style="padding-right: 10px;"><IMG SRC="assets/images/cp_powered2.gif" ALT="" WIDTH="213" HEIGHT="26"></td>
	</tr>
</table>

</body>
</html>
