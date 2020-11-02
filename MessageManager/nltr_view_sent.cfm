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
 
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
</cflock>


<!----------------------->
<!--- Local variables --->
<!----------------------->

<!---------------->
<!--- Get data --->
<!---------------->

<CFTRY>
	<CFINVOKE component="#application.mm_API_Path#getMessage" method="GetSentMessages"  clubid="#session.user.clubid#" returnvariable="getsent">
	</CFINVOKE>
	<CFCATCH type="any">
		<cfdump var="#cfcatch#">		
	</CFCATCH>			
</CFTRY>

<CFSET totalrecs = #getsent.recordcount#>
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

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Message Manager</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >
<script type="text/javascript">
function doConfirmation(message_id){
	gostring = "<CFOUTPUT>nltr_cancel_action.cfm?nextpage=nltr_view_sent.cfm&message_id=</CFOUTPUT>" + message_id;
	
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
		<CF_nltr_navigation location="sent">
		
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
								<!---<td width="99" align="left" valign="middle"><span class="emailnewbut" onclick="location.href='nltr_new_message.cfm?s=#securestring#'">New</span></td>--->
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
						<td width="200" align="left" style="padding-left:4px;"><i><b>Sent Messages</b> #startrec# - #displayendrec# of #totalrecs#</i></td>
						<td align="right" valign="middle">#arrows#</td>
					</tr>
					</CFOUTPUT>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
						<td class="rowhead" width="300">Subject</td>
						<td class="rowhead" width="100">Status</td>
						<td class="rowhead" width="150">Reply To</td>
						<td class="rowhead">Create Date</td>
						<td class="rowhead">Distribution_List</td>
						<td class="rowhead">Owner</td>
						<td class="rowhead"> </td>
					</tr>
					<CFOUTPUT>
					<CFLOOP QUERY="getSent" STARTROW="#startrec#" ENDROW="#endrec#">
					<cfquery name="getOwner" datasource="#application.dsn#">
						Select username from tbl_contact where contact_Id = (select contactid from tbl_message where message_id = #message_id#)
					</cfquery>
					<tr onmouseout="scbg(this, 0);" onmouseover="scbg(this, 1);">
						<td class="blankrowitem" onclick="location.href='nltr_view_sent_message.cfm?message_id=#message_id#'">#message_desc#</td>
						<td class="blankrowitem" onclick="location.href='nltr_view_sent_message.cfm?message_id=#message_id#'">#transmission_status#</td>
						<td class="blankrowitem" onclick="location.href='nltr_view_sent_message.cfm?message_id=#message_id#'">#replyto_email_address#</td>
						<td class="blankrowitem" onclick="location.href='nltr_view_sent_message.cfm?message_id=#message_id#'">#DATEFORMAT(datecreated,"MM/DD/YYYY")# - #TIMEFORMAT(datecreated,"h:mm tt")#</td>
						<td class="blankrowitem" onclick="location.href='nltr_view_sent_message.cfm?message_id=#message_id#'">#distribution_list#</td>
						<td class="blankrowitem" onclick="location.href='nltr_view_sent_message.cfm?message_id=#message_id#'">#getOwner.username#</td>
						<td class="blankrowitem" align="center"><cfif transmission_status_id><a href="javascript:void(0)" class="formlink" onclick="doConfirmation(#message_id#)">Remove</a></cfif></td>
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
