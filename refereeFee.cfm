<!--- 
	FileName:	standings.cfm
	Created on: 08/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Display Standings based on Division
	
MODS: mm/dd/yyyy - filastname - comments
7-29-2014	-	J. Danz	-	(TICKET NCSA15480) - updated referee fees and AR fee and added paragraph to bottom of table.
3-25-2019 - R. Gonzalez (TICKET NCSA33424) - Correct copy 

TODOS: this does not have the logic to display the game details
 --->
 
<cfset mid = 4> 
<cfinclude template="_header.cfm">

<div id="contentText">

<cfoutput>
<H1 class="pageheading">NCSA - Referee Fees</H1>
<br>
<H2></H2>

<br>
	<table cellpadding="5" cellspacing="0" width="85%">
		<tr class="tblHeading">
			<td class="tdUnderLine">Division</td>
			<td class="tdUnderLine">Game Length </td>
			<td class="tdUnderLine">Referee Fee </td>
			<td class="tdUnderLine">AR Fee (per AR)</td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<td class="tdUnderLine"> U17 - U19 </td>
			<td class="tdUnderLine"> 45 minute halves </td>
			<!--- <td class="tdUnderLine"> $80 </td>
			<td class="tdUnderLine"> $46 </td> --->
			<td class="tdUnderLine"> $90 </td>
			<td class="tdUnderLine"> $50 </td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine"> U15 - U16 </td>
			<td class="tdUnderLine"> 40 minute halves </td>
			<!--- <td class="tdUnderLine"> $80 </td>
			<td class="tdUnderLine"> $46 </td> --->
			<td class="tdUnderLine"> $80 </td>
			<td class="tdUnderLine"> $45 </td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,3)#">
			<td class="tdUnderLine"> U13 - U14 </td>
			<td class="tdUnderLine"> 40 minute halves </td>
			<!--- <td class="tdUnderLine"> $70 </td>
			<td class="tdUnderLine"> $40 </td> --->
			<td class="tdUnderLine"> $80 </td>
			<td class="tdUnderLine"> $45 </td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,4)#">
			<td class="tdUnderLine"> U11 - U12 </td>
			<td class="tdUnderLine"> 35 minute halves </td>
			<!--- <td class="tdUnderLine"> $60 </td>
			<td class="tdUnderLine"> $36 </td> --->
			<td class="tdUnderLine"> $70 </td>
			<td class="tdUnderLine"> $40 </td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,5)#">
			<td class="tdUnderLine"> U9 - U10 </td>
			<td class="tdUnderLine"> 30 minute halves </td>
			<!--- <td class="tdUnderLine"> $50 </td>
			<td class="tdUnderLine"> $30* </td> --->
			<td class="tdUnderLine"> $60 </td>
			<td class="tdUnderLine"> $35* </td>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,6)#">
			<td class="tdUnderLine"> U8 </td>
			<td class="tdUnderLine"> 30 minute halves </td>
			<!--- <td class="tdUnderLine"> $50 </td>
			<td class="tdUnderLine"> $30* </td> --->
			<td class="tdUnderLine"> $60 </td>
			<td class="tdUnderLine"> $35* </td>
		</tr>
	</table>
	<p>*AR&apos;s are typically not assigned for U10 and younger; however, if scheduling of U11 or older small sided is mixed with U10 and younger small sided, then AR&apos;s may be assigned for referee assignment continuity.</p>

</cfoutput>

</DIV>

<cfinclude template="_footer.cfm">
