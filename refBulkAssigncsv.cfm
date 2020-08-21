<!--- 
	FileName:	refBulkAssigncsv.cfm
	Created on: 03/24/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/01/2009 - changes it to download an excell file
 --->
 
<cfinclude template="_checkLogin.cfm">

<cfif isDefined("URL.From")>
	<cfset WeekendFrom = URL.From >
<cfelseif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = FORM.WeekendFrom >
<cfelse>
	<cfset WeekendFrom = dateFormat(now(),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("URL.To")>
	<cfset WeekendTo = URL.To >
<cfelseif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo = FORM.WeekendTo >
<cfelse>
	<cfset WeekendTo = dateFormat(DateAdd("d",7,now() ),"mm/dd/yyyy") >
</cfif>

<cfif isDefined("URL.G")> <!--- ???? --->
	<cfset swExecuteSelect = true >
<cfelse>
	<cfset swExecuteSelect = false >
</cfif>

<cfif isDefined("FORM.gameId")>
	<cfset gameId = FORM.gameId >
<cfelse>
	<cfset gameId = "" >
</cfif>

<cfif isDefined("FORM.RefID")>
	<cfset RefID = FORM.RefID >
<cfelse>
	<cfset RefID = "" >
</cfif>

<cfif isDefined("FORM.chkShowNCSAFields")>
	<cfset showNCSAFields = true >
<cfelse>
	<cfset showNCSAFields = false >
</cfif>

<cfif isDefined("FORM.gameNumber")>
	<cfset gameNumber = FORM.gameNumber >
<cfelse>
	<cfset gameNumber = "" >
</cfif>

<cfif isDefined("FORM.chkShowUnassignedOnly")>
	<cfset ShowUnassignedOnly = true >
<cfelse>
	<cfset ShowUnassignedOnly = false >
</cfif>

<cfif isDefined("FORM.selAgeGroup")>
	<cfset ageGroup = FORM.selAgeGroup >
<cfelse>
	<cfset ageGroup = "" >
</cfif>

<!--- get referees --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
</cfinvoke>
<!--- get game types --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<cfif isDefined("form.GO") OR swExecuteSelect OR isDefined("FORM.SAVE")  OR isDefined("FORM.PRINTME") >
	<cfquery name="refGameInfo_A" datasource="#SESSION.DSN#" >
		select  g.GAME_ID,   	g.GAME_DATE,  	  g.GAME_TIME, 
				g.GAME_TYPE, 	g.FIELDABBR,  	  g.Field_id, 	g.DIVISION,
				g.SCOREOVERRIDE, 	g.SCORE_HOME, g.SCORE_VISITOR,
				g.HOME_TEAMNAME,	g.HOME_TEAM_ID,
				g.VISITOR_TEAMNAME, g.VISITOR_TEAM_ID,  g.Virtual_TeamName, 
				g.REFREPORTSBM_YN,  g.REFPAID_YN,
				g.REFID,  	   g.REF_ACCEPT_DATE,	g.Ref_accept_YN,
				g.ASSTREFID1,  g.AREF1ACPTDATE,  	g.ARef1Acpt_YN,
				g.ASSTREFID2,  g.AREF2ACPTDATE,		g.ARef2Acpt_YN,
				c.lastname + ', ' + c.FIRSTNAME as ref_name,
				rrh.FullTimeScore_Home, rrh.FullTimeScore_Visitor,
				rrd.game_id as rrd_game_id,
				dbo.f_get_contact_fullname(g.asstrefid1) as ar1_name,
				dbo.f_get_contact_fullname(g.asstrefid2) as ar2_name
		  from  V_Games_all g  with (nolock)
		  left join TBL_CONTACT c 
		  	ON c.CONTACT_ID = g.REFID
		  left join tbl_referee_rpt_header rrh
		 	 on g.game_id=rrh.game_id
		  left join tbl_referee_rpt_detail rrd
		  	on g.game_id=rrd.game_id and (rrd.serial_no is null or rrd.serial_no = 1)
		  left join tbl_field f
			on g.field_id=f.field_id
		 Where  1=1
		 	<cfif gameNumber NEQ ""  AND isnumeric(gameNumber)>
				and g.game_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#gameNumber#">
			<cfelse>
			    and  g.game_date between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#weekendfrom#"> and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#weekendto#">
			 	and season_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#SESSION.CurrentSeason.ID#">
			 	<cfif NOT showNCSAFields>
					and f.club_id <> 1
				</cfif>
				<cfif ageGroup EQ "fullside">
					and dbo.f_is_game_smallsided(g.game_id) = 0
				<cfelseif ageGroup EQ "u15up">
					and dbo.f_get_game_age(g.game_id) >= 15
				<cfelseif ageGroup EQ "smallside">
					and dbo.f_is_game_smallsided(g.game_id) = 1
				</cfif>
				<cfif showUnassignedOnly>
					and 
					(
						(dbo.f_is_game_smallsided(g.game_id)=1 AND g.refid is null)
						OR
						(dbo.f_is_game_smallsided(g.game_id)=0 AND (g.refid is null or g.asstrefid1 is null or g.asstrefid2 is null))
					)
				</cfif>
			</cfif>
		   order by g.game_date, g.FIELDABBR, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24') 
	</cfquery>
	<!--- and  (g.game_date >= '#WeekendFrom#' and  g.game_date <= '#WeekendTo#' ) #preserveSingleQuotes(whereDiv)# #preserveSingleQuotes(whereState)# --->

	<cfset ctGames = refGameInfo_A.recordCount>
	
	
	<!--- START REF ASSIGNOR LOGIC --->
	<CFIF SESSION.MENUROLEID EQ 23>
		<!--- we have a ref assignor, the games must be limited to the games they are mapped to. --->
		<!--- get the assignor fields --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFields" returnvariable="qAssignorFields">
			<cfinvokeargument name="AssignorContactID" value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="orderBy" value="NAME">
		</cfinvoke>
		<cfset lstAssignorFieldIDs = "0">
		<CFIF qAssignorFields.recordCount>
			<cfset lstAssignorFieldIDs = valueList(qAssignorFields.FIELD_ID)>
		</CFIF>
		<!--- only select games on the fields in the list --->
		<cfquery name="refGameInfo_A" dbtype="query">
			SELECT * FROM refGameInfo_A
			WHERE FIELD_ID in (#lstAssignorFieldIDs#)
		</cfquery>
		<cfset ctGames = refGameInfo_A.recordCount>
	</CFIF>

<cfelse>
	<cfset ctGames = 0>
</cfif>

<!--- 
	<cfset fileName = session.USER.contactid & "file.csv">
	<CFSET tempfile = "#GetDirectoryFromPath(ExpandPath("*.*"))#\uploads\#VARIABLES.fileName#" >
	<!--- The "spaces" in the text below are TAB characters. Do not change them to spaces otherwise the Excel export will not work.--->
	<CFSET output = "">
	<CFSET output = output & "GameType,Date,Time,Game,Div,Field,Home_Team,Visitor_Team,Referee_accept,Referee_name,AR1_accept,AR1_name,AR2_accept,AR2_name" >
	<CFFILE ACTION="WRITE" FILE="#tempfile#" OUTPUT="#output#" nameconflict="OVERWRITE"  >
	<a href="uploads/#VARIABLES.fileName#">Download File</a> 
--->



<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<cfheader name="Content-Disposition" value="inline; filename=refereeAssignment.xls">
<cfcontent type="application/vnd.ms-excel">


<!--- <cfheader name="Content-Disposition" value="inline; filename=refassign.pdf"> 
<cfcontent type="application/pdf" > --->

<cfoutput>
<table cellspacing="0" cellpadding="0" align="center" border="1" width="100%" >
	<tr><td colspan="14"> NCSA - Referee Assignment Bulk</td>						</tr>
	<tr><td colspan="14">#ctGames# game<cfif ctGames gt 1>s</cfif> listed</td>		</tr>
	<tr class="tblHeading">
			<TD> GameType </TD>
			<TD> Date</TD>
			<TD> Time</TD>
			<TD> Game	</TD>
			<TD> Div	</TD>
			<TD> Field	</TD>
			<TD> Home Team 	</TD>
			<TD> Visitor Team	</TD>
			<TD> Referee accept	</TD>
			<TD> Referee name	</TD>
			<TD> AR1 accept	</TD>
			<TD> AR1 name	</TD>
			<TD> AR2 accept	</TD>
			<TD> AR2 name	</TD>
	</TR>
	<cfset Index = 1 >
	<cfset LastVal = refGameInfo_A.Game_Date> <!--- "" --->
	<CFLOOP query="refGameInfo_A">
		<cfset Game			 = GAME_ID>
		<cfset GameDate		 = dateFormat(GAME_DATE,"mm/dd/yy")>
		<cfset GameTime		 = timeFormat(GAME_TIME,"hh:mmtt")>
		<cfset HomeScore	 = SCORE_HOME>
		<cfset VisitorScore	 = SCORE_VISITOR>
		<cfset HomeTeam		 = HOME_TEAMNAME>
		<!--- <cfset VisitorTeam	 = VISITOR_TEAMNAME> --->
		<cfif len(trim(VISITOR_TEAMNAME))>
			<cfset VisitorTeam	 = VISITOR_TEAMNAME>
		<cfelseif len(trim(Virtual_TeamName))>
			<cfset VisitorTeam	 = Virtual_TeamName>
		<cfelse>
			<cfset VisitorTeam	 = "">
		</cfif>
		<cfset HomeTeamID	 = HOME_TEAM_ID>
		<cfset VisitorTeamID = VISITOR_TEAM_ID>
		<cfset GameType		 = GAME_TYPE>
		<cfset RefReportSbm	 = REFREPORTSBM_YN>
		<cfset RefUnPaid	 = REFPAID_YN>
		<cfset RefId		 = REFID >
		<cfset GameField	 = FIELDABBR>
		<cfset ScoreOverride = SCOREOVERRIDE>
		<cfset GameDiv		 = DIVISION>
		<cfset AsstRefId1	 = ASSTREFID1>
		<cfset AsstRefId2	 = ASSTREFID2>
		<cfset ref_name      = REF_NAME>
		<cfset ar1_name      = ar1_name>
		<cfset ar2_name      = ar2_name>
		<cfset RefAcptDate	 = REF_ACCEPT_DATE>
		<cfset RefAssigned = "">
		<cfif len(trim(RefId))>
			<cfset RefAssigned = "Y">
		</cfif>
		<cfif listFind("1,20,22,23",SESSION.MenuRoleID) EQ 0>
			<CFIF len(trim(RefID))>
				<cfset ref_name="Referee Covered">
				<cfset RefAssigned  = "" >
			</cfif> 
			<cfif len(trim(asstrefid1))>
				<cfset ar1_name="Referee Covered">
			</cfif>
			<cfif len(trim(asstrefid2))>
				<cfset ar2_name="Referee Covered">
			</cfif>
		</CFIF>
		<cfset ReportSubmitted = "">
		<cfif len(trim(RefReportSbm))>
			<cfset ReportSubmitted = "Checked">
		<cfelse>
			<cfset ReportSubmitted = "">
		</cfif>

		<cfif len(trim(RefUnPaid))>
			<cfset RefereeUnPaid = "Checked">
		<CFELSE>
			<cfset RefereeUnPaid = "">
		</cfif>

		<cfquery name="getRefScore" datasource="#SESSION.DSN#">
			SELECT FullTimeScore_Home, FullTimeScore_Visitor
			  FROM TBL_referee_rpt_header
			 WHERE Game_ID = #VARIABLES.GAME#
		</cfquery>
		<cfif getRefScore.RECORDCOUNT>
			<cfset RefScore = getRefScore.FullTimeScore_Home & "-" & getRefScore.FullTimeScore_Visitor>
		<cfelse>
			<cfset RefScore = "" >
		</cfif>
		<cfquery name="getRefDetail" datasource="#SESSION.DSN#">
			SELECT Game_ID
			  FROM TBL_referee_RPT_detail
			 WHERE GAME_ID = #VARIABLES.GAME#
			   AND ( Serial_No is Null or Serial_No = 1 )
		</cfquery>
		<cfif getRefDetail.RECORDCOUNT>
			<cfset RefRptChecked = "checked">
		<cfelse>
			<cfset RefRptChecked = "">
		</cfif>

		<cfset GameTypeAbbr = "">
		<cfif len(Trim(Gametype))>
			<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
				<cfif GameType EQ arrGameType[igt][1]>
					<cfset GameTypeAbbr = arrGameType[igt][3]>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

		<cfif len(trim(HomeScore))>
			<cfset SORAttrib	 = "">
			<cfset noScore		 = "N">
			<cfset AllowRefAsgn = "N">
		<cfelse>
			<cfset SORAttrib	= "disabled">
			<cfset noScore		= "Y">
			<cfset AllowRefAsgn = "Y">
		</cfif>
				<cfif Ref_accept_YN EQ "Y">
					<cfset refAccept = "A">
				<cfelseif Ref_accept_YN EQ "N">
					<cfset refAccept = "D">
				<cfelse>
					<cfset refAccept = " ">
				</cfif>
				<cfif ARef1Acpt_YN EQ "Y">
					<cfset AR1accept = "A">
				<cfelseif ARef1Acpt_YN EQ "N">
					<cfset AR1accept = "D">
				<cfelse>
					<cfset AR1accept = " " >
				</cfif>
				<cfif ARef2Acpt_YN EQ "Y">
					<cfset AR2accept = "A">
				<cfelseif ARef2Acpt_YN EQ "N">
					<cfset AR2accept = "D">
				<cfelse>
					<cfset AR2accept = " " >
				</cfif>
				
		
		<tr><td><cfif len(trim(GameTypeAbbr))>#GameTypeAbbr#<cfelse>&nbsp;</cfif></td>
			<TD><cfif len(trim(GameDate))>#GameDate#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(GameTime))>#GameTime#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(Game_ID))>#Game_ID#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(GameDiv))>#GameDiv#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(GameField))>#GameField#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(HomeTeam))>#HomeTeam#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(VisitorTeam))>#VisitorTeam#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(refAccept))>#refAccept#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(ref_Name))>#ref_Name# <cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(AR1accept))>#AR1accept#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(ar1_name))>#ar1_name#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(AR2accept))>#AR2accept#<cfelse>&nbsp;</cfif></TD>
			<TD><cfif len(trim(ar2_name))>#ar2_name#<cfelse>&nbsp;</cfif></TD>
		</TR>
		<cfset Index = Index + 1 >
  
		<!--- <CFSET output = """#GameTypeAbbr#"",""#GameDate#"",""#GameTime#"",""#Game_ID#"",""#GameDiv#"",""#GameField#"",""#HomeTeam#"",""#VisitorTeam#"",""#refAccept#"",""#RefereeLast#"",""#Referee#"",""#AR1accept#"",""#ar1name#"",""#AR2accept#"",""#ar2name#""" >
			<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" > 
		--->

	</CFLOOP>
	</TABLE>

	</cfoutput>
</cfcontent>



