<!--- 
	FileName:	rptNoMDF.cfm
	Created on: 4/6/11
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
- 6/29/2011, J. Oriente (ticket 10501)
	> added link from game # to match day form. 
	> added condition to query qMissingForms to exclude games that were not played from results (gameSts <> 'P')
- 7/14/2011, J. Oriente (ticket 10501)
	> updated the value of the flight column on the display with the "division" column from query qMissingForms (instead of using the flight column)
06/16/17 - mgreenberg (TICKET NCSA22821) - report mods: updated datepicker.
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Match Day Form Not Created Report</H1>


<cfif isDefined("FORM.op")>
	<cfset op = FORM.op > 
<cfelseif isDefined("URL.op")>
	<cfset op = URL.op > 
<cfelse>
	<cfset op = 0 > 
</CFIF>


<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(now(),"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("FORM.gameDiv")>
	<cfset gameDiv = FORM.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfset errMsg = "">

<cfif isDefined("FORM.GO")>
	<!--- filter crtieria endtered, zero out single game value --->
	<cfset gameID = "">
<cfelseif isDefined("FORM.GOSINGLE")>
	<!--- single game search, zero out filter values --->
	<cfset RefID = 0>
	<cfset GameFieldID = 0>
	<cfset gameDiv = "">
</cfif> 

<cfif isDefined("FORM.GO") OR isDefined("FORM.GOSINGLE") >
	<cfset swContinue = true>
	<CFIF isDefined("FORM.GOSINGLE") and not isNumeric(VARIABLES.gameID)>
		<cfset swContinue = false>
		<cfset errMsg = "Game number must be a valid number.">
	</CFIF>

	<cfif swContinue>
		<cfquery name="qMissingForms" datasource="#SESSION.DSN#">
			SELECT *
			  FROM (
			   ( SELECT g1.game_id, g1.field_id, g1.field, g1.game_datetime, g1.home_teamname as team_name, g1.type,
			  			t.playLevel as flight, c.email as coach_email, dbo.f_get_division(t.team_Id) as division,
			  			refc.firstname + ' ' + refc.lastname as ref_name, refc.email as ref_email
			       FROM v_games_all g1 inner join 
				        tbl_team t on g1.home_team_id=t.team_id left join 
						tbl_contact c on t.contactidhead=c.contact_id left join 
						tbl_contact refc on g1.refid=refc.contact_id 
				  WHERE not exists (SELECT match_day_form_id 
				                      FROM tbl_match_day_form mdf 
									 WHERE mdf.game_id=g1.game_id 
									   and mdf.team_id=g1.home_team_id)
					and not exists (SELECT ref.game_id 
					                  FROM tbl_referee_RPT_header ref
									 WHERE ref.GameSts <> 'P' 
									   and g1.game_id = ref.game_id))
			  UNION
			  ( SELECT g1.game_id, g1.field_id, g1.field, g1.game_datetime, g1.visitor_teamname as team_name, g1.type,
			           t.playLevel as flight, c.email as coach_email, dbo.f_get_division(t.team_Id) as division,
			           refc.firstname + ' ' + refc.lastname as ref_name, refc.email as ref_email
			      FROM v_games_all g1 inner join 
				       tbl_team t on g1.visitor_team_id=t.team_id left join 
					   tbl_contact c on t.contactidhead=c.contact_id left join 
					   tbl_contact refc on g1.refid=refc.contact_id 
			     WHERE not exists (SELECT match_day_form_id 
				                     FROM tbl_match_day_form mdf 
									WHERE mdf.game_id=g1.game_id 
									  and mdf.team_id=g1.visitor_team_id)
				   and not exists (SELECT ref.game_id 
					                 FROM tbl_referee_RPT_header ref
								    WHERE ref.GameSts <> 'P' 
								      and g1.game_id = ref.game_id))
									  
					) G inner join 
				   tbl_field f on g.field_id=f.field_id
			 WHERE (type is null OR type = 'L')
			   and f.club_id <> 1
			   <cfif isdefined("form.gosingle")>
			   		and g.game_id=<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
			   <cfelse>
			<cfif Session.MenuRoleID EQ 28 OR Session.MenuRoleID EQ 27 OR Session.MenuRoleID EQ 26 OR Session.MenuRoleID EQ 25>

				and f.club_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.USER.CLUBID#">
			</cfif>

			   and datediff(d,<cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">,g.game_datetime) >= 0
			   and datediff(d,g.game_datetime,<cfqueryparam cfsqltype="CF_SQL_DATE" value="#weekendto#">) >= 0
			   		<cfif len(trim(gameDiv))>
					    and G.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
			   		</cfif>
			   </cfif>
		</cfquery>
	</cfif>
</cfif>

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="Games" action="rptNoMDF.cfm"  method="post">
<input type="hidden" id="op" name="op" value="#op#" />
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
	<TR><TD align="left">
			<B>From</B> &nbsp;
				<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			#repeatString("&nbsp;",3)#
			<B>To</B> &nbsp;
				<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		</td>
		<td align="center">
			<B>Game Number </B> &nbsp;
				<input type="Text" name="gameID" value="#VARIABLES.gameID#" size="5">
				<br>(overrides all filters)
	
	 	</td>
	</tr>
	<tr><td><b>Division</b>
				<cfquery name="qAllDivs" datasource="#SESSION.DSN#">
					select distinct division from v_games where division <> '' order by division
				</cfquery>
				<SELECT name="gameDiv"> 
					<OPTION value="" >Select All</OPTION>
					<CFLOOP query="qAllDivs">
						<OPTION value="#division#" <cfif gameDiv EQ division >selected</cfif> >#division#</OPTION>
					</CFLOOP>
				</SELECT>
			<input type="SUBMIT" name="Go"  value="Go" >  
	
		</td>
		<td align="center">
			<input type="SUBMIT" name="GoSingle"  value="Get Single Game" >  
		</td>
	</tr>

	<cfif len(trim(errMsg))>
		<tr><td colspan="2" align="center">
				<span class="red"><b>#VARIABLES.errMsg#</b></span>
			</td>
		</tr>
	</cfif>

</table>	
</FORM>

<cfset RecCountGrand	= 0>

<CFIF IsDefined("qMissingForms")>
	<table id="resultTable" class="table1" cellspacing="0" cellpadding="3" border="0" width="100%">
		<thead>
		<tr>
			<th>Game</th>
			<th>Flight</th>
			<th>Date</th>
			<th>Field</th>
			<th>Team</th>
			<th>Coach Email</th>
			<th>Referee</th>
			<th>Referee Email</th>
		</tr>
		</thead>
		<tbody>
	<cfloop query="qMissingForms">
		<tr>
			<td>
			<cfif op EQ "1">
			#game_id#
			<cfelse>
			<a target="_blank" href="gameRefReportPrint.cfm?gid=#game_id#">#game_id#</a>
			</cfif>
			</td>
			<td>#division#</td>
			<td>#dateformat(game_datetime,"m/d/yyyy")# #timeformat(game_datetime, "h:mm tt")#</td>
			<td>#field#</td>
			<td>#team_name#</td>
			<td><a href="mailto:#coach_email#">#coach_email#</a></td>
			<td>#ref_name#</td>
			<td><a href="mailto:#ref_email#">#ref_email#</a></td>
		</tr>
	</cfloop>
	</tbody>
	</table>
</CFIF>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		
		$('##resultTable').tablesorter({
			/*headers:{
				3:{
					sorter:false
				}
			},*/
			sortList:[[2,0]]
		});
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">





