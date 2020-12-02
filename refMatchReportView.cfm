<!--- 
	FileName:	refMatchReportView.cfm.cfm
	Created on: 04/22/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

04/28/09 - aa - added "edit" Link for admins when on using page as a report
05/20/2009 - aarnone - Ticket:7762 - changed default sort order to date
05/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<!--- <br> <h2>yyyyyy </h2> --->

<!--- There is an "edit" link for the ref report. 
	  Only show it if the role is ADMIN and we are not in report view for this page. --->
<cfset swShowEditLink = 0>
<cfset swrept = 0>
<cfif SESSION.MENUROLEID EQ 1>
	<cfif isDefined("URL.swrept") and URL.swrept EQ 1 >
		<cfset swShowEditLink = 1 >
		<cfset swrept = URL.swrept>
	<cfelseif isDefined("FORM.swrept") and FORM.swrept EQ 1>
		<cfset swShowEditLink = 1>
		<cfset swrept = FORM.swrept>
	</cfif>
</cfif>

<cfif isDefined("URL.wef") AND isDate(URL.wef)>
	<cfset WeekendFrom = dateFormat(URL.wef,"mm/dd/yyyy") > 
<cfelseif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("URL.wet") AND isDate(URL.wet)>
	<cfset WeekendTo   = dateFormat(URL.wet,"mm/dd/yyyy") >
<cfelseif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(session.currentseason.enddate,"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("URL.rfid") AND isNumeric(URL.rfid)>
	<cfset RefID = URL.rfid>
<cfelseif isDefined("FORM.RefID")>
	<cfset RefID = FORM.RefID>
<cfelse>
	<cfset RefID = 0>
</cfif>

<cfif isDefined("URL.fid") AND isNumeric(URL.fid)>
	<cfset GameFieldID = URL.fid>
<cfelseif isDefined("FORM.GameFieldID")>
	<cfset GameFieldID = FORM.GameFieldID>
<cfelse>
	<cfset GameFieldID = 0>
</cfif>

<cfif isDefined("URL.gdv")>
	<cfset gameDiv = URL.gdv>
<cfelseif isDefined("FORM.gameDiv")>
	<cfset gameDiv = FORM.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("URL.gid") AND isNumeric(URL.gid)>
	<cfset gameID = URL.gid>
<cfelseif isDefined("FORM.gameID") AND isNumeric(FORM.gameID)>
	<cfset gameID = FORM.gameID>
<cfelse>
	<cfset gameID = "">
</cfif>

<cfif isDefined("URL.sby")>
	<cfset sortBy = URL.sby>
<cfelseif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy>
<cfelse>
	<cfset sortBy = "date">
</cfif>

<cfset errMsg = "">

<!--- if we come back from another page, then force the select query to execute below --->
<cfif isDefined("url.gid") OR (isDefined("url.wef") AND isDefined("url.wet") AND isDefined("url.rfid") AND isDefined("url.fid") AND isDefined("url.gdv") AND isDefined("url.sby"))>
	<cfset swRunSelect = true>
<cfelse>
	<cfset swRunSelect = false>
</cfif>
	
<!--- <CFIF SESSION.MENUROLEID EQ 23> <!--- 23=ref assignor --->
	<CFSET refAssignor = session.user.contactRoleID>
<cfelse>
	<CFSET refAssignor = 0 >
</CFIF> --->

<cfif isDefined("FORM.GO")>
	<!--- filter crtieria endtered, zero out single game value --->
	<cfset gameID = "">
<cfelseif isDefined("FORM.GOSINGLE")>
	<!--- single game search, zero out filter values --->
	<cfset RefID = 0>
	<cfset GameFieldID = 0>
	<cfset gameDiv = "">
	<cfset sortBy = "ref">
</cfif> 



<cfif isDefined("FORM.GO") OR isDefined("FORM.GOSINGLE") OR swRunSelect>
	<cfset swContinue = true>
	<CFIF isDefined("FORM.GOSINGLE") and not isNumeric(VARIABLES.gameID)>
		<cfset swContinue = false>
		<cfset errMsg = "Game number must be a valid number.">
	</CFIF>

	<cfif swContinue>
		<cfquery name="qAssignments" datasource="#SESSION.DSN#">
			SELECT vg.game_id, vg.game_date, vg.game_time, vg.Division, vg.game_type,
				   vg.field_id, vg.fieldAbbr,
				   vg.HOME_TEAMNAME, vg.VISITOR_TEAMNAME, vg.virtual_teamName,
				   vg.refReportSbm_yn,
				   vg.RefID,	  vg.Ref_accept_YN, 
					  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.RefID) AS REF_name,
				   vg.AsstRefID1, vg.ARef1Acpt_YN, 
					  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.AsstRefID1) AS AR1_name,
				   vg.AsstRefID2, vg.ARef2Acpt_YN,
					  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.AsstRefID2) AS AR2_name,
		   dbo.f_getTeamRoster(home_team_id) as home_team_roster_id, dbo.f_getTeamRoster(visitor_team_id) as visitor_team_roster_id,
		   dbo.f_get_MDF(home_team_id, game_id) as home_team_mdf, dbo.f_get_MDF(visitor_team_id, game_id) as visitor_team_mdf
			 FROM V_GAMES_all vg  
			<cfif gameid NEQ "">
				WHERE vg.GAME_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.gameID#">
			<cfelse>
				WHERE (	  vg.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
					  AND vg.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
					   )
				  AND ( vg.game_type is null or vg.game_type = '' or vg.game_type in('L','F','P') ) 	
					  <cfif refID GT 0>
						  AND vg.RefID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#">
					  </cfif>
					  <cfif GameFieldID GT 0>
						  AND vg.field_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameFieldID#">
					  </cfif>
					  <cfif len(trim(gameDiv))>
						  AND vg.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
					  </cfif>
			</cfif>
			ORDER BY
				<cfswitch expression="#VARIABLES.sortBy#">
					<cfcase value="field"> vg.FIELDABBR, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="game">  vg.game_id </cfcase>
					<cfcase value="div">   vg.Division, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  </cfcase>
					<cfcase value="ref">   REF_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  	</cfcase>
					<cfdefaultcase>  <!--- date ---> vg.game_date, vg.FIELDABBR, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24') </cfdefaultcase>
				</cfswitch> 
		</cfquery>
	</cfif>
</cfif>

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">


<cfoutput>
<div id="contentText">

<H1 class="pageheading">
	NCSA - Referee Match Reports

	<cfif isDefined("qAssignments") AND qAssignments.RecordCount GT 0>
		<input id="printBtn" type="button" value="Print Report" />
	</cfif>
</H1>

<FORM name="Games" action="refMatchReportView.cfm"  method="post">
	<input type="Hidden" name="swrept" value="#VARIABLES.swrept#"> 

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >

<TR><TD align="left">
		<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
		
		#repeatString("&nbsp;",3)#
		<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		
		#repeatString("&nbsp;",3)#
		<B>Referee </B> &nbsp;
			<!--- get all certified referees --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
			<cfinvokeargument name="certifiedOnly" value="Y"> 
			</cfinvoke>
			<SELECT name="RefID" ID="RefID"> 
				<OPTION value="0" >Select All</OPTION>
				<cfloop query="qRefInfo"><!--- <cfif refId EQ CONTACT_ID>selected</cfif> --->
					<OPTION value="#CONTACT_ID#" <cfif CONTACT_ID EQ VARIABLES.refID>selected</cfif> >#LASTNAME#, #FIRSTNAME#</OPTION>
				</cfloop>
			</SELECT>
	</td>
	<td align="center">
		<B>Game Number </B> &nbsp;
			<input type="Text" name="gameID" value="#VARIABLES.gameID#" size="5">
			<br>(overrides all filters)

 	</td>
</tr>
<tr><td>
		<b>Fields</b>
			<cfquery name="qAllFields" datasource="#SESSION.DSN#">
				SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME AS FIELD
				  FROM TBL_FIELD F
				 Where FieldAbbr is not NULL 
				   and (Active_YN = 'Y')
				 Order by FieldAbbr
			</cfquery>
			<SELECT name="GameFieldID"> 
				<OPTION value="0" >Select All</OPTION>
				<CFLOOP query="qAllFields">
					<OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID >selected</cfif> >#FIELDABBR#</OPTION>
				</CFLOOP>
			</SELECT>
		
		#repeatString("&nbsp;",3)#
		<b>Division</b>
			<cfquery name="qAllDivs" datasource="#SESSION.DSN#">
				select distinct division from v_games WHERE division <> '' order by division
			</cfquery>
			<SELECT name="gameDiv"> 
				<OPTION value="" >Select All</OPTION>
				<CFLOOP query="qAllDivs">
					<OPTION value="#division#" <cfif gameDiv EQ division >selected</cfif> >#division#</OPTION>
				</CFLOOP>
			</SELECT>

		#repeatString("&nbsp;",3)#
		<b>Sort</b>
			<SELECT name="sortBy"> 
				<OPTION value="ref"   <cfif sortBy EQ "ref"  >selected</cfif> >Referee</OPTION>
				<OPTION value="date"  <cfif sortBy EQ "date" >selected</cfif> >Date   </OPTION>
				<OPTION value="field" <cfif sortBy EQ "field">selected</cfif> >Field  </OPTION>
				<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ##</OPTION>
				<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
			</SELECT>
		<input type="SUBMIT" name="Go"  value="Get Games" >  
	</td>
	<td align="center">
		<input type="SUBMIT" name="GoSingle"  value="Get Single Game" >  
		<!--- <input type="Submit" name="printpdf" value="printer friendly" >  
			  <input type="Submit" name="printcsv" value="csv file" > --->
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

<CFIF IsDefined("qAssignments")>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="09%">Game</TD>
			<TD width="05%">Div</TD>
			<TD width="07%">Date <br> Time</TD>
			<TD width="22%">PlayField</TD>
			<TD width="30%">Teams</TD>
			<td width="20%">Referees</td>
			<td width="07%">Report <br> submitted</td>
		</TR>
	</table>	
	
	<!--- <div style="overflow:auto; height:500px; border:1px ##cccccc solid;">  --->
	<div class="overflowbox" style="height:500px;">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<cfloop query="qAssignments">
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="09%" valign="top" #classValue# >
				<CFIF refReportSbm_yn EQ 'Y'>
					<a href="gameRefReportPrint.cfm?gid=#GAME_ID#" target="_blank"> <span class="red">#game_id#</span> </a>
					<!--- if show edit = true - 
							for it to be true then the menu role id must be for ADMIN
							AND a URL/FORM(?) param must be set for it to distinguish as only report or also allow edit
					
					set swShowEditLink = false
					IF SESSION.MENUROLEID EQ 1
						IF isDefined("URL.swrept") and URL.swrept EQ 1
							set swShowEditLink = true
						ELSE IF isDefined("FORM.swrept") anf FORM.swrept EQ 1
							set swShowEditLink = true
						END IF
					END IF
					--->
					<!--- <cfset swShowEditLink = false>
					<cfif SESSION.MENUROLEID EQ 1>
						<cfif isDefined("URL.swrept") and URL.swrept EQ 1>
							<cfset swShowEditLink = true >
						<cfelseif isDefined("FORM.swrept") and FORM.swrept EQ 1>
							<cfset swShowEditLink = true >
						</cfif>
					</cfif> --->
					<cfif swShowEditLink>
						&nbsp;<a href="gameReportEdit.cfm?gid=#GAME_ID#&wef=#VARIABLES.WeekendFrom#&wet=#VARIABLES.WeekendTo#&rfid=#VARIABLES.RefID#&fid=#VARIABLES.GameFieldID#&gdv=#VARIABLES.gameDiv#&sby=#VARIABLES.sortBy#" > edit</a>
					</cfif>
				<CFELSE>
					#game_id#
				</CFIF>
				
				<br>
				<cfswitch expression="#game_type#">
					<cfcase value="C"><br><span class="red">SC</span></cfcase>
					<cfcase value="N"><br><span class="red">NL</span></cfcase>
					<cfcase value="F"><br><span class="red">Fr</span></cfcase>
				</cfswitch>
			</TD>
			<TD width="05%" valign="top" #classValue# >
				#Division#
			</TD>
			<TD width="07%" valign="top" #classValue# >
				#dateFormat(game_date,"ddd")#
				<br> #dateFormat(game_date,"mm/dd/yy")# 
				<br>#timeFormat(game_time,"hh:mm tt")#
			</TD>
			<TD width="22%" valign="top" #classValue# >
				&nbsp;#fieldAbbr#
			</TD>
			<TD width="25%" valign="top" #classValue# >
				(H) #Home_TeamName#  
				<br>(V) 
					<cfif len(trim(Visitor_TeamName))>
						#Visitor_TeamName# 
					<cfelse>
						#Virtual_TeamName#
					</cfif>

				<!--- <cfquery datasource="#application.dsn#" name="getGameDayDoc">
					select game_day_document_id from TBL_GAME_DAY_DOCUMENTS
					where game_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#game_id#">
				</cfquery> --->
				<!--- <cfset official_game_date = dateformat(GAME_DATE,"mm/dd/yyyy") & ' ' & timeformat(GAME_TIME,"hh:mm:ss t")>
				<cfdump var="#datediff('h',official_game_date,now())#"><cfdump var="#GAME_TIME#">   
				<cfif datediff('h',official_game_date,now()) lte 24 and datediff('h',official_game_date,now()) gte -24>  --->
				<!--- <cfif getGameDayDoc.RecordCount> --->
				<p style="margin: 20px 20px 20px 20px;"><a href="ViewGameDayDocs.cfm?game_id=#game_id#" target="_blank" class="yellow_btn"><i class="fa fa-file"></i> Game Day Documents</a></p>
				<!--- </cfif> --->
				<!--- </cfif>  --->
			</TD>
			<TD width="27%" valign="top" #classValue# >
				<!--- Head Referee --->
					<cfif     Ref_accept_YN EQ "Y"> <span class="green"><b>A</b></span>
					<cfelseif Ref_accept_YN EQ "N">	<span class="red"><b>D</b></span>
					<cfelse>  &nbsp; &nbsp;
					</cfif>
					<cfif VARIABLES.refID EQ REFID> <b>REF: #REF_name#</b> <cfelse>REF: #REF_name# 	
					</cfif>
				<br><!--- Asst Referee 1 ---> 
					<cfif     ARef1Acpt_YN EQ "Y">  <span class="green"><b>A</b></span>
					<cfelseif ARef1Acpt_YN EQ "N">	<span class="red"><b>D</b></span>
					<cfelse>  &nbsp; &nbsp;
					</cfif>
					<cfif VARIABLES.refID EQ AsstRefID1> <b>AR1: #AR1_name#</b> <cfelse>AR1: #AR1_name# 
					</cfif>
				<br><!--- ASST Referee 2 --->
					<cfif     ARef2Acpt_YN EQ "Y">  <span class="green"><b>A</b></span>
					<cfelseif ARef2Acpt_YN EQ "N">	<span class="red"><b>D</b></span>
					<cfelse>  &nbsp; &nbsp;
					</cfif>
					<cfif VARIABLES.refID EQ AsstRefID2> <b>AR2: #AR2_name#</b> <cfelse>AR2: #AR2_name# 
					</cfif>
			</TD>
			<TD width="05%" valign="top" #classValue# >
				#refReportSbm_yn#
			</TD>
		</TR>
		<cfset RecCountGrand = RecCountGrand + 1 >
	</cfloop>
	</table>
	</DIV>
	<TABLE cellSpacing=0 cellPadding=5 width="100%" border=0>
			<tr bgcolor="##CCE4F1">
				<td colspan="6" align="center">
					<b> Total between #WeekendFrom# and #WeekendTo# = #RecCountGrand# </b>
				</td>
			</tr>
	</table>
</CFIF>

</cfoutput>
</div>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
		
		$("#printBtn").click(function () {
			window.open('refMatchReportView_PDF.cfm?<cfoutput>swrept=#swrept#&WeekendFrom=#WeekendFrom#&WeekendTo=#WeekendTo#&RefID=#RefID#&GameFieldID=#GameFieldID#&gameDiv=#gameDiv#&gameID=#gameID#&sortBy=#sortBy#</cfoutput>');
		});
		
	});
</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">





