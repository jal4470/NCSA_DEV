<!--- 
	FileName:	rptGameMissingScore.cfm
	Created on: 03/03/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

04/17/09 - aarnone - report mods: default dates, league only games, sort, scroll bar.
06/15/17 - mgreenberg - report mods: updated datepicker. 
08/14/17 - apinzone - NCSA27024 - Fixed an issue with content flowing off the page.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 

<CFSET clubID = SESSION.USER.CLUBID> 

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

<!--- Start WHERE value for DIVISION based on filters --->
<cfset divValue = "">
<cfif len(trim(BGSelected))>
	<cfset divValue = ucase(BGSelected)> 
</cfif>

<cfif len(trim(TeamAgeSelected))>
	<cfset divValue = divValue & right(TeamAgeSelected, 2) > 
</cfif>
	
<cfif len(trim(PlayLevel))>
	<!--- was age selected --->
	<cfif len(trim(TeamAgeSelected))>
		<!--- yes, append level --->
		<cfset divValue = divValue & PlayLevel >
	<cfelse>
		<!--- no, not selected --->
		<cfif len(trim(BGSelected))>
			<!--- gender was selected --->
			<cfset divValue = divValue & PlayLevel>
		<cfelse>
			<!--- gender was not selected --->
			<cfset divValue = PlayLevel >
		</cfif>
	</cfif>
</cfif>

<!--- put % around the value unless gender was selected --->
<cfif len(trim(divValue))>
	<cfif len(trim(BGSelected))>
		<cfset divValue = divValue & "%" >
	<cfelse>
		<cfset divValue = "%" & divValue & "%" >
	</cfif>
</cfif>
<!--- --g[#BGSelected#]- a[#TeamAgeSelected#]- l[#PlayLevel#] = [#divValue#] --->
<!--- End WHERE value for DIVISION based on filters --->


<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfquery name="qGetGames" datasource="#SESSION.DSN#">
	SELECT vg.Game_ID, vg.GAME_DATE, vg.GAME_TIME, 
		   vg.HOME_TEAM_ID, vg.HOME_TEAMNAME,  
		   vg.VISITOR_TEAM_ID, vg.VISITOR_TEAMNAME,  
		   vg.FIELDABBR, vg.Field_id, vg.Division, vg.GAME_Type, f.club_id
	  FROM V_Games_all vg INNER JOIN TBL_FIELD f ON f.field_id = vg.field_id
	 WHERE (	vg.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
			AND vg.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
			)
	   AND vg.HScore is Null
	   AND vg.VScore is Null
	  <CFIF clubID NEQ 1>
	   AND (   VG.Home_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubID#">
	        OR vg.Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubID#">
			)
	  </CFIF>
	  <CFIF len(trim(divValue))>
	  	AND vg.Division LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.divValue#">
	  </CFIF>
	  AND (vg.GAME_Type = 'L' OR vg.GAME_Type IS NULL )
	 ORDER BY <CFIF selectSort EQ "FLIT">
	 				vg.Division, vg.GAME_DATE, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')
	 		  <CFELSE>
			  		vg.GAME_DATE, vg.Division, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')		
			  </CFIF> 
</cfquery><!--- <CFIF selectSort EQ "FLIT">vg.Division, </CFIF> vg.GAME_DATE, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')		 --->

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<!--- <h2>As of #dateFormat(now(),"mm/dd/yyyy")# </h2> --->

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<style type="text/css">
		.overflowbox { height: 450px; }
		@media print { .overflowbox { height: auto; overflow:visible; } }
	</style>
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<!--- === START - Get values for Drop Down Lists === --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->
<!--- === END - Get values for Drop Down Lists === --->

<cfoutput>
<div id="contentText">
<H1 class="pageheading">
	NCSA - Games with Missing Scores 
	<cfif isDefined("qGetGames") AND qGetGames.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>


<FORM name="missingScore" action="rptGameMissingScore.cfm" method="post">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" >
	<TR><TD><b>Gender:</b>
			<SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>
		</TD>
		<TD><b>Team Age:</b>
			<SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
		<TD><b>Level:</b>
			<SELECT  name="PlayLevel">
				<OPTION value="" selected>All</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
		<TD><B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		</TD>
		<TD><b>Sort By:</b>
			<select name="sortOrder">
				<option value="DATE" <cfif selectSort EQ "DATE">selected</cfif> >Date</option>
				<option value="FLIT" <cfif selectSort EQ "FLIT">selected</cfif> >Flight</option>
			</select>
		</TD>
		<TD><INPUT type="Submit" name="getGames" value="Go">
		</TD>
	</TR>
</table>
</FORM> <!--- End of Selection form --->

<table cellspacing="0" cellpadding="0" align="center" border="0" width="100%">
	<TR class="tblHeading">
		<TD width="08%" align="center">Game </TD>
		<TD width="16%" >Date/Time</TD>
		<TD width="22%" >Field</TD>
		<TD width="08%" >Division</TD>
		<TD width="23%" >Home Team</TD>
		<TD width="23%" >Visitor Team</TD>
	</TR>
</TABLE>

<!--- <div style="overflow:auto; height:450px; border:1px ##cccccc solid;"> --->
<div class="overflowbox">
<table cellspacing="0" cellpadding="1" align="left" border="0" width="100%">
	<cfloop query="qGetGames">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,CURRENTROW)#">
			<TD width="08%" class="tdUnderLine" valign="top">&nbsp; #GAME_ID#</TD>
			<TD width="16%" class="tdUnderLine" valign="top">#DateFormat(GAME_DATE, "mm/dd/yyyy")#  #timeFormat(GAME_TIME,"hh:mm tt")# </TD>
			<TD width="23%" class="tdUnderLine" valign="top">#FIELDABBR# </TD>
			<TD width="07%" class="tdUnderLine" valign="top">#Division#  </TD>
			<TD width="23%" class="tdUnderLine" valign="top">#HOME_TEAMNAME# &nbsp;</TD>
			<TD width="23%" class="tdUnderLine" valign="top">#VISITOR_TEAMNAME# &nbsp;</TD>
		</TR>
	</cfloop>
</TABLE>
</div>
</div>


</cfoutput>
<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		$("##printBtn").click(function () {
			window.open('rptGameMissingScore_PDF.cfm?TeamAgeSelected=#TeamAgeSelected#&BGSelected=#BGSelected#&PlayLevel=#PlayLevel#&selectSort=#selectSort#&WeekendFrom=#WeekendFrom#&WeekendTo=#WeekendTo#');
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>

<cfinclude template="_footer.cfm">

  
