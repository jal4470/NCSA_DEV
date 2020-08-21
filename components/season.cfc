<!--- 
	FileName:	season.cfc
	Created on: 08/18/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will get all season information for CURRENT and REGISTRATION seasons
	
MODS: mm/dd/yyyy - filastname - comments
01/27/09 - AArnone add function: getNextSeason
 --->


<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="getCurrentSeason" access="public" returntype="query">
	<!--- --------
		08/18/08 - AArnone - New function: returns values for current season
	----- --->
	<cfquery name="qGetCurrSn" datasource="#VARIABLES.DSN#">
		select season_id, season_startDate, season_endDate, season_SF, season_year, seasonCode
		  from tbl_season 
		 where currentSeason_YN = 'Y'	
	</cfquery>

	<cfreturn qGetCurrSn>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getRegSeason" access="public" returntype="query">
	<!--- --------
		08/18/08 - AArnone - New function: returns values for Registration season
	----- --->
	<cfquery name="qGetRegSn" datasource="#VARIABLES.DSN#">
		select season_id, season_startDate, season_endDate, season_SF, season_year, seasonCode
		  from tbl_season
		 where registrationOpen_YN = 'Y'
	</cfquery>

	<cfreturn qGetRegSn>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getNextSeason" access="public" returntype="query">
	<!--- --------
		01/27/09 - AArnone - When Registration is CLOSED, SESSION.REGSEASON is not available, sometimes we need the 
							season info fot the next season
	----- --->
	<CFQUERY name="qNextSeason" datasource="#VARIABLES.DSN#" maxrows="1">
		SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, CURRENTSEASON_YN, REGISTRATIONOPEN_YN 
	 	  FROM TBL_SEASON 
	 	 WHERE SEASON_ID > (SELECT SEASON_ID FROM TBL_SEASON WHERE CURRENTSEASON_YN = 'Y' ) 
		 ORDER BY SEASON_ID 
	</CFQUERY>		

	<cfreturn qNextSeason>
</cffunction>

<cffunction name="getOpenSeasons" access="public" returntype="query" description="Returns list of current and reg seasons">
	
	<CFQUERY name="qOpenSeasons" datasource="#VARIABLES.DSN#">
		SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, CURRENTSEASON_YN, REGISTRATIONOPEN_YN 
	 	  FROM TBL_SEASON 
	 	 WHERE
		 	currentSeason_yn = 'Y'
			OR registrationOpen_yn = 'Y'
			OR tempRegOpen_yn = 'Y'
		 ORDER BY SEASON_ID 
	</CFQUERY>

	<cfreturn qOpenSeasons>
</cffunction>

<cffunction name="getClubOpenSeasons" access="public" returntype="query" description="Returns list of current and reg seasons">
	<cfargument name="club_id" type="string" required="Yes">
	
	<CFQUERY name="qOpenSeasons" datasource="#VARIABLES.DSN#">
		SELECT s.SEASON_ID, s.SEASON_YEAR, s.SEASON_SF, s.CURRENTSEASON_YN, s.REGISTRATIONOPEN_YN 
	 	  FROM TBL_SEASON s
		  inner join xref_club_season x
		  on s.season_id=x.season_id
	 	 WHERE
		 	x.club_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.club_id#">
			and
		 	(currentSeason_yn = 'Y'
			OR registrationOpen_yn = 'Y'
			OR tempRegOpen_yn = 'Y')
		 ORDER BY s.SEASON_ID 
	</CFQUERY>

	<cfreturn qOpenSeasons>
</cffunction>



<!--- =================================================================== --->
<cffunction name="getHistSeasons" access="public" returntype="query">
	<!--- --------
		08/18/08 - AArnone - New function: returns Years for history seasons 
					for 2002 - 2008, old history tables are being used. for all seasons afterwards, get data from new tables
	----- --->
	<cfargument name="currSeason" required="Yes" type="numeric" > 
	<cfquery name="qHistSNS" datasource="#VARIABLES.DSN#">
		SELECT DISTINCT season_year
		  FROM tbl_season
		 WHERE season_year > 2008 
		   AND season_year <= #ARGUMENTS.currSeason#
		   
		   <!---
		   	J. Rab:
			
			For later: 
		SELECT 	season_year,
				season_SF,
				currentSeason_YN
		  FROM tbl_season
		 WHERE season_year > 2008 
		   AND season_year <= #ARGUMENTS.currSeason#
		   
		   --->
	</cfquery>

	<cfreturn qHistSNS>
</cffunction>


<!--- =================================================================== --->
<cffunction name="getSeasonInfo" access="public" returntype="query">
	<!--- --------
		08/19/08 - AArnone - New function: returns the season values based on YYYY and S/F
	----- --->
	<cfargument name="seasonYY" required="Yes" type="numeric" > 
	<cfargument name="seasonSF" required="Yes" type="string"  > 
	<cfquery name="qGetseasonInfo" datasource="#VARIABLES.DSN#">
		select season_id, season_startDate, season_endDate, season_SF, season_year, seasonCode
		  from tbl_season 
		 where season_year =  #ARGUMENTS.seasonYY#
		   and season_SF   = '#ARGUMENTS.seasonSF#'
	</cfquery>

	<cfreturn qGetseasonInfo>
</cffunction>
	
<!--- =================================================================== --->
<cffunction name="getSeasonInfoByID" access="public" returntype="query">
	<!--- --------
		01/09/09 - AArnone - New function: returns the season values based on seasonID
	----- --->
	<cfargument name="seasonID" required="Yes" type="numeric" > 

	<cfquery name="qGetseasonInfoByID" datasource="#VARIABLES.DSN#">
		select season_startDate, season_endDate, season_SF, season_year, seasonCode,season_id
		  from tbl_season 
		 where season_id =  #ARGUMENTS.seasonID#
	</cfquery>

	<cfreturn qGetseasonInfoByID>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getPlayweeks" access="public" returntype="query">
	<!--- --------
		12/29/08 - AArnone - 
	----- --->
	<cfargument name="seasonID" required="Yes" type="numeric" > 

	<cfquery name="qGetPlayWeeks" datasource="#VARIABLES.DSN#">
		SELECT PLAYWEEKEND_ID, WEEK_NUMBER, Day1_Date, Day2_Date
		  FROM TBL_PLAYWEEKEND
		 WHERE SEASON_ID = #ARGUMENTS.seasonID#	
		 order by week_number
	</cfquery>
	<cfreturn qGetPlayWeeks>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getAllSeasons" access="public" returntype="query">
	<!--- --------
		6/15/2009 b. cooper - gets all seasons
	----- --->

	<cfquery name="getSeasons" datasource="#VARIABLES.DSN#">
		SELECT season_id, season_year, seasonCode
		  FROM TBL_season
	</cfquery>
	<cfreturn getSeasons>
</cffunction>

<cffunction name="getAllSeasonsWithArchive" access="public" returntype="query">
	<cfquery datasource="#variables.dsn#" name="getSeasons">
		select cast(season_id as varchar(10)) as season_id, season_sf as season, season_year as year
		from tbl_season
		UNION ALL
		select distinct '' as season_id, season, year
		from tbl_archive_games_history
		order by year asc, season desc
	</cfquery>
	
	<cfreturn getSeasons>
	
</cffunction>

<cffunction name="getArchiveYears" access="public" returntype="query">

	<cfquery datasource="#variables.dsn#" name="getYears">
		select distinct year from v_archive_clubs
	</cfquery>
	
	<cfreturn getYears>

</cffunction>

<cffunction name="getUseSeason" access="public" returntype="numeric">
	<!--- get reg season --->
	<cfset regseason=getRegSeason()>
	<cfif regseason.recordcount GT 0>
		<cfreturn regseason.season_id>
	<cfelse>
		<!--- get current season --->
		<cfset curSeason=getCurrentSeason()>
		<cfif curSeason.recordcount GT 0>
			<cfreturn curSeason.season_id>
		<cfelse>
			<!--- error.  no season to return --->
			<cfreturn 0>
		</cfif>
	</cfif>
	
	<cfreturn 0>
	
</cffunction>


</cfcomponent>