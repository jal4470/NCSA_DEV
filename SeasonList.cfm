<cfoutput>
<table border="0" cellpadding="2" cellspacing="0">
	<tr><th style="color:Red;font-weight:bold;" colspan="9">
 			<cfif isDefined("URL.err") AND len(trim(URL.err))>
				#URL.err#
			</cfif>
		</th>
	</tr>
	<tr><th colspan="6" align="center">
			Season List 
		</th>
		<th colspan="3" align="center">
			<span style="padding-left:400"><a href="seasonMaintenance.cfm">Add a Season</a></span>
		</th>
	</tr>
	<tr class="tblHeading">
		<th>&nbsp;</th>
		<th>Season Id</th>
		<th>Season Start</th>
		<th>Season End</th>
		<th>Season Type</th>
		<th>Current Season?</th>
		<th>Registration Opened?</th>
		<th>Temp Registration Opened?</th>
		<th>Upload Games?</th>
	</tr>

	<CFQUERY name="qCurrSeason" datasource="#SESSION.DSN#">
		SELECT season_endDate, season_startDate 
		  FROM tbl_season 
		 WHERE currentSeason_YN = 'Y'
	</CFQUERY>
	
	<CFSET currSeasonStart = qCurrSeason.season_startDate>
	<CFSET currSeasonEnd   = qCurrSeason.season_endDate>

	<CFQUERY name="qGetAllSeasons" datasource="#SESSION.DSN#">
		SELECT season_id, season_startDate, season_endDate, seasonCode,
			   currentSeason_YN, registrationOpen_YN, tempRegOpen_YN, upload_games_yn 
		  FROM tbl_season 
		  order by season_startDate desc
	</CFQUERY>
	
	<CFLOOP query="qGetAllSeasons">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td class="tdUnderLine" >
				<cfif season_endDate GT currSeasonEnd>
					<a href="seasonEdit.cfm?season_id=#season_id#">Edit</a>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td class="tdUnderLine" align="center">#season_id#</td>
			<td class="tdUnderLine" align="center">#DateFormat(season_startDate,"mm/dd/yyyy")#</td>
			<td class="tdUnderLine" align="center">#DateFormat(season_endDate,"mm/dd/yyyy")#</td>
			<td class="tdUnderLine" >
				<cfif currentSeason_YN EQ "Y">
					<span class="red"><b>
				</CFIF>
				#seasonCode#
				<cfif currentSeason_YN EQ "Y">
					<b></span>
				</CFIF>
			</td>
			<td class="tdUnderLine" align="center">
				<cfif currentSeason_YN EQ "Y">
					<span class="red"><b> Yes  &nbsp; Current </b></span> <!--- #currentSeason_YN# --->
					<!--a href="SeasonSetToggle.cfm?tt=season&season_id=< %=objrs("season_id").value%>&open=N" class="smallLink">Close</a-->
				<cfelse>
					#currentSeason_YN#  
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=season&season_id=#season_id#&open=Y" class="smallLink">Open</a> 
			  	</cfif>
			</td>
			<td class="tdUnderLine" align="center">
				<cfif registrationOpen_YN EQ "Y">
					<span class="red"><b> Yes </b></span><!--- #registrationOpen_YN# --->
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=reg&season_id=#season_id#&open=N" class="smallLink">Close</a>
				<cfelse>
					#registrationOpen_YN#
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=reg&season_id=#season_id#&open=Y" class="smallLink">Open</a>
				</cfif>
			</td>
			<td class="tdUnderLine" align="center">
				<cfif tempRegOpen_YN EQ "Y">
					<span class="red"><b> Yes </b></span><!--- #tempRegOpen_YN# --->
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=tempreg&season_id=#season_id#&open=N" class="smallLink">Close</a>
				<cfelse>
					#tempRegOpen_YN#
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=tempreg&season_id=#season_id#&open=Y" class="smallLink">Open</a>
				</cfif>
			</td>
			<td class="tdUnderLine" align="center">
				<cfif upload_games_YN EQ "Y">
					<span class="red"><b> Yes </b></span><!--- #upload_games_YN# --->
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=uploadGames&season_id=#season_id#&open=N" class="smallLink">Close</a>
				<cfelse>
					#upload_games_YN#
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="SeasonSetToggle.cfm?tt=uploadGames&season_id=#season_id#&open=Y" class="smallLink">Open</a>
				</cfif>
			</td>
		</tr>
		
	</CFLOOP>
</table>
</cfoutput>