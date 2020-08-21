
<!------------------------------>
<!--- SET UP LOCAL VARIABLES --->
<!------------------------------>

<CFSET clubID = SESSION.USER.CLUBID> 

<cfif isDefined("form.StartDate") AND form.StartDate NEQ "">
	<cfset StartDate = dateFormat(FORM.StartDate,"mm/dd/yyyy") > 
<cfelseif isDefined("url.StartDate") AND url.StartDate NEQ "">
	<cfset StartDate = dateFormat(url.StartDate,"mm/dd/yyyy") > 
<cfelse>
	<cfset StartDate = "" > 
</cfif>

<cfif isDefined("form.EndDate") AND form.EndDate NEQ "">
	<cfset EndDate = dateFormat(FORM.EndDate,"mm/dd/yyyy") > 
<cfelseif isDefined("url.EndDate") AND url.EndDate NEQ "">
	<cfset EndDate = dateFormat(url.EndDate,"mm/dd/yyyy") > 
<cfelse>
	<cfset EndDate = "" > 
</cfif>

<cfif isDefined("form.selFineStatus") AND form.selFineStatus NEQ "">
	<cfset selFineStatus = FORM.selFineStatus>
<cfelseif isDefined("url.selFineStatus") AND url.selFineStatus NEQ "">
	<cfset selFineStatus = url.selFineStatus>
<cfelse>
	<cfset selFineStatus = "N">
</cfif>

<cfif isDefined("form.sortBy") AND form.sortBy NEQ "">
	<cfset sortBy = FORM.sortBy >
<cfelseif isDefined("url.sortBy") AND url.sortBy NEQ "">
	<cfset sortBy = url.sortBy >
<cfelse>
	<cfset sortBy = "2" >
</cfif>

<cfif isDefined("form.sortType") AND form.sortType NEQ "">
	<cfset sortType = FORM.sortType >
<cfelseif isDefined("url.sortType") AND url.sortType NEQ "">
	<cfset sortType = url.sortType >
<cfelse>
	<cfset sortType = "" >
</cfif>

<cfif isDefined("form.season_select") AND form.season_select NEQ "">
	<cfset season_select = form.season_select>
<cfelseif isDefined("url.season_select") AND url.season_select NEQ "">
	<cfset season_select = url.season_select>
<cfelse>
	<cfset season_select = SESSION.CURRENTSEASON.ID>
</cfif>

<cfif isDefined("form.club_select") AND form.club_select NEQ "">
	<cfset club_select = form.club_select>
<cfelseif isDefined("url.club_select") AND url.club_select NEQ "">
	<cfset club_select = url.club_select>
<cfelse>
	<cfif isDefined("SESSION.USER.CLUBID")>
		<cfset club_select = SESSION.USER.CLUBID>
	<cfelse>
		<cfset club_select = "">
	</cfif>
</cfif>

<cfset TypeAll		= "" >
<cfset TypePaid		= "" >
<cfset TypeUnPaid	= "" >
<cfset TypeInvoiced	= "" >
<cfset TypeWaived	 = "" >
<cfset TypeDelete 	 = "" >
<cfset TypeAppealed	 = "" >
<cfset TypeNoInvoice = "" >

<cfset holdClubID	= "" >
<cfset Where_ClubSel= "" >
<cfset TotalPaid	= 0 >
<cfset TotalUnPaid	= 0 >
<cfset TotalInvoiced= 0 >
<cfset TotalWaived	= 0 >
<cfset TotalDelete	= 0 >
<cfset TotalAppealed= 0 >
<cfset TotalAmount	= 0 >
<cfset GameCount	= 0 >

<!---------------->
<!--- GET DATA --->
<!---------------->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="getFines" returnvariable="getFines">
	<cfinvokeargument name="FineStatus" value="#selFineStatus#"> 
	<!--- <cfinvokeargument name="clubID"     value="#SESSION.USER.CLUBID#">  --->
	<cfif club_select EQ "">
	<cfinvokeargument name="clubID"     value="#SESSION.USER.CLUBID#"> 
	<cfelse>
	<cfinvokeargument name="clubID"     value="#club_select#"> 
	</cfif>
	<cfif season_select NEQ "">
	<cfinvokeargument name="seasonID" value="#season_select#">
	</cfif>
	<cfif StartDate NEQ "" and EndDate NEQ "">
		<cfinvokeargument name="StartDate" value="#StartDate#"> 
		<cfinvokeargument name="EndDate" value="#EndDate#"> 
	</cfif>
</cfinvoke>  <!--- <cfdump var="#getFines#"> --->

<cfswitch expression="#sortBy#">
	<cfcase value="1">	<cfset orderByCol = "fine_ID" ></cfcase>
	<cfcase value="2">	<cfset orderByCol = "Game_ID" ></cfcase>
	<cfcase value="3">	<cfset orderByCol = "Club_Name" ></cfcase>
	<cfcase value="4">	<cfset orderByCol = "TeamName" ></cfcase>
	<cfcase value="5">	<cfset orderByCol = "FineDateCreated" ></cfcase>
	<cfcase value="6">		<cfset orderByCol = "CreatedBy" ></cfcase>
	<cfcase value="7">	<cfset orderByCol = "Amount" ></cfcase>
	<cfcase value="8">	<cfset orderByCol = "Status" ></cfcase>
	<cfcase value="9">	<cfset orderByCol = "Description" ></cfcase>
	<cfdefaultcase> 		<cfset orderByCol = "Club_Name" >	</cfdefaultcase>
</cfswitch>

<cfquery name="getFines" dbtype="query">
	select * from getFines
	order by #orderByCol# #SortType#
</cfquery>

<!---------------------------->
<!--- PRODUCE PDF DOCUMENT --->
<!---------------------------->

<cfdocument margintop=".25" marginbottom=".5" format="pdf" name="print_report" localUrl="yes">
	<cfoutput>
		<html>
			<head>
				<title>Report</title>
				<link rel="stylesheet" href="2col_leftNav.css?t=2" type="text/css" />
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
					<H1 class="pageheading">NCSA - Games with Referee Not Filed Match Report</H1>
					<!--- <br> <h2>yyyyyy </h2> --->
			
					<CFIF IsDefined("getFines") AND getFines.RECORDCOUNT GT 0 >
						<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
							<tr class="tblHeading">
								<TD width="25"><b>Fine</b></TD>
								<TD width="35"><b>Game</b></TD>
								<TD width="110"><b>Club</b></TD>
								<TD width="110"><b>Team Fined</b</TD>
								<TD width="155"><b>Fine</b></TD>
								<TD width="110" align="center"><b>By</b></TD>
								<TD width="45"><b>Dated</b></TD>
								<TD width="50" align="right"> <b>Amount</b></TD>
								<TD width="45" align="center"><b>Status</b></TD>
							</TR>
					 		<CFLOOP query="getFines">
								<cfset StatusText = "">
								<CFIF len(trim(AMOUNT)) LT 1>
									<CFSET fineAmount = 0>
								<CFELSE>
									<CFSET fineAmount = AMOUNT>
								</CFIF>
								<cfswitch expression="#UCASE(Status)#">
									<cfcase value="P">
										<cfset TotalPaid = TotalPaid + fineAmount>
										<cfset StatusText = "<font color=blue> Paid </font>">
									</cfcase>
									<cfcase value="W">
										<cfset TotalWaived = TotalWaived + fineAmount>
										<cfset StatusText = "<font color=Green> Waived </font>">
									</cfcase>
									<cfcase value="D">
										<cfset TotalDelete = TotalDelete + fineAmount>
										<cfset StatusText = " Deleted ">
									</cfcase>
									<cfcase value="I">
										<cfset TotalInvoiced = TotalInvoiced + fineAmount>
										<cfset StatusText = "<font color=red> Invoiced </font>">
									</cfcase>
									<cfcase value="E">
										<cfset TotalAppealed = TotalAppealed + fineAmount>
										<cfset StatusText = "<font color=Brown> Appealed </font>">
									</cfcase>
									<cfcase value="U">
										<cfset TotalUnpaid = TotalUnpaid + fineAmount>
										<cfset StatusText = "<font color=orange> Unpaid </font>">
									</cfcase>
									<cfdefaultcase>
										<cfset TotalUnpaid = TotalUnpaid + fineAmount>
										<cfset StatusText = "<font color=orange> Unpaid </font>">
									</cfdefaultcase>
								</cfswitch>

								<cfset GameCount = GameCount + 1>
								<cfset RecPrinted = "">
								<cfset TotalAmount = TotalAmount + fineAmount >


								<cfif len(trim(Comments))>
									<cfset swComments = true>
									<cfset tdClass = "">
								<cfelse>	
									<cfset swComments = false>
									<cfset tdClass = "class='tdUnderLine'">
								</cfif>

								<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" >
									<TD width="25" class="tdUnderLine" valign="top">  #FINE_Id#					</TD>
									<TD width="35" class="tdUnderLine" valign="top">  <cfif GAME_ID GT 0>#Game_id#<cfelse>&nbsp;</cfif></TD>
									<TD width="110" class="tdUnderLine" valign="top">  
									#(Club_Name)#
										</TD>
									<TD width="110" class="tdUnderLine" valign="top">  #TeamName#	&nbsp;	</TD>
									<td width="155" class="tdUnderLine" valign="top">  #Description#				&nbsp;</TD>
									<TD width="110" class="tdUnderLine" valign="top" align=center>  #AddByUser#	&nbsp;</TD><!--- CreatedBy --->
									<TD width="45" class="tdUnderLine" valign="top" align=center>
										<CFIF datediff("d", FineDateCreated, now()) GT 30>
											<span class="red">#dateFormat(FineDateCreated,"mm/dd/yy")#</span>
										<cfelse>
											#dateFormat(FineDateCreated,"mm/dd/yy")#
										</CFIF> 
									</TD>
									<td width="50" class="tdUnderLine" valign="top" align=right> $#fineAmount#</TD>
									<td width="45" class="tdUnderLine" valign="top" align=center> #StatusText#</TD>
								</tr>
								  <cfif  len(trim(Comments))>
										<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" >
											<TD colspan="2" class="tdUnderLine" valign="top">&nbsp;   </TD>
											<TD colspan="4" class="tdUnderLine" valign="top">  <b>Comments:</b> #Comments# </TD>
											<TD colspan="3" class="tdUnderLine" valign="top">&nbsp;   </TD>
										</tr>
								  	 
								  </cfif>

							</CFLOOP>
								<cfif getFines.RECORDCOUNT>
									<TR><TD colspan="5" align=right> <font color=blue>	Total Paid		</FONT></TD>
										<TD colspan="2" align=right> <font color=blue>	$#TotalPaid#	</font></TD>
										<TD align=center>&nbsp;			 									   </TD>
									</TR>
									<TR><TD colspan="5" align=right> <font color=orange> Total UnPaid	</FONT></TD>
										<TD colspan="2" align=right> <font color=orange> $#TotalUnPaid#	</font></TD>
										<TD align=center>&nbsp;			 										</TD>
									</TR>
									<TR><TD colspan="5" align=right> <font color=red>	Total Invoiced	 </FONT></TD>
										<TD colspan="2" align=right> <font color=red>	$#TotalInvoiced# </font></TD>
										<TD align=center>&nbsp;			 										</TD>
									</TR>
									<TR><TD colspan="5" align=right> <font color=green>	Total Waived	</FONT></TD>
										<TD colspan="2" align=right> <font color=green>	$#TotalWaived#	</font></TD>
										<TD align=center>&nbsp;			 										</TD>
									</TR>
									<TR><TD colspan="5" align=right> <font color=black>	Total Deleted	</FONT></TD>
										<TD colspan="2" align=right> <font color=black> $#TotalDelete#	</font></TD>
										<TD align=center>&nbsp;			 										</TD>
									</TR>
									<TR><TD colspan="5" align=right> <font color=brown>	Total Appealed	 </FONT></TD>
										<TD colspan="2" align=right> <font color=brown>	$#TotalAppealed# </font></TD>
										<TD align=center>&nbsp;			 										</TD>
									</TR>
								</cfif>
						</table>
						</div> 
					<CFELSEIF IsDefined("getFines") AND getFines.RECORDCOUNT EQ 0 >
						<table cellspacing="0" cellpadding="5" align="left" border="0" width="98%">
							<tr class="tblHeading"><td>&nbsp;</td></tr>
							<TR><td><span class="red"> <b>No Records found based on choices.</b></span> </td></TR>
						</table>
					</CFIF>
	
				</div>
			</body>
		</html>
	</cfoutput>
</cfdocument>

<cfheader name="Content-Disposition" 
value="inline; filename=print_report.pdf">

<cfcontent type="application/pdf" variable="#toBinary(print_report)#">