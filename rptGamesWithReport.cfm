<!--- 
	FileName:	rptGamesWithReport.cfm
	Created on: 04/08/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">
<!--- <br>  --->

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(now(),"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(dateAdd("d",7,now()),"mm/dd/yyyy") >
</CFIF>

<H1 class="pageheading">NCSA - Games with Match Reports</H1>

<CFIF isDefined("FORM.SORTORDER")>
	<cfset selectSort = FORM.SORTORDER>
<CFELSE>
	<cfset selectSort = "REFEREE">
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
		   AND xgo.refReportSbm_YN = 'Y'
		   AND (	g.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#"> 
		   		AND g.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#"> 
				)
		<cfif selectSort EQ "DATE"> 
			ORDER BY g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
		<cfelseif selectSort EQ "DIV"> 
			ORDER BY g.Division_id, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
		<cfelseif selectSort EQ "FIELD"> 
			ORDER BY f.fieldAbbr, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
		<cfelseif selectSort EQ "REFEREE">  
			ORDER BY co.LastName, co.FirstName, g.game_date, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
		<cfelse>  
			ORDER BY g.game_id
		</cfif>		
		
</cfquery> 
<!--- 
--		   AND 	Score_Home  >= 0	  -- game was played	
--		   AND 	Score_visitor  >= 0		
 --->
<table cellspacing="0" cellpadding="5" align="center" border="0" width="800px" >
<TR><TD align="right">
		<FORM name="refAssgnDisplay" action="rptGamesWithReport.cfm" method="post">
			<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9" readonly> 
			<input type="Hidden" name="DOWfrom"  value="">
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendFrom)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendFrom)>
					<a href="javascript:show_calendar('refAssgnDisplay.WeekendFrom','refAssgnDisplay.DOWfrom','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9" readonly>
			<input type="Hidden" name="DOWto"  value="">
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendTo)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendTo)>
					<a href="javascript:show_calendar('refAssgnDisplay.WeekendTo','refAssgnDisplay.DOWto','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>
			&nbsp;&nbsp;&nbsp;
			<B>Sort By:</B> &nbsp;
			<select name="sortOrder">
				<option value="DATE" <cfif selectSort EQ "DATE">selected</cfif> >Date</option>
				<option value="FIELD" <cfif selectSort EQ "FIELD">selected</cfif> >Field</option>
				<option value="REFEREE" <cfif selectSort EQ "REFEREE">selected</cfif> >Referee</option>
				<option value="GAME" <cfif selectSort EQ "GAME">selected</cfif> >Game</option>
				<option value="DIV" <cfif selectSort EQ "DIV">selected</cfif> >Division</option>
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
	<div class="overflowBox" style="height:450px;">
	<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
		<cfset holdRefID = 0>
 		<CFLOOP query="qGetGames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<TD width="10%" class="tdUnderLine" >
					<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank">#Game_Id#</a>
				</TD>
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
<cfinclude template="_footer.cfm">
