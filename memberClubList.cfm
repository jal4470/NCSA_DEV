<!--- 
	FileName:	clubList.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to display a list of all Clubs
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 5>
<cfinclude template="_header.cfm">

<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
	<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->

<cfoutput>

<div id="contentText">

<H1 class="pageheading"> NCSA Member Club List </H1>
<P align="left"></P>
<H2></H2>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td> &nbsp;		</td>
		<td> Club Name  </td>
	</tr>
	<CFLOOP query="clubInfo">
		<CFIF MemberNCSA EQ "Y">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td valign="top" valign="top" class="tdUnderLine">
				&nbsp;
			</TD>
			<td valign="top" class="tdUnderLine">
				<b>#Club_name#</b>
			</td>
		</tr>
		</CFIF>
	</CFLOOP>
</table>

</cfoutput>

</div>

<cfinclude template="_footer.cfm">

