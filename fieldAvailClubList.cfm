<!--- 
	FileName:	fieldAvailClubList.cfm
	Created on: 01/06/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: this will list the primary fields in a club and list out the availability for the playweekends 
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<CFIF isDefined("SESSION.REGSEASON.ID")>
	<CFSET seasonID  = SESSION.REGSEASON.ID >
	<CFSET seasonTxT = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET seasonSF  = SESSION.REGSEASON.SF >
<CFELSE>
	<CFSET seasonID  = SESSION.CURRENTSEASON.ID >
	<CFSET seasonTxT = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET seasonSF  = SESSION.CURRENTSEASON.SF >
</CFIF> 

<CFIF isDefined("SESSION.USER.CLUBID")>
	<CFSET clubID = SESSION.USER.CLUBID> <!--- club --->
<CFELSE>
	<CFSET clubID = 0>
</CFIF>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Field Availability</H1>
<h2>For: season #seasonTxT# </h2>

<cfif isDefined("URL.fid") AND isNumeric(URL.fid)>
	<cfset fieldid = URL.fid>
<cfelseif isDefined("FORM.fieldid") AND isNumeric(FORM.fieldid)>
	<cfset fieldid = FORM.fieldid>
<CFELSE>
	<cfset fieldid = 0>
</cfif>

<!--- get all primary fields for the club --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getClubPrimaryFields" returnvariable="qFieldsApproved">
	<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
	<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
</cfinvoke>  

<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getPlayweeks" returnvariable="qPlayWE">
	<cfinvokeargument name="seasonID" value="#VARIABLES.seasonID#">
</cfinvoke>
 
<form action="fieldAvailClubList.cfm" method="post">
	Select a field:
	<select name="fieldID" >
		<option value="0">All Fields</option> 
		<cfloop query="qFieldsApproved">
			<option value="#FIELD_ID#" <cfif fieldID EQ FIELD_ID>selected</cfif> > #fieldAbbr# </option>
		</cfloop>
	</select>
	<input type="Submit" name="GetAvailability" value="get field">
	<br>
	<br> <hr size="1">
</form>

<CFIF isDefined("FORM.GetAvailability")>
	<!--- IF fieldID = 0, loop all fields
	If fieldID gt 0, only loop 1 field --->
	<CFIF fieldID EQ 0>
		<cfset listFields = valueList(qFieldsApproved.FIELD_ID)>
	<CFELSE>
		<cfset listFields = VARIABLES.fieldID>
	</CFIF>

	<table border="0" width="98%" cellpadding="2" cellspacing="0">
		<tr class="tblHeading">
			<td> WEEK##  </td>
			<td> Sat     </td>
			<td> Avail?  </td>
			<td> Sat From</td>
			<td> Sat To  </td>
			<td> &nbsp;  </td>
			<td> Sun     </td>
			<td> Avail?  </td>
			<td> Sun From</td>
			<td> Sun To  </td>
		</tr>
	</table>
	<div style="overflow:auto; height:450px; border:1px ##cccccc solid;">
	<table border="0" width="98%" cellpadding="2" cellspacing="0">
	<CFLOOP list="#VARIABLES.listFields#" index="iFld">
		<cfquery name="qfieldInfo" datasource="#SESSION.DSN#">
			SELECT FIELD_ID, FIELDABBR, FIELDNAME, CITY, FIELDSIZE, LIGHTS_YN, TURF_TYPE
			  FROM tbl_FIELD 
			 WHERE FIELD_ID  = #iFld#
		</cfquery>

		<tr bgcolor="##CCE4F1">
			<td colspan="8"> #qfieldInfo.FIELD_ID# - #qfieldInfo.FIELDABBR# - #qfieldInfo.CITY#
							 <br> <a href="fieldAvailEdit.cfm?fid=#qfieldInfo.FIELD_ID#">[ Edit ]</a> #qfieldInfo.FIELDNAME#
			</td>
			<td colspan="2"> Lights: #qfieldInfo.LIGHTS_YN#
							 <br>Turf: #qfieldInfo.TURF_TYPE#
			</td>
		</tr>

		<cfquery name="getplayweeks" datasource="#SESSION.DSN#">
			SELECT X.PLAYWEEKEND_ID, 
				   X.SAT_AVAIL_YN,  X.SAT_TIME_FROM,  X.SAT_TIME_TO,
				   X.SUN_AVAIL_YN,  X.SUN_TIME_FROM,  X.SUN_TIME_TO,
				   pw.WEEK_NUMBER,  pw.Day1_Date, 	  pw.Day2_Date,
				   F.FIELD_ID,		F.FIELDABBR,	  F.FIELDNAME, 
				   F.CITY,			F.FIELDSIZE, 	  F.LIGHTS_YN, F.TURF_TYPE
			  FROM XREF_FIELD_WEEKEND X 
			  			inner join tbl_playweekend pw ON pw.playweekend_ID = X.playweekend_id
			  			inner join tbl_FIELD f		  ON f.FIELD_ID = X.field_id
			 WHERE x.FIELD_ID  = #iFld#
			   AND x.SEASON_ID = #VARIABLES.SeasonID# 
			ORDER BY F.FIELDABBR, pw.WEEK_NUMBER
		</cfquery>

		<CFIF getplayweeks.recordCount>
			<cfloop query="getplayweeks">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,WEEK_NUMBER)#">
					<td width="06%" class="tdUnderLine"> &nbsp; #WEEK_NUMBER#	</td>
					<td width="13%" class="tdUnderLine"> &nbsp; #dateFormat(Day1_Date, "DDD mm/dd/yy")#</td>
					<td width="05%" class="tdUnderLine"> <cfif len(trim(SAT_AVAIL_YN))>#SAT_AVAIL_YN#<cfelse>N</cfif> </td>	
					<td width="13%" class="tdUnderLine"> &nbsp; #timeFormat(SAT_TIME_FROM,"hh:mm tt")#	</td>	
					<td width="13%" class="tdUnderLine"> &nbsp; #timeFormat(SAT_TIME_TO,"hh:mm tt")#	</td>	
					<td width="06%" class="tdUnderLine"> &nbsp;	</td>
					<td width="13%" class="tdUnderLine"> &nbsp; #dateFormat(Day2_Date, "DDD mm/dd/yy")#</td>	
					<td width="05%" class="tdUnderLine"> <cfif len(trim(SUN_AVAIL_YN))>#SUN_AVAIL_YN#<cfelse>N</cfif> </td>	
					<td width="13%" class="tdUnderLine"> &nbsp; #timeFormat(SUN_TIME_FROM,"hh:mm tt")#	</td>	
					<td width="13%" class="tdUnderLine"> &nbsp; #timeFormat(SUN_TIME_TO,"hh:mm tt")# 	</td>	
				</tr>
			</cfloop>	
		<CFELSE>
			<tr><td class="red" colspan="10"> 
					<b>There are no play week availabilty records found for this field. Click <a href="fieldAvailEdit.cfm?fid=#qfieldInfo.FIELD_ID#">[ Edit ]</a> to enter availability. 
				</td> 
			</tr>
		</CFIF>		
	</CFLOOP>
	</table>
	</div>
</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
