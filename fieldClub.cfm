<!--- 
	FileName:	fieldClub.cfm
	Created on: 11/25/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfinclude template="_checkLogin.cfm"> use?


<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Fields Worksheet</H1>
<br> <h2>yyyyyy </h2>



		<cfquery name="getFields" datasource="#SESSION.DSN#">
			SELECT f.CLUB_ID, c.CLUB_NAME, f.field_id, f.FIELDABBR, f.fieldName, 	
				   f.fieldSize, f.LIGHTS_YN, f.TURF_TYPE,									
				   f.day1, f.day1TimeFrom, f.day1TimeTo,					
				   f.day2, f.day2TimeFrom, f.day2TimeTo,					
				   f.exceptions
			  From XREF_CLUB_FIELD xcf
							INNER JOIN TBL_CLUB  C ON C.CLUB_ID  = xcf.CLUB_ID
							INNER JOIN TBL_FIELD F ON F.FIELD_ID = xcf.FIELD_ID
			 WHERE  F.ACTIVE_YN = 'Y'
			   AND  XCF.ACTIVE_YN = 'Y'
			 ORDER  BY c.CLUB_NAME, f.FIELDABBR
		</cfquery>


	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*">
	
		<tr class="tblHeading">
			<TD> 				aaaaa			</TD>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#"> <!--- currentRow or counter --->
			<TD class="tdUnderLine" nowrap> bbbbbbbbb		</TD>
		</tr>
	</table>	

		
		
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td>Fields Name</td>
		<td>Size</td>
		<td>Day</td>
		<td>From - To</td>
		<td>Exceptions</td>
	</tr>
	<cfset TotalFields	= 0 >
	<cfset LastClubId	= 0 >
	<cfset GrandTotal	= 0 >
	<CFLOOP query="getFields">
		<cfif Club_Id NEQ LastClubId>
			<cfif LastClubId NEQ 0>
				<!--- Print the Totals for the Club  --->
				<TR><td>#CLUB_NAME#</td>
					<td><B>Total</b></td>
					<td>#TotalFields#</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</TR>
				<cfset GrandTotal  = GrandTotal + TotalFields >
				<cfset TotalFields = 0 >
			</cfif>
			<cfset LastClubId = Club_Id >
			<tr><td colspan="5"><u><b>#Club_name#</b></u></td>
			</tr>
		</cfif>
		<TR><td>#Field_ABBR#</td>
			<td><cfif FieldSize EQ "S"> Small </cfif>
				<cfif FieldSize EQ "L"> Large </cfif>
				<cfif FieldSize EQ "B"> Both  </cfif>
			</td>
			<td>#Day1#</td>
			<td>#timeFormat(Day1From,"hh:mm tt")# - #timeFormat(Day1To,"hh:mm tt")# </td>
			<td>#Exceptions#</td>
		</tr>
		<CFIF Len(Trim(Day2))>
			<TR style="BACKGROUND-COLOR: <%=BGColor%>">
				<td >&nbsp; </td>
				<td >&nbsp; </td>
				<td>#Day2#</td>
				<td>#timeFormat(Day2From,"hh:mm tt")# - #timeFormat(Day2To,"hh:mm tt")# </td>
				<td >&nbsp; </td>
			</TR>
		</cfif>
		<cfset TotalFields = TotalFields + 1>
	</CFLOOP>

	<CFIF LastClubId NEQ 0>
		<TR><td><b>#club_NAME#</b> </td>
			<td><b>Total</b> </td>
			<td><b>#TotalFields#</b> </td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</TR>
		<CFSET GrandTotal  = GrandTotal + TotalFields >
		<CFSET TotalFields = 0 >
	</CFIF>
	
	<TR><td align=right><b>Grand &nbsp;</b></td>
		<td ><b>Total</b></td>
		<td ><b>#GrandTotal#</b></td>
		<td >&nbsp;</td>
		<td >&nbsp;</td>
	</TR>
</table>

</TABLE>

<table cellSpacing="0" cellPadding="0" width="50%" border="0">
          <tr>
            <td align="middle">
				<INPUT type="button" value="Back" name="Back" onclick="GoBack()"  style="WIDTH: 83px; HEIGHT: 28px" size="38">
            </td>
          </tr>
</table>

<script language="javascript">
function GoBack()
{ history.go(-1);
//	self.document.Coaches.action = "..\menu.asp";
//	self.document.Coaches.submit();	
}
</script>




</cfoutput>
</div>
<cfinclude template="_footer.cfm">
