<!--- 
	FileName:	rptGamesmissingreport.cfm
	Created on: 02/25/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/17/09 - aarnone - report mods: default dates, league only games, sort, scroll bar.
06/15/17 - mgreenberg - report mods: updated datepicker. 
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 

<cfif isDefined("form.WeekendFrom") and form.WeekendFrom NEQ "">
	<cfset WeekendFrom = dateformat(form.WeekendFrom,"mm/dd/yyyy") > 
<cfelseif isDefined("url.WeekendFrom") and url.WeekendFrom NEQ "">
	<cfset WeekendFrom = url.WeekendFrom>
<cfelse>
	<cfset WeekendFrom = dateformat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("form.WeekendTo") and form.WeekendTo NEQ "">
	<cfset WeekendTo   = dateformat(form.WeekendTo,"mm/dd/yyyy") >
<cfelseif isDefined("url.WeekendTo") and url.WeekendTo NEQ "">
	<cfset WeekendTo = url.WeekendTo>
<cfelse>
	<cfset WeekendTo   = dateformat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("form.sortOrder") and form.sortOrder NEQ "">
	<cfset selectSort   = form.sortOrder>
<cfelseif isDefined("url.sortOrder") and url.sortOrder NEQ "">
	<cfset selectSort = url.sortOrder>
<cfelse>
	<cfset selectSort   = "" >
</CFIF>

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
		   AND xgo.game_official_type_id = 1	
		   AND xgo.refReportSbm_YN <> 'Y'
		   AND g.game_type is NULL    
		   AND (	g.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#"> 
		   		AND g.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#"> 
				)
		   AND 	Score_Home  >= 0	  
		   AND 	Score_visitor  >= 0		
		ORDER BY <cfif selectSort EQ "DATE"> 
					g.game_date, co.LastName, co.FirstName, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
				<cfelseif selectSort EQ "FIELD"> 
					f.fieldAbbr, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
				<cfelse> 
					co.LastName, co.FirstName, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
				</cfif>		
</cfquery> 

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">
	NCSA - Games with Referee Not Filed Match Report 
	<cfif isDefined("qGetGames") AND qGetGames.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>
<!--- <br>  --->

<table cellspacing="0" cellpadding="5" align="center" border="0" width="800px" >
<TR><TD align="right">
		<FORM name="refAssgnDisplay" action="rptGamesmissingreport.cfm" method="post">
			<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			&nbsp;&nbsp;&nbsp;
			<B>Sort By:</B> &nbsp;
			<select name="sortOrder">
				<option value="DATE" <cfif selectSort EQ "DATE">selected</cfif> >Date</option>
				<option value="FIELD" <cfif selectSort EQ "FIELD">selected</cfif> >Field</option>
				<option value="REFEREE" <cfif selectSort EQ "REFEREE">selected</cfif> >Referee</option>
			</select>
			
			<input type="SUBMIT" name="Go"  value="Go" >  
		</FORM>
 	</td>
</tr>
</table>	


<CFIF IsDefined("qGetGames") AND qGetGames.RECORDCOUNT GT 0 >
	<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="10%"> Game		</TD>
			<TD width="25%"> Date/Time </TD>
			<TD width="25%"> Play Field</TD>
			<TD width="10%"> Div	 	</TD>
			<TD width="30%"> Name 		</TD>
		</TR>
	</table>
	<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;"> --->
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
		<cfset holdRefID = 0>
 		<CFLOOP query="qGetGames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<TD width="10%" class="tdUnderLine" >#Game_Id#</TD>
				<TD width="25%" class="tdUnderLine">
						#DateFormat(Game_Date,'mm/dd/yyyy')# 
							#repeatString("&nbsp;",3)#
						#TimeFormat(Game_Time,'hh:mm tt')#
				</TD>
				<TD width="25%" class="tdUnderLine" >#fieldAbbr#</TD>
				<TD width="10%" class="tdUnderLine" >#Division_id#</TD>
				<TD width="30%" class="tdUnderLine" >#LastName#, #FirstName#</TD>
			</TR>
		</CFLOOP>
	</table>
	</div> 
<CFELSEIF IsDefined("qGetGames") AND qGetGames.RECORDCOUNT EQ 0 >
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading"><td>&nbsp;</td></tr>
		<TR><td><span class="red"> <b>No Records found based on choices.</b></span> </td></TR>
	</table>
</CFIF>


</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<cfoutput>
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		$("##printBtn").click(function () {
			window.open('rptGamesmissingreport_PDF.cfm?selectSort=#selectSort#&WeekendFrom=#WeekendFrom#&WeekendTo=#WeekendTo#');
		});
		
	});
</script>
</cfoutput>
</cfsavecontent>
<cfinclude template="_footer.cfm">
