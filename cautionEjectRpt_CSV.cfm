<!------------------------------------------------
MODIFICATIONS
8/14/2017 - apinzone - NCSA27024 
-- changed orientation to landscape
--------------------------------------------------->


<!------> <cfheader name="Content-Disposition" 
value="inline; filename=cautionEjectRpt.xls">
<cfcontent type="application/xls"> 
	<cfoutput>
	<html>
	<head>
		<title>Caution Ejection Report</title>

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
<H1 class="pageheading">NCSA - Caution/Ejection Report </H1>
<!--- <br> <h2>yyyyyy </h2> --->


<CFSET Where_ClubSel = "">
<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
	<CFSET Where_ClubSel	= "  AND B.Club_Id = " & SESSION.USER.CLUBID & " " >
	<cfset histWhere_clubsel = " and d.id = " & session.user.clubid & " " >
	<cfset swIsClub = true>
<cfelse>
	<CFSET Where_ClubSel	= "  AND B.Club_Id > 0 " >
	<CFSET histWhere_ClubSel	= "  AND d.Id > 0 " >
	<cfset swIsClub = false>
</cfif>

<cfif isdefined("url.season_id")>
	<cfset viewSeason=url.season_id>
	
	<cfif not isnumeric(viewSeason)>
		<cfset viewHist=true>
		<cfset year=right(viewSeason,4)>
		<cfset season=replace(viewSeason,year,"")>
	<cfelse>
		<cfset viewHist=false>
	</cfif>
<cfelse>
	<cfset viewHist = 0>
	<cfset season = session.currentseason.code>
	<cfset year = session.currentseason.year>
</cfif>


<cfif isdefined("url.division")>
	<cfset division_id=url.division>
<cfelse>
	<cfset division_id="">
</cfif>

<cfif isdefined("url.weekend")>
	<cfset seldate=url.weekend>
<cfelse>
	<cfset seldate="">
</cfif>

<cfif isdefined("url.referee")>
	<cfset selref=url.referee>
<cfelse>
	<cfset selref="0">
</cfif>

<cfif isdefined("url.misconduct")>
	<cfset selmisconduct=url.misconduct>
<cfelse>
	<cfset selmisconduct="">
</cfif>

<cfif isdefined("url.event")>
	<cfset selevent=url.event>
<cfelse>
	<cfset selevent="">
</cfif>
<!---  Joe Lechuga - 9/19/2011 -  Added logic to catch the Start and End Filed Date period filter --->

 <cfif isdefined("url.from") and isdefined("url.to") and len(trim(url.from)) and len(trim(url.to)) and url.from neq url.to>
 	<cfset daterange = " and a.createdate between '" & url.from & "' and '" & url.to & "' ">
	<cfset from = url.from>
	<cfset to = url.to>
 <cfelseif isdefined("url.from") and isdefined("url.to") and len(trim(url.from)) and len(trim(url.to)) and url.from eq url.to>
 	<cfset daterange = " and datediff(d, a.createdate,'" & url.from & "') = 0 ">
 <cfelseif isdefined("url.from") and len(trim(url.from)) and not len(trim(url.to))>
 	<cfset daterange = " and datediff(d, a.createdate,'" & url.from & "') = 0 ">
	<cfset from = url.from>
	<cfset to = "">
 <cfelse>
 	<cfset daterange = "">
	<cfset from = "">
	<cfset to = "">
 </cfif>
 <!--- don't run report unless a season is selected --->
 <cfif isdefined("URL.season_id")>

 	<cfif viewHist>
		<cfquery name="getMisconds" datasource="#SESSION.DSN#">
			select a.game as game_id, a.serialno, a.playername, a.teamid as team_id, a.misconductid, b.division, c.teamname,
				a.teamid, d.club as club_name, d.id as club_id, misconductdesc as misconduct_descr, event as misconduct_event, b.gdate as game_date, b.gtime as game_time,
				'' as refereeid, '' as lastname, '' as firstname, a.dateupdated as createdate,
				replace(cast(rh.comments as varchar(max)),'â€™', '''') comments
				 from tbl_arch_misconduct a
				inner join tbl_archive_games_history b
				on a.game=b.game and a.season=b.season and a.year=b.year
				inner join v_archive_coachesteams c
				on a.teamid=c.id and a.season=c.season and a.year=c.year
				inner join v_archive_clubs d
				on c.clubid=d.id and c.season=d.season and c.year=d.year
				left join tbl_referee_RPT_header rh on rh.game_id = a.game_id
				where a.season=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#season#"> and a.year=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#year#">
				<cfif isdefined("division_id") AND division_id NEQ "">
					and b.division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#division_id#">
				</cfif>
				<cfif isdefined("seldate") AND seldate NEQ "">
					and b.gdate = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#seldate#">
				</cfif>
				<cfif isdefined("selmisconduct") AND selmisconduct NEQ "">
					and a.misconductid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#selmisconduct#">
				</cfif>
				<cfif isdefined("selevent") AND selevent NEQ "">
					and event = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#selevent#">
				</cfif>
				#preservesinglequotes(daterange)#
				#VARIABLES.histWhere_ClubSel#
			 Order by d.club, c.TeamName, A.PlayerName	
		</cfquery>
		<cfquery name="getALLMisconds" datasource="#SESSION.DSN#">
			select a.game as game_id, a.serialno, a.playername, a.teamid as team_id, a.misconductid as misconduct_id, b.division, c.teamname,
				a.teamid, d.club as club_name, d.id as club_id, misconductdesc as misconduct_descr, event as misconduct_event, b.gdate as game_date, b.gtime as game_time,
				'' as refereeid, '' as lastname, '' as firstname
				 from tbl_arch_misconduct a
				inner join tbl_archive_games_history b
				on a.game=b.game and a.season=b.season and a.year=b.year
				inner join v_archive_coachesteams c
				on a.teamid=c.id and a.season=c.season and a.year=c.year
				inner join v_archive_clubs d
				on c.clubid=d.id and c.season=d.season and c.year=d.year
				where a.season=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#season#"> and a.year=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#year#">
				#VARIABLES.histWhere_ClubSel#
			 Order by d.club, c.TeamName, A.PlayerName	
		</cfquery>
	<cfelse>
		 <cfquery name="getMisconds" datasource="#SESSION.DSN#">
			SELECT	DISTINCT
					a.Game_ID, a.Serial_No, a.PlayerName, a.TeamID, a.Misconduct_ID, 
					dbo.f_get_division(b.team_id) AS Division,			   
					dbo.GetTeamName(A.TeamID) AS TeamName, b.TEAM_ID,
					C.CLUB_NAME, C.CLUB_ID,
					D.MisConduct_Descr, D.Misconduct_event,
					E.GAME_DATE, E.GAME_TIME,
					F.RefereeId,
					G.LASTNAME, G.FIRSTNAME,
					s.seasoncode,a.createdate, replace(cast(rh.comments as varchar(max)),'â€™', '''') comments
			  from  TBL_Referee_RPT_Detail  A 
						INNER JOIN  TBL_TEAM  B  		ON b.TEAM_ID = A.TeamID 
						INNER JOIN  V_Clubs C  		ON C.ID = B.Club_ID
						INNER JOIN  tlkp_MisConduct D  ON D.misconduct_id = A.MisConduct_ID
						INNER JOIN  TBL_GAME   E  		ON E.GAME_ID = A.Game_ID
						INNER JOIN  V_RefRptHdr F  	ON F.Game = A.Game_ID
						INNER JOIN  TBL_CONTACT G  	ON G.CONTACT_ID	= F.RefereeId
						LEFT JOIN tbl_season s on e.season_id=s.season_id
						left join tbl_referee_RPT_header rh on rh.game_id = a.game_id
			 where  A.EventType  = 1 
			 	and e.season_id=#viewSeason#
				<cfif isdefined("division_id") AND division_id NEQ "">
					and dbo.f_get_division(b.team_id) = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#division_id#">
				</cfif>
				<cfif isdefined("seldate") AND seldate NEQ "">
					and e.game_date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#seldate#">
				</cfif>
				<cfif isdefined("selmisconduct") AND selmisconduct NEQ "">
					and a.Misconduct_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#selmisconduct#">
				</cfif>
				<cfif isdefined("selevent") AND selevent NEQ "">
					and d.misconduct_event = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#selevent#">
				</cfif>
				<cfif isdefined("selref") AND selref NEQ "0">
					and f.refereeid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#selref#">
				</cfif>
				#preservesinglequotes(daterange)#
				#VARIABLES.Where_ClubSel#
			 -- Order by C.Club_NAME, B.TeamName, A.PlayerName	
			 Order by C.Club_NAME, dbo.GetTeamName(A.TeamID), A.PlayerName	
		</cfquery>
		
		 <cfquery name="getALLMisconds" datasource="#SESSION.DSN#">
			SELECT	DISTINCT
					a.Game_ID, a.Serial_No, a.PlayerName, a.TeamID, a.Misconduct_ID, 
					dbo.f_get_division(b.team_id) AS Division,			   
					dbo.GetTeamName(A.TeamID) AS TeamName, b.TEAM_ID,
					C.CLUB_NAME, C.CLUB_ID,
					D.MisConduct_Descr, D.Misconduct_event,
					E.GAME_DATE, E.GAME_TIME,
					F.RefereeId,
					G.LASTNAME, G.FIRSTNAME,
					s.seasoncode,a.createdate
			  from  TBL_Referee_RPT_Detail  A 
						INNER JOIN  TBL_TEAM  B  		ON b.TEAM_ID = A.TeamID 
						INNER JOIN  V_Clubs C  		ON C.ID = B.Club_ID
						INNER JOIN  tlkp_MisConduct D  ON D.misconduct_id = A.MisConduct_ID
						INNER JOIN  TBL_GAME   E  		ON E.GAME_ID = A.Game_ID
						INNER JOIN  V_RefRptHdr F  	ON F.Game = A.Game_ID
						INNER JOIN  TBL_CONTACT G  	ON G.CONTACT_ID	= F.RefereeId
						LEFT JOIN tbl_season s on e.season_id=s.season_id
			 where  A.EventType  = 1 
			 	and e.season_id=#viewSeason#
				#VARIABLES.Where_ClubSel#
			 -- Order by C.Club_NAME, B.TeamName, A.PlayerName	
			 Order by C.Club_NAME, dbo.GetTeamName(A.TeamID), A.PlayerName	
		</cfquery>
	</cfif>
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
	
</cfif>

<!--- get all seasons --->
<cfinvoke 
	component="#SESSION.SITEVARS.cfcPath#season"
	method="getAllSeasonsWithArchive" 
	returnvariable="seasons">
</cfinvoke>

<cfinvoke
	component="#session.sitevars.cfcpath#season"
	method="getUseSeason"
	returnvariable="useSeason">

	
<cfif isdefined("viewseason")>
	<cfif not viewHist>
		<!--- get season --->
		<cfinvoke 
			component="#SESSION.SITEVARS.cfcPath#season" 
			method="getSeasonInfoByID" 
			seasonid=#viewSeason# 
			returnvariable="seasonInfo">
		</cfinvoke>
		<cfset year=seasoninfo.season_year>
		<cfset season=seasoninfo.season_sf>
	</cfif>
	<h2 style="margin-bottom:10px;">Season: #season# #year#</h2>
</cfif>

<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD>Club Name</TD>
		<TD>Division</TD>
		<TD>Team Name</TD>
		<TD>Player</TD>
		<TD>Referee</TD>
		<TD>Filed On</TD>
		<TD>Game</TD>
		<TD>Date Time</TD>
		<TD>Misconduct</TD>
		<TD>Event</TD>
		<TD>Comments</TD>
	</TR>
	<cfif isdefined("getMisconds")>
		<CFLOOP query="getMisconds">
			<!--- new club --->
				<tr>
					<TD>#ucase(CLUB_NAME)#</TD>
					<TD>#division#</TD>
					<TD>#ucase(TeamName)#</TD>
					<TD class="tdUnderLine"> #repeatString("&nbsp;",6)# #PlayerName# </TD>
					<TD class="tdUnderLine">
					<cfif viewHist>
						&nbsp;
					<cfelse>
						#LASTNAME#, #FIRSTNAME#
					</cfif> 
					</TD>
					<TD class="tdUnderLine"> 
						#dateformat(createdate,"MM-DD-YYYY")#
					</TD>
					<TD class="tdUnderLine" align="center"> 		
						<cfif swIsClub OR viewHist>
							#Game_ID#
						<cfelse>	
							#Game_ID#	
						</cfif>				 </TD>
					<TD class="tdUnderLine" align="center">	#datetimeformat(createdate, 'mm/dd/yyyy h:n tt')#
					</TD>
					<TD class="tdUnderLine">				#lcase(Misconduct_Descr)#	 </TD>
					<TD  class="tdUnderLine">				#Misconduct_Event#	 </TD>
					<TD class="tdUnderLIne">#titleCase(comments)#</TD>
				</tr>
		</CFLOOP>
	</cfif>
	</TABLE>
</div>
</body>
</html>
	</cfoutput>


<cfscript>
/*
 * function - titleCase()
 * accepts and returns string data
 * this function is similar to LCase or UCase,
 * http://livedocs.macromedia.com/coldfusion/6.1/htmldocs/functiob.htm
 * http://livedocs.macromedia.com/coldfusion/6.1/htmldocs/funca112.htm
 * it formats a string according to predefined rules.
 * first it separates test so that it is formatted
 * With All Words With Initial Capital Letters
 * And With The Rest Of The Letters In Lowercase,
 * then, it takes special cases and adjusts, for example,
 * it changes some words, like Of and The to of and the,
 * when they are not the first part of a string,
 * also, it adjusts for names like McKenna.
 * it was designed for the college database which was provided
 * in ALLCAPS.
 * questions? http://artlung.com/feedback/
 * 2003/04/22
*/

function titleCase(string)  {
	if (len(string) gt 1)
	{
		string = lcase(string);

		if (refind("^[a-z]", string))  {
		string = ucase(left(string, 1)) & right(string,
(len(string) - 1 ));
		}

		next = refind("[[:space:][:punct:]][a-z]", string);

		while (next)  {
			if (next lt (len(string) - 1)) {
			string = left(string, (next)) & ucase(mid(string,
next+1, 1)) &  right(string, (len(string) - (next + 1)));
			} else {
			string = left(string, (next)) &
ucase(right(string, 1));
			}

		next = refind("[[:space:][:punct:]][a-z]", string, next);
		}
	} else {
	string = ucase(string);

	}
	/* post fixes */
	/* Recall that "Replace()" is case sensitive */
	string = Replace(string," Of "," of ","ALL");
	string = Replace(string," And "," and ","ALL");
	string = Replace(string,"'S ","'s ","ALL");
	string = Replace(string," At "," at ","ALL");
	string = Replace(string," The "," the ","ALL");
	string = Replace(string," For "," for ","ALL");
	string = Replace(string," De "," de ","ALL");
	string = Replace(string," Y "," y ","ALL");
	string = Replace(string," In "," in ","ALL");

	/* roman numerals */
	string = Replace(string," Iii"," III","ALL");
	string = Replace(string," Ii"," II","ALL");

	/* specific cases of acronyms */
	string = Replace(string,"Abc ","ABC ","ALL");
	string = Replace(string,"Abcd","ABCD ","ALL");
	string = Replace(string,"Aaa ","AAA ","ALL");
	string = Replace(string,"Cbe ","CBE ","ALL");
	string = Replace(string,"Cei ","CEI ","ALL");
	string = Replace(string,"Itt ","ITT ","ALL");
	string = Replace(string,"Mbti ","MBTI ","ALL");
	string = Replace(string,"Cuny ","CUNY ","ALL");
	string = Replace(string,"Suny ","SUNY ","ALL");
	string = Replace(string,"Mta ","MTA ","ALL");
	string = Replace(string,"Mti ","MTI ","ALL");
	string = Replace(string,"Qpe ","QPE ","ALL");
	string = Replace(string," Ogc "," OGC ","ALL");
	string = Replace(string,"Tci ","TCI ","ALL");
	string = Replace(string,"The Cdl ","The CDL ","ALL");
	string = Replace(string,"The Mbf ","The MBF","ALL");
	string = Replace(string,"Lpn","LPN","ALL");
	string = Replace(string,"Cvph ","CVPH ","ALL");
	string = Replace(string,"Dch ","DCH ","ALL");
	string = Replace(string,"Bmr ","BMR ","ALL");
	string = Replace(string,"Isim ","ISIM ","ALL");

	/* contractions */
	string = Replace(string," Mgt"," Management","ALL");
	string = Replace(string,"Trng","Training","ALL");
	string = Replace(string,"Xray","X-Ray","ALL");
	string = Replace(string," Sch "," School ","ALL");
	string = Replace(string," Dba "," dba ","ALL");

	/* specific names with special case */
	string = Replace(string,"Mcc","McC","ALL");
	string = Replace(string,"Mcd","McD","ALL");
	string = Replace(string,"Mch","McH","ALL");
	string = Replace(string,"Mcg","McG","ALL");
	string = Replace(string,"Mci","McI","ALL");
	string = Replace(string,"Mck","McK","ALL");
	string = Replace(string,"Mcl","McL","ALL");
	string = Replace(string,"Mcm","McM","ALL");
	string = Replace(string,"Mcn","McN","ALL");
	string = Replace(string,"Mcp","McP","ALL");

	/* adding punctuation */
	string = Replace(string," Inc",", Inc","ALL");
	string = Replace(string,"Ft ","Ft. ","ALL");
	string = Replace(string,"St ","St. ","ALL");
	string = Replace(string,"Mt ","Mt. ","ALL");

	/* U.S. state abbreviations */
	string = Replace(string, " Ak ", " AK ", " ALL ");
	string = Replace(string, " As ", " AS ", " ALL ");
	string = Replace(string, " Az ", " AZ ", " ALL ");
	string = Replace(string, " Ar ", " AR ", " ALL ");
	string = Replace(string, " Ca ", " CA ", " ALL ");
	string = Replace(string, " Co ", " CO ", " ALL ");
	string = Replace(string, " Ct ", " CT ", " ALL ");
	string = Replace(string, " De ", " DE ", " ALL ");
	string = Replace(string, " Dc ", " DC ", " ALL ");
	string = Replace(string, " Fl ", " FL ", " ALL ");
	string = Replace(string, " Ga ", " GA ", " ALL ");
	string = Replace(string, " Gu ", " GU ", " ALL ");
	string = Replace(string, " Hi ", " HI ", " ALL ");
	string = Replace(string, " Id ", " ID ", " ALL ");
	string = Replace(string, " Il ", " IL ", " ALL ");
	string = Replace(string, " In ", " IN ", " ALL ");
	string = Replace(string, " Ia ", " IA ", " ALL ");
	string = Replace(string, " Ks ", " KS ", " ALL ");
	string = Replace(string, " Ky ", " KY ", " ALL ");
	string = Replace(string, " La ", " LA ", " ALL ");
	string = Replace(string, " Me ", " ME ", " ALL ");
	string = Replace(string, " Md ", " MD ", " ALL ");
	string = Replace(string, " Mh ", " MH ", " ALL ");
	string = Replace(string, " Ma ", " MA ", " ALL ");
	string = Replace(string, " Mi ", " MI ", " ALL ");
	string = Replace(string, " Fm ", " FM ", " ALL ");
	string = Replace(string, " Mn ", " MN ", " ALL ");
	string = Replace(string, " Ms ", " MS ", " ALL ");
	string = Replace(string, " Mo ", " MO ", " ALL ");
	string = Replace(string, " Mt ", " MT ", " ALL ");
	string = Replace(string, " Ne ", " NE ", " ALL ");
	string = Replace(string, " Nv ", " NV ", " ALL ");
	string = Replace(string, " Nh ", " NH ", " ALL ");
	string = Replace(string, " Nj ", " NJ ", " ALL ");
	string = Replace(string, " Nm ", " NM ", " ALL ");
	string = Replace(string, " Ny ", " NY ", " ALL ");
	string = Replace(string, " Nc ", " NC ", " ALL ");
	string = Replace(string, " Nd ", " ND ", " ALL ");
	string = Replace(string, " Mp ", " MP ", " ALL ");
	string = Replace(string, " Oh ", " OH ", " ALL ");
	string = Replace(string, " Ok ", " OK ", " ALL ");
	string = Replace(string, " Or ", " OR ", " ALL ");
	string = Replace(string, " Pw ", " PW ", " ALL ");
	string = Replace(string, " Pa ", " PA ", " ALL ");
	string = Replace(string, " Pr ", " PR ", " ALL ");
	string = Replace(string, " Ri ", " RI ", " ALL ");
	string = Replace(string, " Sc ", " SC ", " ALL ");
	string = Replace(string, " Sd ", " SD ", " ALL ");
	string = Replace(string, " Tn ", " TN ", " ALL ");
	string = Replace(string, " Tx ", " TX ", " ALL ");
	string = Replace(string, " Ut ", " UT ", " ALL ");
	string = Replace(string, " Vt ", " VT ", " ALL ");
	string = Replace(string, " Va ", " VA ", " ALL ");
	string = Replace(string, " Vi ", " VI ", " ALL ");
	string = Replace(string, " Wa ", " WA ", " ALL ");
	string = Replace(string, " Wv ", " WV ", " ALL ");
	string = Replace(string, " Wi ", " WI ", " ALL ");
	string = Replace(string, " Wy ", " WY ", " ALL ");
	string = Replace(string, chr(8208), "-", "ALL");
	string = Replace(string, chr(8209), "-", "ALL");
	string = Replace(string, chr(8210), "&ndash;", "ALL");
	string = Replace(string, chr(8211), "&ndash;", "ALL");
	string = Replace(string, chr(8212), "&mdash;", "ALL");
	string = Replace(string, chr(8213), "&mdash;", "ALL");
	string = Replace(string, chr(8214), "||", "ALL");
	string = Replace(string, chr(8215), "_", "ALL");
	string = Replace(string, chr(8216), "&lsquo;", "ALL");
	string = Replace(string, chr(8217), "&rsquo;", "ALL");
	string = Replace(string, chr(8218), ",", "ALL");
	string = Replace(string, chr(8219), "'", "ALL");
	string = Replace(string, chr(8220), "&ldquo;", "ALL");
	string = Replace(string, chr(8221), "&rdquo;", "ALL");
	string = Replace(string, chr(8222), """", "ALL");
	string = Replace(string, chr(8223), """", "ALL");
	string = Replace(string, chr(8226), "&middot;", "ALL");
	string = Replace(string, chr(8227), "&gt;", "ALL");
	string = Replace(string, chr(8228), ".", "ALL");
	string = Replace(string, chr(8229), "..", "ALL");
	string = Replace(string, chr(8230), "...", "ALL");
	string = Replace(string, chr(8231), "&middot;", "ALL");
	return string;
}
</cfscript>
