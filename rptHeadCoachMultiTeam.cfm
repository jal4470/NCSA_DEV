<!--- 
	FileName:	rptHeadCoachMultiTeam.cfm
	Created on: 9/5/2017
	Created by: rgonzalez@capturepoint.com
	
	Purpose: 
	
	
MODS: mm/dd/yyyy - filastname - comments
 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<!--- Validate From Inputs ---> 
<CFIF isDefined("FORM.TeamAgeSelected")>
	<cfset TeamAgeSelected = trim(FORM.TeamAgeSelected)>
<CFELSE>
	<cfset TeamAgeSelected = "">
</CFIF>
<CFIF isDefined("FORM.BGSelected")>
	<cfset BGSelected = trim(FORM.BGSelected)>
<CFELSE>
	<cfset BGSelected = "">
</CFIF>
<CFIF isDefined("FORM.workingSeason")>
	<cfset workingSeason = trim(FORM.workingSeason)>
<CFELSE>
	<cfset workingSeason = "">
</CFIF>
<CFIF isDefined("FORM.PlayLevel")>
	<cfset PlayLevel = trim(FORM.PlayLevel)>
<CFELSE>
	<cfset PlayLevel = "">
</CFIF>
<CFIF isDefined("FORM.SORTORDER")>
	<cfset selectSort = FORM.SORTORDER>
<CFELSE>
	<cfset selectSort = "">
</CFIF>

<cfif isDefined("form.export") and len(trim(form.export))>
  <cfset export = form.export>
<cfelseif isDefined("url.export") and len(trim(url.export))>
  <cfset export = url.export>
<cfelse>
  <cfset export = false>
</cfif>

<cfset season_id = "">

<!--- Set Order By Clause --->
<cfswitch expression="#ucase(selectSort)#">
  <cfcase value="COACHNAME">
    <cfset orderByClause = " ORDER BY firstname "> 
  </cfcase>
  <cfcase value="FLIGHT_TEAMNAME"> 
    <cfset orderByClause = " ORDER BY Flight, Team_Name "> 
  </cfcase>
</cfswitch>

<!--- Get Head Coach Multi Team Report Data --->
<CFQUERY name="getHeadCoachMultiTeamData" datasource="#SESSION.DSN#">
  WITH cte_coaching_teams 
      AS (SELECT username, 
                  firstname, 
                  lastname, 
                  t.team_id, 
                  t.teamage, 
                  t.playlevel, 
                  t.gender, 
                  ( Isnull(T.gender, '') 
                  + RIGHT(T.teamage, 2) 
                  + Isnull(T.playlevel, '') 
                  + Isnull(playgroup, '')) 
                  AS 
                    flight, 
                  dbo.Getteamname(t.team_id) 
                  AS 
                    team_name, 
                  dbo.F_get_head_coach_multi_team_count(c.contact_id, 
                  xcr.season_id) AS 
                    count 
          FROM   tbl_contact c WITH(nolock) 
                  INNER JOIN xref_contact_role xcr WITH(nolock) 
                          ON c.contact_id = xcr.contact_id 
                  INNER JOIN tbl_club cl WITH(nolock) 
                          ON cl.club_id = xcr.club_id 
                  INNER JOIN tbl_team t WITH(nolock) 
                          ON t.contactidhead = c.contact_id 
                            AND t.season_id = xcr.season_id 
          WHERE  xcr.season_id IN (SELECT season_id 
                                    FROM   tbl_season
                                    WHERE 
                                    <cfif isdefined("workingSeason") AND len(trim(workingSeason))>
                                      season_id = <cfqueryparam value = "#workingSeason#" CFSQLType = "CF_SQL_VARCHAR">
                                    <cfelse>
                                      currentseason_yn = 'Y'
                                    </cfif>
                                    )
                  AND username IS NOT NULL 
                  AND ussfdiv IS NOT NULL 
          GROUP  BY username, 
                    firstname, 
                    lastname, 
                    t.team_id, 
                    t.teamage, 
                    t.playlevel, 
                    t.gender, 
                    requestdiv, 
                    ussfdiv, 
                    playgroup, 
                    dbo.Getteamname(t.team_id), 
                    dbo.F_get_head_coach_multi_team_count(c.contact_id, 
                    xcr.season_id) 
          ) 
  SELECT Sum(count) AS total_teams, 
        username, 
        flight, 
        firstname, 
        lastname, 
        team_id, 
        teamage, 
        playlevel, 
        gender, 
        team_name 
  FROM   cte_coaching_teams 
  WHERE  team_id IS NOT NULL 
        <cfif isDefined("TeamAgeSelected") AND len(trim(TeamAgeSelected))>
          AND teamAge = <cfqueryparam value = "#TeamAgeSelected#" CFSQLType = "CF_SQL_VARCHAR">
        </cfif>

        <cfif isDefined("PlayLevel") AND len(trim(PlayLevel))>
          AND playLevel = <cfqueryparam value = "#PlayLevel#" CFSQLType = "CF_SQL_VARCHAR">
        </cfif>

        <cfif isDefined("BGSelected") AND len(trim(BGSelected))>
          AND gender = <cfqueryparam value = "#BGSelected#" CFSQLType = "CF_SQL_VARCHAR">
        </cfif>
  GROUP BY username, 
            flight, 
            firstname, 
            lastname, 
            team_id, 
            teamage, 
            playlevel, 
            gender, 
            team_name 
  HAVING Sum(count) > 1 
  <cfif isDefined("orderByClause") AND len(trim(orderByClause))>
    #orderByClause#
  <cfelse>
    ORDER BY firstname
  </cfif>
</CFQUERY>

<!--- Query of Queries to get Filter Result --->
<cfquery name="excelData" dbtype="query">
  SELECT firstname + ' ' + lastname AS Coach,
         flight AS Flight,
         team_name AS Team
    FROM getHeadCoachMultiTeamData
</cfquery>

<cfif export>
  <cfinvoke component="#SESSION.SITEVARS.cfcpath#excelExport" method="createExcelDoc" returnvariable="excelDownload">
    <cfinvokeargument name="queryResults" value="#excelData#">
  </cfinvoke>
  <cfset export = false>
</cfif>

<!--- Get Team ages ---> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->

<!--- Get Play Levels ---> 
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->

<!--- Get Working Seasons ---> 
<CFQUERY name="qWorkingSeasons" datasource="#SESSION.DSN#">
	SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, 
		   CURRENTSEASON_YN, REGISTRATIONOPEN_YN
	FROM TBL_SEASON 
	ORDER BY SEASON_ID desc
</CFQUERY>

<cfoutput>
  <div id="contentText">
      <H1 class="pageheading">NCSA - Head Coach Multi Team Report</H1>

      <!--- Filters Form --->
      <FORM id="filterForm" name="filterForm" action="rptHeadCoachMultiTeam.cfm" method="post" style="position:relative">

        <div class="formField one_third">
          <label for="TeamAgeSelected">Team Age:</label>
          <div class="select_box">
            <SELECT id="TeamAgeSelected" name="TeamAgeSelected" >
              <OPTION value="">All</OPTION>
              <CFLOOP list="#lTeamAges#" index="ita">
                <OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
              </CFLOOP>
            </SELECT>
          </div>
        </div>

        <div class="formField one_third">
          <label for="PlayLevel">Level:</label>
          <div class="select_box">
            <SELECT id="PlayLevel" name="PlayLevel">
              <OPTION value="" selected>All</OPTION>
              <CFLOOP list="#lPlayLevel#" index="ipl">
                <OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
              </CFLOOP>
            </SELECT>
          </div>
        </div>

        <div class="formField one_third">
          <label for="BGSelected">Gender:</label>
          <div class="select_box">
            <SELECT id="BGSelected" name="BGSelected">
              <OPTION value="">Both </OPTION>
              <OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
              <OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
            </SELECT>
          </div>
        </div>

        <div class="formField one_half">
          <label for="workingSeason">Season:</label>
          <div class="select_box">
            <SELECT id="workingSeason" name="workingSeason">
              <cfset setSelect = false>
              <CFLOOP query="qWorkingSeasons">

                <CFSET curr = "">
                <CFSET reg = "">
                <CFIF CURRENTSEASON_YN EQ 'Y'>
                  <CFSET curr = "(current)">
                <CFELSEIF REGISTRATIONOPEN_YN EQ 'Y'>
                  <CFSET reg = "(registration)">
                </CFIF>

                <cfif isDefined("workingSeason") AND len(trim(workingSeason))>
                  <cfset setSelect = season_id EQ workingSeason ? true : false>
                <cfelse>
                  <cfset setSelect = CURRENTSEASON_YN EQ 'Y' ? true : false>
                </cfif>

                <option value="#season_id#" <cfif setSelect>selected</cfif>>
                  #SEASON_YEAR# #SEASON_SF# #curr# #reg# 
                </option>

              </CFLOOP>
            </SELECT>
          </div>
        </div>
          
        <div class="formField one_half">
          <label for="sortOrder">Sort by:</label>
          <div class="select_box">
            <select id="sortOrder" name="sortOrder">
              <option value="COACHNAME"  <cfif selectSort EQ "COACHNAME"> selected</cfif> >Coach Name</option>
              <option value="FLIGHT_TEAMNAME" <cfif selectSort EQ "FLIGHT_TEAMNAME">selected</cfif> >Flight/TeamName</option>
            </select>
          </div>
        </div>

        <div class="schedule_cta_wrapper">
          <button class="schedule_cta filter yellow_btn" type="submit" name="filterReport">Filter Report</button>
          <button type="button" class="schedule_cta export gray_btn" name="exportReport">Export to Excel (XLS)</button>
        </div>

      </FORM>

      <!--- Export Form --->
      <FORM id="exportForm" name="exportForm" action="rptHeadCoachMultiTeam.cfm" method="post">
        <input type="hidden" name="export" value="true">
        <input type="hidden" name="TeamAgeSelected" value="#VARIABLES.TeamAgeSelected#">
        <input type="hidden" name="PlayLevel" value="#VARIABLES.PlayLevel#">
        <input type="hidden" name="BGSelected" value="#VARIABLES.BGSelected#">        
        <input type="hidden" name="workingSeason" value="#workingSeason#">
        <input type="hidden" name="sortOrder" value="#selectSort#">
      </FORM> 

<!--[if lte IE 9]>
<div class="old_ie_wrapper">
<!--<![endif]-->
      <div class="responsive-table-wrap">
        <table id="headCoachMultiTeamResultsTable">
          <thead>
            <tr class="tblHeading">
              <th>Coach</th>
              <th>Flight</th>
              <th>Team</th>
            </tr>
          </thead>
          <tbody>
            <cfloop query="getHeadCoachMultiTeamData">	
              <tr>
                <td>
                  <span class="tbl_th">Contact/Coach Name:</span>
                  <span class="tbl_td">#firstname# #lastname#</span>
                </td>
                <td>
                  <span class="tbl_th">Flight:</span>
                  <span class="tbl_td">#flight#</span>
                </td>
                <td>
                  <span class="tbl_th">Team Name:</span>
                  <span class="tbl_td">#team_name#</span>
                </td>
              </tr>
            </cfloop>
          </tbody>
        </table>
      </div>
<!--[if lte IE 9]>
</div>
<!--<![endif]-->

  </div>
</cfoutput>

<!--- Tablesorter CSS --->
<cfsavecontent variable="page_css">
  <style type="text/css">
    .responsive-table-wrap { overflow-x: auto; }
    #headCoachMultiTeamResultsTable .tbl_th { display: none; } /* Mobile Headers */
    #headCoachMultiTeamResultsTable { width: 825px; table-layout: fixed; border-collapse: collapse;border: 1px solid #ddd; }
    #headCoachMultiTeamResultsTable th,
    #headCoachMultiTeamResultsTable td { padding: 5px; text-align: center; width:275px; }
    #headCoachMultiTeamResultsTable thead tr { display: block; position: relative; }
    #headCoachMultiTeamResultsTable tbody { display: block; overflow: auto; width: 100%; height: 300px; }
    .old_ie_wrapper { height: 300px; width: 825px; overflow-x:hidden; overflow-y: auto; }
    .old_ie_wrapper tbody { height: auto; }

  @media screen and (max-width: 1200px) {
    #headCoachMultiTeamResultsTable { width: 650px; }
    #headCoachMultiTeamResultsTable th:nth-child(1),
    #headCoachMultiTeamResultsTable td:nth-child(1) { width: 200px; }
    #headCoachMultiTeamResultsTable th:nth-child(2),
    #headCoachMultiTeamResultsTable td:nth-child(2) { width: 200px; }
    #headCoachMultiTeamResultsTable th:nth-child(3),
    #headCoachMultiTeamResultsTable td:nth-child(3) { width: 250px; }
  }

  @media screen and (max-width: 480px) {
    #headCoachMultiTeamResultsTable,
    #headCoachMultiTeamResultsTable thead,
    #headCoachMultiTeamResultsTable tbody,
    #headCoachMultiTeamResultsTable tr,
    #headCoachMultiTeamResultsTable th,
    #headCoachMultiTeamResultsTable td {
      display: block;
      width: auto !important;
      height: auto;
      text-align: left;
    }
    #headCoachMultiTeamResultsTable { border: 0; }
    #headCoachMultiTeamResultsTable thead { display: none; }
    #headCoachMultiTeamResultsTable tr { border-radius: 2px 10px; border: 1px solid #ddd; padding: 3px; margin-bottom: 10px; }
    #headCoachMultiTeamResultsTable .tbl_th { display: inline; padding-right: 5px; font-weight: 600; }
  }
  </style>
</cfsavecontent>
<cfhtmlhead text="#page_css#">

<!--- JQuery and Tablesorter --->
<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="assets/tablesorter_2.0/jquery.tablesorter.min.js"></script>
	<!--- CUSTOM JAVASCRIPT --->
	<script type="text/javascript">
		$(document).ready(function(){

			// Tablesorter
			$('#headCoachMultiTeamResultsTable').tablesorter();

      // Submit Export Form
      $("button[name='exportReport']").click(function(){ 
        $("#exportForm").submit();
        console.log("Form submitted"); 
      });

		}); // document ready
	</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">
