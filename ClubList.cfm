<!--- 
	FileName:	clubList.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to display a list of all Clubs
	
MODS: mm/dd/yyyy - flastname - comments

 --->

<cfinclude template="_header.cfm">

<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->
<cfoutput>

<div id="contentText">
<H1 class="pageheading" align="center">	NCSA Clubs List </H1>

<table width="800px" cellspacing="0" cellpadding="1" align="center" border="0">
	<tr><td colspan="7"><h3>Click on underlined clubname to send an Email</h3>       </td>
		<!--- <td><a href="clubReps.cfm">clubreps</a>       </td> --->
	</tr>
	<tr class="tblHeading">
		<td width="0%"></td>
		<td width="56%"> Club</td>
		<td width="07%"> &nbsp;</td>
		<td width="10%"> &nbsp;</td>
		<td width="07%"> &nbsp;</td>
		<td width="10%"> &nbsp;</td>
		<td width="10%"> &nbsp;</td>
	</tr>

	<CFLOOP query="clubInfo">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td valign="top" class="tdUnderLine">
				#Club_Id#
			</TD>
			<td valign="top" class="tdUnderLine">
				#Club_name#
			</td>
			<td valign="top" class="tdUnderLine">
				<CFIF MemberNCSA EQ "Y">
					<font color=red>Member</font>
				<CFELSE>
					&nbsp;
				</CFIF>
			</td>
			<td valign="top" class="tdUnderLine">
				<A href="##">Coaches List</A>
			</td>
			<td valign="top" class="tdUnderLine">
				<A href="##">Fields</A>
			</td>
			<td valign="top" class="tdUnderLine">
				<A href="##">Club Details</A>
			</td>
			<td valign="top" class="tdUnderLine">
				<CFIF len(trim(ClubHomePage))>
					<A href="http://#ClubHomePage#" Target="_blank">Website</A>
				<CFELSE>
					&nbsp;
				</CFIF>[[#ClubHomePage#]]
			</td>
		</TR>
	</CFLOOP>
</table>

</div>

</cfoutput><cfinclude template="_footer.cfm">

