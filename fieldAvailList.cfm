<!--- 
	FileName:	fieldAvailList.cfm
	Created on: 12/29/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: (ADMIN USE) this will list all the fields and the availability for the playweekends 
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

					<!--- <CFIF isDefined("SESSION.REGSEASON.ID")>
						<CFSET seasonID = SESSION.REGSEASON.ID >
						<CFSET seasonTxT = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
						<CFSET seasonSF = SESSION.REGSEASON.SF>
					<CFELSE>
						<CFSET seasonID = SESSION.CURRENTSEASON.ID >
						<CFSET seasonTxT = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
						<CFSET seasonSF = SESSION.CURRENTSEASON.SF>
					</CFIF> --->


<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Field Availability</H1>
<!--- <h2>For: season #seasonTxT# </h2> --->

<cfif isDefined("URL.fid") AND isNumeric(URL.fid)>
	<cfset fieldid = URL.fid>
<cfelseif isDefined("FORM.fieldid") AND isNumeric(FORM.fieldid)>
	<cfset fieldid = FORM.fieldid>
<CFELSE>
	<cfset fieldid = 0>
</cfif>

<cfif isDefined("URL.weid") AND isNumeric(URL.weid)>
	<cfset weekEndID	 = URL.weid>
	<cfset selectWEval	 = URL.weid> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = 0>
<cfelseif isDefined("FORM.weekEndID") AND isNumeric(FORM.weekEndID)>
	<cfset weekEndID	 = FORM.weekEndID>
	<cfset selectWEval	 = FORM.weekEndID> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = 0>
<cfelseif isDefined("FORM.weekEndID") AND FORM.weekEndID EQ "cur" >
	<cfset weekEndID	 = 0>
	<cfset selectWEval	 = FORM.weekEndID> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = SESSION.CURRENTSEASON.ID>
<cfelseif isDefined("FORM.weekEndID") AND FORM.weekEndID EQ "reg" >
	<cfset weekEndID	 = 0>
	<cfset selectWEval	 = FORM.weekEndID> <!--- preserves value for dropdown --->
	<cfset QuerySeasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<cfset weekEndID	 = 0>
	<cfset selectWEval	 = "">
	<cfset QuerySeasonID = 0>
</cfif>

<!--- <cfif isDefined("URL.sid") AND isNumeric(URL.sid)>
	<cfset seasonID = URL.sid>
<cfelseif isDefined("FORM.seasonID") AND isNumeric(FORM.seasonID)>
	<cfset seasonID = FORM.seasonID>
<CFELSE>
	<cfset seasonID = SESSION.CURRENTSEASON.ID>
</cfif> --->


<!--- get all fields --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAllFields" returnvariable="qFieldsApproved">
	<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
</cfinvoke>  

<!--- get the season's play weeks
<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getPlayweeks" returnvariable="qPlayWEs">
	<cfinvokeargument name="seasonID" value="#seasonID#">
</cfinvoke>
 --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getPlayweeks" returnvariable="qPlayWEcurr">
	<cfinvokeargument name="seasonID" value="#SESSION.CURRENTSEASON.ID#">
</cfinvoke>
 
<cfif IsDefined("SESSION.REGSEASON")>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#SEASON" method="getPlayweeks" returnvariable="qPlayWEreg">
		<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
	</cfinvoke>
</cfif>




<form action="fieldAvailList.cfm" method="post">
	Field:
	<select name="fieldID" >
		<option value="0">All Fields</option> 
		<cfloop query="qFieldsApproved">
			<option value="#FIELD_ID#" <cfif fieldID EQ FIELD_ID>selected</cfif> > #fieldname# </option><!--- fieldAbbr --->
		</cfloop>
	</select>
	and/or Weekend:
	<select name="weekEndID" >
		<option value="cur" <cfif selectWEval EQ "cur">selected</cfif> >All #SESSION.CURRENTSEASON.SF# #SESSION.CURRENTSEASON.YEAR# Weekends</option> 
		<cfloop query="qPlayWEcurr">
			<option value="#playWeekEnd_ID#" <cfif selectWEval EQ playWeekEnd_ID>selected</cfif> > 
				#week_number#. #dateFormat(Day1_date,"ddd mm/dd/yy")# #dateFormat(Day2_date,"ddd mm/dd/yy")# 
			</option>
		</cfloop>
		<CFIF isDefined("qPlayWEreg")>
			<option value="reg" <cfif selectWEval EQ "reg">selected</cfif> >All #SESSION.REGSEASON.SF# #SESSION.REGSEASON.YEAR# Weekends</option> 
			<cfloop query="qPlayWEreg">
				<option value="#playWeekEnd_ID#" <cfif selectWEval EQ playWeekEnd_ID>selected</cfif> > 
					#week_number#. #dateFormat(Day1_date,"ddd mm/dd/yy")# #dateFormat(Day2_date,"ddd mm/dd/yy")# 
				</option>
			</cfloop>
		</CFIF> 
	</select>
	<input type="Submit" name="GetAvailability" value="get field">
	<br>
	<br> <hr size="1">
</form>


<CFIF isDefined("FORM.GetAvailability")>
	<!--- get the avials.... based on selection <br> fieldid[#FORM.FIELDID#] <br> playWE [#FORM.weekEndID#] --->
	<CFIF FIELDID GT 0> 
		<CFSET whereField = "x.FIELD_ID = #FIELDID#">
	<CFELSE>
		<CFSET whereField = "">
	</CFIF>
	<CFIF weekEndID GT 0> 
		<CFSET whereWEID = "x.PLAYWEEKEND_ID = #weekEndID#">
	<CFELSE>
		<CFSET whereWEID = "">
	</CFIF>
	<CFIF weekEndID EQ 0 AND QuerySeasonID GT 0> 
		<CFSET whereSeasonID = "x.SEASON_ID = #QuerySeasonID#">
	<CFELSE>
		<CFSET whereSeasonID = "">
	</CFIF>

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
		<CFIF len(trim(whereField)) OR len(trim(whereWEID)) OR len(trim(whereSeasonID)) >
			WHERE 
		</CFIF>
		<CFIF len(trim(whereField))>
			#whereField#
		</CFIF>
		<CFIF len(trim(whereField)) AND ( len(trim(whereWEID)) OR len(trim(whereSeasonID)) )>
			AND 
		</CFIF>
		<CFIF len(trim(whereWEID))>
			#whereWEID#
		<cfelseif len(trim(whereSeasonID))>
			#whereSeasonID#
		</CFIF>
		ORDER BY F.FIELDABBR, pw.WEEK_NUMBER
	</cfquery>

	<CFIF getplayweeks.recordCount>
		<cfset holdFieldID = 0>
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
		<cfloop query="getplayweeks">
			<table border="0" width="98%" cellpadding="2" cellspacing="0">
				<!--- <cfif holdFieldID NEQ FIELD_ID>
						<cfset holdFieldID = FIELD_ID> --->
				<cfif holdFieldID NEQ FIELDABBR>
					<cfset holdFieldID = FIELDABBR>
					<tr bgcolor="##CCE4F1">
						<td colspan="8">
							#FIELD_ID# - <b>#FIELDABBR#</b> - #CITY#
							<br> <a href="fieldAvailEdit.cfm?fid=#FIELD_ID#&sid=#VARIABLES.QuerySeasonID#">[ Edit ]</a> <b>#FIELDNAME#</b>
						</td>
						<td colspan="2">
								Lights: #LIGHTS_YN#
							<br>Turf: #TURF_TYPE#
						</td>
					</tr>
				</cfif> 
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
			</table>
		</cfloop>	
		</div>
	<CFELSE>
		<table border="0" width="98%" cellpadding="2" cellspacing="0">
			<tr class="tblHeading">	
				<td> &nbsp; </td> 
			</tr>
			<tr><td class="red"> 
					<b>There are no play week availabilty records found for this field.</b> 
				</td> 
			</tr>
		</table>
	</CFIF>	

</CFIF>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
