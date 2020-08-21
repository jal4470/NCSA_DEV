<!--- 
	FileName:	clubList.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to display a list of all Clubs
	
MODS: mm/dd/yyyy - flastname - comments
	12/30/08 - aa - supress club 1
 --->
<cfset mid = 2>
<cfinclude template="_header.cfm">

<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->

<cfoutput>

<div id="contentText">

<H1 class="pageheading"> NCSA Clubs List </H1>
<P align="left"></P>
<H2>Click on the clubname to see the club's information.</H2>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td> &nbsp;		</td>
		<td> Club Name  </td>
	</tr>
</table>
<div style="overflow:auto; height:350px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
	<CFLOOP query="clubInfo">
		<cfif CLUB_ID NEQ 1> <!--- supress club 1 --->
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td valign="top" valign="top" class="tdUnderLine">
					&nbsp;
				</TD>
				<td valign="top" class="tdUnderLine">
					<b><a href="clubContactDetails.cfm?cid=#CLUB_ID#">#Club_name#</a></b>
					&nbsp;
					<CFIF MemberNCSA EQ "Y">
						<font color=red>Member</font>
					</CFIF>
				</td>
			</tr>
		</cfif>
	</CFLOOP>
</table>
</div>
</cfoutput>

</div>

<cfinclude template="_footer.cfm">

