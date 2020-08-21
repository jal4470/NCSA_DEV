<!--- 
	FileName:	rptBoardmembers.cfm
	Created on: 02/20/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	As of 2/6/09: we have 2 reports in 1
		Club President Report
			accessed by:	board only 
			shows: 			club president email phone#s
			produces:		a list of eamil addresses
		Club Representative Report
			accessed by:	board only 
			Shows: 			clu rep/alt rep email phone#s
			produces:		a list of eamil addresses
	
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>


<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMems">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->


<div id="contentText">


<H1 class="pageheading">NCSA - Board List</H1>
<!--- <br><h2>yyyyyy </h2> 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">--->

<table cellspacing="0" cellpadding="3" width="100%" align="center" border="0" >
	<tr><td colspan="7">Click on the Board Member's Email address to send an email.</td>
	<tr>
	<tr class="tblHeading">
		<td width="30%"> Title / Name	 </td>
		<td width="30%"> Email Address </td>
		<td width="20%"> NCSA Phone	 </td>
		<td width="20%"> Contact Phone </td>
	</tr>
</table>
<div style="overflow:auto;height:450px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="3" width="100%" align="left" border="0" >
		<CFLOOP query="boardMems">
			<cfif ACTIVE_YN EQ "Y">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td width="30%" valign="top" class="tdUnderLine" nowrap>
						#TITLE#
						<br>#repeatString("&nbsp;",20)# <b>#FIRSTNAME# #LASTNAME#</b>
						<br>#repeatString("&nbsp;",20)# #address#
						<br>#repeatString("&nbsp;",20)# #city# #state# #zipcode#
					</td>
					<td width="30%" valign="top" class="tdUnderLine">
							ncsa: <a href="mailto:#NCSAEMAIL#"> #NCSAEMAIL# </a>  &nbsp;
						<br>
						<br>contact: <a href="mailto:#contactEmail#"> #contactEmail# </a>  &nbsp;
					</td>
					<td width="20%" valign="top" class="tdUnderLine">
							N: #NCSAPHONE#		&nbsp;
						<br>f: #NCSAFAX#		&nbsp;
					</td>
					<td width="20%" valign="top" class="tdUnderLine">
							h: #contactPhoneHome#
						<br>w: #contactPhoneWork#
						<br>c: #contactPhoneCell#
						<br>f: #contactPhoneFax#
					</td>
				</tr>
			</cfif>
		</CFLOOP>
	</table>
</div>




</div>
</cfoutput>
<cfinclude template="_footer.cfm">