<!--- 
	FileName:	refAssignmentGameView.cfm
	Created on: 04/21/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
05/20/2009 - aarnone - Ticket:7762 - changed default sort order to date
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Referee Assignments </H1>
<!--- <br> <h2>yyyyyy </h2> --->

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfquery name="qGetMinDate" datasource="#SESSION.DSN#">
		SELECT MIN(GAME_DATE) as min_game_date FROM V_Games
	</cfquery>
	<cfset WeekendFrom = dateFormat(qGetMinDate.min_game_date,"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(dateAdd("d",7,now()),"mm/dd/yyyy") >
</CFIF>

<cfif isDefined("FORM.RefID")>
	<cfset RefID = FORM.RefID>
<cfelse>
	<cfset RefID = 0>
</cfif>

<cfif isDefined("FORM.RefPos")>
	<cfset RefPos = FORM.RefPos>
<cfelse>
	<cfset RefPos = "ALL">
</cfif>

<cfif isDefined("FORM.GameFieldID")>
	<cfset GameFieldID = FORM.GameFieldID>
<cfelse>
	<cfset GameFieldID = 0>
</cfif>

<cfif isDefined("FORM.gameDiv")>
	<cfset gameDiv = FORM.gameDiv>
<cfelse>
	<cfset gameDiv = "">
</cfif>

<cfif isDefined("FORM.sortBy")>
	<cfset sortBy = FORM.sortBy>
<cfelse>
	<cfset sortBy = "date">
</cfif>
	
<!--- <CFIF SESSION.MENUROLEID EQ 23> <!--- 23=ref assignor --->
	<CFSET refAssignor = session.user.contactRoleID>
<cfelse>
	<CFSET refAssignor = 0 >
</CFIF> --->

<cfif isDefined("FORM.GO")>
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
				  (SELECT LastName + ', ' + FirstName FROM TBL_CONTACT WHERE contact_id = vg.AsstRefID2) AS AR2_name
		 FROM V_GAMES vg  
		where (	  vg.game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendFrom#">
			  and vg.game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#WeekendTo#">
			   )
			<cfif refPos NEQ "ALL">
				<cfif VARIABLES.refID GT 0>
					<cfswitch expression="#VARIABLES.refPos#">
						<cfcase value="REF">AND vg.RefID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#"> </cfcase>
						<cfcase value="AR1">AND vg.AsstRefID1 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#"> </cfcase>
						<cfcase value="AR2">AND vg.AsstRefID2 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#"> </cfcase>
					</cfswitch>
				</cfif>
			<cfelseif refID GT 0>
				AND (   vg.RefID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#">
					 OR vg.AsstRefID1 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#">
					 OR vg.AsstRefID2 = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.refID#">
					 )
			</cfif>
			<cfif GameFieldID GT 0>
				AND vg.field_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.GameFieldID#">
			</cfif>
			<cfif len(trim(gameDiv))>
				AND vg.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.gameDiv#">
			</cfif>
		ORDER BY
			<cfswitch expression="#VARIABLES.sortBy#">
				<!---<cfcase value="field"> vg.FIELDABBR, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  </cfcase>--->
				<cfcase value="game">  vg.game_id </cfcase>
				<cfcase value="div">   vg.Division, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  </cfcase>
				<cfcase value="ref">  <cfif refPos NEQ "ALL">
											<cfif VARIABLES.refID GT 0>
												<cfswitch expression="#VARIABLES.refPos#">
													<cfcase value="REF">REF_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24') </cfcase>
													<cfcase value="AR1">AR1_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24') </cfcase>
													<cfcase value="AR2">AR2_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24') </cfcase>
												</cfswitch>
											</cfif>
									  <cfelseif refID GT 0>
											REF_name, AR1_name, AR2_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  
									  <cfelse>
											REF_name, vg.game_date, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24')  
									  </cfif>
				</cfcase>
				<cfdefaultcase>  <!--- date ---> vg.game_date<!---, vg.FIELDABBR--->, dbo.formatDateTime(vg.GAME_TIME,'HH:MM 24') </cfdefaultcase>
			</cfswitch> 
	</cfquery>
</cfif>

	<!--- START REF ASSIGNOR LOGIC 
	<CFIF SESSION.MENUROLEID EQ 23>
		<!--- we have a ref assignor, the games must be limited to the games they are mapped to. --->
		<!--- get the assignor fields --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAssignorFields" returnvariable="qAssignorFields">
			<cfinvokeargument name="AssignorContactID" value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="orderBy" value="NAME">
		</cfinvoke>
		<cfset lstAssignorFieldIDs = "0">
		<CFIF qAssignorFields.recordCount>
			<cfset lstAssignorFieldIDs = valueList(qAssignorFields.FIELD_ID)>
		</CFIF>
		<!--- only select games on the fields in the list --->
		<cfquery name="refGameInfo_A" dbtype="query">
			SELECT * FROM refGameInfo_A
			WHERE FIELD_ID in (#lstAssignorFieldIDs#)
		</cfquery>
		<cfset ctGames = refGameInfo_A.recordCount>
	</CFIF>--->


<FORM name="Games" action="refAssignmentGameView.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
<TR><TD align="left">
		<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9" readonly> 
			<input type="Hidden" name="DOWfrom"  value="">
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendFrom)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendFrom)>
					<a href="javascript:show_calendar('Games.WeekendFrom','Games.DOWfrom','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>
		
		#repeatString("&nbsp;",3)#
		<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9" readonly>
			<input type="Hidden" name="DOWto"  value="">
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendTo)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendTo)>
					<a href="javascript:show_calendar('Games.WeekendTo','Games.DOWto','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>
		
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

		#repeatString("&nbsp;",3)#
		<B>Position </B> &nbsp;
			<SELECT name="RefPos" ID="RefPos"> 
				<OPTION value="ALL" >Select All</OPTION>
				<OPTION value="REF" <cfif RefPos EQ "REF">selected</cfif> >Head Referee</OPTION>
				<OPTION value="AR1" <cfif RefPos EQ "AR1">selected</cfif> >Assistant Ref 1</OPTION>
				<OPTION value="AR2" <cfif RefPos EQ "AR2">selected</cfif> >Assistant Ref 2</OPTION>
			</SELECT>
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
				<!--- If ( ucase(trim(Session("RoleCode"))) = "GAMESCHAIR" ) _
									  OR ( ucase(trim(Session("RoleCode"))) = "ASSTADMIN"  ) then
								<cfif (SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1) > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
									<cfquery name="otherFieldValues" datasource="#SESSION.DSN#">
										SELECT F.FIELD_ID, F.FIELDABBR, F.FIELDNAME
										  FROM TBL_FIELD F  INNER JOIN XREF_CLUB_FIELD xcf ON xcf.field_id = F.field_id
										 WHERE XCF.CLUB_ID = 1 
										   and f.Active_YN = 'Y'
									</cfquery>
									<CFLOOP query="otherFieldValues">
										<OPTION value="#FIELD_ID#" <cfif GameFieldID EQ FIELD_ID>selected</cfif> >#FIELDABBR#</OPTION>
									</CFLOOP>
								</cfif> --->
			</SELECT>
		
		#repeatString("&nbsp;",3)#
		<b>Division</b>
			<cfquery name="qAllDivs" datasource="#SESSION.DSN#">
				select distinct division from v_games order by division
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
				<!---<OPTION value="field" <cfif sortBy EQ "field">selected</cfif> >Field  </OPTION>--->
				<OPTION value="game"  <cfif sortBy EQ "game" >selected</cfif> >Game ##</OPTION>
				<OPTION value="div"   <cfif sortBy EQ "div"  >selected</cfif> >Division</OPTION>
			</SELECT>

		#repeatString("&nbsp;",3)#
		<input type="SUBMIT" name="Go"  value="Get Games" >  
		
		<!--- <input type="Submit" name="printpdf" value="printer friendly" >
		<input type="Submit" name="printcsv" value="csv file" > --->
	</td>
</tr>
</table>	
</FORM>

<cfset RecCountGrand	= 0>

<CFIF IsDefined("qAssignments")>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="07%">Game</TD>
			<TD width="07%">Div</TD>
			<TD width="07%">Date <br> Time</TD>
			<TD width="22%">PlayField</TD>
			<TD width="30%">Teams</TD>
			<td width="20%">Referees</td>
			<td width="07%">Report <br> submitted</td>
		</TR>
	</table>	
	
	<div style="overflow:auto; height:500px; border:1px ##cccccc solid;"> 
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<cfloop query="qAssignments">
		<cfset classValue = "class='tdUnderLine'">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="07%" valign="top" #classValue# >
				#game_id#
				<br>
				<cfswitch expression="#game_type#">
					<cfcase value="C"><br><span class="red">SC</span></cfcase>
					<cfcase value="N"><br><span class="red">NL</span></cfcase>
					<cfcase value="F"><br><span class="red">Fr</span></cfcase>
				</cfswitch>
			</TD>
			<TD width="07%" valign="top" #classValue# >
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

<!--- 
<CFIF isDefined("FORM.printpdf") >
	<script> window.open('refAssignmentReportcsv.cfm?wef=#VARIABLES.WeekendFrom#&wet=#VARIABLES.WeekendTo#&rep=pdf','popwin'); </script> 
</CFIF>
<CFIF isDefined("FORM.printcsv") >
	<script> window.open('refAssignmentReportcsv.cfm?wef=#VARIABLES.WeekendFrom#&wet=#VARIABLES.WeekendTo#&rep=csv','popwin'); </script> 
</CFIF>

 --->



</cfoutput>
</div>
<cfinclude template="_footer.cfm">
