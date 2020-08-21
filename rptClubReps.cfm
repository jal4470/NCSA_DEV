<!--- 
	FileName:	rptClubReps.cfm
	Created on: mm/dd/2008
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
<div id="contentText">


<cfif isDefined("URL.prs")>
	<cfset roleID = SESSION.CONSTANT.ROLEIDCLUBPRES>
	<cfset headingText = "Club President Report">
<cfelseif isDefined("URL.rep")>
	<cfset roleID = SESSION.CONSTANT.ROLEIDCLUBREP & "," & SESSION.CONSTANT.ROLEIDCLUBALT>
	<cfset headingText = "Club Representative Report">
<cfelse>
	<cfset roleID = 0>
	<cfset headingText = "" >
</cfif>

<H1 class="pageheading">NCSA - #headingText#</H1>
<!--- <br><h2>yyyyyy </h2> 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">--->


<CFQUERY name="qGetClubPres" datasource="#SESSION.DSN#">
	select cl.Club_name, x.contact_id, co.FirstNAme, co.LastName,
		   co.email, co.phoneHome, co.phoneWork, co.phoneCell, co.phoneFax,
		   co.address, co.city, co.state, co.zipcode 
	  from xref_contact_role x 
				INNER JOIN TBL_CONTACT co on co.CONTACT_ID = x.CONTACT_ID
				INNER JOIN TBL_CLUB    cl on cl.club_id    = co.club_id
	 where x.role_id 
	 		<cfif listLen(roleID) GT 1>
				in (#VARIABLES.roleID#)
			<cfelse>
				= #VARIABLES.roleID#
			</cfif>
	   and x.season_id = #SESSION.CURRENTSEASON.ID#
	   and x.active_yn = 'Y'
	   and CO.active_yn = 'Y'
	 ORDER by CL.CLUB_NAME, x.role_id 
</CFQUERY>

<table cellspacing="0" cellpadding="4" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="25%">Club</TD>
		<TD width="25%">President</TD>
		<TD width="20%">Email</TD>
		<TD width="30%">Phone Numbers</TD>
	</tr>
</table>
	<cfset emaillist = "">	

<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="3" align="center" border="0" width="98%">
	<CFLOOP query="qGetClubPres">
		<cfset emailList = emailList & email & "; " > 
		<tr  bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD class="tdUnderLine" width="30%" valign="top"> #Club_name#</TD>
			<TD class="tdUnderLine" width="30%" valign="top"> 
					<b>#FirstNAme# #LastName#</b>
				<br>#address# 
				<br>#city#, #state# #zipcode#
			</TD>
			<TD class="tdUnderLine" width="10%" valign="top"> <a href="mailto:#email#">#email#</a> </TD>

			<TD class="tdUnderLine" width="15%" valign="top"> 
						(h) #phoneHome# &nbsp;
					<br>
					<br> (c) #phoneCell# &nbsp;
			</TD>
			<TD class="tdUnderLine" width="15%" valign="top"> 
						(w) #phoneWork# &nbsp;
					<br>
					<br> (f) #phoneFax#  &nbsp;
			</TD>
		</tr>

			<!--- <TD class="tdUnderLine" width="10%" valign="top"> #phoneHome# &nbsp;</TD>
			<TD class="tdUnderLine" width="10%" valign="top"> #phoneCell# &nbsp;</TD>
			<TD class="tdUnderLine" width="10%" valign="top"> #phoneWork# &nbsp;</TD>
			<TD class="tdUnderLine" width="10%" valign="top"> #phoneFax#  &nbsp;</TD> --->
		<!--- <tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD valign="top" class="tdUnderLine">&nbsp;</TD>
			<TD colspan="2" valign="top" class="tdUnderLine">
					#repeatString("&nbsp;",5)# #address# 
				<br>#repeatString("&nbsp;",5)# #city#, #state# #zipcode#
			</TD>
			<TD colspan="4" valign="top" class="tdUnderLine">&nbsp;</TD>
		</tr> --->
		
	</CFLOOP>
	</table>
</div>
<br> All emails: start[
<br>
<br> #emailList# 
<br>
<br> ]end	


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
