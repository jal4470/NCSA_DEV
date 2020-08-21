<!--- 
	FileName:	rptRefereeassign.cfm
	Created on: 02/25/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
06/15/17 - mgreenberg - report mods: updated datepicker. 
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
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<CFIF isDefined("URL.st") and isNumeric(URL.st) >
	<cfset assignmentStatus = URL.st>
<CFELSEIF isDefined("FORM.assignmentStatus")>
	<cfset assignmentStatus = FORM.assignmentStatus>
<CFELSE>
	<cfset assignmentStatus = 0><!--- NOT ACCEPTED --->
</CFIF>
<CFIF assignmentStatus EQ 0>
	<!--- NOT ACCEPTED --->
	<cfset whereRefAccptYN = " is NULL ">
	<H1 class="pageheading">NCSA - Games with Referee Not Accepted</H1>
	<cfset stsText = "NOT ACCEPTED">
<cfelse>
	<!--- REJECTED --->
	<cfset whereRefAccptYN = " = 'N' ">
	<H1 class="pageheading">NCSA - Games with Referee Declining Assignment</H1>
	<cfset stsText = "DECLINED">
</CFIF>

<CFIF isDefined("FORM.SORTORDER")>
	<cfset selectSort = FORM.SORTORDER>
<CFELSE>
	<cfset selectSort = "DATE">
</CFIF>



<cfquery name="qGetGames" datasource="#SESSION.DSN#">
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division,  G.fieldAbbr,
		       G.RefID, C.FirstName, C.LastName,  
			   G.Ref_accept_Date, G.Ref_accept_YN, 'REF' as refType
		  from V_Games_all G  inner JOIN TBL_CONTACT C  ON C.CONTACT_ID  = g.REFID
		 Where G.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">
		   and G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.Ref_accept_Date is NULL 
		   and G.Ref_accept_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	UNION
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division,  G.fieldAbbr,
			   G.AsstRefID1, C1.FirstName, C1.LastName,  
			   G.ARef1AcptDate,   G.ARef1Acpt_YN, 'AR1' as refType
		  from V_Games G   inner JOIN TBL_CONTACT C1 ON C1.CONTACT_ID = g.AsstRefID1
		 Where G.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">
		   and G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.ARef1AcptDate is NULL 
		   and G.ARef1Acpt_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	UNION
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division,  G.fieldAbbr,
			   G.AsstRefID2, C2.FirstName, C2.LastName,  
			   G.ARef2AcptDate,   G.ARef2Acpt_YN, 'AR2' as refType
		  from V_Games G   inner JOIN TBL_CONTACT C2 ON C2.CONTACT_ID = g.AsstRefID2
		 Where G.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">
		   and G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.ARef2AcptDate is NULL 
		   and G.ARef2Acpt_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	ORDER BY 
		<CFIF selectSort EQ "DATE">
			2, 8, 7, 3 
		<CFELSE>
			8, 7, 2, 3 
		</CFIF>
	
</cfquery> 

<cfsavecontent variable="custom_css">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
</cfsavecontent>
<cfhtmlhead text="#custom_css#">

<table cellspacing="0" cellpadding="5" align="center" border="0" width="800px" >
<TR><TD align="right">
		<FORM name="refAssgnDisplay" action="rptRefereeassign.cfm" method="post">
			<input type="hidden" name="assignmentStatus" value="#VARIABLES.assignmentStatus#">
			<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			&nbsp;&nbsp;&nbsp;
			<B>Sort By:</B>
			<select name="sortOrder">
				<option value="DATE" <cfif selectSort EQ "DATE">selected</cfif> >Date</option>
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
			<TD width="20%"> Name 		</TD>
			<TD width="10%"> Pos 		</TD>
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
				<TD width="10%" class="tdUnderLine" >#Division#</TD>
				<TD width="20%" class="tdUnderLine" >#LastName#, #FirstName#</TD>
				<TD width="10%" class="tdUnderLine" >#REFTYPE#</TD>
			</TR>
		</CFLOOP>
	</table>
	</div> 
<CFELSEIF IsDefined("qGetGames") AND qGetGames.RECORDCOUNT EQ 0 >
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
		<tr class="tblHeading">
			<td>&nbsp;</td>
		</tr>
		<TR><td> <span class="red"> <b>No Records found based on choices.</b></span> </td>
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
