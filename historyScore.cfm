<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<!--- <div id="contentText"> --->
 
 

<CFIF isDefined("URL.SY") and len(trim(URL.SY))>
	<CFSET sy = URL.SY>
<CFELSEIF isDefined("FORM.SY") and len(trim(FORM.SY))>
	<CFSET sy = FORM.SY>
<CFELSE>
	<CFSET sy = "">
</CFIF>
	
<CFIF len(trim(VARIABLES.SY))>
	<CFSET swOldWay=1> 
	<cfswitch expression="#UCASE(VARIABLES.SY)#">
		<!--- <CFCASE value="S02">
			<CFSET season="Spring">
			<CFSET year=2002> 
		</CFCASE> 
		<CFCASE value="F02"> 
			<CFSET season="Fall">  
			<CFSET year=2002> 
			<CFSET gametable="Games_Fall_2002">   
			<CFSET coachtable="CoachesTeams_Fall_2002">   
		</CFCASE>--->
		<CFCASE value="S03"> 
			<CFSET season="Spring">
			<CFSET year=2003> 
			<CFSET gametable="Games_Spring_2003"> 
			<CFSET coachtable="CoachesTeams_Spring_2003"> 
		</CFCASE>
		<CFCASE value="F03"> 
			<CFSET season="Fall">  
			<CFSET year=2003> 
			<CFSET gametable="Games_Fall_2003">   
			<CFSET coachtable="CoachesTeams_Fall_2003">   
		</CFCASE>
		<CFCASE value="S04"> 
			<CFSET season="Spring">
			<CFSET year=2004> 
			<CFSET gametable="Games_Spring_2004"> 
			<CFSET coachtable="CoachesTeams_Spring_2004"> 
		</CFCASE>
		<CFCASE value="F04"> 
			<CFSET season="Fall">  
			<CFSET year=2004> 
			<CFSET gtmeaable="Games_Fall_2004">   
			<CFSET coachtable="CoachesTeams_Fall_2004">   
		</CFCASE>
		<CFCASE value="S05"> 
			<CFSET season="Spring">
			<CFSET year=2005> 
			<CFSET gametable="Games_Spring_2005"> 
			<CFSET coachtable="CoachesTeams_Spring_2005"> 
		</CFCASE>
		<CFCASE value="F05"> 
			<CFSET season="Fall">  
			<CFSET year=2005> 
			<CFSET gametable="Games_Fall_2005">   
			<CFSET coachtable="CoachesTeams_Fall_2005">   
		</CFCASE>
		<CFCASE value="S06"> 
			<CFSET season="Spring">
			<CFSET year=2006> 
			<CFSET gametable="Games_Spring_2006"> 
			<CFSET coachtable="CoachesTeams_Spring_2006"> 
		</CFCASE>
		<CFCASE value="F06"> 
			<CFSET season="Fall">  
			<CFSET year=2006> 
			<CFSET gametable="Games_Fall_2006">   
			<CFSET coachtable="CoachesTeams_Fall_2006">   
		</CFCASE>
		<CFCASE value="S07"> 
			<CFSET season="Spring">
			<CFSET year=2007> 
			<CFSET gametable="Games_Spring_2007"> 
			<CFSET coachtable="CoachesTeams_Spring_2007"> 
		</CFCASE>
		<CFCASE value="F07"> 
			<CFSET season="Fall">  
			<CFSET year=2007> 
			<CFSET gametable="Games_Fall_2007">   
			<CFSET coachtable="CoachesTeams_Fall_2007">   
		</CFCASE>
		<CFCASE value="S08"> 
			<CFSET season="Spring">
			<CFSET year=2008> 
			<CFSET gametable="Games_Spring_2008"> 
			<CFSET coachtable="CoachesTeams_Spring_2008"> 
		</CFCASE>
		<CFCASE value="F08"> 
			<CFSET season="Fall">  
			<CFSET year=2008> 
			<CFSET gametable="Games_Fall_2008">   
			<CFSET coachtable="CoachesTeams_Fall_2008">   
		</CFCASE>
		<CFDEFAULTCASE> 
			<!--- use new standings --->
			<CFIF mid(UCASE(VARIABLES.SY),1,1) EQ "F">
				<CFSET season="Fall"> 
			<CFELSE>
				<CFSET season="Spring"> 
			</CFIF>
			<CFSET year = 20 & mid(VARIABLES.SY,4,2)>  

			<CFSET gametable="V_GAMES_History">  
			<!--- <CFSET coachtable="YYYYYYYYYY">  --->
			<CFSET swOldWay=0> 

		</CFDEFAULTCASE>
	</cfswitch>
</CFIF>






<H1 class="pageheading">NCSA - History</H1>
<br>
<h2>Game Score for: #VARIABLES.Season# #VARIABLES.year# </h2>
 

<CFSET SelDiv  = "">
<CFSET SelDate = "">

<cfif isDefined("FORM.Division") AND len(trim(FORM.Division))>
	<CFSET selDiv = FORM.Division>
</cfif>
<cfif isDefined("FORM.Weekend") AND len(trim(FORM.Weekend))>
	<CFSET selDate = FORM.Weekend>
</cfif> 

 

<CFIF isDefined("VARIABLES.gametable") AND len(trim(VARIABLES.gametable))>
	
	<CFIF swOldWay>
		<!--- this way uses the old ncsa history tables for certain seasons --->
		<CFQUERY name="qDivisions" datasource="#SESSION.DSN#">
			Select distinct Division 
			  from #VARIABLES.gametable#
			ORDER BY DIVISION
		</CFQUERY> <!--- <cfdump var="#qDivisions#"> --->
		
		 <CFQUERY name="qDates" datasource="#SESSION.DSN#">
			Select distinct gDate as GameDate 
			  from #VARIABLES.gametable#
			<CFIF len(trim(VARIABLES.selDiv))>
		     where Division = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#">
			</CFIF>
			 order by gDate
		</CFQUERY> <!--- <cfdump var="#qDates#"> --->
		
		<cfif len(trim(VARIABLES.selDiv)) and len(trim(VARIABLES.selDate)) >
			<cfquery name="qGetGames" datasource="#SESSION.DSN#">
				select A.Game, A.gDate as GameDate, A.gTime as GameTime, A.HScore, A.VScore, 
					   A.HomeForfeit, A.VisitorForfeit, A.DelayedEntry, A.type,
					   B.TeamName as HTeamName, B.ID as HteamID,    
					   C.TeamName as VTeamName, C.ID as VteamID 
				  from #VARIABLES.gametable# A 
				  			INNER JOIN #VARIABLES.coachtable# B ON B.ID = A.Home
							INNER JOIN #VARIABLES.coachtable# C ON C.ID = A.Visitor
				 where A.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#">
				 <CFIF selDate NEQ "ALL">
					 <cfset selGameDate = createDate(listGetAt(selDate,3,"/"),listGetAt(selDate,1,"/"),listGetAt(selDate,2,"/") )>
					 and A.gDate = <CFQUERYPARAM cfsqltype="CF_SQL_TIMESTAMP" value="#VARIABLES.selGameDate#">
				 </CFIF> 
				 Order by A.gDate, A.gTime 
			</cfquery> 
			<!--- <cfdump var="#qGetGames#"> --->
		</cfif>

	<CFELSE>
		
			<!--- <BR> season [<cfdump var="#season#">]
			<BR> year [<cfdump var="#year#">] --->
		<!--- this way uses the new tables/views --->
		<!--- get the id for the selected SEASON --->
		<CFINVOKE component="#SESSION.siteVars.cfcPath#season" method="getSeasonInfo" returnvariable="qSeason">
			<CFINVOKEARGUMENT name="seasonYY" value="#year#"> 
			<CFINVOKEARGUMENT name="seasonSF" value="#season#">
		</CFINVOKE> <!--- <cfdump var="#qSeason#"> --->
		
		<cfif qSeason.season_id EQ SESSION.CURRENTSEASON.ID>
			<cfset qSeason.season_id = 0>
		</cfif>
		
		<CFQUERY name="qDivisions" datasource="#SESSION.DSN#">
			SELECT distinct Division 
			  FROM V_GAMES_HISTORY
			 WHERE SEASON_ID = #qSeason.SEASON_ID# 
			  ORDER BY DIVISION
		</CFQUERY> <!--- <cfdump var="#qDivisions#"> --->
		
		<CFQUERY name="qDates" datasource="#SESSION.DSN#">
			Select distinct gDate as GameDate 
			  from V_GAMES_HISTORY
			 WHERE SEASON_ID = #qSeason.SEASON_ID# 
			<CFIF len(trim(VARIABLES.selDiv))>
		       AND Division = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#">
			</CFIF>
			 order by gDate
		</CFQUERY> <!--- <cfdump var="#qDates#"> --->
		
		<cfif len(trim(VARIABLES.selDiv)) and len(trim(VARIABLES.selDate)) >
			<cfquery name="qGetGames" datasource="#SESSION.DSN#">
				select A.Game, A.gDate as GameDate, A.gTime as GameTime, A.HScore, A.VScore, 
					   A.HomeForfeit, A.VisitorForfeit, A.DelayedEntry, A.type,
					   A.Home_TeamName    as HTeamName, A.Home    as HteamID,    
					   A.Visitor_TeamName as VTeamName, A.Visitor as VteamID 
				  from V_GAMES_HISTORY A
				 where A.Division = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDiv#">
				   AND SEASON_ID = #qSeason.SEASON_ID# 
				 	   <CFIF selDate NEQ "ALL">
						 <cfset selGameDate = createDate(listGetAt(selDate,3,"/"),listGetAt(selDate,1,"/"),listGetAt(selDate,2,"/") )>
						 and A.gDate = <CFQUERYPARAM cfsqltype="CF_SQL_TIMESTAMP" value="#VARIABLES.selGameDate#">
					   </CFIF> 
				Order by A.gDate, A.gTime 
			</cfquery> 
			<!--- <cfdump var="#qGetGames#"> ---> 
		</cfif>

	</CFIF>
	<!-- drop downs  -->
	<form action="historyScore.cfm" method="post">
	<INPUT type="Hidden" name="SY" value="#VARIABLES.SY#">
	<TABLE cellSpacing=0 cellPadding=5 width="100%" align=center border="0">
		<TR><TD><FONT color=blue><STRONG>Division</STRONG></FONT> &nbsp; 
				<SELECT name="Division" style="WIDTH: 144px"> 
					<OPTION value="0" selected>Select Division</OPTION>
					<CFLOOP query="qDivisions">
						<OPTION value="#Division#" <cfif Division EQ VARIABLES.selDiv>selected</cfif> >#Division#</OPTION>
					</CFLOOP>
				</SELECT>
				&nbsp; 
	
				<STRONG><FONT color=##0000ff>Weekend</FONT></STRONG> &nbsp;
				<SELECT name="Weekend" style="WIDTH: 144px" onchange="GetWeekendsList()" > 
					<OPTION value="ALL">Show ALL Weekends</OPTION>
					<CFLOOP query="qDates">
						<OPTION value="#DateFormat(GameDate,"mm/dd/yyyy")#" <cfif DateFormat(GameDate,"mm/dd/yyyy") EQ VARIABLES.selDate>selected</cfif> >#DateFormat(GameDate,"mm/dd/yyyy")#</OPTION>
					</CFLOOP>
					
				</SELECT>
				<input type="Submit" name="enter" value="Enter">
	    	</TD>
			<TD align="left">
				<a href="history.cfm" >Back to History List</a>
	    	</TD>
		</TR>
	</TABLE>
	</form>
	
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr><td colspan="12">
				<font size=2 color=green> <b>F</b> - ForFeited, <b>L</b> - Late Score</li> </font>
			</td>
		</tr>
		<tr class="tblHeading">
			<TD width="4%" align=right>&nbsp;  </TD>
			<TD width="18%" align=CENTER> Date Time</TD>
			<TD width="8%" align=center> Game## </TD>
			<TD width="4%"> (F) </TD>
			<TD width="25%"> Home Team </TD>
			<TD width="4%"> (F) </TD>
			<TD width="23%"> VisitorTeam </TD>
			<cfif mid(selDiv,2,2) EQ "08">
				<TD width="4%"> Plyd </TD>
				<TD width="0%">&nbsp;</TD>
			<cfelse>
				<TD width="3%"> HS </TD>
				<TD width="3%"> VS </TD>
			</cfif> 
			<TD width="3%"> (L) </TD>
			<TD width="5%">&nbsp; </TD>
		</TR>
	</TABLE>	

	<cfif IsDefined("qGetGames") AND qGetGames.RECORDCOUNT>
		<div style="overflow:auto; height:350px; border:1px ##cccccc solid;">
		<TABLE cellSpacing=0 cellPadding=0 width="98%" border=0>
			<CFLOOP query="qGetGames">
				<CFSET GameForfeitedBy = "">
				<CFIF HomeForfeit EQ "Y">
					<CFSET GameForfeitedBy = "H">
				</CFIF> 
				<cfif VisitorForfeit EQ "Y">
					<cfset GameForfeitedBy = "V">
				</CFIF>
	
				<cfIf DelayedEntry EQ "Y">
					<cfset CheckedMark = "checked">
				<cfelse>
					<cfset CheckedMark = "">
				</CFIF>
	
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td width="4%" class="tdUnderLine" >
						<font size=2, color="red">
							<cfswitch expression="#Trim(Type)#">
								<cfcase value="P"> P/off	 </cfcase>
								<cfcase value="I">  Final	 </cfcase>
								<cfcase value="Q">  Q-Fnl	 </cfcase>
								<cfcase value="S">  S-Fnl	 </cfcase>
								<cfcase value="F">  Frndly	 </cfcase>
								<cfcase value="C">  StateCup </cfcase>
								<cfdefaultcase>&nbsp;</cfdefaultcase>
							</cfswitch>
						</font>
					</td>
					<TD width="18%" class="tdUnderLine"  align="right"> 
						<font size=2>#dateFormat(GameDate,"mm/dd/yy")# #timeFormat(GameTime,"hh:mm tt")#</font>
					</TD>
					<TD width="8%" class="tdUnderLine"  align="center"><font size=2>#Game#</font></TD>
					<td width="4%" class="tdUnderLine" >
						<input DISABLED type="checkbox" maxlength="1" name="HomeForfeit" <cfif HomeForfeit EQ "Y">checked</cfif>   style="WIDTH: 20px; HEIGHT: 20px" size=1 >
					</td>
					<TD width="25%" class="tdUnderLine" ><font size=2>#HTeamName#</font></TD>
					<td width="4%" class="tdUnderLine" >
						<input DISABLED type="checkbox" maxlength="1" name="VisitorForfeit" <cfif VisitorForfeit EQ "Y" > checked</cfif> style="WIDTH: 20px; HEIGHT: 20px" size=1>
					</td>
					<TD width="25%" class="tdUnderLine" ><font size=2>#VTeamName#</font></TD>
					<cfif mid(selDiv,2,2) EQ "08">
						<cfif len(trim(HScore)) or len(trim(VScore))> 
							<CFSET GamePlayed = "Checked">
						<cfelse>
							<cfset GamePlayed = "" >
						</cfif>
						<TD width="4%" class="tdUnderLine" >
							<input DISABLED type="checkbox" maxlength="1" name="Div8" #GamePlayed# style="WIDTH: 20px; HEIGHT: 20px" size=1>
						</td>
						<TD width="0%" class="tdUnderLine" >
							<!--- <font size=2>#HScore# - #VScore#</font>
							<input DISABLED type="hidden" maxlength="2" name="HScore" value="#HScore#" >
							<input DISABLED type="hidden" maxlength="2" name="VScore" value="#VScore#"> --->
						</TD>
					<cfelse>
						<TD width="3%" class="tdUnderLine" >#HScore# &nbsp;</TD><!--- <input DISABLED maxlength="2" name="HScore" value="#HScore#" size=2 > --->
						<TD width="3%" class="tdUnderLine" >#Vscore# &nbsp;</TD><!--- <input DISABLED maxlength="2" name="VScore" value="#Vscore#" size=2 > ---> 
					</cfif>
					<td width="6%" class="tdUnderLine" ><input DISABLED type="checkbox" maxlength="1" name="DE" #CheckedMark#  style="WIDTH: 15px; HEIGHT: 15px" size=1></td>
				</TR>
			</CFLOOP>
		</TABLE>
		</DIV>
	</cfif>
	
<CFELSE>
	<h2>There is no history for this season</h2>	<br><br> <a href="history.cfm" >Click here to go back to History List</a>
</CFIF>


</cfoutput>

<cfinclude template="_footer.cfm">
