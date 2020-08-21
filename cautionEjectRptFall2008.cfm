<!--- 
	FileName:	cautionEjectRptFall2008.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Caution/Ejection Report </H1>
<h2>FALL 2008 </h2>


<!--- <CFSET Where_ClubSel = "">
<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
	<CFSET Where_ClubSel	= "  AND B.Club_Id = " & SESSION.USER.CLUBID & " " >
<cfelse>
	<CFSET Where_ClubSel	= "  AND B.Club_Id > 0 " >
</cfif> --->

<cfquery name="getMisconds" datasource="#SESSION.DSN#">
	SELECT a.Game			AS GAME_ID
	     , a.SerialNo		AS Serial_No
		 , a.PlayerName	
		 , a.TeamID			AS TEAM_ID
		 , a.MisconductID	AS Misconduct_ID
		 , b.TeamName	
		 , C.ID				AS CLUB_ID
		 , C.Club			AS CLUB_NAME
		 , D.MisConductDesc AS MisConduct_Descr
		 , D.Event			AS Misconduct_event
		 , E.gDate			AS GAME_DATE
		 , E.gTime			AS GAME_TIME
	 from RefRptDtl_FALL_2008 A,
		  CoachesTeams_FALL_2008 B,
		  Clubs_FALL_2008 C,
		  MisConduct_FALL_2008 D,
		  Games_FALL_2008 E
	 where A.TeamID			= b.ID
	   and B.ClubID			= C.ID
	   and A.MisConductID	= D.ID
	   and A.Game			= E.Game
	 Order by C.Club, B.TeamName, A.PlayerName
</cfquery>

<!--- 	SELECT	a.Game_ID, a.Serial_No, a.PlayerName, a.TeamID, a.Misconduct_ID, 
			IsNull(B.Gender,'') + right(B.TeamAge,2) + IsNull(B.PlayLevel,'') + IsNull(B.PlayGroup,'') AS Division,			   
			dbo.GetTeamName(A.TeamID) AS TeamName, b.TEAM_ID,			C.CLUB_NAME, C.CLUB_ID, 
			D.MisConduct_Descr, D.Misconduct_event,		E.GAME_DATE, E.GAME_TIME,
			F.RefereeId,		G.LASTNAME, G.FIRSTNAME 				
	  from  TBL_Referee_RPT_Detail  A 
				LEFT OUTER JOIN  TBL_TEAM  B  		ON b.TEAM_ID = A.TeamID 
				LEFT OUTER JOIN  V_Clubs C  		ON C.ID = B.Club_ID
				LEFT OUTER JOIN  tlkp_MisConduct D  ON D.misconduct_id = A.MisConduct_ID
				LEFT OUTER JOIN  TBL_GAME   E  		ON E.GAME_ID = A.Game_ID
				LEFT OUTER JOIN  V_RefRptHdr F  	ON F.Game = A.Game_ID
				LEFT OUTER JOIN  TBL_CONTACT G  	ON G.CONTACT_ID	= F.RefereeId
	 where  A.EventType  = 1 
		#VARIABLES.Where_ClubSel#
	 Order  by C.Club_NAME, B.TeamName, A.PlayerName	
 --->

<cfquery name="maxDate" dbtype="query">
	SELECT max(GAME_DATE) as last_Date								
	  from getMisconds	
</cfquery>		

<CFIF maxDate.RECORDCOUNT>
	<cfset LastDate = dateFormat(maxDate.last_Date, "mm/dd/yyyy") >
<cfelse>
	<cfset LastDate = dateFormat(now(), "mm/dd/yyyy") >
</CFIF>
	
<cfset lastDateMinus8 = dateadd("d", -8, LastDate)>
		

<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
<tr class="tblHeading">
	<TD width="22%">#repeatString("&nbsp;",6)#Player</TD>
	<TD width="18%"><!--- Referee ---></TD>
    <TD width="07%">Game</TD>
	<TD width="13%"> Date Time</TD>
	<TD width="25%">Misconduct</TD>
	<TD width="10%">Event</TD>
</TR>
</TABLE>


	
<cfset holdClub = 0>
  
<div style="overflow:auto; height:500px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="3" align="left" border="0" width="100%">
<CFLOOP query="getMisconds">
	<!--- new club --->
	<cfif holdClub NEQ CLUB_ID>
		<cfset holdClub = CLUB_ID>
		<cfset holdTeam = 0>
		<tr class="tblHeading">
			<TD colspan=7>#ucase(CLUB_NAME)#</TD>
		</tr>
	</cfif>
	<!--- New Team --->
	<cfif holdTeam NEQ TEAM_ID>
		<cfset holdTeam = TEAM_ID>
		<TR bgcolor="##CCE4F1">
			<TD colspan=7><!--- #division# - ---> #ucase(TeamName)#</TD> <!--- #repeatString("&nbsp;",2)# --->
		</tr>
	</cfif>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
		<TD width="19%" class="tdUnderLine"> #repeatString("&nbsp;",6)# #PlayerName# </TD>
		<TD width="17%" class="tdUnderLine"> &nbsp;<!--- #LASTNAME#, #FIRSTNAME# ---> 		</TD>
		<TD width="06%" class="tdUnderLine"> &nbsp;<!--- <a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank">view rpt</a> --->	</TD>
		<TD width="05%" class="tdUnderLine" align="center"> #Game_ID#				 </TD>
		<TD width="18%" class="tdUnderLine" align="center">	#dateFormat(Game_Date, "mm/dd/yy")# #timeFormat(Game_Time, "hh:mm tt")#	</TD>
		<TD width="30%" class="tdUnderLine">				#lcase(Misconduct_Descr)#	 </TD>
		<TD width="05%" class="tdUnderLine">				#Misconduct_Event#	 </TD>
	</tr>
</CFLOOP>
</TABLE>
</div>   


</cfoutput>
</div>
<cfinclude template="_footer.cfm">


