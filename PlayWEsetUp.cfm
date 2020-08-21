<!--- 
	FileName:	PlayWEsetUp.cfm
	Created on: 09/22/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>

<cfoutput>

<CFIF isDefined("FORM.listSeasonID") and FORM.listSeasonID GT 0>
	<CFQUERY name="getSeason" datasource="#SESSION.DSN#">
		SELECT season_id, season_year, season_SF, seasonCode
			 , currentSeason_YN, registrationOpen_YN
		     , season_startDate, season_endDate
		  FROM tbl_season
		 WHERE SEASON_ID = #FORM.listSeasonID#
	</CFQUERY><!--- <cfdump var="#getSeason#" abort="true"> --->
	<CFSET displaySeason = getSeason.season_SF & " " & getSeason.season_year >
	<CFSET SF 			 = getSeason.season_SF>
	<CFSET variables.seasonID 	 = getSeason.season_id>
	<CFSET seasonYear 	 = getSeason.season_year>
<CFELSEIF isDefined("FORM.SeasonID")>
	<CFSET displaySeason = FORM.displaySeason>
	<CFSET SF 			 = FORM.SF>
	<CFSET variables.seasonID 	 = FORM.seasonID>
	<CFSET seasonYear 	 = FORM.seasonYear>
<CFELSEIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF 			 = SESSION.REGSEASON.SF>
	<CFSET variables.seasonID 	 = SESSION.REGSEASON.ID>
	<CFSET seasonYear 	 = SESSION.REGSEASON.YEAR>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF 			 = SESSION.CURRENTSEASON.SF>
	<CFSET variables.seasonID 	 = SESSION.CURRENTSEASON.ID>
	<CFSET seasonYear 	 = SESSION.CURRENTSEASON.YEAR>
</CFIF>

<CFIF isDefined("FORM.SAVE")>

	<!--- set up struct so we can easily loop to do the inserts --->
	<CFSET stWeekEnd = structNew()>
	<cfloop collection="#FORM#" item="iFm">
		<cfif listlen(ifm,"_") GT 1 >
			<CFSET weekX = listLast(ifm,"_")>
			<cfif NOT listFind(StructKeyList(stWeekEnd),weekX)>
				<CFSET stWeekEnd[weekX] = structNew()>
			</cfif>
			<cfif listFirst(ifm,"_") EQ "SAT">
				<CFSET stWeekEnd[weekX].Sat = evaluate(#ifm#)>
			</cfif>
			<cfif listFirst(ifm,"_") EQ "SUN">
				<CFSET stWeekEnd[weekX].SUN = evaluate(#ifm#)>
			</cfif>
		</cfif>
	</cfloop>	<!--- <cfdump var="#stWeekEnd#" abort="true"> --->
	
	<CFLOOP collection="#stWeekEnd#" item="iWE">
		<!--- <br>week[#iWE#]-sat[#stWeekEnd[iWE].sat#]-sun[#stWeekEnd[iWE].sun#] --->
		<cfif isNumeric(iWe)>
			<CFQUERY name="qWeekExist" datasource="#SESSION.DSN#">
				SELECT playWeekEnd_ID
				FROM tbl_PlayWeekEnd
				WHERE season_id   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#variables.seasonID#">
				AND week_number = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#iWE#">
			</CFQUERY>


			<CFIF qWeekExist.RECORDCOUNT>
		
				<!--- record was found so UPDATE row --->
				<CFQUERY name="UpdatePWE" datasource="#SESSION.DSN#">
					Update TBL_PlayWeekend
					set Day1_date   = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#stWeekEnd[iWE].sat#" null="#YesNoFormat(NOT LEN(TRIM(stWeekEnd[iWE].sat)) )#">
						, Day2_date   = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#stWeekEnd[iWE].sun#" null="#YesNoFormat(NOT LEN(TRIM(stWeekEnd[iWE].sun)) )#">
					Where week_number = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#iWE#">
					AND season_id   = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#seasonID#">
				</CFQUERY>
			<CFELSE>
			
				<!--- record was not found so INSERT row --->
				<CFQUERY name="InsertPWE" datasource="#SESSION.DSN#">
					INSERT INTO tbl_PlayWeekEnd 
							( week_number, Day1_date, Day2_date, season_id )
					VALUES	( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#iWE#">
							, <cfqueryparam cfsqltype="CF_SQL_DATE" value="#stWeekEnd[iWE].sat#" null="#YesNoFormat(NOT LEN(TRIM(stWeekEnd[iWE].sat)) )#">
							, <cfqueryparam cfsqltype="CF_SQL_DATE" value="#stWeekEnd[iWE].sun#" null="#YesNoFormat(NOT LEN(TRIM(stWeekEnd[iWE].sun)) )#">
							, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#seasonID#">
							)
				</CFQUERY> 
			</CFIF>
		</cfif>
	</CFLOOP>
</CFIF>

<CFQUERY name="playWeeks" datasource="#SESSION.DSN#">
	select week_number as week,
		   Day1_date as sat,
		   Day2_date as sun
	  from TBL_PlayWeekend
	 where season_id =  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#seasonID#">
	 order by week_number
</CFQUERY><!--- <cfdump var="#playWeeks#"> --->

<CFQUERY name="getSeasons" datasource="#SESSION.DSN#">
	SELECT season_id, season_year, season_SF, seasonCode
		 , currentSeason_YN, registrationOpen_YN
	     , season_startDate, season_endDate
	  FROM tbl_season
	 ORDER BY SEASON_ID DESC
</CFQUERY><!--- <cfdump var="#getSeasons#"> --->

<div id="contentText">
<H1 class="pageheading">NCSA - Game Weekends Setup</H1>
<br>
<h2>for #displaySeason# season</h2>

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<FORM name="PlayWeekends" action="##"  method="post">
<input type="hidden" name="SeasonID"	  value="#VARIABLES.SeasonID#" >
<input type="hidden" name="displaySeason" value="#VARIABLES.displaySeason#">
<input type="hidden" name="SF" 			  value="#VARIABLES.SF#">
<input type="hidden" name="seasonYear" 	  value="#VARIABLES.seasonYear#">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="75%">
	<tr><td colspan="4" align="center">
			<B>Season:</b> &nbsp; 
			<SELECT name="listSeasonID"> 
				<OPTION value="0" selected>Select Season</OPTION>
				<CFLOOP query="getSeasons">
					<OPTION value="#season_id#" <CFIF season_id EQ SeasonID>selected</CFIF> >#season_year#-#season_SF#</OPTION>
				</CFLOOP>
			</SELECT>
			 &nbsp; 
			<input type="SUBMIT" name="changeSeason" value="Show PlayWeeks"> 
		</td>
	</tr>	
	<tr><td colspan="4" align="center" >
			&nbsp;<span class="red">The dates must be entered as mm/dd/yyyy</span>
		</td>
	</tr>
	<tr class="tblHeading">
		<td width="20%" align=right>			<b>Season</b>		</td>
		<td width="20%" align=right>			<b>Week</b>		</td>
		<td width="30%" align=center>			<b>Sat</b>		</td>
		<td width="30%" align=center>			<b>Sun</b>		</td>
	</tr>

	<CFIF playWeeks.RECORDCOUNT>
		<CFLOOP query="playWeeks">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td class="tdUnderLine"  align=right>
					#VARIABLES.displaySeason#
				</td>
				<td class="tdUnderLine"  align=right>
					<input type="hidden" name="Week_#Week#" value="#Week#">
					<b>Week&nbsp;#Week#</b>
				</td>
				<td class="tdUnderLine"  align="center">
					<input maxlength="10" name="Sat_#Week#" size=10 value="#dateFormat(Sat,'mm/dd/yyyy')#">
					<a href="javascript:show_calendar('PlayWeekends.Sat_#Week#');" 
									onmouseover="window.status='Date Picker';return true;" 
									onmouseout="window.status='';return true;"> <!--- <font size=2>mm/dd/yyyy</font> --->
							    <img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
							</a>
				</td>
				<td class="tdUnderLine"  align="center">
					<input maxlength="10" name="Sun_#Week#" size=10 value="#dateFormat(Sun,'mm/dd/yyyy')#">
					<a href="javascript:show_calendar('PlayWeekends.Sun_#Week#');" 
									onmouseover="window.status='Date Picker';return true;" 
									onmouseout="window.status='';return true;"> <!--- <font size=2>mm/dd/yyyy</font> --->
							    <img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
							</a>
				</td>
			</tr>
		</CFLOOP>
	<CFELSE>
		<!--- Weeks DO NOT exist for season, create empty table.... --->
		<CFLOOP from="1" to="10" index="idx">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,idx)#">
				<td class="tdUnderLine"  align=right>
					#VARIABLES.displaySeason#
				</td>
				<td class="tdUnderLine" align=right>
					<input type="hidden" name="Week_#idx#" value="#idx#">
					<b>Week&nbsp;#idx#</b>
				</td>
				<td class="tdUnderLine" align="center">
					<input maxlength="10" name="Sat_#idx#" size=10 value="">
					<a href="javascript:show_calendar('PlayWeekends.Sat_#idx#');" 
									onmouseover="window.status='Date Picker';return true;" 
									onmouseout="window.status='';return true;"> <!--- <font size=2>mm/dd/yyyy</font> --->
							    <img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
							</a>
				</td>
				<td class="tdUnderLine" align="center">
					<input maxlength="10" name="Sun_#idx#" size=10 value="">
					<a href="javascript:show_calendar('PlayWeekends.Sun_#idx#');" 
									onmouseover="window.status='Date Picker';return true;" 
									onmouseout="window.status='';return true;"> <!--- <font size=2>mm/dd/yyyy</font> --->
							    <img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
							</a>
				</td>
			</tr>
		</CFLOOP>
	</CFIF>
	<TR><TD colspan="4" align="center">
			<INPUT type="submit" value="Save" name="Save">
		</TD>
	</TR>
</TABLE>			

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
