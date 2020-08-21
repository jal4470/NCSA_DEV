<!--- 
	FileName:	rptGameForfeit.cfm
	Created on: 03/03/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/17/09 - aarnone - report mods: default dates, league only games, sort, scroll bar.
06/15/17 - mgreenberg - report mods: updated datepicker. 
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Games with Forfeit Recorded</H1>
<!--- <h2>yyyyyy </h2> --->

<!--- 	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*">
 --->




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
<!--- gd[#goalDiff#]--g[#BGSelected#]- a[#TeamAgeSelected#]- l[#PlayLevel#] = [#divValue#] --->
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

<!--- <CFIF isDefined("FORM.GO")> --->
	<CFQUERY name="qGetGames" datasource="#SESSION.DSN#">
		SELECT  GAME_ID, GAME_DATE, GAME_TIME, GAME_TYPE, 
				FIELDABBR, DIVISION,
				HOME_TEAM_ID,    HOME_TEAMNAME,     Forfeit_Home,
				VISITOR_TEAM_ID, VISITOR_TEAMNAME,  Forfeit_Visitor
		  FROM  V_GAMES_all
		 WHERE (	GAME_DATE >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
				AND GAME_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
				)
		   AND  ( Forfeit_Home = 'Y' OR  Forfeit_Visitor = 'Y' )
		  <CFIF len(trim(divValue))>
			  	AND DIVISION LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.divValue#">
		  </CFIF>
		  <CFIF session.user.clubID NEQ 1>
		   AND (   Home_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#session.user.clubID#">
		        OR Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#session.user.clubID#">
				)
		  </CFIF>
		  AND (GAME_Type = 'L' OR GAME_Type IS NULL )
		 ORDER BY <CFIF selectSort EQ "FLIT">
		 				Division, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24')
		 		  <CFELSE>
				  		GAME_DATE, Division, dbo.formatDateTime(GAME_TIME,'HH:MM 24')		
				  </CFIF> 
	</CFQUERY>
	<!---  ORDER BY <CFIF selectSort EQ "FLIT"> DIVISION, </CFIF> GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') --->
<!--- </CFIF> --->


<!--- === START - Get values for Drop Down Lists === --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->
<!--- === END - Get values for Drop Down Lists === --->

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<FORM name="excessScore" action="rptGameForfeit.cfm"  method="post">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%" >
	<TR><td align="center">
			<b>Gender:</b>
			<br>
			<SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>
		</TD>
		<TD align="center">
			<b>Team Age:</b>
			<br>
			<SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
		<TD align="center">
			<b>Level:</b>
			<br>
			<SELECT  name="PlayLevel">
				<OPTION value="" selected>All</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
		<TD align="center">
			<B>From</B> <br>
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
		</TD>
		<TD align="center">
			<B>To</B> <br>
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		</TD>
		<TD align="center">
			<b>Sort By:</b>
			<br>
			<select name="sortOrder">
				<option value="DATE" <cfif selectSort EQ "DATE">selected</cfif> >Date</option>
				<option value="FLIT" <cfif selectSort EQ "FLIT">selected</cfif> >Flight</option>
			</select>
		</TD>
		<TD><INPUT type="Submit" name="Go" value="Go">
		</TD>
	</TR>
</table>
</FORM>
<br>	

<CFIF isDefined("qGetGames.RECORDCOUNT") AND qGetGames.RECORDCOUNT GT 0>
	
	<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
		<tr><TD colspan="6" align="right"> 
				<span class="red">Team names that appear </span> <b>Bold</b> <span class="red">have forfeited. </span> 
			</TD>
		</TR>
		<tr class="tblHeading">
			<TD width="08%" align="center">Game </TD>
			<TD width="14%">Date/Time</TD>
			<TD width="20%">Field</TD>
			<TD width="08%">Division</TD>
			<TD width="25%" align="center">Home Team</TD>
			<TD width="25%">VisitorTeam</TD>
		</TR>
	</table>
	
	<div style="overflow:auto; height:350px; border:1px ##cccccc solid;">
	<!--- <div class="overflowbox" style="height:350px;"> --->
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%" >
		<CFLOOP query="qGetGames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
				<TD width="08%" valign="top" class="tdUnderLine" align="center">#GAME_ID# </TD>
				<TD width="14%" valign="top" class="tdUnderLine"> #dateFormat(GAME_DATE,"mm/dd/yyyy")#  #timeFormat(GAME_TIME,"hh:mm tt")# </TD>
				<TD width="20%" valign="top" class="tdUnderLine">#FIELDABBR# </TD>
				<TD width="08%" valign="top" class="tdUnderLine">#Division# </TD>
				<TD width="25%" valign="top" class="tdUnderLine">
					<cfif Forfeit_Home EQ 'Y'>
						<b>#HOME_TEAMNAME#</b>
					<cfelse>
						#HOME_TEAMNAME#
					</cfif>
				</TD>
				<TD width="25%" valign="top" class="tdUnderLine">
					<cfif Forfeit_Visitor EQ 'Y'>
						<b>#VISITOR_TEAMNAME# </b>
					<cfelse>
						#VISITOR_TEAMNAME# 
					</cfif>
				</TD>
			</TR>
		</CFLOOP>	
	</TABLE>
	</div>
<CFELSEIF isDefined("qGetGames.RECORDCOUNT") AND qGetGames.RECORDCOUNT EQ 0>
	<span class="red">There are no forfeits based on the selection criteria.</span> 
</CFIF>		
	
	
</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		
	});
</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">




