<!--- 
	FileName:	FieldsApproved.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Approved Fields</H1>

<!---  

select case RptOPtion
	case "U
		SELECT f.CLUB_ID AS ClubId, f.fieldName AS FIELD, f.fieldSize, f.field_id,
				 f.day1, f.day1TimeFrom, f.day1TimeTo,
				 f.day2, f.day2TimeFrom, f.day2TimeTo,
				 f.exceptions, vc.CLUB		
		 FROM TBL_FIELD F INNER JOIN V_CLUBS vc ON vc.ID = f.CLUB_ID
		Where (f.Approved is Null or f.Approved = '' )
		  and (f.Active_YN is NULL or f.active_YN <> 'N')
		Order by vc.club, f.CLUB_ID, f.Field
	case else
 --->
		<!--- <cfinvoke component="#SESSION.cfcPath#FIELD" method="getFields" returnvariable="qTheFields">
			<cfinvokeargument name="orderBy" value="CLUB">
		</cfinvoke> --->
	<CFQUERY name="qTheFields" datasource="#SESSION.DSN#">
		SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, f.CITY, 
			   f.APPROVED, f.REQUEST_YN, f.LIGHTS_YN, f.TURF_TYPE, 
			   f.FIELDSIZE, f.FIELDSIZECOMMENT, 
			   f.Day1, f.Day1TimeFrom, f.day1TimeTo, 
			   f.Day2, f.Day2TimeFrom, f.day2TimeTo, 
			   f.exceptions,
			   c.CLUB_ID, c.CLUB_NAME, xcf.active_yn
		  From XREF_CLUB_FIELD xcf
					INNER JOIN TBL_CLUB  C ON C.CLUB_ID = xcf.CLUB_ID
					INNER JOIN TBL_FIELD F ON F.FIELD_ID = xcf.FIELD_ID
		 WHERE F.ACTIVE_YN = 'Y'
		   AND XCF.ACTIVE_YN = 'Y'
		   AND c.CLUB_ID <> 1
		 order by c.CLUB_NAME, f.FIELDNAME
	</CFQUERY>

 
	
		
 
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td width="40%" >Field Name </td>
		<td width="30%" > Day  From - To </td>
		<td width="10%" > Size </td>
		<td width="10%" > Lights </td>
		<td width="10%" > Turf</td>
	</tr>
</table>

<div style="overflow:auto; height:415px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
	<cfset lastClubID  = 0 >
	<cfset GrandTotal  = 0 >
	<cfset TotalFields = 0 >
	<cfset LastClubNAME = qTheFields.Club_NAME >
	<CFLOOP query="qTheFields">
		<cfIf Club_Id NEQ LastClubId>
			<cfif LastClubId NEQ 0>
				<!--- Print the Totals for the Club --->
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine" ><b>#LastClubNAME#</b></td>
					<td colspan="4" class="tdUnderLine"  ><b>Total: #TotalFields#</b></td>
				</TR>
				<cfset GrandTotal  = GrandTotal + TotalFields >
				<cfset TotalFields = 0 >
		   </cfif>
		   <cfset LastClubId = Club_Id >
		   <cfset LastClubNAME = Club_NAME >
			<tr bgcolor="##CCE4F1">
				<td class="tdUnderLine" colspan="5"><b>#Club_NAME#</b></td>
			</tr>
		</cfif>
		<cfif len(trim(Exceptions))>
			<cfset classValue = "">
		<cfelse>
			<cfset classValue = "class='tdUnderLine'">
		</cfif>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td width="40%" #classValue# valign="top">#repeatString("&nbsp;",5)# #FieldNAME#</td>
			<td width="30%" #classValue# valign="top">
				#Day1# &nbsp;&nbsp; #TimeFormat(Day1TimeFrom,"hh:mm tt")# - #TimeFormat(Day1TimeTo,"hh:mm tt")#
				<cfif LEN(TRIM(Day2)) >
					<br> #Day2# &nbsp;&nbsp; #TimeFormat(Day2TimeFrom,"hh:mm tt")# - #TimeFormat(Day2TimeTo,"hh:mm tt")#
				</cfif>
			</td>
			<td width="10%" #classValue# valign="top">
				<cfswitch expression="#UCASE(FieldSize)#">
					<cfcase value="S">Small</cfcase>
					<cfcase value="L">Large</cfcase>
					<cfcase value="B">Both</cfcase>
					<cfdefaultcase> &nbsp; </cfdefaultcase>
				</cfswitch>
			</td>
			<td width="10%" #classValue# valign="top"> #LIGHTS_YN# &nbsp; </td>
			<td width="10%" #classValue# valign="top"> #TURF_TYPE# &nbsp; </td>
		</tr>
		<cfif len(trim(Exceptions))>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td class="tdUnderLine" colspan="5">#repeatString("&nbsp;",25)# Coments: #Exceptions#</td>
			</tr>
		</cfif>
		<cfset TotalFields = TotalFields + 1 >
	</CFLOOP>

	<cfif LastClubId NEQ 0 >
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
				<td ><b>#LastClubNAME#</b></td>
				<td ><b>Total: #TotalFields#</b></td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
			</TR>
			<cfset GrandTotal  = GrandTotal + TotalFields >
			<cfset TotalFields = 0 >
	</cfif>
		<tr bgcolor="##CCE4F1">
			<td align=right><b>Grand Total:</b> </td>
			<td align=left> <b>#GrandTotal#</b> </td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
		</TR>
</table>
</div>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
