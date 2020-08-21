<!--- 
	FileName:	clubList.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to display a list of all Clubs
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 2>
<cfinclude template="_header.cfm">

<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->

<cfoutput>

<div id="contentText">

<H1 class="pageheading"> NCSA Club Web Sites </H1>
<P align="left"></P>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td>&nbsp;</td>
		<td> Club Name </td>
		<td> Web Site  </td>
	</tr>
</table>

<div style="overflow:auto; height:350px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="100%">
	<CFLOOP query="clubInfo">
		<CFIF CLUB_ID NEQ 1> <!--- omits ncsa from list --->
			<CFIF listLen(ClubHomePage,":") GT 1>
				<!--- remove http:// --->
				<CFSET displayHomePage = listLast(ClubHomePage,":")>
				<CFSET displayHomePage = listLast(ClubHomePage,"/")>
			<CFELSE>
				<CFSET displayHomePage = ClubHomePage>
			</CFIF>
			
			<CFIF listLen(displayHomePage,".") EQ 1>
				<CFSET displayHomePage = "none">
			</CFIF>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td valign="top" class="tdUnderLine">
					&nbsp;
					<!--- <b>#currentRow# --->
					<!--- <input type="Hidden" name="cid#CLUB_ID#" value="#CLUB_ID#"> --->
				</TD>
				<td valign="top" class="tdUnderLine">
					<CFIF displayHomePage EQ "none">
						<!--- there are no . in the address so it must be invalid --->
						<b>#Club_name#</b>
					<CFELSE>
						<a href="http://#displayHomePage#" target="_blank"><b>#Club_name#</b></a>
					</CFIF>
					&nbsp;
					<CFIF MemberNCSA EQ "Y">
						<font color=red>Member</font>
					</CFIF>
				</td>
				<td valign="top" class="tdUnderLine">
					<CFIF displayHomePage EQ "none">
						<!--- there are no . in the address so it must be invalid --->
						none
					<CFELSE>
						<a href="http://#displayHomePage#" target="_blank"><b>#displayHomePage#</b></a>
					</CFIF>
				</td>
			</tr>
		</CFIF>
	</CFLOOP>
</table>
</div>

</cfoutput>

</div>

<cfinclude template="_footer.cfm">

