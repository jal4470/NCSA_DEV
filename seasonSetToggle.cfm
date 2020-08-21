<!--- 
	FileName:	seasonSetToggle.cfm
	Created on: 09/09/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfinclude template="_checkLogin.cfm"> use?

<cfoutput>

<CFSET open_yn = URL.open>
<CFSET season_id = URL.season_id>

<CFSWITCH expression="#URL.tt#">
	<CFCASE value="season">
		<cfstoredproc procedure="p_set_season" datasource="#SESSION.DSN#" returncode="Yes">
			<cfprocparam type="In"  dbvarname="@season_id" 		  cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.season_id#">
			<cfprocparam type="In"  dbvarname="@currentSeason_YN" cfsqltype="CF_SQL_VARCHAR" value="#open_yn#">
		</cfstoredproc><!--- <cfprocparam type="Out" 				    	cfsqltype="CF_SQL_NUMERIC" variable="Return"> --->
	</CFCASE>
	<CFCASE value="reg">
		<cfstoredproc procedure="p_set_registration_season" datasource="#SESSION.DSN#" returncode="Yes">
			<cfprocparam type="In"  dbvarname="@registration_season_id"	cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.season_id#">
			<cfprocparam type="In"  dbvarname="@open_yn"				cfsqltype="CF_SQL_VARCHAR"   value="#open_yn#">
		</cfstoredproc><!--- <cfprocparam type="Out" dbvarname="Return"		cfsqltype="CF_SQL_NUMERIC"  variable="Return"> --->
	</CFCASE>
	<CFCASE value="tempreg">
		<cfstoredproc procedure="p_set_temp_reg_season" datasource="#SESSION.DSN#" returncode="Yes">
			<cfprocparam type="In"  dbvarname="@registration_season_id"	cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.season_id#">
			<cfprocparam type="In"  dbvarname="@open_yn"				cfsqltype="CF_SQL_VARCHAR"  value="#open_yn#">
		</cfstoredproc><!--- <cfprocparam type="Out" dbvarname="Return"		cfsqltype="CF_SQL_NUMERIC"  variable="Return"> --->
	</CFCASE>
	<CFCASE value="uploadGames">
		<cfstoredproc procedure="p_set_games_upload" datasource="#SESSION.DSN#" returncode="Yes">
			<cfprocparam type="In"  dbvarname="@season_id"	cfsqltype="CF_SQL_NUMERIC"  value="#VARIABLES.season_id#">
		</cfstoredproc><!--- <cfprocparam type="Out" dbvarname="Return"		cfsqltype="CF_SQL_NUMERIC"  variable="Return"> --->
	</CFCASE>
</CFSWITCH>

<CFIF IsDefined("cfstoredProc.statusCode") AND cfstoredProc.statusCode NEQ "">
	<CFSET status = cfstoredProc.statusCode>
<CFELSE>
	<CFSET status = "">
</CFIF>

<cfif status EQ -1>
	<CFSET err = "Games upload cannot be turned on for a season that is being played or that has been played">
<cfelseif status EQ -2 >
	<CFSET err = "The season selected for Games Upload is not the current season, please set the current season and try again">
<cfelse>
	<CFSET err = "">
</cfif>


<cflocation url="seasonMaintenance.cfm?err=#err#">

</cfoutput>
