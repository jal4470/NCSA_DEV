<!--- 
	FileName:	refereeUnPaidReport.cfm
	Created on: 10/29/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 

	
	<cfquery name="refUnPaidAdded" datasource="#SESSION.DSN#">
		select  						r.RefPosition,
				r.REFID, co.FirstNAME, co.LastName,
				r.GAME,  r.GDATE,  r.GTIME, r.DIVISION, r.COMMENTS,
				r.FIELD, r.FIELDABBR, 
				dbo.getTeamName(r.HOME)    AS HomeTeamName,
				dbo.getTeamName(r.VISITOR) AS VisitorTeamName,
				r.RefAmountOwed, C.CLUB_NAME,
				r.FIELDID, 	th.Club_ID,
				r.RefGameDateUnpaid,  
				r.HOME, r.VISITOR,  r.SEASONID, r.STATUS, 
				r.DATEADDED, r.ADDBYUSER, r.TIMEADDED, 
				r.DATEUPDATED, r.UPDBYUSER, r.TIMEUPDATED
		  from  RefUnPaid r INNER JOIN TBL_TEAM TH 		ON TH.TEAM_ID = R.Home
							INNER JOIN TBL_CLUB C 		ON C.CLUB_ID = TH.CLUB_ID
							INNER JOIN TBL_CONTACT CO	ON CO.CONTACT_ID = R.REFID
		 where  r.seasonid = #SESSION.CURRENTSEASON.ID#
		 ORDER BY C.CLUB_NAME, r.gDate DESC, r.gTime DESC
	</cfquery> <!--- <cfdump var="#refUnPaid#"> --->


<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfsavecontent variable="cfhtmlhead_unpaid">
<script>window.jQuery || document.write(unescape('%3Cscript src="assets/jquery-1.10.1.min.js"%3E%3C/script%3E'))</script>
<script>
	$(function () {
		$("#printBtn").click(function () {
			window.open('refereeUnPaidReport_PDF.cfm');
		});
	});
</script>
</cfsavecontent>
<cfhtmlhead text="#cfhtmlhead_unpaid#">
<cfoutput>
<div id="contentText">
	<H1 class="pageheading">
		NCSA - UnPaid Referee Report 
		<cfif isDefined("refUnPaidAdded") AND refUnPaidAdded.RecordCount GT 0>
			<input id="printBtn" type="button" value="Print Report" />
		</cfif>
	</H1>
	<!--- <br> <h2>yyyyyy </h2> --->
	
	<cfset WhereClub = "">
	<cfif IsDefined("SESSION.MENUROLEID") AND listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0 > <!---  "CU" = 26=club pres, 27=club rep, 28=club alt rep, 29=coach  --->
		<cfset WhereClub = " and B.ClubId = " & SESSION.USER.CLUBID >
	</cfif>
	
	<!--- <cfquery name="qGetUnPaid" datasource="#SESSION.DSN#">
		select  R.xref_game_official_id, R.game_official_type_id,
				R.Refid, R.RefFirstName, R.RefLastName,    
				R.game_id,      R.game_date, R.game_time, R.Division, R.RefPaidComment,
				R.field_id, R.FieldAbbr, R.HomeTeamName,  R.VisitorTeamName,
				R.RefAmountOwed,
				C.Club_NAME
		  from  V_RefUnPaid R INNER JOIN TBL_CLUB C ON R.HomeClubID = C.CLUB_ID
		  ORDER by C.Club_NAME, R.GAME_ID
	</cfquery> --->
	
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="23%">Referee</TD>
			<TD width="06%">Pos</TD>
			<TD width="06%" >Owed</TD>
			<TD width="06%">Game</TD>
			<TD width="24%"> Date/Time/Field</TD>
			<TD width="05%">Div</TD>
			<TD width="30%">Teams </TD>
		</tr>
	</table>
	
	
	<div style="overflow:auto; height:425px; border:1px ##cccccc solid;">
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="99%">
		<!--- 
		<tr class="tblHeading">
				<TD colspan="8" align="left">#repeatString("&nbsp;",5)# Assigned Referess </TD>
		</tr>
		<cfset holdClubName = "">
		<CFLOOP query="qGetUnPaid">
			<cfif holdClubName NEQ CLUB_NAME>
				<cfset holdClubName = CLUB_NAME>
				<TR bgcolor="##CCE4F1">
					<TD colspan="8" align="left"><B>#ucase(Club_Name)#</b></TD>
				</tr>
			</cfif>
			<cfif len(trim(RefPaidComment))>
				<cfset tdClass = "">
			<cfelse>
				<cfset tdClass = "class='tdUnderLine' ">
			</cfif>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
				<TD width="23%" #tdClass#> #RefLastName#, #RefFirstName# 			</TD>
				<TD width="06%" #tdClass# align="center">
						<cfswitch expression="#game_official_type_id#">
							<cfcase value="1"> Ref </cfcase>
							<cfcase value="2"> AR1 </cfcase>
							<cfcase value="3"> AR2 </cfcase>
						</cfswitch>
				</TD>
				<TD width="06%" #tdClass# align="center"> #dollarFormat(RefAmountOwed)# </TD>
				<TD width="05%" #tdClass# align="center"> #GAME_ID#		 </TD>
				<TD width="25%" #tdClass# > 
							#dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#		
							<br>#repeatString("&nbsp;",4)# #FieldAbbr#
				</TD>
				<TD width="05%" #tdClass# > #Division#		 </TD>
				<TD width="30%" #tdClass# > 
							 (H) #HomeTeamName#
						<br> (V) #VisitorTeamName#	
				</TD>
			</tr>
				<cfif len(trim(RefPaidComment))>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
						<TD colspan="1" class="tdUnderLine">&nbsp;  </TD>
						<TD colspan="6" class="tdUnderLine"> Comments:  #RefPaidComment# </TD>
					</tr>
				</cfif>
		</CFLOOP> 
		--->
	
		<CFIF refUnPaidAdded.RECORDCOUNT>
			<!--- <tr class="tblHeading">
				<TD colspan="8" align="left">#repeatString("&nbsp;",5)# Unassigned Referees <!--- ADDED Unpaid Referess ---> </TD>
			</tr> --->
			<cfset holdClubName = "">
			<cfloop query="refUnPaidAdded">
				
				<cfif holdClubName NEQ CLUB_NAME>
					<cfset holdClubName = CLUB_NAME>
					<TR bgcolor="##CCE4F1">
						<TD colspan="8" align="left"><B>#ucase(Club_Name)#</b></TD>
					</tr>
				</cfif>
				<cfif len(trim(Comments))>
					<cfset tdClass = "">
				<cfelse>
					<cfset tdClass = "class='tdUnderLine' ">
				</cfif>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
					<TD #tdClass# > #LastName#, #FirstNAME# </TD>
					<TD #tdClass# align="center"> 	 
							<cfswitch expression="#RefPosition#">
								<cfcase value="1"> Ref </cfcase>
								<cfcase value="2"> AR1 </cfcase>
								<cfcase value="3"> AR2 </cfcase>
							</cfswitch>
					</TD>
					<TD #tdClass# align="center"> #dollarFormat(RefAmountOwed)#		 </TD>
					<TD #tdClass#> #GAME#		 </TD>
					<TD #tdClass#> #dateFormat(RefGameDateUnpaid,"mm/dd/yyyy")# &nbsp; &nbsp; &nbsp; #timeFormat(GTIME,"hh:mm tt")#
								<br>#repeatString("&nbsp;",4)# #FieldAbbr#
					</TD>
					<TD #tdClass#> #Division#		 </TD>
					<TD #tdClass#> 
								 (H) #HomeTeamName#
							<br> (V) #VisitorTeamName#	
					</TD>
				</tr>
				<cfif len(trim(Comments))>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
						<TD colspan="1" class="tdUnderLine">&nbsp;  </TD>
						<TD colspan="6" class="tdUnderLine" align="left"> Comments:  #Comments# </TD>
					</tr>
				</cfif>
			</cfloop>	
		</CFIF>
	</TABLE>
	</div>

</div>
</cfoutput>
<cfinclude template="_footer.cfm">
