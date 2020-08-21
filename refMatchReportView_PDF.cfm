
<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 


<cfset swShowEditLink = 0>

<cfset swrept = 0>

<cfif SESSION.MENUROLEID EQ 1>
	<cfif isDefined("URL.swrept") and URL.swrept EQ 1 >
		<cfset swShowEditLink = 1 >
		<cfset swrept = URL.swrept>
	<cfelseif isDefined("FORM.swrept") and FORM.swrept EQ 1>
		<cfset swShowEditLink = 1>
		<cfset swrept = FORM.swrept>
	</cfif>
</cfif>

<cfif isDefined("form.WeekendFrom") AND form.WeekendFrom NEQ "">
	<cfset WeekendFrom = form.WeekendFrom>
<cfelseif isDefined("url.WeekendFrom") AND url.WeekendFrom NEQ "">
	<cfset WeekendFrom = url.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = "">
</cfif>

<cfif isDefined("form.WeekendTo") AND form.WeekendTo NEQ "">
	<cfset WeekendTo = form.WeekendTo>
<cfelseif isDefined("url.WeekendTo") AND url.WeekendTo NEQ "">
	<cfset WeekendTo = url.WeekendTo>
<cfelse>
	<cfset WeekendTo = "">
</cfif>

<cfif isDefined("form.RefID") AND form.RefID NEQ "">
	<cfset RefID = form.RefID>
<cfelseif isDefined("url.RefID") AND url.RefID NEQ "">
	<cfset RefID = url.RefID>
<cfelse>
	<cfset RefID = "">
</cfif>

<cfif isDefined("form.GameFieldID") AND form.GameFieldID NEQ "">
	<cfset GameFieldID = form.GameFieldID>
<cfelseif isDefined("url.GameFieldID") AND url.GameFieldID NEQ "">
	<cfset GameFieldID = url.GameFieldID>
<cfelse>
	<cfset GameFieldID = "">
</cfif>

<cfif isDefined("form.gameDiv") AND form.gameDiv NEQ "">
	<cfset gameDiv = form.gameDiv>
<cfelseif isDefined("url.gameDiv") AND url.gameDiv NEQ "">
	<cfset gameDiv = url.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("form.gameID") AND form.gameID NEQ "">
	<cfset gameID = form.gameID>
<cfelseif isDefined("url.gameID") AND url.gameID NEQ "">
	<cfset gameID = url.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfif isDefined("form.sortBy") AND form.sortBy NEQ "">
	<cfset sortBy = form.sortBy>
<cfelseif isDefined("url.sortBy") AND url.sortBy NEQ "">
	<cfset sortBy = url.sortBy>
<cfelse>
	<cfset sortBy = "">
</cfif>

<cfset RecCountGrand = 0>

<!---------------->
<!--- GET DATA --->
<!---------------->

		<cfquery name="qAssignments" datasource="#SESSION.DSN#">
			SELECT vg.game_id, vg.game_date, vg.game_time, vg.Division, vg.game_type,
				   vg.field_id, vg.fieldAbbr,
				   vg.HOME_TEAMNAME, vg.VISITOR_TEAMNAME, vg.virtual_teamName,
				   vg.refReportSbm_yn,
				   vg.RefID,	  vg.Ref_accept_YN, 
					  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.RefID) AS REF_name,
				   vg.AsstRefID1, vg.ARef1Acpt_YN, 
					  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.AsstRefID1) AS AR1_name,
				   vg.AsstRefID2, vg.ARef2Acpt_YN,
					  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.AsstRefID2) AS AR2_name
			 FROM V_GAMES_all vg  
			<cfif gameid NEQ "">
				WHERE vg.GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
			<cfelse>
				WHERE (	  vg.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
					  AND vg.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
					   )
				  AND ( vg.game_type is null or vg.game_type = '' or vg.game_type = 'L') 	
					  <cfif refID GT 0>
						  AND vg.RefID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#">
					  </cfif>
					  <cfif GameFieldID GT 0>
						  AND vg.field_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameFieldID#">
					  </cfif>
					  <cfif len(trim(gameDiv))>
						  AND vg.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
					  </cfif>
			</cfif>
			ORDER BY
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="field"> vg.FIELDABBR, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="game">  vg.game_id </cfcase>
					<cfcase value="div">   vg.Division, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="ref">   REF_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  	</cfcase>
					<cfdefaultcase>  <!--- date ---> vg.game_date, vg.FIELDABBR, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24') </cfdefaultcase>
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
					<H1 class="pageheading">NCSA - Referee Match Reports</H1>
					<!--- <br> <h2>yyyyyy </h2> --->
			
					<CFIF IsDefined("qAssignments") AND qAssignments.RECORDCOUNT GT 0 >
						<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
							<tr class="tblHeading">
								<TD width="09%">Game</TD>
								<TD width="05%">Div</TD>
								<TD width="07%">Date <br> Time</TD>
								<TD width="22%">PlayField</TD>
								<TD width="30%">Teams</TD>
								<td width="20%">Referees</td>
								<td width="07%">Report <br> submitted</td>
							</tr>
							<cfloop query="qAssignments">
								<cfset classValue = "class='tdUnderLine'">
								<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
									<TD width="09%" valign="top" #classValue# >
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
										#dateFormat(game_date,"ddd")#
										<br> #dateFormat(game_date,"mm/dd/yy")# 
										<br>#timeFormat(game_time,"hh:mm tt")#
									</TD>
									<TD width="22%" valign="top" #classValue# >
										&nbsp;#fieldAbbr#
									</TD>
									<TD width="25%" valign="top" #classValue# >
										(H) #Home_TeamName#  
										<br>(V) 
											<cfif len(trim(Visitor_TeamName))>
												#Visitor_TeamName# 
											<cfelse>
												#Virtual_TeamName#
											</cfif>
									</TD>
									<TD width="27%" valign="top" #classValue# >
										<!--- Head Referee --->
											<cfif     Ref_accept_YN EQ "Y"> <span class="green"><b>A</b></span>
											<cfelseif Ref_accept_YN EQ "N">	<span class="red"><b>D</b></span>
											<cfelse>  &nbsp; &nbsp;
											</cfif>
											<cfif VARIABLES.refID EQ REFID> <b>REF: #REF_name#</b> <cfelse>REF: #REF_name# 	
											</cfif>
										<br><!--- Asst Referee 1 ---> 
											<cfif     ARef1Acpt_YN EQ "Y">  <span class="green"><b>A</b></span>
											<cfelseif ARef1Acpt_YN EQ "N">	<span class="red"><b>D</b></span>
											<cfelse>  &nbsp; &nbsp;
											</cfif>
											<cfif VARIABLES.refID EQ AsstRefID1> <b>AR1: #AR1_name#</b> <cfelse>AR1: #AR1_name# 
											</cfif>
										<br><!--- ASST Referee 2 --->
											<cfif     ARef2Acpt_YN EQ "Y">  <span class="green"><b>A</b></span>
											<cfelseif ARef2Acpt_YN EQ "N">	<span class="red"><b>D</b></span>
											<cfelse>  &nbsp; &nbsp;
											</cfif>
											<cfif VARIABLES.refID EQ AsstRefID2> <b>AR2: #AR2_name#</b> <cfelse>AR2: #AR2_name# 
											</cfif>
									</TD>
									<TD width="05%" valign="top" #classValue# >
										#refReportSbm_yn#
									</TD>
								</TR>
								<cfset RecCountGrand = RecCountGrand + 1 >
							</cfloop>
						</table>
						</div> 
					<CFELSEIF IsDefined("qGetGames") AND qGetGames.RECORDCOUNT EQ 0 >
						<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
							<tr class="tblHeading"><td>&nbsp;</td></tr>
							<TR><td><span class="red"> <b>No Records found based on choices.</b></span> </td></TR>
						</table>
					</CFIF>
	
				</div>
			</body>
		</html>
	</cfoutput>
</cfdocument>

<cfheader name="Content-Disposition" 
value="inline; filename=print_report.pdf">

<cfcontent type="application/pdf" variable="#toBinary(print_report)#">