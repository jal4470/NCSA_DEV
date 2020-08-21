<!--- 
	FileName:	fieldavailEdit.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Enter/change a fields hours of availability per playweek
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<CFIF isDefined("FORM.seasonID")>
	<CFSET seasonID  = FORM.seasonID >
	<CFSET seasonTxT = FORM.seasonTxT >
	<CFSET seasonSF  = FORM.seasonSF >
<CFELSEIF isDefined("URL.SID") AND isNumeric(URL.sid) >
	<cfquery name="qGetseasonInfo" datasource="#SESSION.DSN#">
		select season_SF, season_year
		  from tbl_season 
		 where season_ID =  #URL.SID#
	</cfquery>
	<CFIF qGetseasonInfo.RECORDCOUNT>
		<CFSET seasonID  = URL.SID>
		<CFSET seasonTxT = qGetseasonInfo.season_SF & " " & qGetseasonInfo.season_year>
		<CFSET seasonSF  = qGetseasonInfo.season_SF>
	<CFELSE>	
		<CFSET seasonID  = "">
		<CFSET seasonTxT = "Season error">
		<CFSET seasonSF  = "">
	</CFIF>
<CFELSEIF isDefined("SESSION.REGSEASON.ID")>
	<CFSET seasonID  = SESSION.REGSEASON.ID >
	<CFSET seasonTxT = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET seasonSF  = SESSION.REGSEASON.SF>
<CFELSE>
	<CFSET seasonID  = SESSION.CURRENTSEASON.ID >
	<CFSET seasonTxT = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET seasonSF  = SESSION.CURRENTSEASON.SF>
</CFIF>


<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit Field Availability - for season: #seasonTxT#</H1>
<!--- <h2>For: season #seasonTxT# </h2> --->

<CFIF isDefined("SESSION.USER.CLUBID") >
	<CFSET clubID = SESSION.USER.CLUBID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>

<cfif isDefined("URL.fid") AND isNumeric(URL.fid)>
	<cfset fieldid = URL.fid>
<cfelseif isDefined("FORM.FIELDID") AND isNumeric(FORM.FIELDID)>
	<cfset fieldid = FORM.FIELDID>
<cfelse>
	<cfset fieldid = 0>
</cfif>

<CFSET theMsg = "">


<cfif isDefined("FORM.SAVE")> <!--- <cfdump var="#FORM#"> <CFABORT> --->
	<cfset swWK1forALL = false >
	<cfloop list="#FORM.listOFweekendIDs#" index="iWKno">
		<cfset satAvailYN = "">
		<cfset satHHfrom  = "">
		<cfset satMMfrom  = "">
		<cfset satTTfrom  = "">
		<cfset satHHto    = "">
		<cfset satMMto    = "">
		<cfset satTTto    = "">
		<cfset sunAvailYN = "">
		<cfset sunHHfrom  = "">
		<cfset sunMMfrom  = "">
		<cfset sunTTfrom  = "">
		<cfset sunHHto    = "">
		<cfset sunMMto    = "">
		<cfset sunTTto    = "">

		<CFLOOP collection="#FORM#" item="iFm">
			<CFIF listFirst(iFm,"_") EQ iWKno>
				<!--- Sat --->
				<CFIF listGetAt(iFm,2,"_") EQ "SAT">
					<CFIF listGetAt(iFm,3,"_") EQ "FROM"> 	
						<CFIF listGetAt(iFm,4,"_") EQ "HH">
							<CFSET satHHfrom = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "MM">
							<CFSET satMMfrom = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "TT">
							<CFSET satTTfrom = FORM[iFm]>
						</CFIF>
					</CFIF>
					<CFIF listGetAt(iFm,3,"_") EQ "TO"> 				
						<CFIF listGetAt(iFm,4,"_") EQ "HH">
							<CFSET satHHto = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "MM">
							<CFSET satMMto = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "TT">
							<CFSET satTTto = FORM[iFm]>
						</CFIF>
					</CFIF>
					<CFIF listGetAt(iFm,3,"_") EQ "AVAIL"> 				
						<CFSET satAvailYN = FORM[iFm]>
					</CFIF>
				</CFIF>			
				<!--- SUN --->
				<CFIF listGetAt(iFm,2,"_") EQ "SUN">
					<CFIF listGetAt(iFm,3,"_") EQ "FROM"> 		
						<CFIF listGetAt(iFm,4,"_") EQ "HH">
							<CFSET sunHHfrom = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "MM">
							<CFSET sunMMfrom = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "TT">
							<CFSET sunTTfrom = FORM[iFm]>
						</CFIF>
					</CFIF>
					<CFIF listGetAt(iFm,3,"_") EQ "TO"> 		
						<CFIF listGetAt(iFm,4,"_") EQ "HH">
							<CFSET sunHHto = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "MM">
							<CFSET sunMMto = FORM[iFm]>
						</CFIF>
						<CFIF listGetAt(iFm,4,"_") EQ "TT">
							<CFSET sunTTto = FORM[iFm]>
						</CFIF>
					</CFIF>
					<CFIF listGetAt(iFm,3,"_") EQ "AVAIL"> 				
						<CFSET sunAvailYN = FORM[iFm]>
					</CFIF>
				</CFIF>			
			</CFIF>
		</CFLOOP>

		
		<CFSET sunTimeFrom = "">
		<CFSET sunTimeTo   = "">
		<CFSET satTimeFrom = "">
		<CFSET satTimeTo   = "">
		<!--- assemble "time" entered --->
		<CFIF sunAvailYN EQ "Y" AND sunHHfrom NEQ "hr" AND sunMMfrom NEQ "mm" >
			<CFSET sunTimeFrom = sunHHfrom & ":" & sunMMfrom & " " & sunTTfrom>
		</CFIF>
		<CFIF sunAvailYN EQ "Y" AND sunHHto NEQ "hr" AND sunMMto NEQ "mm" >
			<CFSET sunTimeTo   = sunHHto   & ":" & sunMMto   & " " & sunTTto>
		</CFIF>
		<CFIF satAvailYN EQ "Y" AND satHHfrom NEQ "hr" AND satMMfrom NEQ "mm" >
			<CFSET satTimeFrom = satHHfrom & ":" & satMMfrom & " " & satTTfrom>
		</CFIF>
		<CFIF satAvailYN EQ "Y" AND satHHto NEQ "hr" AND satMMto NEQ "mm" >
			<CFSET satTimeTo   = satHHto   & ":" & satMMto   & " " & satTTto>
		</CFIF>

		<!--- <br> [#sunAvailYN#][#sunTimeFrom#][#sunTimeTo#] - [#satAvailYN#][#satTimeFrom#][#satTimeTo#]  --->
		 
		<CFIF iWKno EQ FORM.makeLikeWeek1>
			<!--- save week 1 values --->
			<cfset WK1_SUN_TIME_FROM = sunTimeFrom > 
			<cfset WK1_SUN_TIME_TO   = sunTimeTo > 
			<cfset WK1_SUN_AVAIL_YN  = sunAvailYN > 
			<cfset WK1_SAT_TIME_FROM = satTimeFrom > 
			<cfset WK1_SAT_TIME_TO   = satTimeTo > 
			<cfset WK1_SAT_AVAIL_YN  = satAvailYN > 
			<cfset swWK1forALL = true >
		</CFIF>			
		
		<CFIF swWK1forALL>
			<cfset sunTimeFrom = WK1_SUN_TIME_FROM > 
			<cfset sunTimeTo   = WK1_SUN_TIME_TO   > 
			<cfset sunAvailYN  = WK1_SUN_AVAIL_YN  > 
			<cfset satTimeFrom = WK1_SAT_TIME_FROM > 
			<cfset satTimeTo   = WK1_SAT_TIME_TO   > 
			<cfset satAvailYN  = WK1_SAT_AVAIL_YN  > 
		</CFIF>
		
				
		<!--- insert or update???? --->
		<cfquery name="qFindRow" datasource="#SESSION.DSN#">
			SELECT  PLAYWEEKEND_ID
			  FROM  XREF_FIELD_WEEKEND
			 WHERE  FIELD_ID       = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#FORM.fieldID#">
			   AND  PLAYWEEKEND_ID = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#iWKno#">
			   AND  SEASON_ID      = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#FORM.seasonID#">
		</cfquery>
		
		<CFIF qFindRow.RECORDCOUNT>
			<!--- row found so update it --->
			<cfquery name="qUpdateFieldAvail" datasource="#SESSION.DSN#">
				UPDATE XREF_FIELD_WEEKEND
				   SET SUN_TIME_FROM = <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#sunTimeFrom#" null="#YesNoFormat(NOT(len(sunTimeFrom)))#"> 
					 , SUN_TIME_TO   = <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#sunTimeTo#"   null="#YesNoFormat(NOT(len(sunTimeTo)))#"> 
					 , SUN_AVAIL_YN  = <cfqueryParam cfsqltype="CF_SQL_VARCHAR"   value="#sunAvailYN#"  null="#YesNoFormat(NOT(len(sunAvailYN)))#"> 
				<CFIF UCASE(seasonSF) NEQ "SPRING">
					 , SAT_TIME_FROM = <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#satTimeFrom#" null="#YesNoFormat(NOT(len(satTimeFrom)))#"> 
					 , SAT_TIME_TO   = <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#satTimeTo#"   null="#YesNoFormat(NOT(len(satTimeTo)))#"> 
					 , SAT_AVAIL_YN  = <cfqueryParam cfsqltype="CF_SQL_VARCHAR"   value="#satAvailYN#"  null="#YesNoFormat(NOT(len(satAvailYN)))#"> 
				</CFIF>
				WHERE  FIELD_ID      = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#FORM.fieldID#">
				  AND  PLAYWEEKEND_ID = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#iWKno#">
				  AND  SEASON_ID     = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#FORM.seasonID#">
			</cfquery>
		<CFELSE>
			<!--- not found, insert NEW row --->
			<cfquery name="qUpdateFieldAvail" datasource="#SESSION.DSN#">
				INSERT INTO XREF_FIELD_WEEKEND
					 ( FIELD_ID   
					 , PLAYWEEKEND_ID   
				     , SEASON_ID     
				 	 , SUN_TIME_FROM 
					 , SUN_TIME_TO   
					 , SUN_AVAIL_YN  
						<CFIF UCASE(seasonSF) NEQ "SPRING">
							 , SAT_TIME_FROM 
							 , SAT_TIME_TO   
							 , SAT_AVAIL_YN  
					  	</CFIF>
					 )
				VALUES
					( <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#FORM.fieldID#">
					, <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#iWKno#">
					, <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#FORM.seasonID#">
					, <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#sunTimeFrom#" null="#YesNoFormat(NOT(len(sunTimeFrom)))#"> 
					, <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#sunTimeTo#"   null="#YesNoFormat(NOT(len(sunTimeTo)))#"> 
					, <cfqueryParam cfsqltype="CF_SQL_VARCHAR"   value="#sunAvailYN#"  null="#YesNoFormat(NOT(len(sunAvailYN)))#"> 
						<CFIF UCASE(seasonSF) NEQ "SPRING">
							, <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#satTimeFrom#" null="#YesNoFormat(NOT(len(satTimeFrom)))#"> 
							, <cfqueryParam cfsqltype="CF_SQL_TIMESTAMP" value="#satTimeTo#"   null="#YesNoFormat(NOT(len(satTimeTo)))#"> 
							, <cfqueryParam cfsqltype="CF_SQL_VARCHAR"   value="#satAvailYN#"  null="#YesNoFormat(NOT(len(satAvailYN)))#"> 
						</CFIF>
					)
			</cfquery>
		</CFIF>	
	</cfloop>
	<CFSET theMsg = "The changes were made, please review for accuracy.">

</cfif>
 
<!--- Get field details ---> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#field" method="getDirections" returnvariable="getField">
	<cfinvokeargument name="fieldID" value="#variables.fieldID#">
</cfinvoke>  

<!--- get field availability ---> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#field" method="getFieldAvailability" returnvariable="qFieldAvail">
	<cfinvokeargument name="fieldID"  value="#variables.fieldID#">
	<cfinvokeargument name="seasonID" value="#variables.seasonID#">
</cfinvoke>
<cfset listOFweekendIDs = valueList(qFieldAvail.PLAYWEEKEND_ID)>

<!--- get date/time values for dropDowns --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="ddhhmmtt">
	<cfinvokeargument name="listType" value="DDHHMMTT"> 
</cfinvoke>




<CFIF clubID GT 1> <!--- a club user is logged in --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubinfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	</cfinvoke>
	<h2> for #qClubinfo.club_name# </h2>
	<!--- get Approved fields --->
	<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getFields" returnvariable="qFieldsApproved"> --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getClubPrimaryFields" returnvariable="qFieldsApproved">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
<CFELSE>	<!--- club = 1 --->
	<!--- get Approved fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAllFields" returnvariable="qFieldsApproved">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
</CFIF>

<form action="fieldAvailEdit.cfm" method="post">
<input type="Hidden" name="clubID"			 value="#VARIABLES.clubID#">
<input type="Hidden" name="seasonID"		 value="#VARIABLES.seasonID#">
<input type="Hidden" name="seasonTxT"		 value="#VARIABLES.seasonTxT#">
<input type="Hidden" name="seasonSF"		 value="#VARIABLES.seasonSF#">
<input type="Hidden" name="listOFweekendIDs" value="#VARIABLES.listOFweekendIDs#">

Select a field:
<select name="fieldID" >
	<option value="0">Select a field</option> 
	<cfloop query="qFieldsApproved">
		<option value="#FIELD_ID#" <cfif variables.fieldID EQ FIELD_ID>selected</cfif> > #fieldAbbr# </option>
	</cfloop>
</select>
<input type="Submit" name="submit" value="get field">

<br> <cfif len(trim(theMsg))><span class="red"> <b>#theMsg#</b> </span> </cfif>

<br> <hr size="1">

<CFIF getField.recordCount>
	<table border="0" width="98%" cellpadding="2" cellspacing="0">
		<tr><td width="10%"> <b>ID - Abbr</b>:</td>
			<td width="40%"> #getField.FIELD_ID# - #getField.FIELDABBR#</td>
			<td width="10%"> <b>Name</b>:</td>
			<td width="40%"> #getField.FIELDNAME#</td>
		</tr>
		<tr><td><b>Lights</b>: #getField.LIGHTS_YN#</td>
			<td><b>TurfType:</b> #getField.TURF_TYPE# </td>
			<td><b>Address</b>:</td>
			<td>#getField.ADDRESS# #getField.CITY# #getField.STATE# #getField.ZIPCODE#</td>
		</tr>
		<tr><td><b>Size/comments</b>:</td>
			<td colspan="3">Size:#trim(getField.FIELDSIZE)#  Comments: #trim(getField.FIELDSIZECOMMENT)# </td>
		</tr>
		<tr><td><b>Sat Comments</b>:</td>
			<td colspan="3">#trim(getField.day1comment)# </td>
		</tr>
		<tr><td><b>Sun Comments</b>:</td>
			<td colspan="3">#trim(getField.day2comment)# </td>
		</tr>
		<tr><td><b>Exceptions</b>:</td>
			<td colspan="3">#trim(getField.exceptions)# </td>
		</tr>
	</table>

	<hr size="1">
	 
	<table cellspacing="0" cellpadding="1" align="center" border="0" width="100%">
		<tr><td colspan="7" align="center">
				<b>Edit Field Availability for Season: #seasonTxT#</b>
				<CFIF VARIABLES.seasonID EQ SESSION.CURRENTSEASON.ID 
				  AND isDefined("SESSION.REGSEASON") 
				  AND SESSION.GLOBALVARS.REGOPEN EQ "OPEN">
					<span class="red">
						<br><b>NOTE:</b> To edit field availability for the <b>#SESSION.REGSEASON.SF# #SESSION.REGSEASON.YEAR#</b> season, go to "Register Field Availability" under "PRE-SEASON ACTIVITIES"
					</span>  
				</CFIF>
			</td>
		</tr>
		<tr class="tblHeading">
			<td>&nbsp;</td>
			<td>SAT Avail?</td>
			<td>From</td>
			<td>To</td>
			<td>SUN Avail?</td>
			<td>From</td>
			<td>To</td>
		</tr>
		<CFSET likeWeekNumber = 0>
		<cfloop query="qFieldAvail">
			<!--- break apart times found --->
			<CFIF len(trim(Sat_Time_From))>
				<cfset  satFromHH	 = timeFormat(Sat_Time_From,"hh")>
				<cfset  satFromMM	 = timeFormat(Sat_Time_From,"mm")>
				<cfset  satFromTT	 = timeFormat(Sat_Time_From,"tt")>
			<cfelse>
				<cfset  satFromHH	 = "hr">
				<cfset  satFromMM	 = "mm">
				<cfset  satFromTT	 = "AM">
			</CFIF>		<!--- <br>a[#satFromHH#:#satFromMM# #satFromTT#] --->
			<CFIF len(trim(Sat_Time_To))>
				<cfset  satToHH		 = timeFormat(Sat_Time_To,"hh")>
				<cfset  satToMM		 = timeFormat(Sat_Time_To,"mm")>
				<cfset  satToTT		 = timeFormat(Sat_Time_To,"tt")>
			<cfelse>
				<cfset  satToHH		 = "hr">
				<cfset  satToMM		 = "mm">
				<cfset  satToTT		 = "AM">
			</CFIF>		<!--- <br>b[#satToHH#:#satToMM# #satToTT#] --->
			<CFIF len(trim(Sun_Time_from))>
				<cfset  sunFromHH	 = timeFormat(Sun_Time_from,"hh")>
				<cfset  sunFromMM	 = timeFormat(Sun_Time_from,"mm")>
				<cfset  sunFromTT	 = timeFormat(Sun_Time_from,"tt")>
			<cfelse>
				<cfset  sunFromHH	 = "hr">
				<cfset  sunFromMM	 = "mm">
				<cfset  sunFromTT	 = "AM">
			</CFIF>		<!--- <br>c[#sunFromHH#:#sunFromMM# #sunFromTT#] --->
			<CFIF len(trim(Sun_Time_To))>
				<cfset  sunToHH		 = timeFormat(Sun_Time_To,"hh")>
				<cfset  sunToMM		 = timeFormat(Sun_Time_To,"mm")>
				<cfset  sunToTT		 = timeFormat(Sun_Time_To,"tt")>
			<cfelse>
				<cfset  sunToHH		 = "hr">
				<cfset  sunToMM		 = "mm">
				<cfset  sunToTT		 = "AM">
			</CFIF>		<!--- <br>d[#sunToHH#:#sunToMM# #sunToTT#] --->
	
			<CFIF UCASE(seasonSF) EQ "SPRING">
				<CFSET springDisabled = "disabled">
			<CFELSE>
				<CFSET springDisabled = "">
			</CFIF>
	
			<CFIF WEEK_NUMBER EQ 1>
				<!--- used for, "make all like week 1" --->
				<CFSET likeWeekNumber = PLAYWEEKEND_ID>
			</CFIF>
	
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,WEEK_NUMBER)#">
				<td class="tdUnderLine" >#WEEK_NUMBER#</td>
				<td class="tdUnderLine" nowrap >
					#dateFormat(Day1_Date, "mm/dd/yy")# 
					&nbsp; 				 
					<SELECT name="#PLAYWEEKEND_ID#_SAT_AVAIL" size="1" #springDisabled# > 
						<OPTION value="N" <CFIF SAT_AVAIL_YN EQ "N">selected</CFIF> >no</OPTION> 
						<OPTION value="Y" <CFIF SAT_AVAIL_YN EQ "Y">selected</CFIF> >yes</OPTION> 
					</SELECT>
				</td>	
				<td class="tdUnderLine" nowrap >
					<SELECT name="#PLAYWEEKEND_ID#_SAT_FROM_HH" size="1" #springDisabled# >
						<OPTION value="hr" selected>hr</OPTION> 
						<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">
							<OPTION value="#iH#" <CFIF satFromHH EQ iH>selected</CFIF> >#iH#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SAT_FROM_MM" size="1" #springDisabled# >
						<OPTION value="mm" selected>mm</OPTION> 
						<CFLOOP list="#ddhhmmtt.MIN#"  index="iM">
							<OPTION value="#iM#" <CFIF satFromMM EQ iM>selected</CFIF> >#iM#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SAT_FROM_TT" size="1" #springDisabled# >
						<OPTION value="AM" <CFIF satFromTT EQ "AM">selected</CFIF> >am</OPTION>
						<OPTION value="PM" <CFIF satFromTT EQ "PM">selected</CFIF> >pm</OPTION> 
					</SELECT>
				</td>	
				<td class="tdUnderLine" nowrap >
					<SELECT name="#PLAYWEEKEND_ID#_SAT_TO_HH"   size="1" #springDisabled# >
						<OPTION value="hr" selected>hr</OPTION> 
						<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">
							<OPTION value="#iH#" <CFIF satToHH EQ iH>  selected</CFIF> >#iH#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SAT_TO_MM"   size="1" #springDisabled# >
						<OPTION value="mm" selected>mm</OPTION> 
						<CFLOOP list="#ddhhmmtt.MIN#"  index="iM">
							<OPTION value="#iM#" <CFIF satToMM EQ iM>  selected</CFIF> >#iM#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SAT_TO_TT"   size="1" #springDisabled# >
						<OPTION value="AM" <CFIF satToTT EQ "AM"  >selected</CFIF> >am</OPTION>
						<OPTION value="PM" <CFIF satToTT EQ "PM">selected</CFIF> >pm</OPTION> 
					</SELECT>
				</td>	
				<td class="tdUnderLine" nowrap >
					#dateFormat(Day2_Date, "mm/dd/yy")#
					&nbsp; 
					<SELECT name="#PLAYWEEKEND_ID#_SUN_AVAIL" size="1" >
						<OPTION value="N" <CFIF SUN_AVAIL_YN EQ "N">selected</CFIF> >no</OPTION> 
						<OPTION value="Y" <CFIF SUN_AVAIL_YN EQ "Y">selected</CFIF> >yes</OPTION> 
					</SELECT>
				</td>	
				<td class="tdUnderLine" nowrap >
					<SELECT name="#PLAYWEEKEND_ID#_SUN_FROM_HH" size="1">
						<OPTION value="hr" selected>hr</OPTION> 
						<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">
							<OPTION value="#iH#" <CFIF sunFromHH EQ iH>selected</CFIF> >#iH#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SUN_FROM_MM" size="1">
						<OPTION value="mm" selected>mm</OPTION> 
						<CFLOOP list="#ddhhmmtt.MIN#"  index="iM">
							<OPTION value="#iM#" <CFIF sunFromMM EQ iM>selected</CFIF> >#iM#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SUN_FROM_TT" size="1">
						<OPTION value="AM" <CFIF sunFromTT EQ "AM">selected</CFIF> >am</OPTION>
						<OPTION value="PM" <CFIF sunFromTT EQ "PM">selected</CFIF> >pm</OPTION> 
					</SELECT>
				</td>	
				<td class="tdUnderLine" nowrap >
					<SELECT name="#PLAYWEEKEND_ID#_SUN_TO_HH"   size="1">
						<OPTION value="hr" selected>hr</OPTION> 
						<CFLOOP list="#ddhhmmtt.HOUR#" index="iH">
							<OPTION value="#iH#" <CFIF sunToHH EQ iH>  selected</CFIF> >#iH#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SUN_TO_MM"   size="1">
						<OPTION value="mm" selected>mm</OPTION> 
						<CFLOOP list="#ddhhmmtt.MIN#"  index="iM">
							<OPTION value="#iM#" <CFIF sunToMM EQ iM>  selected</CFIF> >#iM#</OPTION>
						</CFLOOP>
					</SELECT>
					<SELECT name="#PLAYWEEKEND_ID#_SUN_TO_TT"   size="1">
						<OPTION value="AM" <CFIF sunToTT EQ "AM"  >selected</CFIF> >am</OPTION>
						<OPTION value="PM" <CFIF sunToTT EQ "PM">selected</CFIF> >pm</OPTION> 
					</SELECT>
				</td>	
			</tr>
		</cfloop>
		<tr><td colspan="7" align="center">
				Make all play weeks (2-10) the same as week 1?
				 <SELECT name="makeLikeWeek1" size="1">
					<OPTION value="0"  >No</OPTION>
					<OPTION value="#likeWeekNumber#" >Yes</OPTION> 
				 </SELECT>
				#repeatString("&nbsp;",5)#
				<input type="Submit" name="save" value="save"> 
				<cfif len(trim(theMsg))>
					<span class="red"> <br> <b>#theMsg#</b> </span> 
				</cfif>

				<CFIF VARIABLES.seasonID EQ SESSION.CURRENTSEASON.ID 
				  AND isDefined("SESSION.REGSEASON") 
				  AND SESSION.GLOBALVARS.REGOPEN EQ "OPEN">
					<span class="red">
						<br><b>NOTE:</b> To edit field availability for the <b>#SESSION.REGSEASON.SF# #SESSION.REGSEASON.YEAR#</b> season, go to "Register Field Availability" under "PRE-SEASON ACTIVITIES"
					</span>  
				</CFIF>

			</td>
		</tr>
	</table>

</CFIF>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
