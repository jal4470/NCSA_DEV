<!--- 
	FileName:	agebracket.cfm
	Created on: 08/15/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: calculates the age based on birth date to figure out proper age bracket 
	
MODS: mm/dd/yyyy - filastname - comments
12/11/08 - AA - fixed js so it will work in firefox
7-29-2014	-	J. Danz	-	(TICKET NCSA15482) - made copy and table changes requested in ticket, fixed js since it broke from not having DOM nodes that were removed from table.
5/12/2016 - R.Gonzalez (TICKET NCSA22392 ) - changed copy for Click for Next Year Calculations to Click Here for 2016-17 Calculations. Changed url of same link to formsView.cfm?form_id=213
05/23/2016 - R.Gonzalez (TICKET NCSA22392 ) - Added logic to derrive start dates based on the year to show the new dates mentioned by client but keep the existing dates for this year.
6/14/2016 - R. Gonzalez (TICKET NCSA26774) - changes logic around the setting of the start year based on what the current month is
6/15/2016 - J Lechuga (TICKET NCSA26774) - Changed year logic to use the value of the current season. Updated logic around Age groups, it appears that the starting point was a year behind. Updated Copy on page.
8/16/2018 M Greenberg (Ticket NCSA27075) - updated style to make responsive
 --->
 
<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">

<cfsavecontent variable="localStyle">
	<style>
		p{
			margin:10px 0;
		}
		p b{
			font-size:16px;
			margin-right:2px;
		}
	 	tr {
	    border: 0;
	    border-radius: 0;
	    display: table-row;
	    float: none;
	    margin: 0;
	    padding: 0;
	    width: 100%; }
	      tr:after {
	      display: none; }
	   tr:nth-child(odd) {
	      margin: 0; }
  		tr:nth-child(even) {
	      background: ##E1E1E1; }
	     thead { 
    		display: table-header-group; }
	    th{
	    	background: transparent;
	    	background-color: ##FFFFFF;
		    border-top: 1px solid ##AEAEAE;
		    border-bottom: 1px solid ##AEAEAE;
		    color: ##333;
		    font-size: 11px;
		    padding: 15px 0;
		    text-transform: uppercase; }
	    td {
		    display: table-cell;
		    float: none;
		    font-size: 11px;
		    margin: 0;
		    padding: 10px 5px;
		    text-align: center;
		    width: auto;}
	    td {
	      display: table-cell; }

	    td.title {
	      background: transparent;
	      border-radius: 0;
	      color: inherit;
	      padding: 10px 0;
	      font-weight: normal;
	      text-align: right; }
	      
	     td.name { 
	      position: relative; }
		h3{
			background: ##E1E1E1;
			clear: both;
			color: ##1A1A1A;
			font-size: 1em;
			font-weight: 400;
			line-height: 1.5;
			margin: 20px -20px;
			padding: 10px 20px;
			text-align: center;
		}
		.checkage{
			text-align: center;
			box-sizing: content-box;
			width: 100%;
		}
		.select_box{
			float: none !important;
			margin-left: 1.5em; 
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#localStyle#">
<CFIF isDefined("URL.YearSel")>
	<CFSET YearSel = URL.YearSel>
<CFELSE>
	<CFSET YearSel = "">
</CFIF>
<!--- set up array for periods --->
<CFSET Period[ 1][1] =  8 >
<CFSET Period[ 2][1] =  9 >
<CFSET Period[ 3][1] = 10 >
<CFSET Period[ 4][1] = 11 >
<CFSET Period[ 5][1] = 12 >
<CFSET Period[ 6][1] = 13 >
<CFSET Period[ 7][1] = 14 >
<CFSET Period[ 8][1] = 15 >
<CFSET Period[ 9][1] = 16 >
<CFSET Period[10][1] = 17 >
<CFSET Period[11][1] = 18 >
<CFSET Period[12][1] = 19 >

<!---  The period runs from August 1st till July 31st
	' We change the date to August 1st (start of period)
	' So, for a date which is greater then August 1st, should be made August 1st
 --->

<CFSET Today = NOW()>

<CFSET StartDay   = 1>	<!--- Always first of the month --->
<!--- <CFSET StartMonth = 8> --->	<!--- Always start from 8 i.e, August --->
<CFSET StartMonth = 1>	<!--- Always start from 1 --->
<CFSET EndMonth = 12> <!--- Always end at 12 --->

<!--- Set StartYear to the current year --->
<!--- 
Removed since the logic is based on the current season
<CFSET StartYear = datePart("yyyy",Today)> --->

<!--- Set CurrentMonth to the current month for SPRING/FALL check below --->
<CFSET CurrentMonth = datePart("m",Today)>

<!--- If YearSel equals to N increase the start year by 1 to represent the next year values --->
<!---<CFIF trim(YearSel) EQ "N">
	<CFSET StartYear = StartYear + 1>
</CFIF> --->

<!--- If in SPRING season display CURRENT YEAR - 1 / CURRENT YEAR  --->
<!--- <cfif CurrentMonth lt 8>
	<CFSET CalcPeriod = StartYear - 1 & " - " & StartYear>
ELSE in FALL season display CURRENT YEAR / CURRENT YEAR + 1
<cfelse>
	<CFSET CalcPeriod = StartYear & " - " & StartYear + 1>
</cfif>
 --->


<!--- <CFIF datePart("m",today) LT 8>
	<CFSET StartYear = StartYear - 1>  Set the Year to the begining of August - July Period
</CFIF> --->
<cfquery name="getCurrentSeason" datasource="#application.dsn#">
	Select season_year, 
	case when season_SF = 'SPRING' then season_year - 1 else season_year end as Start_Year,
	case when season_SF = 'FALL' then season_year + 1 else season_year end as End_Year 
	from tbl_season where currentSeason_yn = 'Y'
</cfquery>
<cfif getCurrentSeason.recordcount gt 0>
	<CFSET StartYear = getCurrentSeason.Start_Year>
	<CFSET EndYear = getCurrentSeason.End_Year>
</cfif>

<!--- R. Gonzalez - Ticket NCSA22392 - Added check of year to set dates to the new dates specified by client. 2016 keeps August start date and July end date, else start January and December end date  --->
<!------> 
<!--- <CFIF StartYear EQ "2016">
	<CFSET StartMonth = 8>
	<CFSET EndMonth = 7>
<CFELSE> --->
	<CFSET StartMonth = 1>
	<CFSET EndMonth = 12>
<!--- </CFIF> 
 --->
<CFIF trim(YearSel) EQ "N">
	
	<CFSET CalcPeriod = StartYear + 1 & " - " & EndYear + 1>
	<!--- Adjust for player dates --->
	<CFSET StartYear = StartYear + 2>
<CFELSE>
	<CFSET CalcPeriod = StartYear & " - " & EndYear>
	<CFSET StartYear = StartYear + 1>
</CFIF> 

<!--- Create StartDate object for the cfloop that lists the different playgroups and their birthdate time --->
<CFSET StartDate  = createDate(StartYear, StartMonth, StartDay)>

<h1 class="pageheading">NCSA - Age brackets for play groups for Season #CalcPeriod#</h1>

<FORM name="PlayGroup" action=""  method="post">
<TABLE cellSpacing=0 cellPadding=5 width="100%" align="center" border=0>
	<tr><td colspan="5">
			<cfif trim(YearSel) EQ "N">
				<a href="agebracket.cfm">Click for Current Year Calculations</a>
			<cfelse>
				<a href="agebracket.cfm?YearSel=N">Click for Next Year Calculations</a>
				<!--- <a href="formsView.cfm?form_id=213">Click Here for 2016-17 Calculations</a> --->
			</cfif>
			<!---
				There is often confusion about the typical play group based upon a player&apos;s birthdate as opposed to any play group in which the player is eligible to play. Typically, players play at the youngest age level for which they are eligible; the chart below and the check birthdate function are based upon that concept. It is also true under current sponsoring organization guidelines that a player may always &quot;play up&quot; in an age group older than that player&apos;s typical age group; for example, a player eligible for a U13 team can be registered on a U14 or older team. However, under those same guidelines, a player may never &quot;play down&quot; to an age group younger than that player&apos;s age group; for example, a player eligible for a U13 team may not be registered to a U12 or younger team. The check birthdate function produces the typical or youngest age group for that birthdate. PLEASE NOTE: each club may set its own rules whether a player may be registered in an age group older than typical for that player&apos;s birthdate; no club is obligated to allow this even though the sponsoring organization allows it.
				--->
		<!--- 		<b><u>New USSF Calendar Year Age Group</u></b>. As was announced by the league during the Fall 2015 season, NCSA will be implementing the calendar year group definitions beginning with the Fall 2016 season. The United States Soccer Federation (USSF) mandated the Calendar year age group beginning with the 2016/2017 rosters effective 8/1/2016. US Club Soccer, along with all other youth USSF affiliated members, adopted the USSF mandate. NCSA is a US Club Soccer sanctioned league and therefore NCSA must comply.
				<p>
				<b>Age   Group   Play.</b>    Typically,   players   play   at   the   youngest   age   level   for   which   they are eligible. However,  please  note  that  under  current  US  Club  Soccer  guidelines  a  player  may "play up" in an age group older than that player's typical age group. (Example: A player eligible for  a  13  team  can  be  registered  on  a  U14  or  older  team.) Under  those  same  guidelines,  a player may not play down" to an age group younger than that player's age group. (Example: A player  eligible  for  a  U13  team may  not be  registered  to  a  U12  or  younger  team.) The  check birthdate function produces the typical or youngest age group for that birthdate according to the chart below.  PLEASE NOTE: Each club may set its own rules whether a player may be registered in  an  age  group  older  than typical  for  that  player's  birthdate;  no  club  is  obligated  to  allow  this even though US Club Soccer allows it.
				<p>
				<b>Fall Play for U15 Players.</b>  There have been many questions and concerns regarding the U15 age  group  since  typically some  of  those  players  will  be  in  8th grade  and  some  will  be  in  high school.  The former age brackets were more closely aligned with school year eligibility, but every school district had its own cutoff date, so there was always an age group that had some HS age players.  The change to calendar year also changed the age bracket designations, so now U15 is the  age  group  with  HS players.   NCSA  will continue  to provide Fall play  opportunity  for  those players in the U15 age group since many U15 players will not be in HS. --->
				<p><b><u>USSF Calendar Year Age Group</u></b>. NCSA must follow the calendar year age group definitions established by the United States Soccer Federation (USSF). US Club Soccer, along with all other youth USSF affiliated members, adopted the USSF mandate. NCSA is a US Club Soccer sanctioned league and therefore NCSA must comply.
				<p><b><u>Age Group Play</u></b>    Typically, players play at the youngest age level for which they are eligible. However, please note that under current US Club Soccer guidelines a player may "play up" in an age group older than that player's typical age group. (Example: A player eligible for a U13 team can be registered on a U14 or older team.) Under those same guidelines, a player may not play down" to an age group younger than that player's age group. (Example: A player eligible for a U13 team may not be registered to a U12 or younger team.) The check birthdate function produces the typical or youngest age group for that birthdate according to the chart below. PLEASE NOTE: Each club may set its own rules whether a player may be registered in an age group older than typical for that player's birthdate; no club is obligated to allow this even though US Club Soccer allows it.
				<p>
				<p><b><u>Fall Play for U15 Players</u></b>  The U15 age group typically includes players in 8th grade as well as in high school.  Every school district has its own cutoff date, so every age group typically has players in more than one grade.  NCSA will continue to provide Fall play opportunity for those players in the U15 age group, whether players are in 8th grade or HS.  NCSA offers flexibility in scheduling to allow these teams to play not in conflict with HS schedules.</p>
				<p><b><u>U8 and Younger Players</u></b>  In keeping with the USSF mandate, effective Fall 2017 NCSA will no longer offer league play for U8 teams.  USSF recommends they play 4v4 on smaller fields, with smaller goals, no goalkeepers, no referees and no tracking of scores; there is no reason for NCSA to be involved in such programs, although it will assist its clubs in coordinating any inter-club play if desired.  U8 players may always play up on older teams, as currently, if the club permits it.  A Club may register teams as U9 provided all players qualify as U9 or younger, even if all U8 or younger; the designation of such a team will be U9.</p>
		<td>
	</tr>
	<tr class="tblHeading">
		<th width="25%" align="center">Play Group</th>
		<th width="20%">&nbsp;</th>
		<th width="55%" align="center" colspan="3">Birthdate on or after ...</th>
	</tr>
	<CFLOOP from="1" to="#arrayLen(period)#" index="index">
		<cfset Age = Period[index][1]>
		<CFSET per2year = datePart("yyyy",StartDate) - Age>
		<CFSET per3year = datePart("yyyy",StartDate) - Age + 1>
		<!--- <cfset Period[index][2] = createDate(per2year , 8, 1)>
		<cfset Period[index][3] = createDate(per3year , 7, 31)> --->
		<cfset Period[index][2] = createDate(per2year , StartMonth, 1)>
		<cfset Period[index][3] = createDate(per3year , EndMonth, 31)>
		
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,index)#">
			<TD align="center" class="tdUnderLine">
				<FONT size=2 id="AgeU#index#">U #AGE# </FONT>
			</TD>
			<TD align="center" class="tdUnderLine">
				&nbsp;
			</td>
			<TD	align="center" class="tdUnderLine" colspan="3">
				<FONT size=2  id="FromDate#Index#">
					#DateFormat(PERIOD[index][2],"mm/dd/yyyy")#
				</FONT>
			</TD>
			<!--- <TD	align="center" class="tdUnderLine">
					and 
			</TD>
			<TD	align="center" class="tdUnderLine">
				<FONT size=2  id="ToDate#Index#">
					#DateFormat(PERIOD[index][3],"mm/dd/yyyy")#
				</FONT>
			</TD> --->
		</TR>
	</CFLOOP>
	</tr>
	<tr><td class="red" align="center" colspan="5">
			<span id=error>&nbsp;</span>
		<td>
	</tr>
</TABLE>
	<div>
		<h3>To check your play group. Please select the birthdate</h3>
	</div>
	<div class="checkage row">
		<div class="select_box col4">
			<SELECT name="BDMonth"> 
				<OPTION value="0" selected>Month</OPTION>
				<OPTION value="1" >01-Januaury</OPTION>
				<OPTION value="2" >02-February</OPTION>
				<OPTION value="3" >03-March</OPTION>
				<OPTION value="4" >04-April</OPTION>
				<OPTION value="5" >05-May</OPTION>
				<OPTION value="6" >06-June</OPTION>
				<OPTION value="7" >07-July</OPTION>
				<OPTION value="8" >08-August</OPTION>
				<OPTION value="9" >09-September</OPTION>
				<OPTION value="10" >10-October</OPTION>
				<OPTION value="11" >11-November</OPTION>
				<OPTION value="12" >12-December</OPTION>
			</SELECT>
		</div>
	
		<div class="select_box col4">
			<SELECT name="BDDay"> 
				<OPTION value="0" selected>Day</OPTION>
				<CFLOOP from="1" to="31" index="iday">
					<OPTION value="#iday#" >#iday#</OPTION>
				</CFLOOP>
			</SELECT>
		</div>
	
		<div class="select_box col4">
			<SELECT name="BDYear"> 
				<OPTION value="0" selected>Year</OPTION>
				<CFSET firstYR = datePart("yyyy",Period[1][2]) - 11 >
				<CFLOOP from="#firstYR#" to="#datePart("YYYY",NOW())#" step="1" index="iYR">	
						<OPTION value="#iYR#" >#iYR#</OPTION>
				</CFLOOP>
			</SELECT>
		</div>
		<div class="col4">
			<button type="button" name="ChkPG()" value="Check PlayGroup" onclick="CheckPlayGroup()" class="yellow_btn">Check PlayGroup</button>
		</div>
	</div>

</form>

<script language="javascript">

var cForm = document.PlayGroup.all;

function CheckPlayGroup()
{
	var date1 = new Date();
	var sFD = new String();
	var sTD = new String();
	var BD = new Date();
	var FD = new Date();
	var TD = new Date();
	var minDate = new Date();
	var maxDate = new Date();
	var	PlayGroupFound;

	PlayGroupFound = 0;

	BDMonth =  document.PlayGroup.BDMonth.value;
	BDDay   = document.PlayGroup.BDDay.value;
	BDYear  = document.PlayGroup.BDYear.value;

	if (BDMonth == 0 || BDDay == 0 || BDYear == 0) { return false; }

	BD.setFullYear (BDYear, BDMonth - 1, BDDay);

	for (idx=1; idx < 13; idx++)
	{
		AgeGroup  = "AgeU"   + idx;
		FromDate  = "FromDate" + idx;
		ToDate    = "ToDate"   + idx;

//		sFD = document.PlayGroup.all (FromDate).innerHTML
//		sTD = document.PlayGroup.all (ToDate).innerHTML

		sFD = document.getElementById(FromDate).innerHTML
		//sTD = document.getElementById(ToDate).innerHTML

		frm = 0;
		pos = sFD.indexOf("/");
		Month = sFD.substring(frm, pos);

		
		frm = pos + 1;
		pos = sFD.indexOf("/", frm);
		Day = sFD.substring (frm, pos);


		frm = pos + 1;
		Year = sFD.substring (frm, sFD.length - 1 );

		FD.setFullYear (Year, Month - 1, Day);

		frm = 0;
		//pos = sTF.indexOf("/");
		//Month = sTF.substring(frm, pos);
		
		frm = pos + 1;
		//pos = sTD.indexOf("/", frm);
		//Day = sTD.substring (frm, pos);

		frm = pos + 1;
		//Year = sTD.substring (frm, sTD.length - 1 );

		//TD.setFullYear (Year, Month - 1, Day);
		TD.setFullYear(parseInt(Year) + 1, Month-2, 31);

		if (idx ==  1) { minDate = FD; }
		if (idx == 12) { maxDate = TD; }

		if (BD >= FD & BD <= TD)
		{
			PlayGroupFound = 1;

			document.getElementById (AgeGroup).color = "red";
			document.getElementById (AgeGroup).size  = 2;
			document.getElementById (AgeGroup).style.fontWeight = "bold";

			document.getElementById (FromDate).color = "red";
			document.getElementById (FromDate).size  = 2;
			document.getElementById (FromDate).style.fontWeight = "bold";

			//document.getElementById (ToDate).color = "red";
			//document.getElementById (ToDate).size  = 2;
			//document.getElementById (ToDate).style.fontWeight = "bold";

			document.getElementById ( "error").innerHTML = "You qualify for <font size=3>" + document.getElementById (AgeGroup).innerHTML + "</font>";

			document.getElementById ("error").color = "red";
			document.getElementById ("error").style.fontWeight = "bold";

		}
		else
		{
			document.getElementById (AgeGroup).color = "black";
			document.getElementById (AgeGroup).size  = 2;
			document.getElementById (AgeGroup).style.fontWeight = "normal";

			document.getElementById (FromDate).color = "black";
			document.getElementById (FromDate).size  = 2;
			document.getElementById (FromDate).style.fontWeight = "normal";

			//document.getElementById (ToDate).color = "black";
			//document.getElementById (ToDate).size  = 2;
			//document.getElementById (ToDate).style.fontWeight = "normal";

		}
	}

	if (PlayGroupFound == 0 )
	{
		if (BD < minDate)
		{
			msg = "<font color=red><u>OVERAGE</u>. Sorry, You do not qualify.</font>" ;
		}
		if (BD > maxDate)
		{
			msg = "<font color=red>This birthdate is younger than the typical age groups offered by NCSA. You must check with the club for which you are seeking to play to determine if it allows younger players to play up to an offered age group team.</font>" ;
		}

		document.getElementById( "error").innerHTML = msg;
		document.getElementById ("error").style.fontWeight = "bold";
	}
	return false;
}
</script>



</cfoutput>
</div>
<cfinclude template="_footer.cfm">
