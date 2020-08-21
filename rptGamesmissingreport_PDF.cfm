<!------------------------------------------------
MODIFICATIONS
8/14/2017 - apinzone - NCSA27024 
-- changed orientation to landscape
--------------------------------------------------->

<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 

<cfif isDefined("form.selectSort") and form.selectSort NEQ "">
	<cfset selectSort = form.selectSort>
<cfelseif isDefined("url.selectSort") AND url.selectSort NEQ "">
	<cfset selectSort = url.selectSort>
<cfelse>
	<cfset selectSort = "REFEREE">
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

<!---------------->
<!--- GET DATA --->
<!---------------->

<cfquery name="qGetGames" datasource="#SESSION.DSN#">
	select g.season_id, g.game_id, g.game_date, g.game_time, g.Division_id,
		   f.fieldAbbr,  
		   xgo.xref_game_official_id, xgo.game_official_type_id,
		   lgo.game_official_type_name,
		   co.FirstName, co.LastName 
	  from TBL_GAME G LEFT JOIN XREF_GAME_OFFICIAL xgo ON xgo.game_id = g.game_id
					  INNER JOIN tlkp_game_official_type lgo ON lgo.game_official_type_id = xgo.game_official_type_id
					  LEFT JOIN TBL_FIELD    f ON f.FIELD_ID = g.FIELD_ID	
					  LEFT JOIN TBL_CONTACT co ON co.CONTACT_ID = xgo.CONTACT_ID	
	 WHERE g.season_id = #SESSION.CURRENTSEASON.ID#
		   AND xgo.game_official_type_id = 1	
		   AND xgo.refReportSbm_YN <> 'Y'
		   AND g.game_type is NULL    
		   AND (	g.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#"> 
		   		AND g.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#"> 
				)
		   AND 	Score_Home  >= 0	  
		   AND 	Score_visitor  >= 0		
		ORDER BY <cfif selectSort EQ "DATE"> 
					g.game_date, co.LastName, co.FirstName, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
				<cfelseif selectSort EQ "FIELD"> 
					f.fieldAbbr, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
				<cfelse> 
					co.LastName, co.FirstName, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
				</cfif>		
</cfquery> 

<!---------------------------->
<!--- PRODUCE PDF DOCUMENT --->
<!---------------------------->

<cfdocument margintop=".25" marginbottom=".5" format="pdf" name="print_report" localUrl="yes" orientation="landscape">
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
					<H1 class="pageheading">NCSA - Games with Referee Not Filed Match Report</H1>
					<!--- <br> <h2>yyyyyy </h2> --->
			
					<CFIF IsDefined("qGetGames") AND qGetGames.RECORDCOUNT GT 0 >
						<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
							<tr class="tblHeading">
								<TD width="10%"> Game		</TD>
								<TD width="25%"> Date/Time </TD>
								<TD width="25%"> Play Field</TD>
								<TD width="10%"> Div	 	</TD>
								<TD width="30%"> Name 		</TD>
							</TR>
							<cfset holdRefID = 0>
					 		<CFLOOP query="qGetGames">
								<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
									<TD width="10%" class="tdUnderLine" >#Game_Id#</TD>
									<TD width="25%" class="tdUnderLine">
											#DateFormat(Game_Date,'mm/dd/yyyy')# 
												#repeatString("&nbsp;",3)#
											#TimeFormat(Game_Time,'hh:mm tt')#
									</TD>
									<TD width="25%" class="tdUnderLine" >#fieldAbbr#</TD>
									<TD width="10%" class="tdUnderLine" >#Division_id#</TD>
									<TD width="30%" class="tdUnderLine" >#LastName#, #FirstName#</TD>
								</TR>
							</CFLOOP>
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