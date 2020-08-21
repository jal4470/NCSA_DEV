<cfdocument margintop=".25" marginbottom=".5" format="pdf" name="print_report" localUrl="yes">
	<cfoutput>
	<html>
	<head>
		<title>Report</title>
		<link rel="stylesheet" href="2col_leftNav.css?t=2" type="text/css" />
		<link rel="stylesheet" href="css/advert_edit.css" type="text/css" />
		<style>
			##contentText { margin: 0 !important;}
			##contentText table { font-family: Tahoma, Verdana,Arial,sans-serif; font-size: 11px !important;}
			h1.pageheading {font-family: Tahoma, Verdana,Arial,sans-serif; font-size: 18px; color: ##334d55;}
			.tblHeading
			{	background-color: ##3399CC;
				font-size: 12px;
				font-weight: bold;
				color:##ffffff;
			}
			h2 {
			font-size: 114%;
			color: ##006699;
			}
			h1, h2, h3, h4, h5, h6 {
			font-family: Tahoma, Verdana,Arial,sans-serif;
			margin: 0px;
			padding: 0px;
			}
		</style>
	</head>
	<body>
	<div id="contentText">
		<H1 class="pageheading">NCSA - UnPaid Referee Report</H1>
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
			<CFIF refUnPaidAdded.RECORDCOUNT>
				<cfset holdClubName = "">
				<cfloop query="refUnPaidAdded">
					
					<cfif holdClubName NEQ CLUB_NAME>
						<cfset holdClubName = CLUB_NAME>
						<TR bgcolor="##CCE4F1">
							<TD colspan="7" align="left"><B>#ucase(Club_Name)#</b></TD>
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
	</body>
	</html>
	</cfoutput>
</cfdocument>
<cfheader name="Content-Disposition" 
value="inline; filename=print_report.pdf">
<cfcontent type="application/pdf" variable="#toBinary(print_report)#">