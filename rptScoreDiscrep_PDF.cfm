
<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 

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

<cfquery name="qScoreDiscrep" datasource="#SESSION.DSN#">
	SELECT G.SCORE_HOME, G.SCORE_VISITOR, R.FullTimeScore_Home, R.FullTimeScore_Visitor,
		   G.GAME_ID,  G.Division, G.game_date, G.game_time, G.fieldAbbr, G.game_type,
		   G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.virtual_teamName,
		   G.refReportSbm_yn, G.RefID, 
		   (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = G.RefID) AS REF_name
	  FROM V_GAMES_all G INNER JOIN tbl_referee_RPT_header R ON R.GAME_ID = G.GAME_ID
					 INNER JOIN TBL_CONTACT C 			 ON G.refID = C.contact_id
	 WHERE (   (G.SCORE_HOME    IS NULL
					AND R.FullTimeScore_Home is not null
				)
		    OR (   G.SCORE_HOME    <> R.FullTimeScore_Home 
				OR G.SCORE_VISITOR <> R.FullTimeScore_Visitor
				)
			)
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
					<H1 class="pageheading">NCSA - Score Discrepancy Report</H1>
					<!--- <br> <h2>yyyyyy </h2> --->
					<cfif isDefined("qScoreDiscrep") and qScoreDiscrep.RecordCount GT 0>


						<cfset RecCountGrand	= 0>
						<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
							<tr class="tblHeading">
								<TD width="07%">Game</TD>
								<TD width="05%">Div</TD>
								<TD width="07%">Date <br> Time</TD>
								<TD width="20%">PlayField</TD>
								<TD width="27%">Teams</TD>
								<td width="20%">Referees</td>
								<td width="07%">Ref Score</td>
								<td width="07%">DC Score</td>
							</tr>
							<cfset ctLoop = 0>
							<cfloop query="qScoreDiscrep">
								<cfset ctLoop = ctLoop + 1>
								<cfset classValue = "class='tdUnderLine'">
								<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctLoop)#">
									<TD width="07%" valign="top" #classValue# >
										<CFIF refReportSbm_yn EQ 'Y'>
											<span class="red">#game_id#</span>
										<CFELSE>
											#game_id#
										</CFIF>
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
									<TD width="20%" valign="top" #classValue# >
										&nbsp; #fieldAbbr#
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
									<TD width="20%" valign="top" #classValue# >
										#REF_name# 
									</TD>
									<TD width="07%" valign="top" align="left" #classValue# >
										#FullTimeScore_Home# - #FullTimeScore_Visitor#
									</TD>
									<TD width="06%" valign="top" align="left" #classValue# >
										<cfif len(trim(SCORE_HOME)) or len(trim(SCORE_VISITOR))>
											#SCORE_HOME# - #SCORE_VISITOR# &nbsp; &nbsp; &nbsp; &nbsp;
										<cfelse>
											&nbsp;
										</cfif>
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