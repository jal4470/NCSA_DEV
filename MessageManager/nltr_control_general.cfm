<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS UI Page		   			--->
<!------------------------------------->
<!---  Created:  11.12.2007 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 				--->
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
<CFSET signup_header_image = "">
<CFSET signup_footer_copy = "">
<CFSET newsletter_status_id = "">

<!---------------->
<!--- Get data --->
<!---------------->
<cftry>
	<CFINVOKE component="#application.CRS_CFC_Path#GetOrgInfo" method="GetOrgSignupInfo" returnvariable="orgsignup">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>

	<cfcatch>
		<cfinclude template="cfctach.cfm">
	</cfcatch>			
</cftry>

<CFSET signup_header_image = "#orgsignup.signup_header_asset_id#">
<CFSET signup_footer_copy = "#orgsignup.signup_footer_copy#">
<CFSET newsletter_status_id = "#orgsignup.newsletter_status_id#">

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
						<td width="250" align="left" valign="middle" style="background-image: url(assets/images/emailbarback.jpg);background-repeat:repeat-x;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="250" align="left" valign="middle" class="bartitle">Administration - General Controls</td>
							</tr>
						</table>
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="General administration of newsletters, including the public newsletter sign-up form and default settings." width="21" height="17" border="0"></td>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				
				<table border="0" cellspacing="2" cellpadding="4" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_control_general_action.cfm?s=#securestring#" ENCTYPE="multipart/form-data">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Sign Up Url:<img src="assets/icons/ques3.gif" alt="URL of newsletter sign up form." width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh"><a href="#application.public_URL#news_login.cfm?o=#organization_id#" target="_new">#application.public_URL#news_login.cfm?o=#organization_id#</a></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Status:<img src="assets/icons/ques3.gif" alt="Status of newsletter sign-up form." width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh">
						<select name="newsletter_status_id" class="regularfield">
							<option value="1"<CFIF newsletter_status_id EQ 1> SELECTED</CFIF>>Active
							<option value="0"<CFIF newsletter_status_id NEQ 1> SELECTED</CFIF>>Inactive
						</select>
						</td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Header Image:<img src="assets/icons/ques3.gif" alt="The header image that appears at the top of the newsletter sign up form." width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh"><input type="file" name="signup_header_image" class="imagefield"> <CFIF signup_header_image IS NOT ""><a href="javascript:popupimage('#signup_header_image#')" class="formlink">View Current</a></CFIF></td>
					</tr>
					<tr>
						<td class="formitemlabelwh" valign="top">Footer Copy:<img src="assets/icons/ques3.gif" alt="Copy that appears at the bottom of the newsletter sign up form." width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh"><textarea name="signup_footer_copy" class="mceEditor" style="width:600px;height:200px;">#signup_footer_copy#</textarea></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
						<td class="formitemwh"><img src="assets/images/but_email_cancel.gif"  width="72" height="17" onclick="location.href='nltr_admin.cfm?s=#securestring#'" border="0" style="cursor: pointer;"> 
						<input type="image" name="Submit" value="Submit" src="assets/images/but_email_save.gif"  width="72" height="17"></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
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
