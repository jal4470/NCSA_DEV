

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<!--- <cfdump var="#url#" abort="true"> --->
<cfif isDefined("url.clubid")>
	<cfset clubID = url.clubid>
<cfelse>
	<cfset clubID = "0">
</cfif>	


<cfif isDefined("url.Season")>
	<cfset Season = url.Season>
<cfelse>

	<cfset Season = session.currentseason.id>

</cfif>


<cfif isdefined("url.finestatus")>
	<cfset finestatus = url.finestatus>
<cfelse>
	<cfset finestatus = "U">
</cfif>

<cfif (isdefined("url.startDate") and len(trim(url.startDate))) and (isdefined("url.endDate") and len(trim(url.endDate)))>
	<cfset startDate = url.startDate>
	<cfset endDate = url.endDate>
<cfelse>
	<cfset startDate =" ">
	<cfset endDate = " ">
</cfif>

<cfif isdefined("url.sortBy")>
	<cfset sortBy = url.sortBy>
<cfelse>
	<cfset sortBy = "1">
</cfif>

 	<cfquery name="refUnPaidAdded" datasource="#SESSION.DSN#">
		select  
			 r.RefPosition,
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
		 where  r.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Season#">
		 	<CFIF isDefined("clubID") AND clubID GT 1>
				and C.Club_Id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#clubID#">
			</CFIF>
			<!--- 11/1/2012 J. Rab --->
			<cfif (isDefined("StartDate") and isDate(StartDate)) and (isDefined("EndDate") and isDate(EndDate))>
				and cast(r.dateadded as date) between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#StartDate#"> and  <cfqueryparam cfsqltype="CF_SQL_DATE" value="#EndDate#">
			</cfif>
			
			
		 ORDER BY C.CLUB_NAME, r.gDate DESC, r.gTime DESC
	</cfquery>  

<!--------------------------- 
	START PDF PAGE 
----------------------------->
<cfdocument 
	format="pdf" 
	marginBottom=".4"
	marginLeft=".3"
	marginRight=".3"
	marginTop=".75"  
	orientation="landscape" localurl="true"
	name="output">
<html>
	<head>
		<title>NCSA - UnPaid Referee Report</title>
		<!--- <style type="text/css">
			#teamResultsTable {
				border-width: 1px 0 0 1px;
				border-style: solid;
				border-color: #ccc;
			}
			#teamResultsTable th,
			#teamResultsTable td {
				border-width: 0 1px 1px 0;
				border-style: solid;
				border-color: #ccc;
			}
		</style> --->
	</head>
<body>
<H1 class="pageheading">NCSA - UnPaid Referee Report </H1>

<div id="teamRegInfoResults">
	<table width="1700" border="0" cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="teamResultsTable" class="tablesorter" style="table-layout:fixed;">
		<thead>
			<tr class="tblHeading">
				<TH width="23%">Referee</TH>
				<TH width="06%">Pos</TH>
				<TH width="06%" >Owed</TH>	
				<TH width="06%">Game</TH>
				<TH width="24%"> Date/Time/Field</TH>
				<TH width="05%">Div</TH>
				<TH width="30%">Teams </TH>
			</tr>
		</thead>
		<tbody>
				<CFIF refUnPaidAdded.RECORDCOUNT>
					<!--- <tr class="tblHeading">
						<TD colspan="8" align="left">#repeatString("&nbsp;",5)# Unassigned Referees <!--- ADDED Unpaid Referess ---> </TD>
					</tr> --->
					<cfset holdClubName = "">
					<cfoutput query="refUnPaidAdded">
						
						<cfif holdClubName NEQ CLUB_NAME>
							<cfset holdClubName = CLUB_NAME>
							<TR bgcolor="##CCC">
								<TD colspan="8" align="left"><B>#ucase(Club_Name)#</b></TD>
							</tr>
						</cfif>
						<cfif len(trim(Comments))>
							<cfset tdClass = "">
						<cfelse>
							<cfset tdClass = "class='tdUnderLine' ">
						</cfif>
						<cfif refUnPaidAdded.currentRow mod 2 eq 0>
							<cfset altColor = "##fdfcfb">
						<cfelse>
							<cfset altColor = "##FFF">
						</cfif>
						<tr bgcolor="#altColor#"> <!--- currentRow or counter --->
							<TD > #LastName#, #FirstNAME# </TD>
							<TD align="center"> 	 
									<cfswitch expression="#RefPosition#">
										<cfcase value="1"> Ref </cfcase>
										<cfcase value="2"> AR1 </cfcase>
										<cfcase value="3"> AR2 </cfcase>
									</cfswitch>
							</TD>
							<TD align="center"> #dollarFormat(RefAmountOwed)#		 </TD>
							<TD> #GAME#		 </TD>
							<TD> #dateFormat(RefGameDateUnpaid,"mm/dd/yyyy")# &nbsp; &nbsp; &nbsp; #timeFormat(GTIME,"hh:mm tt")#
										<br>#repeatString("&nbsp;",4)# #FieldAbbr#
							</TD>
							<TD> #Division#		 </TD>
							<TD> 
										 (H) #HomeTeamName#
									<br> (V) #VisitorTeamName#	
							</TD>
						</tr>
						<cfif len(trim(Comments))>
							<tr bgcolor="#altColor#"> <!--- currentRow or counter --->
								<TD colspan="1" class="tdUnderLine">&nbsp;  </TD>
								<TD colspan="6" class="tdUnderLine" align="left"> Comments:  #Comments# </TD>
							</tr>
						</cfif>
					</cfoutput>	
				</CFIF>
		</tbody>
	</table>
</div>
</body>
</html>
</cfdocument>
<CFSET filename = "#SESSION.USER.CONTACTID#SeasonTeamLog.PDF" >
<cfheader name="Content-disposition" value="attachment;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#">