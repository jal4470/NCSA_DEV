<!--- 
	FileName:	cautionEjectRpt.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

03/31/2009 - aarnone - change query to get rid of dupes
09/19/2011 -  Joe Lechuga -Added logic to catch the Start and End Filed Date period filter Modified Report to include date filed. 
09/12/2012 - J. Rab - Added createdate column to output for historic data
06/20/2016 - R. Gonzalez - Fixed order by for getMisconds and getALLMisconds queries
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker and sorter.

 --->
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

<cfif isdefined("form.season_id")>
	<cfset viewSeason=form.season_id>
	
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


<cfif isdefined("form.division")>
	<cfset division_id=form.division>
<cfelse>
	<cfset division_id="">
</cfif>

<cfif isdefined("form.weekend")>
	<cfset seldate=form.weekend>
<cfelse>
	<cfset seldate="">
</cfif>

<cfif isdefined("form.referee")>
	<cfset selref=form.referee>
<cfelse>
	<cfset selref="0">
</cfif>

<cfif isdefined("form.misconduct")>
	<cfset selmisconduct=form.misconduct>
<cfelse>
	<cfset selmisconduct="">
</cfif>

<cfif isdefined("form.event")>
	<cfset selevent=form.event>
<cfelse>
	<cfset selevent="">
</cfif>

<!---  Joe Lechuga - 9/19/2011 -  Added logic to catch the Start and End Filed Date period filter --->

 <cfif isdefined("form.from") and isdefined("form.to") and len(trim(form.from)) and len(trim(form.to)) and form.from neq form.to>
 	<cfset daterange = " and a.createdate between '" & form.from & "' and '" & form.to & "' ">
	<cfset from = form.from>
	<cfset to = form.to>
 <cfelseif isdefined("form.from") and isdefined("form.to") and len(trim(form.from)) and len(trim(form.to)) and form.from eq form.to>
 	<cfset daterange = " and datediff(d, a.createdate,'" & form.from & "') = 0 ">
 <cfelseif isdefined("form.from") and len(trim(form.from)) and not len(trim(form.to))>
 	<cfset daterange = " and datediff(d, a.createdate,'" & form.from & "') = 0 ">
	<cfset from = form.from>
	<cfset to = "">
 <cfelse>
 	<cfset daterange = "">
	<cfset from = "">
	<cfset to = "">
 </cfif>

 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<div id="contentText">

<H1 class="pageheading">
	NCSA - Caution/Ejection Report 
	<cfif isDefined("viewSeason")>
		<input id="printBtn" type="button" value="Print Report" />
		<input id="printBtnXLS" type="button" value="Download Report" />
	</cfif> 
</H1>

<!--- <br> <h2>yyyyyy </h2> --->


 <!--- don't run report unless a season is selected --->
 <cfif isdefined("form.season_id")>

 	<cfif viewHist>
		<cfquery name="getMisconds" datasource="#SESSION.DSN#">
			select a.game as game_id, a.serialno, a.playername, a.teamid as team_id, a.misconductid, b.division, c.teamname,
				a.teamid, d.club as club_name, d.id as club_id, misconductdesc as misconduct_descr, event as misconduct_event, b.gdate as game_date, b.gtime as game_time,
				'' as refereeid, '' as lastname, '' as firstname, a.dateupdated as createdate
				 from tbl_arch_misconduct a
				inner join tbl_archive_games_history b
				on a.game=b.game and a.season=b.season and a.year=b.year
				inner join v_archive_coachesteams c
				on a.teamid=c.id and a.season=c.season and a.year=c.year
				inner join v_archive_clubs d
				on c.clubid=d.id and c.season=d.season and c.year=d.year
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
	<h2 style="margin-bottom:10px;">Season: #season# #year# <a href="cautionEjectRpt.cfm" style="font-weight:normal; font-size:.7em;">Switch</a></h2>
</cfif>
	<cfif not isdefined("viewseason")>
		<form action="cautionEjectRpt.cfm" name="changeSeasonForm" method="post">
			<FONT color=blue><STRONG>Season</STRONG></FONT>
			<select name="season_id">
				<cfloop query="seasons">
					<cfif season_id NEQ "">
					<option style="text-align:right;" value="#seasons.season_id#" <cfif seasons.season_id EQ useSeason>selected="selected"</cfif>>#titleCase(season)# #year#</option>
					<cfelse>
						<option style="text-align:right;" value="#season##year#">#titleCase(season)# #year#</option>
					</cfif>
				</cfloop>
			</select>
			<input type="Submit" value="Enter">
		</form>
	<cfelse>

		<cfquery name="qDivisions" dbtype="query">
			SELECT	DISTINCT
					division
			  from  getALLMisconds
			  order by division
		</cfquery>
		
		 <CFQUERY name="qDates" dbtype="query">
			Select distinct Game_Date as gamedate
			  from getALLMisconds
			 order by Game_Date
		</CFQUERY>
		
		<cfquery name="qReferees" dbtype="query">
			select distinct refereeid, lastname, firstname
			from getALLMisconds
			order by lastname, firstname
		</cfquery>
		
		<cfquery name="qMisconducts" dbtype="query">
			select distinct Misconduct_ID, Misconduct_Descr
			from getALLMisconds
			order by misconduct_descr
		</cfquery>
		
		<cfquery name="qEvents" dbtype="query">
			select distinct misconduct_event
			from getALLMisconds
			order by misconduct_event
		</cfquery>
		<form action="cautionEjectRpt.cfm" method="post">
			<input type="hidden" name="season_id" value="#viewseason#">
			<TABLE cellSpacing=0 cellPadding=5 width="100%" align=center border="0">
				<TR>
					<TD align="right">
						<FONT color=blue><STRONG>Division</STRONG></FONT> &nbsp;
						<SELECT name="Division" style="WIDTH: 144px"> 
						<OPTION value="" selected>Show ALL Divisions</OPTION>
						<CFLOOP query="qDivisions">
						<OPTION value="#Division#" <cfif Division EQ VARIABLES.Division_id>selected</cfif> >#Division#</OPTION>
						</CFLOOP>
						</SELECT>
					</td>
					<td align="right">
						<STRONG><FONT color=##0000ff>Weekend</FONT></STRONG> &nbsp;
						<SELECT name="Weekend" style="WIDTH: 144px" > 
						<OPTION value="">Show ALL Weekends</OPTION>
						<CFLOOP query="qDates">
						<OPTION value="#DateFormat(GameDate,"mm/dd/yyyy")#" <cfif DateFormat(GameDate,"mm/dd/yyyy") EQ VARIABLES.selDate>selected</cfif> >#DateFormat(GameDate,"mm/dd/yyyy")#</OPTION>
						</CFLOOP>
						
						</SELECT>
					</TD>
					<td align="right">
						<STRONG><FONT color=##0000ff>Referee</FONT></STRONG> &nbsp;
						<SELECT name="referee" style="WIDTH: 144px" > 
						<OPTION value="0">Show ALL Referees</OPTION>
						<CFLOOP query="qReferees">
						<OPTION value="#refereeid#" <cfif refereeid EQ VARIABLES.selRef>selected</cfif> >#lastname#, #firstname#</OPTION>
						</CFLOOP>
						
						</SELECT>
					</TD>
				</TR>
				<tr>
					<TD align="right">
						<FONT color=blue><STRONG>Misconduct</STRONG></FONT> &nbsp;
						<SELECT name="misconduct" style="WIDTH: 144px"> 
						<OPTION value="" selected>Show ALL Misconducts</OPTION>
						<CFLOOP query="qMisconducts">
						<OPTION value="#misconduct_id#" <cfif misconduct_id EQ VARIABLES.selMisconduct>selected</cfif> >#misconduct_descr#</OPTION>
						</CFLOOP>
						</SELECT>
					</td>
					<td align="right">
						<STRONG><FONT color=##0000ff>Event</FONT></STRONG> &nbsp;
						<SELECT name="event" style="WIDTH: 144px" > 
						<OPTION value="">Show ALL Events</OPTION>
						<CFLOOP query="qEvents">
						<OPTION value="#misconduct_event#" <cfif misconduct_event EQ VARIABLES.selevent>selected</cfif> >#misconduct_event#</OPTION>
						</CFLOOP>
						
						</SELECT>
						
					</TD>
					<td align="right">
						<input type="Submit" name="enter" value="Enter">
					</td>
				</tr>
			</TABLE>
		</form>
	</cfif>	
	
<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
<cfif isdefined("viewSeason")>

<tr class="tblHeading">
<td colspan="7" style="color:white;" align="center">
<div   style="width:55%;border:1px solid white;margin:10px 10px 10px 10px;">
Report Filed date range.<br>
<form action="cautionEjectRpt.cfm" method="post">		
	<input type="Hidden" name="division" value="#division_id#">
	<input type="Hidden" name="weekend" value="#seldate#">
	<input type="Hidden" name="referee" value="#selref#">
	<input type="Hidden" name="misconduct" value="#selmisconduct#">
	<input type="Hidden" name="event" value="#selevent#">
	<input type="Hidden" name="season_id" value="#viewSeason#">
	
<label for="from" style="color:white;">From</label>
<input type="text" id="from" name="from" value="#From#"/>
<label for="to" style="color:white;">To</label>
<input type="text" id="to" name="to" value="#To#"/>
<input type="submit" value="Go!">		
</form>
<small style="padding-top:0px;">(Select the Same date for both to view single date)</small><br>
</div>
</td></tr>
</cfif>
<tr class="tblHeading">
<td colspan="7" style="color:red;background:white;" align="center">
Click on game number to View Referee Match Report!
</td>
</tr>
<tr class="tblHeading">
	<TD width="22%">#repeatString("&nbsp;",6)#Player</TD>
	<TD width="15%">Referee</TD>
	<td width="8%">Filed On</td>
    <TD width="07%">Game</TD>
	<TD width="13%"> Date Time</TD>
	<TD width="25%">Misconduct</TD>
	<TD align="center">Event</TD>
</TR>
</TABLE>


<cfif isdefined("getMisconds")>
	<cfset holdClub = 0>
	  
	<div style="overflow:auto; border:1px ##cccccc solid;">
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
				<TD colspan=7>#division# - #ucase(TeamName)#</TD> <!--- #repeatString("&nbsp;",2)# --->
			</tr>
		</cfif>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="19%" class="tdUnderLine"> #repeatString("&nbsp;",6)# #PlayerName# </TD>
			<TD width="19%" class="tdUnderLine">
				<cfif viewHist>
					&nbsp;
				<cfelse>
					#LASTNAME#, #FIRSTNAME#
				</cfif> 
			</TD>
			<TD width="06%" class="tdUnderLine"> 
				#dateformat(createdate,"MM-DD-YYYY")#
			</TD>
			<TD width="05%" class="tdUnderLine" align="center"> 		
				<cfif swIsClub OR viewHist>
					#Game_ID#
				<cfelse>	
					<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank">#Game_ID#</a>	
				</cfif>				 </TD>
			<TD width="16%" class="tdUnderLine" align="center">	
					<!--- <cfif Game_Date GT lastDateMinus8>
						<font color=red>
					</cfif> --->
					#dateFormat(Game_Date, "mm/dd/yy")# #timeFormat(Game_Time, "hh:mm tt")#	
					<!--- <cfif Game_Date GT lastDateMinus8>
						</font> 
					</cfif> --->
			</TD>
			<TD width="30%" class="tdUnderLine">				#lcase(Misconduct_Descr)#	 </TD>
			<TD  class="tdUnderLine">				#Misconduct_Event#	 </TD>
		</tr>
	</CFLOOP>
	</TABLE>
	</div>   
</cfif>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script src="assets/Datepicker/jquery.ui.core.js"></script>
	<script src="assets/Datepicker/jquery.ui.widget.js"></script>
<script>
	$(function() {
		var dates = $( "##from, ##to" ).datepicker({
			defaultDate: "+1w",
			changeMonth: true,
			numberOfMonths: 1,
			onSelect: function( selectedDate ) {
				var option = this.id == "from" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
		<cfif isDefined("viewSeason")>
			$("##printBtn").click(function () {
				window.open('cautionEjectRpt_PDF.cfm?division=#division_id#&season_id=#viewSeason#&weekend=#seldate#&referee=#selref#&misconduct=#selmisconduct#&event=#selevent#&from=#from#&to=#to#');
			});
			$("##printBtnXLS").click(function () {
				window.open('cautionEjectRpt_CSV.cfm?division=#division_id#&season_id=#viewSeason#&weekend=#seldate#&referee=#selref#&misconduct=#selmisconduct#&event=#selevent#&from=#from#&to=#to#');
			});
		</cfif>
	});
	</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">



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

return string;
}
</cfscript>
