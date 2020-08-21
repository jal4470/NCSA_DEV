<!--- 
File: Index.cfm 
Purpose: To Display all Message drafts and navigation.
Author: Joe Lechuga jlechuga@capturepoint.

Changes:
Joe Lechuga 3/11/2010 Initial Revision
Joe Lechuga 3/11/2010 Removed Securestring References and Organization Id references.

 --->
 
<cfsetting requesttimeout="999"> 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">

<cfset application.mm_api_path = "API.">

<!--- <CFTRY> --->
	<CFINVOKE component="#application.mm_api_path#getMessage" method="GetDraftMessages" contactid="#session.user.contactid#" returnvariable="getdrafts">
	</CFINVOKE>

<CFSET totalrecs = #getdrafts.recordcount#>
<CFSET viewrecs = 10>

<CFSET startrec = 1>

<CFIF totalrecs GT viewrecs>
	<CFSET endrec = viewrecs>
<CFELSE>
	<CFSET endrec = totalrecs>
</CFIF>

<CFIF ISDEFINED("url.start_record")>
	<CFSET startrec = #url.start_record#>
</CFIF>
<CFIF ISDEFINED("url.end_record")>
	<CFSET endrec = #url.end_record#>
</CFIF>

<CFIF endrec GT totalrecs>
	<CFSET displayendrec = totalrecs>
<CFELSE>
	<CFSET displayendrec = endrec>
</CFIF>
<!--- 	<CFCATCH type="any">
		<cfdump var="#cfcatch#">	<cfabort>
	</CFCATCH>			
</CFTRY> --->

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>NCSA</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >
<script type="text/javascript">
function doConfirmation(message_id){
	gostring = "<CFOUTPUT>nltr_cancel_action.cfm?nextpage=index.cfm&message_id=</CFOUTPUT>" + message_id;
	
	var message = "Are you sure you want to remove this message?";
	var wantToContinue = "false";
	

	wantToContinue = confirm(message);
	
	
	if (wantToContinue == true) { 
		// put whatever you want to happen if someone clicks OK here
		window.location.href=gostring;
	}else{
		return false;
	}
}

</script>
<script language="JavaScript1.3" type="text/javascript">
function scbg(objRef, state) {
	objRef.style.backgroundColor = (1 == state) ? '#D3D8ED' : '#FFFFFF';
	return;
}
</script>


<cfscript> 
rs = structNew(); 
rs.start_record = #startrec#; 
rs.end_record = #endrec#; 
rs.records_per_page = #viewrecs#; 
rs.total_records = #totalrecs#; 
rs.query_str = ""; 
</cfscript> 
<cfmodule template="assets/modules/pagination.cfm" recordStruct="#rs#">

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="assets/js/tooltip.js">


<CFINCLUDE TEMPLATE="header_nltr.cfm"> 


<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
<CF_nltr_navigation location="drafts" >

		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="Step1.cfm">
					<tr>
						<td width="70" align="left" valign="middle" style="background-image: url(assets/images/emailnewbutton.jpg);background-repeat: no-repeat;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="99" align="left" valign="middle"><input type="submit" name="submit" value="New" class="emailnewbut"></td>
							</tr>
						</table>
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</form>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			
			<tr>
				<td class="emailtablebar">
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="200" align="left" style="padding-left:4px;"><i><b>Draft Messages</b> #startrec# - #displayendrec# of #totalrecs#</i></td>
						<td align="right" valign="middle">#arrows#</td>
					</tr>
					</CFOUTPUT>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
						<td class="rowhead" width="200">Subject</td>
						<td class="rowhead" width="100">Status</td>
						<td class="rowhead" width="150">Reply To</td>
						<td class="rowhead">Create Date</td>
						<td class="rowhead">Distribution List</td>
						<td class="rowhead">Owner</td>
						<td class="rowhead"> </td>
					</tr>
					<CFOUTPUT>
					
					<CFLOOP QUERY="getDrafts" STARTROW="#startrec#" ENDROW="#endrec#">
					<tr onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);">
						<td class="blankrowitem" onclick="location.href='Step1.cfm?message_id=#message_id#'">#message_desc#</td>
						<td class="blankrowitem" onclick="location.href='Step1.cfm?message_id=#message_id#'">Test #TRANSMISSION_STATUS#</td>
						<td class="blankrowitem" onclick="location.href='Step1.cfm?message_id=#message_id#'">#replyto_email_address#</td>
						<td class="blankrowitem" onclick="location.href='Step1.cfm?message_id=#message_id#'">#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
						<td class="blankrowitem" onclick="location.href='Step1.cfm?message_id=#message_id#'">#Distribution_list#</td>
						<td class="blankrowitem" onclick="location.href='Step1.cfm?message_id=#message_id#'">#owner#</td>
						<td class="blankrowitem" align="center" onclick="doConfirmation(#message_id#)"><a href="javascript:void(0)" class="formlink">Remove</a></td>
					</tr>
					</CFLOOP>
					</CFOUTPUT>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="150" align="left" class="tablebasenav">#pages#</td>
						<td align="center" class="tablebasenav">#counter#</td>
						<td width="150" align="right" valign="middle" class="tablebasenav">#arrows#</td>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!--- END BODY --->

</body>
</html>
 