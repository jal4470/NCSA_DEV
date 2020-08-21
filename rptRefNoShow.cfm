<!--- 
	FileName:	rptRefNoShow.cfm
	Created on: 02/24/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: 
	
	
MODS: mm/dd/yyyy - filastname - comments
06/15/17 - mgreenberg - report mods: updated datepicker. 
 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Games With Referee Not Present</H1>	
<br><!--- <h2> </h2> --->


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

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = FORM.WeekendFrom >
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</cfif>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo = FORM.WeekendTo >
<cfelse>
	<cfset WeekendTo = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</cfif>

<CFIF isDefined("FORM.SORTORDER")>
	<cfset selectSort = FORM.SORTORDER>
<CFELSE>
	<cfset selectSort = "">
</CFIF>

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

<FORM name="Games" action="rptRefNoShow.cfm" method="post" id="Games">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="80%" >
	<TR><TD valign="bottom"><b>Gender:</b>		 </TD>
		<TD valign="bottom"><b>Age:</b>	 		</TD>
		<!--- <TD valign="bottom"><b>Level:</b>		 </TD> --->
		<TD valign="bottom"><b>Play Weekend:</b> </TD>
		<TD valign="bottom"><b>Sort By:</b>		 </TD>
		<TD>&nbsp;				 </TD>
	</TR>
	<TR><TD><SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>
		</TD>
		<TD><SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
	<td>
		<B>From</B> &nbsp;
		<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
		&nbsp;&nbsp;&nbsp;
		<B>To</B> &nbsp;
		<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		&nbsp;&nbsp;&nbsp;
	</td>
	<TD><select name="sortOrder">
			<option value="DATE" <cfif selectSort EQ "DATE">selected</cfif> >Date</option>
			<option value="REFEREE" <cfif selectSort EQ "REFEREE">selected</cfif> >Referee</option>
		</select>
	</TD>
	<TD><INPUT type="Submit" name="getGames" value="Go">
	</TD>
</TR>
</table>
</FORM> <!--- End of Selection form --->



<!--- <CFIF isDefined("FORM.getGames")> --->
	<CFIF len(trim(BGSelected)) AND len(trim(TeamAgeSelected))>
		<!--- both were selected --->
		<CFSET getDiv = BGSelected & right(TeamAgeSelected,2) & "%">
	<CFELSEIF len(trim(BGSelected))>
		<!--- only Gender was selected --->
		<CFSET getDiv = BGSelected & "%">
	<CFELSEIF len(trim(TeamAgeSelected))>
		<!--- only Age was selected --->
		<CFSET getDiv =  "%" & right(TeamAgeSelected,2) & "%">
	<CFELSE>
		<!--- none selected --->
		<CFSET getDiv =  "">
	</CFIF>

	<!--- Get Teams based on selection criteria --->
	<cfquery name="qGetGames" datasource="#SESSION.DSN#">
		select g.season_id, g.game_id, g.game_date, g.game_time, g.Division_id, 
			   f.fieldAbbr,  
			   xgo.xref_game_official_id, xgo.game_official_type_id,
			   lgo.game_official_type_name,
			   co.FirstName, co.LastName 
		  from TBL_GAME G LEFT JOIN XREF_GAME_OFFICIAL xgo ON xgo.game_id = g.game_id
						  INNER JOIN tlkp_game_official_type lgo ON lgo.game_official_type_id = xgo.game_official_type_id
						  LEFT JOIN TBL_FIELD    f ON f.FIELD_ID = g.FIELD_ID	
						  LEFT JOIN TBL_CONTACT co ON co.CONTACT_ID = xgo.CONTACT_ID	
		 WHERE g.season_id = #SESSION.CURRENTSEASON.ID#
		   AND g.RefNoShow = 'Y'
		   AND (	g.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#"> 
		   		AND g.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#"> 
				)
		   AND xgo.game_official_type_id = 1
			<CFIF len(trim(getDiv))>
				AND g.Division_id LIKE '#VARIABLES.getDiv#'
			</CFIF>
			
		ORDER BY <cfif selectSort EQ "REFEREE"> 
					co.LastName, co.FirstName, 
				</cfif>		
				g.game_date, g.Division_id, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
	</cfquery> <!---  <cfdump var="#qGetGames#"> --->
<!--- </CFIF> --->


<CFIF isDefined("qGetGames") AND qGetGames.RECORDCOUNT GT 0>
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<td width="10%">Game</td>
			<td width="15%">Date/Time </td>
			<td width="20%">Field</td>
			<td width="15%">Flight</td>
			<td width="20%">Official</td>
			<td width="15%">Position</td>
		</tr>
		<CFLOOP query="qGetGames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td class="tdUnderLine" >#game_id# </td>
				<td class="tdUnderLine" >#dateFormat(game_date,"mm/dd/yy")# #timeFormat(game_time,"hh:mm tt")# </td>
				<td class="tdUnderLine" >#fieldAbbr# </td>
				<td class="tdUnderLine" >#Division_id# </td>
				<td class="tdUnderLine" >#LastName#, #FirstName# </td>
				<td class="tdUnderLine" >#game_official_type_name# </td>
			</tr>
		</CFLOOP>
	</table>
<cfelseIF isDefined("qGetGames") AND qGetGames.RECORDCOUNT EQ 0>
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<td>&nbsp;</td>
		</tr>
		<TR><td> <span class="red"> <b>No Games found based on choices.</b></span> </td>
		</TR>
	</table>
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
