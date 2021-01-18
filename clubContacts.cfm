<!--- 
	FileName:	clubCoaches.cfm 
	Created on: 08/12/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will display a list of clubs and their Coaches
	
MODS: mm/dd/yyyy - filastname - comments
12/30/08 - aa -  supress club 1
12/10/2012 - Rodney - replaced drop down menu to text
 --->

<cfset mid = 2>
<cfinclude template="_header.cfm">

<div id="contentText">

<H1 class="pageheading"> Club Contacts List </H1>
<P align="left"></P>
<!---<H2>Select a club and click Enter to see the club's contacts.</H2>--->

<CFIF isDefined("FORM.clubID")>
	<CFSET clubID = FORM.clubid>
<CFELSEIF isDefined("URL.cid")>
	<CFSET clubID = url.cid>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>

<CFIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid>
<CFELSE>
	<CFSET teamID = 0>
</CFIF>




<cfoutput>


<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
	<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>  <!--- <cfdump var="#clubInfo#"> --->
	
<!---This function is no longer available, please contact your Club Representative for more details--->
<div style="font-size: 115%;">
<p>This function is no longer available.  This function had included all contacts associated with a particular club; as a result, it contained information for many contacts no longer active in the club.  In order to protect their contact information, this function has been removed.  Information on active contacts is available as follows:</p>
<p>For a club official, please use the “club” link above.</p>
<p>For a coach, please use the “teams/coaches” link above.</p>
</div>

	
<!---<FORM action="clubContacts.cfm" method="post">
	<select name="clubid">
		<option value="0">Select a Club...</option>
		<CFLOOP query="clubInfo">
			<cfif CLUB_ID NEQ 1> <!--- supress club 1 --->
				<option value="#CLUB_ID#" <cfif variables.clubid EQ CLUB_ID>selected</cfif> >#CLUB_NAME#</option>
			</cfif>
		</CFLOOP>
	</select> 
	<input type="Submit" name="getCoaches" value="Enter">

</FORM>--->

<CFIF VARIABLES.clubid GT 0>
	<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getClubContacts" returnvariable="qClubContacts">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
	</cfinvoke>  
	<cfquery name="qContacts" dbtype="query">
		select * from qContacts where active_yn = 'Y'
	</cfquery>
	<CFIF qClubContacts.recordCount>
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
			<tr class="tblHeading">
				<td colspan="6"><!---  #qClubContacts.Club_Name#  ---></td>
			</tr>
			<tr class="tblHeading">
				<td width="20%"> Name </td>
				<td width="20%"> email   </td>
				<td width="15%"> Home ## </td>
				<td width="15%"> Work ## </td>
				<td width="15%"> Cell ## </td>
				<td width="15%"> Fax ##  </td>
			</tr>
		</table>
		<div style="overflow:auto; height:350px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="5" align="center" border="0" width="98%">
			<CFLOOP query="qClubContacts">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td width="20%" valign="top" class="tdUnderLine">
						&nbsp;  <b>#LastName#, #FirstName#</b>
					</TD>
					<td width="20%" valign="top" class="tdUnderLine">
						&nbsp; <a href="mailto:#email#">#email#</a>
					</TD>
					<td width="15%" valign="top" class="tdUnderLine">
						#PHONEHOME#	&nbsp;  
					</td>
					<td width="15%" valign="top" class="tdUnderLine">
						#PHONEWORK#	&nbsp;  
					</td>
					<td width="15%" valign="top" class="tdUnderLine">
						#PHONECELL#	&nbsp;  
					</td>
					<td width="15%" valign="top" class="tdUnderLine">
						#PHONEFAX#	&nbsp;  
					</td>
				</tr>
			</CFLOOP>
		</table>
		</div>
	</CFIF>
</CFIF>

 
</cfoutput>
</div>


<cfinclude template="_footer.cfm">



