<!--- 
	FileName:	refAssignmentReport.cfm
	Created on: 11/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

NOTE!!!! The following files have similar logic and changes to 
			refAssignmentReport.cfm
		may also need to be applied to:	
			refAssignmentReportcsv.cfm
			refAssignmentReportPDF.cfm

 --->
<cfinclude template="_checkLogin.cfm">

<!--- <H1 class="pageheading">NCSA - Games Ref Assignment Schedule</H1> --->
<cfset FirstTime = "Y">
<cfset RecCount		= 0>
<cfset RecCountDate	= 0>
<cfset RecCountGrand	= 0>

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<CFELSEIF isDefined("URL.WEF") AND isDate(URL.WEF)>
	<cfset WeekendFrom = dateFormat(URL.WEF,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(now(),"mm/dd/yyyy") > 
</CFIF>

<CFIF isDefined("FORM.printcsv")>
	<CFSET rptType = "csv">
<CFELSEIF isDefined("FORM.printpdf")>
	<CFSET rptType = "pdf">
<CFELSEIF isDefined("URL.rep") AND (URL.rep EQ "csv" OR URL.rep EQ "pdf")>
	<CFSET rptType = URL.rep>
<CFELSE>
	<CFSET rptType = "csv"> 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<CFELSEIF isDefined("URL.WET") AND isDate(URL.WET)>
	<cfset WeekendTo   = dateFormat(URL.WET,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendTo   = dateFormat(dateAdd("d",7,now()),"mm/dd/yyyy") >
</CFIF>

<CFIF SESSION.MENUROLEID EQ 23> <!--- 23=ref assignor --->
	<CFSET refAssignor = session.user.contactRoleID>
<cfelse>
	<CFSET refAssignor = 0 >
</CFIF>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGames">
	<cfinvokeargument name="fromdate"	value="#DateFormat(VARIABLES.WeekendFrom,"mm/dd/yyyy")#">
	<cfinvokeargument name="todate"		value="#DateFormat(VARIABLES.WeekendTo,"mm/dd/yyyy")#">
	<cfinvokeargument name="orderBy"	value="DateFAbbrTime">
</cfinvoke>

<!--- <CFIF IsDefined("qGames")> --->
<cfset holdDate = qGames.game_date > <!--- seed w/first date --->


<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<cfheader name="Content-Disposition" value="inline; filename=refereeAssign.xls">
<cfcontent type="application/vnd.ms-excel"> 


<cfoutput>
		<CFIF rptType EQ "csv">
			<table>
			<TR><TD>Game</TD>
				<TD>Div</TD>
				<TD>Date</TD>
				<TD>Time</TD>
				<TD>GameType</TD>
				<TD>PlayField</TD>
				<TD>Home Team</TD>
				<TD>Visiting Team</TD>
				<td>Ref Accept</td>
				<td>Referee</td>
				<td>AR1 Accept</td>
				<td>AR1</td>
				<td>AR2 Accept</td>
				<td>AR2</td>
				<td>comments</td>
			</TR>
		<CFELSE>
			<table  border="0" cellpadding="0" cellspacing="0" width="100%" >
			<TR><TD>Game</TD>
				<TD>Division</TD>
				<TD>Date/Time</TD>
				<!--- <TD>Type</TD> --->
				<TD>Field</TD>
				<TD>Teams</TD>
				<TD>Referees</TD>
			</TR> 
		</CFIF>
	<cfloop query="qGames">
		<cfif holdDate NEQ game_date>
			<CFIF rptType EQ "pdf">
				<tr bgcolor="##CCE4F1"><td colspan="7" align="center">
					Total number of Games on #dateFormat(holdDate,"mm/dd/yyyy")# = #RecCountDate# 
					</td>
				</tr>
			</CFIF>
			<cfset RecCountDate	= 0>
			<cfset holdDate = GAME_DATE>
		</cfif>
		
		<cfif len(trim(COMMENTS)) GT 0>
			<!--- supress underline if a comment is found, comment will put in underline --->
			<cfset classValue = "">
		<cfelse>
			<cfset classValue = "class='tdUnderLine'">
		</cfif>
		<cfswitch expression="#game_type#">
			<cfcase value="C"><cfset gameType = "SC"></cfcase>
			<cfcase value="N"><cfset gameType = "NL"></cfcase>
			<cfcase value="F"><cfset gameType = "FR"></cfcase>
			<cfdefaultcase>	  <cfset gameType = ""></cfdefaultcase>
		</cfswitch>
		<cfif len(trim(Visitor_TeamName))>
			<cfset VisTeamName = Visitor_TeamName> 
		<cfelse>
			<cfset VisTeamName = Virtual_TeamName>
		</cfif>
		<cfif Ref_accept_YN EQ "Y">
			<cfset refAccpt = "A">
		<cfelseif Ref_accept_YN EQ "N">
			<cfset refAccpt = "D">
		<cfelse>
			<cfset refAccpt = "">
		</cfif>
		<cfif len(trim(REFID))>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo">
				<cfinvokeargument name="contactID" value="#REFID#">
			</cfinvoke>
			<cfif qContactInfo.recordCount>
				<cfset refName = qContactInfo.LastName & ", " & qContactInfo.firstName>
			<cfelse>
				<cfset refName = "">
			</cfif>
		<cfelse>
			<cfset refName = "">
		</cfif>
		<cfif ARef1Acpt_YN EQ "Y">
			<cfset AR1accpt = "A">
		<cfelseif ARef1Acpt_YN EQ "N">
			<cfset AR1accpt = "D">
		<cfelse>
			<cfset AR1accpt = "">
		</cfif>
		<cfif len(trim(AsstRefId1))>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo1">
					<cfinvokeargument name="contactID" value="#AsstRefId1#">
			</cfinvoke>
			<cfif qContactInfo1.recordCount> 
				<cfset ar1name = qContactInfo1.LastName & ", " & qContactInfo1.firstName>
			<cfelse>
				<cfset ar1name = "">
			</cfif>
		<cfelse>
			<cfset ar1name = "">
		</cfif>
		<cfif ARef2Acpt_YN EQ "Y">
			<cfset ar2accpt = "A">
		<cfelseif ARef2Acpt_YN EQ "N">
			<cfset ar2accpt = "D">
		<cfelse>
			<cfset ar2accpt = "">
		</cfif>
		<cfif len(trim(AsstRefId2))>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo2">
				<cfinvokeargument name="contactID" value="#AsstRefId2#">
			</cfinvoke>
			<cfif qContactInfo2.recordCount> 
				<cfset ar2name = qContactInfo2.LastName & ", " & qContactInfo2.firstName>
			<cfelse>
				<cfset ar2name = "">
			</cfif>
		<cfelse>
			<cfset ar2name = "">
		</cfif>
		
		<CFIF rptType EQ "csv">
			<TR><TD>#game_id#</TD>
				<TD>#Division#</TD>
				<TD>#dateFormat(game_date,"mm/dd/yy")#</TD>
				<TD>#timeFormat(game_time,"hh:mm tt")#</TD>
				<TD>#gameType#</TD>
				<TD>#fieldAbbr#</TD>
				<TD>#Home_TeamName#</TD>
				<TD>#VisTeamName#</TD>
				<TD>#refAccpt#</TD>
				<TD>#refName#</TD>
				<TD>#AR1accpt#</TD>
				<TD>#ar1name#</TD>
				<TD>#ar2accpt#</TD>
				<TD>#ar2name#</TD>
				<TD>#Comments#</TD>
			</TR>
		<CFELSE>
			<TR><TD valign="top" class="tdUnderLine"><cfif len(trim(game_id))>	#game_id#<cfelse>&nbsp;</cfif>	
					<br><cfif len(trim(gameType))>	<span class="red">#gameType#</span><cfelse>&nbsp;</cfif>
				</TD>
				<TD valign="top" class="tdUnderLine"><cfif len(trim(Division))>	#Division#<cfelse>&nbsp;</cfif>	</TD>
				<TD valign="top" class="tdUnderLine"><cfif len(trim(game_date))> #dateFormat(game_date,"ddd")#<cfelse>&nbsp;</cfif>
					<br><cfif len(trim(game_date))> #dateFormat(game_date,"mm/dd/yy")#<cfelse>&nbsp;</cfif>
					<br><cfif len(trim(game_time))> #timeFormat(game_time,"hh:mm tt")#<cfelse>&nbsp;</cfif>	
				</TD>
				<!--- <TD class="tdUnderLine"><cfif len(trim(gameType))>	#gameType#<cfelse>&nbsp;</cfif>	</TD> --->

				<TD valign="top" class="tdUnderLine"><cfif len(trim(fieldAbbr))> #fieldAbbr#<cfelse>&nbsp;</cfif>	</TD>
				<TD valign="top" class="tdUnderLine">(h)<cfif len(trim(Home_TeamName))>#Home_TeamName#<cfelse>&nbsp;</cfif>	
					<br>(v)<cfif len(trim(VisTeamName))>#VisTeamName#<cfelse>&nbsp;</cfif>	
				</TD>
				<TD valign="top" class="tdUnderLine">Ref: (<cfif len(trim(refAccpt))>#refAccpt#<cfelse>&nbsp;</cfif>)
						 <cfif len(trim(refName))>	#refName#<cfelse>&nbsp;</cfif>	
					<br>Ar1: (<cfif len(trim(AR1accpt))>	#AR1accpt#<cfelse>&nbsp;</cfif>)	
							 <cfif len(trim(ar1name))>	#ar1name#<cfelse>&nbsp;</cfif>	
					<br>Ar2: (<cfif len(trim(ar2accpt))>	#ar2accpt#<cfelse>&nbsp;</cfif>)	
							 <cfif len(trim(ar2name))>	#ar2name#<cfelse>&nbsp;</cfif>	
				</TD>
			</TR>
			<!--- <TR><TD><cfif len(trim(Comments))>	#Comments#<cfelse>&nbsp;</cfif>	</TD>
			</TR> ---> 
		</CFIF>
		<cfset RecCount		 = RecCount + 1 >
		<cfset RecCountDate	 = RecCountDate + 1 >
		<cfset RecCountGrand = RecCountGrand + 1 >
		<!--- <CFSET output = """#game_id#"",""#Division#"",""#dateFormat(game_date,"mm/dd/yy")#"",""#timeFormat(game_time,"hh:mm tt")#"",""#gameType#"",""#fieldAbbr#"",""#Home_TeamName#"",""#VisTeamName#"",""#refAccpt#"",""#refName#"",""#AR1accpt#"",""#ar1name#"",""#ar2accpt#"",""#ar2name#"",""#Comments#""" >
		<CFFILE ACTION="APPEND" FILE="#tempfile#" OUTPUT="#output#" > --->
	</cfloop>

	<CFIF rptType EQ "pdf">
		<tr bgcolor="##CCE4F1"><!--- <CFIF rptType EQ "csv">
				<td colspan="15"> 
			<CFELSE> --->
				<td class="tdUnderLine" colspan="7"> 
			<!--- </CFIF> --->
				Total number of Games on #dateFormat(holdDate,"mm/dd/yyyy")# = #RecCountDate#
			</td>
		</tr>
		<tr bgcolor="##CCE4F1"><!--- <CFIF rptType EQ "csv">
				<td colspan="15"> 
			<CFELSE> --->
				<td class="tdUnderLine" colspan="7"> 
			<!--- </CFIF> --->
				<br> 
				<b>Grand Total for Games between #WeekendFrom# and #WeekendTo# = #RecCountGrand# </b>
			</td>
		</tr>
	</CFIF>

	</table>
</cfoutput>
</cfcontent>

