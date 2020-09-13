<!--- 
	FileName:	GameDayDocuments.cfm
	Created on: 9/1/2020
	Created by: J Lechuga
	
	Purpose: Combine all Game Day docs
	


 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfset hasVisitorMdf = 0 >
<cfset hasHomeMdf = 0 >
<cfset hasVisitorRoster = 0 >
<cfset hasHomeRoster = 0 >
<cfset bin = true>
<!--- <cftry> --->
	<cfif isdefined("url.game_id")>
		<cfset game_id = url.game_id>
	</cfif>

	<cfquery name="getRostersAndMDFS" datasource="#application.dsn#">
		Select dbo.f_getTeamRoster(home_team_id) as home_team_roster_id, dbo.f_getTeamRoster(visitor_team_id) as visitor_team_roster_id,
		   dbo.f_get_MDF(home_team_id, game_id) as home_team_mdf, dbo.f_get_MDF(visitor_team_id, game_id) as visitor_team_mdf
	  from V_Games with (nolock)
	  where game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#game_id#">
	</cfquery>

	<cfif getRostersAndMDFS.recordcount>
		<cfset variables.visitor_team_mdf = getRostersAndMDFS.visitor_team_mdf>
		<cfset variables.visitor_team_roster_id = getRostersAndMDFS.visitor_team_roster_id>
		<cfset variables.home_team_mdf = getRostersAndMDFS.home_team_mdf>
		<cfset variables.home_team_roster_id = getRostersAndMDFS.home_team_roster_id>
	</cfif>
	<cfif  isdefined("variables.visitor_team_mdf") and isnumeric(variables.visitor_team_mdf)>
		<cfset visitor_match_day_form_id=#variables.visitor_team_mdf#>
		<cfinclude template="./matchDayFormView.cfm">
		<cfset pdf_error = "VISITOR MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:MM TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfif isdefined("visitor_mdf")>
			<cfset visitor_team_mdf_bin = visitor_mdf>
			<cffile action="write" output="#visitor_team_mdf_bin#" file="ram://vmdf.pdf">
			<cfset hasVisitorMDF = 1>
		<cfelse>
			<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
			<cffile action="write" output="#error#" file="ram://vmdf.pdf">
		</cfif>
	<cfelse>
		<cfset pdf_error = "VISITOR MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:MM TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="ram://vmdf.pdf">
	</cfif>
	<cfif  isdefined("variables.visitor_team_roster_id") and len(trim(variables.visitor_team_roster_id))>
		<cfset roster = "">
		<cfset roster_id=#variables.visitor_team_roster_id#>
		<cfinclude template="./rosterView.cfm">
		<cfset visitor_team_roster_bin = roster>
		<cffile action="write" output="#visitor_team_roster_bin#" file="ram://vtr.pdf">
		<cfset hasVisitorRoster = 1 >
	<cfelse>
		<cfset pdf_error = "VISITOR TEAM ROSTER NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:MM TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="ram://vtr.pdf">
	</cfif>
	<cfif  isdefined("variables.home_team_mdf") and isnumeric(variables.home_team_mdf)>
		<cfset home_match_day_form_id=#variables.home_team_mdf#>
		<cfset visitor_match_day_form_id="">
		<cfinclude template="./matchDayFormView.cfm">
		<cfset pdf_error = "HOME MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:MM TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfif isdefined("home_mdf")>
			<cfset home_team_mdf_bin = home_mdf>
			<cffile action="write" output="#home_team_mdf_bin#" file="ram://hmdf.pdf">
			<cfset hasHomeMdf = 1 >
		<cfelse>
			<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
			<cffile action="write" output="#error#" file="ram://hmdf.pdf">
		</cfif>
	<cfelse>
		<cfset pdf_error = "HOME MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:MM TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="ram://hmdf.pdf">
	</cfif>
	<cfif  isdefined("variables.home_team_roster_id") and len(trim(variables.home_team_roster_id))>
		<cfset roster = "">
		<cfset roster_id=#variables.home_team_roster_id#>
		<cfinclude template="./rosterView.cfm">
		<cfset home_team_roster_bin = roster>
		<cffile action="write" output="#home_team_roster_bin#" file="ram://htr.pdf">
		<cfset hasHomeRoster = 1 >
	<cfelse>
		<cfset pdf_error = "HOME TEAM ROSTER NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:MM TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="ram://htr.pdf">
	</cfif>

	<!--- <cfdump var="#home_team_mdf_bin#" abort="true"> --->

	<cfpdf action="merge" name="GameDayDoc" >
	    	<cfpdfparam source="ram://vmdf.pdf">
	    	<cfpdfparam source="ram://vtr.pdf">
	    	<cfpdfparam source="ram://hmdf.pdf">
	    	<cfpdfparam source="ram://htr.pdf">
	</cfpdf>

	<cfstoredproc datasource="#session.dsn#" procedure="P_UPSERT_GAME_DAY_DOC">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@game_id" type="In" value="#game_id#">
		<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" value="#ToBinary(GameDayDoc)#">
	</cfstoredproc>
			
	<cfinclude template="ViewGameDayDocs.cfm">
<!--- 
	<cfcatch>
		<html>
			<head>
				<title>
				</title>
			</head>
			<body>
				<cfset errCt = 1>
				We're sorry but the 
				<cfif hasVisitorMDF>
	    			 Visitor Match Day Form
	    			 <cfset errCt++>
				</cfif>
				<cfif hasVisitorRoster>
	    			<cfif errCt gt 1>,</cfif>Visitor Roster
	    			<cfset errCt++>
				</cfif>
				<cfif hasHomeMDF>
	    			<cfif errCt gt 1>,</cfif>Home Match Day Form
	    			<cfset errCt++>
				</cfif>
				<cfif hasHomeRoster>
	    			<cfif errCt gt 1>,</cfif>Home Roster
	    			<cfset errCt++>
				</cfif>
				are missing
			</body>
		</html>
	</cfcatch>
</cftry>
 --->
 
