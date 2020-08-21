
<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 

<cfif isDefined("FORM.op")>
	<cfset op = FORM.op > 
<cfelseif isDefined("URL.op")>
	<cfset op = URL.op > 
<cfelse>
	<cfset op = 0 > 
</CFIF>

<cfif isDefined("form.WeekendFrom") and form.WeekendFrom NEQ "">
	<cfset WeekendFrom = dateformat(form.WeekendFrom,"mm/dd/yyyy") > 
<cfelseif isDefined("url.WeekendFrom") and url.WeekendFrom NEQ "">
	<cfset WeekendFrom = url.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = dateformat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("form.WeekendTo") and form.WeekendTo NEQ "">
	<cfset WeekendTo   = dateformat(form.WeekendTo,"mm/dd/yyyy") >
<cfelseif isDefined("url.WeekendTo") and url.WeekendTo NEQ "">
	<cfset WeekendTo = url.WeekendTo>
<cfelse>
	<cfset WeekendTo   = dateformat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("form.gameDiv") and form.gameDiv NEQ "">
	<cfset gameDiv = form.gameDiv>
<cfelseif isDefined("url.gameDiv") and url.gameDiv NEQ "">
	<cfset gameDiv = url.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("form.gameID") and form.gameID NEQ "" AND isNumeric(form.gameID)>
	<cfset gameID = form.gameID>
<cfelseif isDefined("url.gameID") and url.gameID NEQ "" and isNumeric(url.gameID)>
	<cfset gameID = url.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfif isDefined("form.sortBy") and form.sortBy NEQ "">
	<cfset sortBy = form.sortBy>
<cfelseif isDefined("url.sortBy") and url.sortBy NEQ "">
	<cfset sortBy = url.sortBy>
<cfelse>
	<cfset sortBy = "date">
</cfif>

<!---------------->
<!--- GET DATA --->
<!---------------->

		<cfquery name="qGamesNotPlayed" datasource="#SESSION.DSN#">
			SELECT G.GAME_ID, G.Division, G.game_date, G.game_time, G.fieldAbbr, G.game_type,
				   G.HOME_TEAMNAME, G.VISITOR_TEAMNAME,  G.virtual_teamName,
				   G.RefID, G.refReportSbm_yn,
				   (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = G.RefID) AS REF_name,
				   G.SCORE_HOME, G.SCORE_VISITOR,
				   R.GameSts
			  FROM tbl_referee_RPT_header R 
						INNER JOIN V_GAMES_all G	 ON G.GAME_ID = R.GAME_ID
			 WHERE R.GameSts <> 'P'
			 	AND ( G.SCORE_HOME >= 0 OR G.SCORE_VISITOR >= 0)
			 	<cfif isDefined("gameID") and gameID NEQ "">
					AND G.GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
				<cfelse>
					AND (	  G.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
						  AND G.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
						)
					AND ( G.game_type is null or G.game_type = '' or G.game_type = 'L') 	
					<cfif len(trim(gameDiv))>
						AND G.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
					</cfif>
				</cfif>
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>

				and (G.home_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#"> or G.visitor_club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">)
			</cfif>
			ORDER BY
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="field"> G.FIELDABBR, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="game">  G.game_id </cfcase>
					<cfcase value="div">   G.Division, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="ref">   REF_name, G.game_date, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24')  	</cfcase>
					<cfdefaultcase>  <!--- date ---> G.game_date, G.FIELDABBR, dbo.formatDateTime(G.GAME_TIME,'HH:MM 24') </cfdefaultcase>
				</cfswitch> 
		</cfquery>

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
					<H1 class="pageheading">NCSA - Game Not Played Discrepancy Report </H1>
					<!--- <br> <h2>yyyyyy </h2> --->
					<cfif isDefined("qGamesNotPlayed") and qGamesNotPlayed.RecordCount GT 0>

						<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrgameStatus">
							<cfinvokeargument name="listType" value="GAMESTATUS"> 
						</cfinvoke> <!--- <cfdump var="#arrgameStatus#"> --->

						<cfset RecCountGrand	= 0>
						<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
							<tr class="tblHeading">
								<TD width="07%">Game</TD>
								<TD width="05%">Div</TD>
								<TD width="07%">Date <br> Time</TD>
								<TD width="18%">PlayField</TD>
								<TD width="28%">Teams</TD>
								<td width="17%">Referees</td>
								<td width="11%">Not Played <br> Reason</td>
								<td width="07%">DC <br> Score</td>
							</tr>
							<cfset ctLoop = 0>
							<cfloop query="qGamesNotPlayed">
								<cfset ctLoop = ctLoop + 1>
								<cfset classValue = "class='tdUnderLine'">
								<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
									<TD width="07%" valign="top" #classValue# >
									<cfif op EQ "1">
									#game_id#
									<cfelse>
										<CFIF refReportSbm_yn EQ 'Y'>
											<span class="red">#game_id#</span>
										<CFELSE>
											#game_id#
										</CFIF>
									
									</cfif>
										<br>
										<cfswitch expression="#game_type#">
											<cfcase value="C"><br><span class="red">SC</span></cfcase>
											<cfcase value="N"><br><span class="red">NL</span></cfcase>
											<cfcase value="F"><br><span class="red">Fr</span></cfcase>
										</cfswitch>
									</TD>
									<TD width="05%" valign="top" #classValue# >
										#Division#
									</TD>
									<TD width="07%" valign="top" #classValue# >
											#dateFormat(game_date,"mm/dd/yy")# 
										<br>#timeFormat(game_time,"hh:mm tt")#
									</TD>
									<TD width="18%" valign="top" #classValue# >
										&nbsp;#fieldAbbr#
									</TD>
									<TD width="28%" valign="top" #classValue# >
										(H) #Home_TeamName#  
										<br>(V) 
											<cfif len(trim(Visitor_TeamName))>
												#Visitor_TeamName# 
											<cfelse>
												#Virtual_TeamName#
											</cfif>
									</TD>
									<TD width="18%" valign="top" #classValue# >
										#REF_name# 
									</TD>
									<TD width="11%" valign="top" align="left" #classValue# >
										<!--- #GameSts# -  --->
										<cfloop from="1" to="#arrayLen(arrGameStatus)#" index="ix">
											<cfif GameSts EQ arrGameStatus[ix][1]>
												#arrGameStatus[ix][2]#
												<cfbreak>
											</cfif>
										</cfloop>	
									</TD>
									<TD width="06%" valign="top" align="left" #classValue# >
										#SCORE_HOME# - #SCORE_VISITOR#
									</TD>
								</TR>
								<cfset RecCountGrand = RecCountGrand + 1 >
							</cfloop>
						</TABLE>
					</cfif>
				</div>
			</body>
		</html>
	</cfoutput>
</cfdocument>

<cfheader name="Content-Disposition" 
value="inline; filename=print_report.pdf">

<cfcontent type="application/pdf" variable="#toBinary(print_report)#">