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

	<cfquery name="getHomeMDF" datasource="#application.dsn#">
		  select dbo.f_get_MDF(g.team_id, g.game_id) as home_team_mdf,g.game_id
		  from tbl_match_day_form mf inner join xref_Game_Team g on mf.game_id = g.game_id 
		  where mf.game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#game_id#"> and isHomeTeam = 1
		  group by g.team_id,g.game_id
	</cfquery>

	<cfif getHomeMDF.recordcount>
		<cfset variables.home_team_mdf = getHomeMDF.home_team_mdf>
	</cfif>

	<cfquery name="getHomeRoster" datasource="#application.dsn#">
		  select dbo.f_getTeamRoster(g.team_id) as home_team_roster_id
		  from xref_Game_Team g 
		  where game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#game_id#"> and isHomeTeam = 1
	</cfquery>
	<cfif getHomeRoster.recordcount>
		<cfset variables.home_team_roster_id = getHomeRoster.home_team_roster_id>
	</cfif>

	<cfquery name="getVisitorMDF" datasource="#application.dsn#">
		  select dbo.f_get_MDF(g.team_id, g.game_id) as visitor_team_mdf,g.game_id
		  from tbl_match_day_form mf inner join xref_Game_Team g on mf.game_id = g.game_id 
		  where mf.game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#game_id#"> and isHomeTeam = 0
		  group by g.team_id,g.game_id
	</cfquery>

	<cfif getVisitorMDF.recordcount>
		<cfset variables.visitor_team_mdf = getVisitorMDF.visitor_team_mdf>
	</cfif>

	<cfquery name="getVisitorRoster" datasource="#application.dsn#">
		    select dbo.f_getTeamRoster(g.team_id) as visitor_team_roster_id
		  from xref_Game_Team g 
		  where game_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#game_id#"> and isHomeTeam = 0
	</cfquery>

	<cfif getVisitorRoster.recordcount>
		<cfset variables.visitor_team_roster_id = getVisitorRoster.visitor_team_roster_id>
	</cfif>


	<cfset tempPath = ExpandPath("uploads\temp\gamedayforms")>

	<cfif  isdefined("variables.visitor_team_mdf") and isnumeric(variables.visitor_team_mdf)>
		<cfset visitor_match_day_form_id=#variables.visitor_team_mdf#>
		<cfinclude template="./matchDayFormView.cfm">
		<cfset pdf_error = "VISITOR MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:NN TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfif isdefined("visitor_mdf")>
			<cfset visitor_team_mdf_bin = visitor_mdf>
			<cffile action="write" output="#visitor_team_mdf_bin#" file="#tempPath#\vmdf#game_id#.pdf">
			<cfset hasVisitorMDF = 1>
		<cfelse>
			<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
			<cffile action="write" output="#error#" file="#tempPath#\vmdf#game_id#.pdf">
		</cfif>
	<cfelse>
		<cfset pdf_error = "VISITOR MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:NN TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="#tempPath#\vmdf#game_id#.pdf">
	</cfif>
	<cfif  isdefined("variables.visitor_team_roster_id") and len(trim(variables.visitor_team_roster_id))>
		<cfset roster = "">
		<cfset roster_id=#variables.visitor_team_roster_id#>
		<cfinclude template="./rosterView.cfm">
		<cfset visitor_team_roster_bin = roster>
		<cffile action="write" output="#visitor_team_roster_bin#" file="#tempPath#\vtr#game_id#.pdf">
		<cfset hasVisitorRoster = 1 >
	<cfelse>
		<cfset pdf_error = "VISITOR TEAM ROSTER NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:NN TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="#tempPath#\vtr#game_id#.pdf">
	</cfif>
	<cfif  isdefined("variables.home_team_mdf") and isnumeric(variables.home_team_mdf)>
		<cfset home_match_day_form_id=#variables.home_team_mdf#>
		<cfset visitor_match_day_form_id="">
		<cfinclude template="./matchDayFormView.cfm">
		<cfset pdf_error = "HOME MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:NN TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfif isdefined("home_mdf")>
			<cfset home_team_mdf_bin = home_mdf>
			<cffile action="write" output="#home_team_mdf_bin#" file="#tempPath#\hmdf#game_id#.pdf">
			<cfset hasHomeMdf = 1 >
		<cfelse>
			<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
			<cffile action="write" output="#error#" file="#tempPath#\hmdf#game_id#.pdf">
		</cfif>
	<cfelse>
		<cfset pdf_error = "HOME MATCH DAY FORM NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:NN TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="#tempPath#\hmdf#game_id#.pdf">
	</cfif>
	<cfif  isdefined("variables.home_team_roster_id") and len(trim(variables.home_team_roster_id))>
		<cfset roster = "">
		<cfset roster_id=#variables.home_team_roster_id#>
		<cfinclude template="./rosterView.cfm">
		<cfset home_team_roster_bin = roster>
		<cffile action="write" output="#home_team_roster_bin#" file="#tempPath#\htr#game_id#.pdf">
		<cfset hasHomeRoster = 1 >
	<cfelse>
		<cfset pdf_error = "HOME TEAM ROSTER NOT PROVIDED AS OF #datetimeformat(now(),'MM/DD/YYYY HH:NN TT')# WHEN LAST UPDATED BY THE REFEREE! THIS PAGE WILL NOT UPDATE UNTIL REFEREE UPDATES IT">
		<cfdocument name="error" format="PDF"><DIV style="color:red;font-weight:bold;"><cfoutput>#pdf_error#</cfoutput></DIV></cfdocument>
		<cffile action="write" output="#error#" file="#tempPath#\htr#game_id#.pdf">
	</cfif>

	<!--- <cfdump var="#home_team_mdf_bin#" abort="true"> --->

	<cfpdf action="merge" name="GameDayDoc" >
	    	<cfpdfparam source="#tempPath#\vmdf#game_id#.pdf">
	    	<cfpdfparam source="#tempPath#\vtr#game_id#.pdf">
	    	<cfpdfparam source="#tempPath#\hmdf#game_id#.pdf">
	    	<cfpdfparam source="#tempPath#\htr#game_id#.pdf">
	</cfpdf>

	<cfstoredproc datasource="#session.dsn#" procedure="P_UPSERT_GAME_DAY_DOC">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@game_id" type="In" value="#game_id#">
		<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" value="#ToBinary(GameDayDoc)#">
	</cfstoredproc>
			
	<cffile action="delete" file="#tempPath#\vmdf#game_id#.pdf">
	<cffile action="delete" file="#tempPath#\vtr#game_id#.pdf">
	<cffile action="delete" file="#tempPath#\hmdf#game_id#.pdf">
	<cffile action="delete" file="#tempPath#\htr#game_id#.pdf">


	<cfquery name="getBin" datasource="#session.DSN#">
		Select content,  game_id
		from TBL_GAME_DAY_DOCUMENTS
		where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
	</cfquery>

	<!--- guess content type --->
	<cfif getBin.recordcount>
		<cfset mimeType="application/pdf">


		<cfheader name="Content-Disposition" value="inline; filename=game_#getBin.Game_id#_game_day_doc.pdf">

		<cfcontent variable="#toBinary(getBin.content)#" type="#mimeType#">
	<cfelse>
		<cfinclude template="_header.cfm">
					<div>We're sorry but the Game Day Documents file has not yet been created by the Referee.  The Referee cannot do so until less than 24 hours before game time.  Please check back later</div>
		<cfinclude template="_footer.cfm">
	</cfif>

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
 
