<!--- 
	FileName:	rptFieldAvail.cfm
	Created on: 02/06/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: 
	
MODS: mm/dd/yyyy - filastname - comments
02/26/09 - aarnone - club was missing from select query if a club was selected.
05/19/09 - aarnone - #7311 added printr friendly


	NOTE! - changes to this page may also have to be included into rptFieldAvailPDF.cfm
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Field Availability Report </H1>
<!--- <h2>For: season #seasonTxT# </h2> --->


<CFIF isDefined("FORM.clubSelected")>
	<CFSET clubSelected = FORM.clubSelected >
<CFELSE>
	<CFSET clubSelected = 0 >
</CFIF>

<cfif isDefined("FORM.fieldid") AND isNumeric(FORM.fieldid)>
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

<cfif isDefined("FORM.size")>
	<cfset size = FORM.size>
<CFELSE>
	<cfset size = "">
</cfif>
<cfif isDefined("FORM.turf")>
	<cfset turf = FORM.turf>
<CFELSE>
	<cfset turf = "">
</cfif>
<cfif isDefined("FORM.lights")>
	<cfset lights = FORM.lights>
<CFELSE>
	<cfset lights = "">
</cfif>

 

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

<!--- CLUBS --->
<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
	SELECT club_id, Club_name 
      FROM  tbl_club 
	 ORDER BY CLUB_NAME
</CFQUERY>


<form action="rptFieldAvail.cfm" method="post">
<table width="100%">
	<tr><td>
			<b>Club:</b> 				
			<Select name="Clubselected">
				<option value="0">All Clubs</option>
				<CFLOOP query="qClubs">
					<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.clubSelected>selected</CFIF> >#CLUB_NAME#</option>
					<CFIF CLUB_ID EQ VARIABLES.clubSelected><cfset clubname = CLUB_NAME></CFIF>
				</CFLOOP>
			</SELECT>
		
			<b>Field:</b>
			<select name="fieldID" >
				<option value="0">All Fields</option> 
				<cfloop query="qFieldsApproved">
					<option value="#FIELD_ID#" <cfif fieldID EQ FIELD_ID>selected</cfif> > #fieldname# </option><!--- fieldAbbr --->
				</cfloop>
			</select>
		</td>
	</tr>
	<tr><td>
			<b>and/or Weekend:</b>
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
			
			<b>Size:</b>
			<select name="size" >
				<option value="">Any Size</option> 
				<option value="S" <cfif size EQ "S">selected</cfif> > Small </option>
				<option value="L" <cfif size EQ "L">selected</cfif> > Large </option>
				<option value="B" <cfif size EQ "B">selected</cfif> > Both </option>
			</select>
			
			<b>Turf:</b>
			<select name="turf" >
				<option value="">Any Turf</option> 
				<option value="Artificial" <cfif turf EQ "Artificial">selected</cfif> > Artificial </option>
				<option value="Grass"	   <cfif turf EQ "Grass">selected</cfif> 	  > Grass </option>
			</select>
		
			<b>Lights:</b>
			<select name="lights" >
				<option value="">Any Lights</option> 
				<option value="Y" <cfif lights EQ "Y">selected</cfif> > Yes </option>
				<option value="N" <cfif lights EQ "N">selected</cfif> > No  </option>
			</select>
			
			<input type="Submit" name="GetAvailability" value="get field">
		</td>
	</tr>
	<CFIF isDefined("FORM.GetAvailability") OR isDefined("FORM.PRINTME")>
		<tr><td align="right">
				<input type="Submit" name="printme" value="Printer Friendly" >  
			</td>
		</tr>
	</CFIF>
	<tr><td>
			<hr size="1">
		</td>
	</tr>
</table>
</form>

 


<CFIF isDefined("FORM.GetAvailability") OR isDefined("FORM.PRINTME")>
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

	<cfif len(trim(size)) > 
		<cfset whereSize = " AND F.FIELDSIZE = '" & VARIABLES.size & "'">
	<CFELSE>
		<cfset whereSize = "">
	</cfif>
	<cfif len(trim(turf)) >
		<cfset whereTurf = " AND F.TURF_TYPE = '" & VARIABLES.turf & "'">
	<CFELSE>
		<cfset whereTurf = "">
	</cfif>
	<cfif len(trim(lights)) >
		<cfset whereLights = " AND F.LIGHTS_YN = '" & VARIABLES.lights & "'">
	<CFELSE>
		<cfset whereLights = "">
	</cfif>
	
	<cfquery name="getFieldplayweeks" datasource="#SESSION.DSN#">
		SELECT X.PLAYWEEKEND_ID, 
			   X.SAT_AVAIL_YN,  X.SAT_TIME_FROM,  X.SAT_TIME_TO,
			   X.SUN_AVAIL_YN,  X.SUN_TIME_FROM,  X.SUN_TIME_TO,
			   pw.WEEK_NUMBER,  pw.Day1_Date, 	  pw.Day2_Date,
			   F.FIELD_ID,		F.FIELDABBR,	  F.FIELDNAME, 
			   F.CITY,			F.FIELDSIZE, 	  F.LIGHTS_YN, F.TURF_TYPE
		  FROM XREF_FIELD_WEEKEND X 
		  			inner join tbl_playweekend pw ON pw.playweekend_ID = X.playweekend_id
		  			inner join tbl_FIELD f		  ON f.FIELD_ID = X.field_id
					<CFIF clubSelected GT 0>
						left JOIN XREF_CLUB_FIELD CF ON CF.FIELD_ID = F.field_id
					</CFIF>
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
				<CFIF len(Trim(whereSize))>
					#preserveSingleQuotes(whereSize)#
				</CFIF>
				<CFIF len(Trim(whereTurf))>
					#preserveSingleQuotes(whereTurf)#
				</CFIF>
				<CFIF len(Trim(whereLights))>
					#preserveSingleQuotes(whereLights)#
				</CFIF>
				<CFIF clubSelected GT 0>
					AND CF.CLUB_ID = #VARIABLES.clubSelected#
				</CFIF>
		ORDER BY F.FIELDABBR, pw.WEEK_NUMBER
	</cfquery>

	<cfquery name="qDistinctFieldIDs" dbtype="query">
		SELECT DISTINCT FIELD_ID FROM getFieldplayweeks
	</cfquery>
	<span class="red">Number of fields displayed: #qDistinctFieldIDs.recordCount#</span>

	<CFIF getFieldplayweeks.recordCount>
		<cfset holdFieldID = 0>


		<table border="0" width="100%" cellpadding="2" cellspacing="0">
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
		<cfloop query="getFieldplayweeks">
			<table border="0" width="99%" cellpadding="2" cellspacing="0">
					<!--- <cfif holdFieldID NEQ FIELD_ID>
						<cfset holdFieldID = FIELD_ID> --->
				<cfif holdFieldID NEQ FIELDABBR>
					<cfset holdFieldID = FIELDABBR>
					<cfset swPrintWeeks = true>
					<tr bgcolor="##CCE4F1">
						<td colspan="8">
							#FIELD_ID# - <b>#FIELDABBR#</b> - #CITY#
							<br> <b>#FIELDNAME#</b>
						</td>
						<td colspan="1">
								Lights: #LIGHTS_YN#
							<br>Turf: #TURF_TYPE#
						</td>
						<td colspan="1">
							Size: #FIELDSIZE#
						</td>
					</tr>
					<cfset swAllSame = false>
					<cfif WEEK_NUMBER EQ 1><!--- check 1st week only so we don't repeat this for every row --->
						<cfquery name="qAllSame" dbtype="query">
							SELECT DISTINCT SAT_AVAIL_YN,  SAT_TIME_FROM,  SAT_TIME_TO, SUN_AVAIL_YN,  SUN_TIME_FROM,  SUN_TIME_TO
							  FROM getFieldplayweeks
							 WHERE FIELD_ID = #FIELD_ID#
						</cfquery>
						<cfif qAllSame.RECORDCOUNT EQ 1>
							<cfset swAllSame = true>
						</cfif>
					</cfif>
				</cfif> 
				
				<CFIF swPrintWeeks>
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
				</CFIF>
				
				<CFIF swAllSame AND WEEK_NUMBER EQ 1>
					<cfset swPrintWeeks = false>
					<!--- if all the weeks are the same, then supress wks2-10 and put out message --->
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,WEEK_NUMBER)#">
						<td colspan="6" class="tdUnderLine"> &nbsp; 2 - 10 <span class="red">same as Week 1</span>	</td>
						<td colspan="4" class="tdUnderLine"> &nbsp;<span class="red"> Weeks 2-10 same as Week 1	</span></td>
					</tr>
					</table>
				</CFIF>

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
<cfoutput>


<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
	<!--- This will pop up a window that will display the page in a pdf --->
	<script> window.open('rptfieldAvailPDF.cfm?cid=#VARIABLES.clubSelected#&fid=#VARIABLES.fieldid#&wid=#VARIABLES.selectWEval#&sz=#VARIABLES.size#&tf=#VARIABLES.turf#&lit=#VARIABLES.lights#','popwin'); </script> 
</CFIF>

</cfoutput>