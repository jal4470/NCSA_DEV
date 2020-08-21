
<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 

<cfif isDefined("form.TeamAgeSelected") and form.TeamAgeSelected NEQ "">
	<cfset TeamAgeSelected = form.TeamAgeSelected>
<cfelseif isDefined("url.TeamAgeSelected") AND url.TeamAgeSelected NEQ "">
	<cfset TeamAgeSelected = url.TeamAgeSelected>
<cfelse>
	<cfset TeamAgeSelected = "">
</cfif>

<cfif isDefined("form.BGSelected") and form.BGSelected NEQ "">
	<cfset BGSelected = form.BGSelected>
<cfelseif isDefined("url.BGSelected") AND url.BGSelected NEQ "">
	<cfset BGSelected = url.BGSelected>
<cfelse>
	<cfset BGSelected = "">
</cfif>

<cfif isDefined("form.PlayLevel") and form.PlayLevel NEQ "">
	<cfset PlayLevel = form.PlayLevel>
<cfelseif isDefined("url.PlayLevel") AND url.PlayLevel NEQ "">
	<cfset PlayLevel = url.PlayLevel>
<cfelse>
	<cfset PlayLevel = "">
</cfif>

<cfif isDefined("form.selectSort") and form.selectSort NEQ "">
	<cfset selectSort = form.selectSort>
<cfelseif isDefined("url.selectSort") AND url.selectSort NEQ "">
	<cfset selectSort = url.selectSort>
<cfelse>
	<cfset selectSort = "">
</cfif>

<cfif isDefined("form.WeekendFrom") and form.WeekendFrom NEQ "">
	<cfset WeekendFrom = form.WeekendFrom>
<cfelseif isDefined("url.WeekendFrom") AND url.WeekendFrom NEQ "">
	<cfset WeekendFrom = url.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = "">
</cfif>

<cfif isDefined("form.WeekendTo") and form.WeekendTo NEQ "">
	<cfset WeekendTo = form.WeekendTo>
<cfelseif isDefined("url.WeekendTo") AND url.WeekendTo NEQ "">
	<cfset WeekendTo = url.WeekendTo>
<cfelse>
	<cfset WeekendTo = "">
</cfif>


<!--- Start WHERE value for DIVISION based on filters --->
<cfset divValue = "">
<cfif len(trim(BGSelected))>
	<cfset divValue = ucase(BGSelected)> 
</cfif>

<cfif len(trim(TeamAgeSelected))>
	<cfset divValue = divValue & right(TeamAgeSelected, 2) > 
</cfif>
	
<cfif len(trim(PlayLevel))>
	<!--- was age selected --->
	<cfif len(trim(TeamAgeSelected))>
		<!--- yes, append level --->
		<cfset divValue = divValue & PlayLevel >
	<cfelse>
		<!--- no, not selected --->
		<cfif len(trim(BGSelected))>
			<!--- gender was selected --->
			<cfset divValue = divValue & PlayLevel>
		<cfelse>
			<!--- gender was not selected --->
			<cfset divValue = PlayLevel >
		</cfif>
	</cfif>
</cfif>

<!--- put % around the value unless gender was selected --->
<cfif len(trim(divValue))>
	<cfif len(trim(BGSelected))>
		<cfset divValue = divValue & "%" >
	<cfelse>
		<cfset divValue = "%" & divValue & "%" >
	</cfif>
</cfif>
<!--- --g[#BGSelected#]- a[#TeamAgeSelected#]- l[#PlayLevel#] = [#divValue#] --->
<!--- End WHERE value for DIVISION based on filters --->

<!---------------->
<!--- GET DATA --->
<!---------------->

<cfquery name="qGetGames" datasource="#SESSION.DSN#">
	SELECT vg.Game_ID, vg.GAME_DATE, vg.GAME_TIME, 
		   vg.HOME_TEAM_ID, vg.HOME_TEAMNAME,  
		   vg.VISITOR_TEAM_ID, vg.VISITOR_TEAMNAME,  
		   vg.FIELDABBR, vg.Field_id, vg.Division, vg.GAME_Type, f.club_id
	  FROM V_Games_all vg INNER JOIN TBL_FIELD f ON f.field_id = vg.field_id
	 WHERE (	vg.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
			AND vg.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
			)
	   AND vg.HScore is Null
	   AND vg.VScore is Null
	  <CFIF clubID NEQ 1>
	   AND (   VG.Home_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubID#">
	        OR vg.Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubID#">
			)
	  </CFIF>
	  <CFIF len(trim(divValue))>
	  	AND vg.Division LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.divValue#">
	  </CFIF>
	  AND (vg.GAME_Type = 'L' OR vg.GAME_Type IS NULL )
	 ORDER BY <CFIF selectSort EQ "FLIT">
	 				vg.Division, vg.GAME_DATE, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')
	 		  <CFELSE>
			  		vg.GAME_DATE, vg.Division, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')		
			  </CFIF> 
</cfquery><!--- <CFIF selectSort EQ "FLIT">vg.Division, </CFIF> vg.GAME_DATE, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')		 --->

<!---------------------------->
<!--- PRODUCE PDF DOCUMENT --->
<!---------------------------->

<cfdocument margintop=".25" marginbottom=".5" format="pdf" name="print_report" localUrl="yes">
	<cfoutput>
		<html>
			<head>
				<title>Report</title>
				<link rel="stylesheet" href="2col_leftNav.css?t=2" type="text/css" />
				<style>
					##contentText { margin: 0 !important;}
					##contentText table { font-family: Tahoma, Verdana,Arial,sans-serif; font-size: 11px !important;}
					h1.pageheading {font-family: Tahoma, Verdana,Arial,sans-serif; font-size: 18px; color: ##334d55;}
					.tblHeading
					{	background-color: ##3399CC;
						font-size: 12px;
						font-weight: bold;
						color:##ffffff;
					}
					h2 {
					font-size: 114%;
					color: ##006699;
					}
					h1, h2, h3, h4, h5, h6 {
					font-family: Tahoma, Verdana,Arial,sans-serif;
					margin: 0px;
					padding: 0px;
					}
				</style>
			</head>
			<body>
				<div id="contentText">
					<H1 class="pageheading">NCSA - Games with Missing Scores Report</H1>
					<!--- <br> <h2>yyyyyy </h2> --->
			
					<table cellspacing="0" cellpadding="0" align="center" border="0" width="100%">
						<TR class="tblHeading">
							<TD width="08%" align="center">Game </TD>
							<TD width="16%" >Date/Time</TD>
							<TD width="22%" >Field</TD>
							<TD width="08%" >Division</TD>
							<TD width="23%" >Home Team</TD>
							<TD width="23%" >Visitor Team</TD>
						</TR>
						<cfloop query="qGetGames">
							<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,CURRENTROW)#">
								<TD width="08%" class="tdUnderLine" valign="top">&nbsp; #GAME_ID#</TD>
								<TD width="16%" class="tdUnderLine" valign="top">#DateFormat(GAME_DATE, "mm/dd/yyyy")#  #timeFormat(GAME_TIME,"hh:mm tt")# </TD>
								<TD width="23%" class="tdUnderLine" valign="top">#FIELDABBR# </TD>
								<TD width="07%" class="tdUnderLine" valign="top">#Division#  </TD>
								<TD width="23%" class="tdUnderLine" valign="top">#HOME_TEAMNAME# &nbsp;</TD>
								<TD width="23%" class="tdUnderLine" valign="top">#VISITOR_TEAMNAME# &nbsp;</TD>
							</TR>
						</cfloop>
					</TABLE>
	
				</div>
			</body>
		</html>
	</cfoutput>
</cfdocument>

<cfheader name="Content-Disposition" 
value="inline; filename=print_report.pdf">

<cfcontent type="application/pdf" variable="#toBinary(print_report)#">