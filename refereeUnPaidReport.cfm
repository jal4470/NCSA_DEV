<!--- 
	FileName:	refereeUnPaidReport.cfm
	Created on: 10/29/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

Fine Status
A - All
E - Appealed
U - Unpaid
W - Waived
D - Deleted
P - Paid
I - Invoiced


 --->
 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfset mid = 0> <!--- optional =menu id ---> 


<cfif isDefined("FORM.club_id")>
	<cfset clubID = FORM.club_id>
<cfelse>
	<cfset clubID = "0">
</cfif>	


<cfif isDefined("FORM.Season")>
	<cfset Season = FORM.Season>
<cfelse>

	<cfset Season = session.currentseason.id>

</cfif>


<cfif isdefined("form.finestatus")>
	<cfset finestatus = form.finestatus>
<cfelse>
	<cfset finestatus = "U">
</cfif>

<cfif (isdefined("form.startDate") and len(trim(form.startDate))) and (isdefined("form.endDate") and len(trim(form.endDate)))>
	<cfset startDate = form.startDate>
	<cfset endDate = form.endDate>
<cfelse>
	<cfset startDate ="#dateformat(session.currentseason.StartDate,'mm/dd/yyyy')#">
	<cfset endDate = "#dateformat(session.currentseason.EndDate,'mm/dd/yyyy')#">
</cfif>

<cfif isdefined("form.sortBy")>
	<cfset sortBy = form.sortBy>
<cfelse>
	<cfset sortBy = "1">
</cfif>

<cfset sortType = "ASC">


<!--- 	<cfswitch expression="#finestatus#">
		<cfcase value="P">
			<cfset SelCriteria = " and Status = 'P'" >
		</cfcase>
		<cfcase value="U">	 
			<cfset SelCriteria = " and (Status in ('U', '', '') or Status is Null ) " >
		</cfcase>
		<cfcase value="I">	
			<cfset SelCriteria = " and Status = 'I'" >
		</cfcase>
		<cfcase value="W">
			<cfset SelCriteria = " and Status = 'W'" >
		</cfcase>
		<cfcase value="D">
			<cfset SelCriteria = " and Status = 'D'" >
		</cfcase>
		<cfcase value="E">
			<cfset SelCriteria = " and Status = 'E'" >
		</cfcase>
		<cfcase value="A">
			<cfset SelCriteria = "" >
		</cfcase>
		<cfdefaultcase>
			<cfset SelCriteria = " and ( Status not in ('I' , 'D') or Status is Null)" >
		</cfdefaultcase>
	</cfswitch> --->
	
	<!--- 11/1/2012 J. Rab --->
<!--- 	<cfif isDefined("sortBy")>
		<cfswitch expression="#sortBy#">
		<cfcase value="1">
		<cfset sortByExpression = "Order by Fine_ID " & sortType>
		</cfcase>
		<cfcase value="2">
		<cfset sortByExpression = "Order by Game_ID " & sortType>
		</cfcase>
		<cfcase value="3">
		<cfset sortByExpression = "Order by Club_Name " & sortType>
		</cfcase>
		<cfcase value="4">
		<cfset sortByExpression = "Order by TeamName " & sortType>
		</cfcase>
		<cfcase value="5">
		<cfset sortByExpression = "Order by Description " & sortType>
		</cfcase>
		<cfcase value="6">
		<cfset sortByExpression = "Order by AddByUser " & sortType>
		</cfcase>
		<cfcase value="7">
		<cfset sortByExpression = "Order by FineDateCreated " & sortType>
		</cfcase>
		<cfcase value="8">
		<cfset sortByExpression = "Order by Amount " & sortType>
		</cfcase>
		<cfcase value="9">
		<cfset sortByExpression = "Order by Status " & sortType>
		</cfcase>
		<cfdefaultcase>
		<cfset sortByExpression = "Order by Club_Name, TeamName">
		</cfdefaultcase>
		</cfswitch>
	<cfelse>
		<cfset sortByExpression = "Order by Club_Name, TeamName">
	</cfif>
 --->


<!---<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="getFines" returnvariable="refUnPaidAdded">
	<cfinvokeargument name="FineStatus" value="#finestatus#"> 
	<cfinvokeargument name="clubID"     value="#clubID#"> 
	<cfinvokeargument name="seasonID" value="#Season#"> 
	<cfif sortBy NEQ "">
	<cfinvokeargument name="sortBy" value="#sortBy#">
	<cfinvokeargument name="sortType" value="#sortType#">
	</cfif>
	<cfinvokeargument name="StartDate" value="#StartDate#"> 
	<cfinvokeargument name="EndDate" value="#EndDate#"> 
</cfinvoke> --->
<!--- <cfdump var="#refUnPaidAdded#" abort="true"> --->
	
 	<cfquery name="refUnPaidAdded" datasource="#SESSION.DSN#">
		select  r.RefPosition,
				r.REFID, co.FirstNAME, co.LastName,
				r.GAME,  r.GDATE,  r.GTIME, r.DIVISION, r.COMMENTS,
				r.FIELD, r.FIELDABBR, 
				dbo.getTeamName(r.HOME)    AS HomeTeamName,
				dbo.getTeamName(r.VISITOR) AS VisitorTeamName,
				r.RefAmountOwed, C.CLUB_NAME,
				r.FIELDID, 	th.Club_ID,
				r.RefGameDateUnpaid,  
				r.HOME, r.VISITOR,  r.SEASONID, r.STATUS, 
				r.DATEADDED, r.ADDBYUSER, r.TIMEADDED, 
				r.DATEUPDATED, r.UPDBYUSER, r.TIMEUPDATED
		  from  RefUnPaid r INNER JOIN TBL_TEAM TH 		ON TH.TEAM_ID = R.Home
							INNER JOIN TBL_CLUB C 		ON C.CLUB_ID = TH.CLUB_ID
							INNER JOIN TBL_CONTACT CO	ON CO.CONTACT_ID = R.REFID
		 where  r.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Season#">
		 	<CFIF isDefined("clubID") AND clubID neq 0>
				and C.Club_Id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#clubID#">
			</CFIF>
			<!--- 11/1/2012 J. Rab --->
			<cfif (isDefined("StartDate") and isDate(StartDate)) and (isDefined("EndDate") and isDate(EndDate))>
				and cast(r.dateadded as date) between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#StartDate#"> and  <cfqueryparam cfsqltype="CF_SQL_DATE" value="#EndDate#">
			</cfif>
			
			
		 ORDER BY C.CLUB_NAME, r.gDate DESC, r.gTime DESC
	</cfquery>  
<!--- #preserveSingleQuotes(SelCriteria)# 
<cfoutput>		select  						r.RefPosition,
				r.REFID, co.FirstNAME, co.LastName,
				r.GAME,  r.GDATE,  r.GTIME, r.DIVISION, r.COMMENTS,
				r.FIELD, r.FIELDABBR, 
				dbo.getTeamName(r.HOME)    AS HomeTeamName,
				dbo.getTeamName(r.VISITOR) AS VisitorTeamName,
				r.RefAmountOwed, C.CLUB_NAME,
				r.FIELDID, 	th.Club_ID,
				r.RefGameDateUnpaid,  
				r.HOME, r.VISITOR,  r.SEASONID, r.STATUS, 
				r.DATEADDED, r.ADDBYUSER, r.TIMEADDED, 
				r.DATEUPDATED, r.UPDBYUSER, r.TIMEUPDATED
		  from  RefUnPaid r INNER JOIN TBL_TEAM TH 		ON TH.TEAM_ID = R.Home
							INNER JOIN TBL_CLUB C 		ON C.CLUB_ID = TH.CLUB_ID
							INNER JOIN TBL_CONTACT CO	ON CO.CONTACT_ID = R.REFID
		 where  r.seasonid = #Season#
		 <CFIF isDefined("clubID") AND clubID NEQ 1>
				and C.Club_Id = #clubID#"
			</CFIF>
			<cfif isdefined("seasonID")>
				and season_id = #seasonID#"
			</cfif>
			<!--- 11/1/2012 J. Rab --->
			<cfif (isDefined("StartDate") and isDate(StartDate)) and (isDefined("EndDate") and isDate(EndDate))>
				and cast(r.dateadded as date) between '#StartDate#' and  '#EndDate#'
			</cfif>
			
		 ORDER BY C.CLUB_NAME, r.gDate DESC, r.gTime DESC
</cfoutput>

<cfabort>--->


<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qClubs">
		<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>

<!--- Get Team Age --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke>
<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getPreviousSeasonDivisions" returnvariable="lDivision"> <!--- Divisions --->

<cfquery name="getSeasons" datasource="#session.dsn#">
	select season_id,seasonCode, season_StartDate, season_EndDate
	from tbl_season
</cfquery>


<CFIF isDefined("FORM.PRINTME")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "clubID=#clubId#&startDate=#startDate#&endDate=#endDate#&season=#season#">
<!--- 	<script> window.location.href = 'rptTeamCreatedSeason_PDF.cfm?#qString#'; </script>  --->
	<cflocation url="refereeUnPaidReport_PDF.cfm?#qString#">
<CFELSEIF isDefined("FORM.EXPORT")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "clubID=#clubId#&startDate=#startDate#&endDate=#endDate#&season=#season#">
<!--- 	<script> window.location.href = 'rptTeamCreatedSeason_csv.cfm?#qString#'; </script>  --->
	<cflocation url="refereeUnPaidReport_csv.cfm?#qString#">
</CFIF>


<!--- <cfsavecontent variable="cfhtmlhead_unpaid">
<script>window.jQuery || document.write(unescape('%3Cscript src="assets/jquery-1.10.1.min.js"%3E%3C/script%3E'))</script>
<script>
	$(function () {
		$("#printBtn").click(function () {
			window.open('refereeUnPaidReport_PDF.cfm');
		});
	});
</script>
</cfsavecontent> --->

<cfsavecontent variable="custom_css">
  <link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
  <style>
  	 .dateRange{
  	 	width:100px;
  	 }
  	 .tblDateRange{
  	 	width:208px;
  	 	margin-left: 2%;
    	margin-top: -2px;
  	 }
  	 #teamRegInfo .question{
  	 	float:left;
  	 }
  	</style>
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">
	<H1 class="pageheading">
		NCSA - UnPaid Referee Report 
	</H1>

	<FORM id="teamRegInfo" action="#cgi.script_name#" method="post">
	<input name="sort" type="hidden" value="team_id">
	<input name="order" type="hidden" value="asc">
 	<div id="qClubs" class="question">
		<label for="clubs" style="display: block;"><b>Select a Club:</b></label>
		<SELECT name="club_id" id="club_id">
			<option value="0">All Clubs</option>
			<cfloop query="qClubs">
				<option value="#CLUB_ID#" <CFIF CLUB_ID EQ ClubID>selected</CFIF> >#CLUB_NAME#</option>
			</cfloop>
		</SELECT>
	</div> 

	<div id="qSeason" class="question">
		<label for="Season" style="display: block;"><b>Select Season </b></label>
		<SELECT name="Season" id="Season">
			<CFLOOP query="#getSeasons#" >
				<OPTION value="#season_id#" data-start-date="#dateformat(season_StartDate,'mm/dd/yyyy')#" data-end-date="#dateformat(season_EndDate,'mm/dd/yyyy')#"  <cfif Season_id EQ variables.season>selected</cfif> > #seasonCode# </OPTION>
			</CFLOOP>
		</SELECT>
	</div>
	<div  class="question">
		<table cellspacing="0" cellpadding="2" align="center" border="0" class="tblDateRange">
			<tr>
			
			<td>
				<label for="Season" style="display: block;"><b>Start Date:</b></label> 
				<div><input type="text" name="StartDate" class="dateRange" value="#startDate#" /></div>
			</td>
			<td>
				<label for="Season" style="display: block;"><b>End Date:</b></label>
				<div><input type="text" name="EndDate" class="dateRange" value="#endDate#" /></div>
			</td>
			</tr>
		</table>
	</div>

<!--- 	<div id="qSeason" class="question">
		<label for="Season" style="display: block;"><b>Fine Status </b></label>
		<SELECT name="FineStatus" id="FineStatus">
				<OPTION value="A"  <cfif 'A' EQ variables.FineStatus>selected</cfif> >All</OPTION>
				<OPTION value="E"  <cfif 'E' EQ variables.FineStatus>selected</cfif> >Appealed</OPTION>
				<OPTION value="U"  <cfif 'U' EQ variables.FineStatus>selected</cfif> >Unpaid</OPTION>
				<OPTION value="W"  <cfif 'W' EQ variables.FineStatus>selected</cfif> >Waived</OPTION>
				<OPTION value="D"  <cfif 'D' EQ variables.FineStatus>selected</cfif> >Deleted</OPTION>
				<OPTION value="P"  <cfif 'P' EQ variables.FineStatus>selected</cfif> >Paid</OPTION>
				<OPTION value="I"  <cfif 'I' EQ variables.FineStatus>selected</cfif> >Invoiced</OPTION>
		</SELECT>
	</div> --->
<!--- 	<div id="sortBy"  class="question">
		<label for="sortBy" style="display: block;"><b>Sort by</b></label>
		<SELECT name="FineStatus" id="FineStatus">
				<OPTION value="1"  <cfif '1' EQ variables.Sortby>selected</cfif> >Fine Id</OPTION>
				<OPTION value="2"  <cfif '2' EQ variables.Sortby>selected</cfif> >Game Id</OPTION>
				<OPTION value="3"  <cfif '3' EQ variables.Sortby>selected</cfif> >Club Name</OPTION>
				<OPTION value="4"  <cfif '4' EQ variables.Sortby>selected</cfif> >Team Name</OPTION>
				<OPTION value="5"  <cfif '5' EQ variables.Sortby>selected</cfif> >Description</OPTION>
				<OPTION value="6"  <cfif '6' EQ variables.Sortby>selected</cfif> >Add By User</OPTION>
				<OPTION value="7"  <cfif '7' EQ variables.Sortby>selected</cfif> >Fine Date Created</OPTION>
				<OPTION value="8"  <cfif '8' EQ variables.Sortby>selected</cfif> >Amount</OPTION>
				<OPTION value="9"  <cfif '9' EQ variables.Sortby>selected</cfif> >Status</OPTION>
		</SELECT>
	</div> --->

<!--- 	<div id="qTeamFormed" class="question">
		<label for="teamFormed" style="display: block;"><b>Team Formation Question</b></label>
		<SELECT name="teamFormed" id="teamFormed">
			<OPTION value="" selected>Select</OPTION>
			<OPTION value="using birth year" <CFIF teamFormed EQ "using birth year">selected</CFIF> >Using birth year only to form team</OPTION>
			<OPTION value="using old 7/31-8/1 year" <CFIF teamFormed EQ "using old 7/31-8/1 year">selected</CFIF> >Using old 7/31-8/1 year (playing up)</OPTION>
			<OPTION value="other" <CFIF teamFormed EQ "other">selected</CFIF> >Other-Does not fit either of above</OPTION>
		</SELECT>
	</div>
	<div id="qTeamAvailability" class="question">
		<label for="teamAvailability" style="display: block;"><b>Team Availability Question</b></label>
		<SELECT name="teamAvailability" id="teamAvailability">
			<OPTION value="">Select</OPTION>
			<OPTION value="yes" <CFIF teamAvailability EQ "yes">selected</CFIF> >Yes</OPTION>
			<OPTION value="no" <CFIF teamAvailability EQ "no">selected</CFIF> >No</OPTION>
		</SELECT>
	</div>
 --->
	<div id="qSubmit" class="question-submit">
		<input type="Submit" name="GO" value="GO">
		<input type="Submit" name="printme" value="Printer Friendly">
		<input type="Submit" name="Export" value="Export">
	</div>

</FORM>

<!--- 	<div>
		<cfif isDefined("refUnPaidAdded") AND refUnPaidAdded.RecordCount GT 0>
			<input id="printBtn" name="PRINTME" type="submit" value="Print Report" />
			<input id="downloadBtn" name="EXPORT" type="submit" value="Export" />
		</cfif>
	</div> --->


	<!--- <br> <h2>yyyyyy </h2> --->
	
	<cfset WhereClub = "">
	<cfif IsDefined("SESSION.MENUROLEID") AND listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0 > <!---  "CU" = 26=club pres, 27=club rep, 28=club alt rep, 29=coach  --->
		<cfset WhereClub = " and B.ClubId = " & SESSION.USER.CLUBID >
	</cfif>
	
	<!--- <cfquery name="qGetUnPaid" datasource="#SESSION.DSN#">
		select  R.xref_game_official_id, R.game_official_type_id,
				R.Refid, R.RefFirstName, R.RefLastName,    
				R.game_id,      R.game_date, R.game_time, R.Division, R.RefPaidComment,
				R.field_id, R.FieldAbbr, R.HomeTeamName,  R.VisitorTeamName,
				R.RefAmountOwed,
				C.Club_NAME
		  from  V_RefUnPaid R INNER JOIN TBL_CLUB C ON R.HomeClubID = C.CLUB_ID
		  ORDER by C.Club_NAME, R.GAME_ID
	</cfquery> --->
	
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TH width="23%">Referee</TH>
			<TH width="06%">Pos</TH>
			<TH width="06%" >Owed</TH>	
			<TH width="06%">Game</TH>
			<TH width="24%"> Date/Time/Field</TH>
			<TH width="05%">Div</TH>
			<TH width="30%">Teams </TH>
		</tr>
	</table>
	
	
	<div style="overflow:auto; height:425px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
	
		<CFIF refUnPaidAdded.RECORDCOUNT>
			<!--- <tr class="tblHeading">
				<TD colspan="8" align="left">#repeatString("&nbsp;",5)# Unassigned Referees <!--- ADDED Unpaid Referess ---> </TD>
			</tr> --->
			<cfset holdClubName = "">
			<cfloop query="refUnPaidAdded">
				
				<cfif holdClubName NEQ CLUB_NAME>
					<cfset holdClubName = CLUB_NAME>
					<TR bgcolor="##CCE4F1">
						<TD colspan="8" align="left"><B>#ucase(Club_Name)#</b></TD>
					</tr>
				</cfif>
				<cfif len(trim(Comments))>
					<cfset tdClass = "">
				<cfelse>
					<cfset tdClass = "class='tdUnderLine' ">
				</cfif>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" > <!--- currentRow or counter --->
					<TD #tdClass# > #LastName#, #FirstNAME# </TD>
					<TD #tdClass# align="center"> 	 
							<cfswitch expression="#RefPosition#">
								<cfcase value="1"> Ref </cfcase>
								<cfcase value="2"> AR1 </cfcase>
								<cfcase value="3"> AR2 </cfcase>
							</cfswitch>
					</TD>
					<TD #tdClass# align="center"> #dollarFormat(RefAmountOwed)#		 </TD>
					<TD #tdClass#> #GAME#		 </TD>
					<TD #tdClass#> #dateFormat(RefGameDateUnpaid,"mm/dd/yyyy")# &nbsp; &nbsp; &nbsp; #timeFormat(GTIME,"hh:mm tt")#
								<br>#repeatString("&nbsp;",4)# #FieldAbbr#
					</TD>
					<TD #tdClass#> #Division#		 </TD>
					<TD #tdClass#> 
								 (H) #HomeTeamName#
							<br> (V) #VisitorTeamName#	
					</TD>
				</tr>
				<cfif len(trim(Comments))>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
						<TD colspan="1" class="tdUnderLine">&nbsp;  </TD>
						<TD colspan="6" class="tdUnderLine" align="left"> Comments:  #Comments# </TD>
					</tr>
				</cfif>
			</cfloop>	
		</CFIF>
	</TABLE>
	</div>

</div>
</cfoutput>

<cfsavecontent variable="cf_footer_scripts">
	<cfoutput>
		<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
		<script language="JavaScript" type="text/javascript">
			$(function(){
				$('input[name=StartDate],input[name=EndDate]').datepicker();

				$("th").click(function(){
					//console.log($(this).data('sort'));
					$('input[name=sort]').val($(this).data('sort'));
					//console.log($(this).data('order'));
					$('input[name=order]').val($(this).data('order'));

					if($(this).data('order') == 'asc')
						$(this).data('order','desc');
					else
						$(this).data('order','asc');
					
				});

				//$('##resultTable').tablesorter();

				$( "select[name=Season]" ).change(function() {
				  	let _start_date = $(this).find('option:selected').data('start-date');
					let _end_date = $(this).find('option:selected').data('end-date');
				  	$("input[name=StartDate]").val(_start_date);
				  	$("input[name=EndDate]").val(_end_date);
				});

			});
		</script>
	</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">
