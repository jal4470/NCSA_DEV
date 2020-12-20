<!--- 
	FileName:	gameRefReportPrint.cfm
	Created on: 10/22/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/29/2009 - aarnone - removed ref paid and amount from printed report
03/31/2009 - aarnone - fixed error wen adding misconds and inj when missing  value
05/20/2009 - aarnone - #7757 changed text
9/8/2014	-	J. Danz	- 15511 - added players playing up section to this report view if there are any players playing up.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<!--- <cfinclude template="_header.cfm"> --->
<cfinclude template="_checkLogin.cfm">
<link rel="stylesheet" href="2col_leftNav.css" type="text/css" />
<cfoutput>
<!--- 
<div id="contentText"> 
<H1 class="pageheading">NCSA - xxxxxxxxxxxxx</H1>
br><h2>yyyyyy </h2> 
--->

<CFIF isDefined("URL.GID") AND isNumeric(URL.GID)>
	<CFSET gameID = URL.GID>
<CFELSE>
	<CFSET gameID = 0>
</CFIF>


<!--- 

	to do, add check for session.menuroleid, 
				add ref id to get rpt hdr along with gameID, 
				if board, then only game id will be fine

 --->


<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTHeader" returnvariable="qRefRptHeader">
	<cfinvokeargument name="gameID" value="#VARIABLES.gameID#" >
</cfinvoke>  <!--- <cfdump var="#qRefRptHeader#"> --->

<cfif qRefRptHeader.RECORDCOUNT>
	<cfset refRptHeaderID 	= qRefRptHeader.referee_rpt_header_ID>
	<cfset RefereeID		= qRefRptHeader.REFEREEID >
	<cfset StartTime		= timeFormat(qRefRptHeader.STARTTIME,"hh:mm tt")>
	<cfset EndTime			= timeFormat(qRefRptHeader.ENDTIME,"hh:mm tt")>
	<cfset AsstRef1writein	= qRefRptHeader.ASSISTANTREF1_WRITEIN >
	<cfset AsstRef2writein	= qRefRptHeader.ASSISTANTREF2_WRITEIN >
	<cfset AsstRefId1		= qRefRptHeader.contact_id_asstRef1 >
	<cfset AsstRefId2		= qRefRptHeader.contact_id_asstRef2 >
	<cfset Official4th		= qRefRptHeader.contact_id_official4th >
	<cfset scoreHomeHT		= qRefRptHeader.HalfTimeScore_Home >
	<cfset scoreVisitorHT	= qRefRptHeader.HalfTimeScore_Visitor >
	<cfset scoreHomeFT		= qRefRptHeader.FullTimeScore_Home >
	<cfset scoreVisitorFT	= qRefRptHeader.FullTimeScore_Visitor >
	<cfset Comments			= qRefRptHeader.Comments >
	<cfset SpectatorCount	= qRefRptHeader.spectatorCount >
	<cfif qRefRptHeader.refPaid_YN EQ "Y">
		<cfset RefPaid = "Yes" >
	<cfelse>
		<cfset RefPaid = "No">
	</cfif>
	<cfset RefAmount = qRefRptHeader.refPaid_Amount >

	<cfif qRefRptHeader.IsOnTime_Home EQ 1 ><!--- <cfif qRefRptHeader.IsOnTime_Home EQ "Y" > --->
		<cfset OnTimeHome = "Yes" >
	<cfelse>
		<cfset OnTimeHome = "No" >
	</cfif>

	<cfif qRefRptHeader.IsOnTime_Visitor EQ 1 ><!--- <cfif qRefRptHeader.IsOnTime_Visitor EQ "Y" > --->
		<cfset OnTimeVisitor = "Yes" >
	<cfelse>
		<cfset OnTimeVisitor = "No" >
	</cfif>

	<cfset HTHowLate		= qRefRptHeader.HowLate_Home >
	<cfset VTHowLate		= qRefRptHeader.HowLate_Visitor >
	
	<cfif qRefRptHeader.Passes_Home EQ 1 >	<!--- <cfif qRefRptHeader.Passes_Home EQ "Y" > --->
		<cfset PassesHome  = "were" >
		<cfset PassesHome2 = "" >
	<cfelse>
		<cfset PassesHome  = "were not" >
		<cfset PassesHome2 = "not" >
	</cfif>
	<cfif qRefRptHeader.Passes_Visitor EQ 1 > <!--- <cfif qRefRptHeader.Passes_Visitor EQ "Y" > --->
		<cfset PassesVisitor = "were" >
		<cfset PassesVisitor2 = "" >
	<cfelse>
		<cfset PassesVisitor = "were not" >
		<cfset PassesVisitor2 = "not" >
	</cfif>

	<cfif qRefRptHeader.LineUP_Home EQ 1 >	<!--- <cfif qRefRptHeader.LineUP_Home EQ "Y" > --->
		<cfset LineUpHome = "is" >
		<cfset LineUpHome2 = "" >
	<cfelse>
		<cfset LineUpHome = "is not" >
		<cfset LineUpHome2 = "not" >
	</cfif>
	<cfif qRefRptHeader.LineUP_Visitor EQ 1 >	<!--- <cfif qRefRptHeader.LineUP_Visitor EQ "Y" > --->
		<cfset LineUpVisitor = "is" >
		<cfset LineUpVisitor2 = "" >
	<cfelse>
		<cfset LineUpVisitor = "is not" >
		<cfset LineUpVisitor2 = "not" >
	</cfif>

	<!--- <cfif qRefRptHeader.Official4thLog EQ "Y" >
		<cfset Official4thLog = "is" >
		<cfset Official4thLog2 = "" >
	<cfelse>
		<cfset Official4thLog = "is not" >
		<cfset Official4thLog2 = "not" >
	</cfif> --->

	<CFSET FieldCondText = "">
	<cfif len(trim(qRefRptHeader.fieldCond))>
		<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrFieldCond">
			<cfinvokeargument name="listType" value="FIELDCOND"> 
		</cfinvoke> 
		<!--- qRefRptHeader.fieldCond is a string of values, parse the string to get each individual value --->
		<cfset ctX = 1>
		<cfloop from="1" to="#len(qRefRptHeader.fieldCond)#" index="ifc"><!--- <cfloop list="qRefRptHeader.fieldCond" index="ifc"> --->
			<cfset fCondValue = Mid(qRefRptHeader.fieldCond, ifc, 1)>
				<cfloop from="1" to="#arrayLen(arrFieldCond)#" index="arr">
					<cfif fCondValue EQ arrFieldCond[arr][1]>
						<CFSET FieldCondText = FieldCondText & "<br>" & ctX & ") " & arrFieldCond[arr][2] & ".  " >
						<cfset ctX = ctX + 1>
						<cfbreak>
					</cfif>
				</cfloop> 
		</cfloop>
	</cfif>

	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameStatus">
		<cfinvokeargument name="listType" value="GAMESTATUS"> 
	</cfinvoke> 
	<cfloop from="1" to="#arrayLen(arrGameStatus)#" index="ix">
		<cfif qRefRptHeader.GameSts EQ arrGameStatus[ix][1]>
			<cfset GameSts = arrGameStatus[ix][2]>
			<cfbreak>
		</cfif>
	</cfloop>	
	
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrWeather">
		<cfinvokeargument name="listType" value="WEATHER"> 
	</cfinvoke> 
	<cfset Weather = "">
	<cfloop from="1" to="#arrayLen(arrWeather)#" index="ix">
		<cfif qRefRptHeader.weather EQ arrWeather[ix][1]>
			<cfset Weather = arrWeather[ix][2]>
			<cfbreak>
		</cfif>
	</cfloop>	

	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrRatings1">
		<cfinvokeargument name="listType" value="RATINGS1"> 
	</cfinvoke> 

	<cfloop from="1" to="#arrayLen(arrRatings1)#" index="ix">
		<cfif qRefRptHeader.FieldMarking EQ arrRatings1[ix][1]>
			<cfset FieldMarking = arrRatings1[ix][2]>
			<cfbreak>
		</cfif>
	</cfloop>	

	<cfloop from="1" to="#arrayLen(arrRatings1)#" index="ix">
		<cfif qRefRptHeader.conductOfficials EQ arrRatings1[ix][1]>
			<cfset ConductOfficial = arrRatings1[ix][2]>
			<cfbreak>
		</cfif>
	</cfloop>	

	<cfloop from="1" to="#arrayLen(arrRatings1)#" index="ix">
		<cfif qRefRptHeader.ConductPlayers EQ arrRatings1[ix][1]>
			<cfset ConductPlayers = arrRatings1[ix][2]>
			<cfbreak>
		</cfif>
	</cfloop>	

	<cfloop from="1" to="#arrayLen(arrRatings1)#" index="ix">
		<cfif qRefRptHeader.conductSpectators EQ arrRatings1[ix][1]>
			<cfset conductSpectators = arrRatings1[ix][2]>
			<cfbreak>
		</cfif>
	</cfloop>	

	<cfset RefereeLastName  = "">
	<cfset RefereeName		= "">
	<cfset RefereePhone		= "">
	<cfset Grade			= "">
	<cfif len(trim(RefereeID))>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
			<cfinvokeargument name="refereeID" value="#VARIABLES.RefereeID#">
		</cfinvoke>
		<CFIF qRefInfo.RECORDCOUNT>
			<cfset RefereeLastName	= qRefInfo.LastName >
			<cfset RefereeName		= qRefInfo.FirstName >
			<cfset Grade			= qRefInfo.Grade>
			<cfif len(trim(qRefInfo.phoneCell))>
				<cfset RefereePhone = "(c) " & qRefInfo.phoneCell>
			<cfelseif len(trim(qRefInfo.phoneHome))>
				<cfset RefereePhone = "(h) " & qRefInfo.phoneHome>
			<cfelseif len(trim(qRefInfo.phoneWork))>
				<cfset RefereePhone = "(w) " & qRefInfo.phoneWork>
			</cfif>
		</CFIF>
	</cfif>	

	<cfset AR1LastName	= "">
	<cfset AR1Name		= "">
	<cfset AR1Phone	= "">
	<cfset AR1Grade	= "">
	<cfif len(trim(AsstRefId1))>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo1">
			<cfinvokeargument name="refereeID" value="#VARIABLES.AsstRefId1#">
		</cfinvoke>
		<CFIF qRefInfo1.RECORDCOUNT>
			<cfset AR1LastName	= qRefInfo1.LastName >
			<cfset AR1Name		= qRefInfo1.FirstName >
			<cfset AR1Grade		= qRefInfo1.Grade>
			<cfif len(trim(qRefInfo1.phoneCell))>
				<cfset AR1Phone = "(c) " & qRefInfo1.phoneCell>
			<cfelseif len(trim(qRefInfo1.phoneHome))>
				<cfset AR1Phone = "(h) " & qRefInfo1.phoneHome>
			<cfelseif len(trim(qRefInfo1.phoneWork))>
				<cfset AR1Phone = "(w) " & qRefInfo1.phoneWork>
			</cfif>
		</CFIF>
	</cfif>	

	<cfset AR2LastName	= "">
	<cfset AR2Name		= "">
	<cfset AR2Phone	= "">
	<cfset AR2Grade	= "">
	<cfif len(trim(AsstRefId2))>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo2">
			<cfinvokeargument name="refereeID" value="#VARIABLES.AsstRefId2#">
		</cfinvoke>
		<CFIF qRefInfo2.RECORDCOUNT>
			<cfset AR2LastName	= qRefInfo2.LastName >
			<cfset AR2Name		= qRefInfo2.FirstName >
			<cfset AR2Grade		= qRefInfo2.Grade>
			<cfif len(trim(qRefInfo2.phoneCell))>
				<cfset AR2Phone = "(c) " & qRefInfo2.phoneCell>
			<cfelseif len(trim(qRefInfo2.phoneHome))>
				<cfset AR2Phone = "(h) " & qRefInfo2.phoneHome>
			<cfelseif len(trim(qRefInfo2.phoneWork))>
				<cfset AR2Phone = "(w) " & qRefInfo2.phoneWork>
			</cfif>
		</CFIF>
	</cfif>	


	<cfinvoke component="#SESSION.SITEVARS.cfcPath#REPORT" method="getRefRPTDetails" returnvariable="qRefRptDetails">
		<cfinvokeargument name="refRptHeaderID" value="#VARIABLES.refRptHeaderID#" >
	</cfinvoke><!--- <cfdump var="#qRefRptDetails#"> --->

	<cfquery name="qGameMisconducts" dbtype="query">
		Select PlayerName, EventType, PassNo, TeamID, MisConduct_ID
		  from qRefRptDetails
		 Where EventType = 1
	</cfquery>

	<cfquery name="qGameInjuries" dbtype="query">
		Select PlayerName, EventType, PassNo, TeamID, MisConduct_ID
		  from qRefRptDetails
		 Where EventType = 2
	</cfquery>

	<cfquery name="qGamePlayUps" dbtype="query">
		Select PlayerName, EventType, PassNo, TeamID, MisConduct_ID, PlayUpFromOther, PlayUpFromTeamName
		from 	 qRefRptDetails
		Where  EventType = 3
		order by TeamID
	</cfquery>
<!--- 	<cfdump var="#qGamePlayUps#"><cfabort> --->

	<cfquery name="qMisconducts" datasource="#SESSION.DSN#">
		SELECT Misconduct_ID, Misconduct_DESCR, Misconduct_EVENT
		  FROM TLKP_Misconduct
		 ORDER BY MisConduct_Descr
	</cfquery> <!--- <cfdump var="#qMisconducts#"> --->

	
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrInjury">
		<cfinvokeargument name="listType" value="INJURY"> 
	</cfinvoke> 
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
		<cfinvokeargument name="gameID"		value="#VARIABLES.GameID#">
	</cfinvoke>


	<cfif qGameInfo.RECORDCOUNT>
		<cfset GameDate		= dateFormat(qGameInfo.game_date,"mm/dd/yyyy") >
		<cfset GameTime		= timeFormat(qGameInfo.game_time,"hh:mm tt") >
		<cfset HomeScore	= qGameInfo.Score_Home >
		<cfset VisitorScore	= qGameInfo.Score_visitor >
		<cfset HomeTeam		= qGameInfo.Home_TeamName >
		<cfset VisitorTeam	= qGameInfo.Visitor_TeamName >
		<cfset HomeTeamID	= qGameInfo.Home_Team_ID >
		<cfset VisitorTeamID = qGameInfo.Visitor_Team_ID >
		<cfset PlayField	 = qGameInfo.FIELD_ID >
		<cfset Division		 = qGameInfo.Division >
	</cfif>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#FIELD" method="getDirections" returnvariable="qField">
		<cfinvokeargument name="fieldID" value="#VARIABLES.PlayField#">
	</cfinvoke>
	<CFIF qField.RECORDCOUNT>
		<cfset FieldName = qField.FIELDNAME>
		<cfset FieldAbbr = qField.FIELDABBR>
		<cfset Address  = qField.Address>
		<cfset State	= qField.State>
		<cfset Zip		= qField.ZIPCODE>
	</cfif>
</cfif>






<STYLE>
.title { font-size: 10; font-family:  Comic Sans MS, arial ;  color: blue; }
.data  { font-size: 13;  font-family: Comic Sans MS, Courier New, arial, Times New Roman;  color: black;  text-decoration:underline;  font-weight:bold;	}
.data2 { font-size: 12;  font-family: Comic Sans MS, Courier New, arial, Times New Roman (serif), Times New Roman;	  color: black;	  font-weight:bold;	}
</STYLE>
<div align=Left>
<TABLE cellSpacing=5 cellPadding=0 width="85%" align="left" border=0>
<tr><td>
		<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<TR><TD align="center">
					<FONT size=4> NORTHERN COUNTIES SOCCER ASSOCIATION OF NJ </FONT>
				</TD>
			</TR>
			<TR><TD align="center">
					<FONT size=3> <strong>REFEREE REPORT (Online)</strong> </FONT>
				</TD>
			</TR>
			<tr><td><hr></td>
			</tr>
			<tr><td><font class="title">GAME:</font>	
					<font class="data">#GameId#</font> &nbsp;&nbsp; 
					<font class="data">#HomeTeam# (<b>#HomeScore#</b>)</font>
					<font class="title">(Home) v/s</font>
					<font class="data">#VisitorTeam# (<b>#VisitorScore#</b>)</font>
					<font class="title">(Visitor)</font>
				</td>
			</tr>
			<tr><td><font class="title">State Association/Professional League:</font>
					<font class="data">Northern counties Soccer Association of NJ</font>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<font class="title">Division/AgeGroup:</font>
					<font class="data">#Division#</font>
				</td>
			</tr>
			<tr><td >&nbsp;</td>
			</tr>
			<tr><td><font class="title">Game Played/Cancelled:</font>
					<font class="data">#GameSts#</font>
				</td>
			</tr>
			<tr><td>&nbsp;</td>
			</tr>
		</table>

		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td width="30%">	<font class="title">Game Date & Time:</font>	</td>
				<td width="25%">	<font class="title">Kick off Time:</font>		</td>
				<td width="25%">	<font class="title">End of Game time:</font>	</td>
				<td width="10%">	<font class="title">Half Time score:</font>		</td>
				<td width="10%">	<font class="title">Full Time score:</font>		</td>
			</tr>
			<tr><td><font class="data">#GameDate#</font>&nbsp;&nbsp;<font class="data">#GameTime#</font>	</td>
				<td><font class="data">#StartTime#</font>				</td>
				<td><font class="data">#EndTime#</font>				</td>
				<td><font class="data">#scoreHomeHT#-#scoreVisitorHT#</font>	</td>
				<td><font class="data">#scoreHomeFT#-#scoreVisitorFT#</font>	</td>
			</tr>
		</table>
		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td width="05%" align="left">	<font class="title">Field:</font>		</td>
				<td width="95%" align="left">	<font class="data">#FieldAbbr#</font>	</td>
			</tr>
			<tr><td width="05%" align="left">	<font class="title">&nbsp;</font>		</td>
				<td width="95%" align="left">	<font class="data">#FieldName#, #Address#, #State#-#Zip#</font>		</td>
			</tr>
			<tr><td colspan="2"><hr></td>
			</tr>
		</table>

		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td width="15%" align="left">	<font class="title">Referee:</font>			
				</td>
				<td width="85%" align="left">		
					<font class="data">#RefereeLastName#, #RefereeName#</font>
					<font class="title">&nbsp;&nbsp;USSF Referee Grade:</font>
					<font class="data">#Grade#</font>
				</td>
			</tr>
			<tr><td align="left">	<font class="title">Asst Referee ##1:</font>
				</td>
				<td align="left">
					<cfif len(Trim(AR1LastName))>
						<font class="data">#AR1LastName#, #AR1Name#</font>
						<font class="title">&nbsp;&nbsp;USSF Referee Grade:</font>
						<font class="data">#AR1Grade#</font>
					<cfelseif len(trim(AsstRef1WriteIn))>
						<font class="data">#AsstRef1WriteIn#</font>
					<cfelse>
						<font class="data">none</font>
					</cfif>
				</td>
			</tr>
			<tr><td align="left">	<font class="title">Asst Referee ##2:</font>
				</td>
				<td align="left">
					<cfif len(Trim(AR2LastName))>
						<font class="data">#AR2LastName#, #AR2Name#</font>
						<font class="title">&nbsp;&nbsp;USSF Referee Grade:</font>
						<font class="data">#AR2Grade#</font>
					<cfelseif len(trim(AsstRef2WriteIn))>
						<font class="data">#AsstRef2WriteIn#</font>
					<cfelse>
						<font class="data">none</font>
					</cfif>
				</td>
			</tr>
			<tr><td colspan="2"><hr></td>
			</tr>
		</table>

		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td width="15%" align="left"  valign="top"><font class="title">Field Condition:</font></td>
				<td width="85%" align="left" valign="top">
					<font class="title">(overall)</font>
					<font class="data">#FieldMarking#</font>
					<br>
					<font class="title">(Specifics)</font>
					<font class="data">#FieldCondText#</font>
				</td>
			</tr>
			<tr><td width="15%" align="left"  valign="top"><font class="title">Weather:</font></td>
				<td width="85%" align="left">				<font class="data">#Weather#</font>	 </td>
			</tr>
			<tr><td colspan="2"><hr></td>
			</tr>
		</table>

		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td width="65%" align="left"  valign="top">
					<font class="title">Was the home team on the field on time (Yes/No)?</font>
					<font class="data">#OnTimeHome#</font>
					&nbsp;
					<cfif ucase(OnTimeHome) EQ "NO">
						<font class="data">#HTHowLate#</font>
						<font class="title">Minutes Late</font>
					</cfif>
				</td>
				<td width="25%" align="right"  valign="top">
					<font class="title">No. of Spectators</font>&nbsp;&nbsp;
				</td>
				<td width="10%" align="left"  valign="top">
					<font class="data">#SpectatorCount#</font>
					<font class="title">Approx.</font>
				</td>
			</tr>
			<tr><td width="65%" align="left"  valign="top">
					<font class="title">Was the Visiting team on the field on time (Yes/No)?</font>
					<font class="data">#OnTimeVisitor#</font>
					&nbsp;
					<cfif ucase(OnTimeVisitor) EQ "NO" >
						<font class="data">#VTHowLate#</font>
						<font class="title">Minutes Late</font>
					</cfif>
				</td>
				<td width="25%" align="right"  valign="top">
					<font class="title">Conduct of official</font>&nbsp;&nbsp;
				</td>
				<td width="10%" align="left"  valign="top">
					<font class="data">#ConductOfficial#</font>
				</td>
			</tr>
			<tr><td width="65%" align="left"  valign="top">
					<font class="title">Players passes of the home team <font class="data">#PassesHome#</font> received and <font class="data">#PassesHome2#</font> checked</font>
				</td>
				<td width="25%" align="right"  valign="top">
					<font class="title">of Players</font>&nbsp;&nbsp;
				</td>
				<td width="10%" align="left"  valign="top">
					<font class="data">#ConductPlayers#</font>
				</td>
			</tr>
			<tr><td width="65%" align="left"  valign="top">
					<font class="title">Players passes of the visiting team <font class="data">#PassesVisitor# </font> received and <font class="data">#PassesVisitor2#</font> checked</font>
				</td>
				<td width="25%" align="right"  valign="top">
					<font class="title">of Spectators</font>&nbsp;&nbsp;
				</td>
				<td width="10%" align="left"  valign="top">
					<font class="data">#ConductSpectators#</font>
				</td>
			</tr>
			<tr><td width="65%" align="left"  valign="top">
					<font class="title">Line-up of home team <font class="data">#LineUpHome#</font> enclosed, <font class="data">#LineUpHome2#</font> available</font>
				</td>
				<td width="25%" align="right"  valign="top">
					<!--- <font class="title">Referee Paid?</font> --->
					&nbsp;
				</td>
				<td width="10%" align="left"  valign="top">
					<!--- <font class="data">#RefPaid#</font>		 --->
					&nbsp;
				</td>
			</tr>
			<tr><td width="65%" align="left"  valign="top">
					<font class="title">Line-up of visiting team <font class="data">#LineUpVisitor#</font> enclosed, <font class="data">#LineUpVisitor2#</font> available</font>
				</td>
				<td width="25%" align="right"  valign="top">
					<!--- <font class="title">Amount</font> --->
					&nbsp;
				</td>
				<td width="10%" align="left"  valign="top">
					<!--- <font class="data">#RefAmount#</font> --->
					&nbsp;
				</td>
			</tr>
			<tr><td colspan="3"><hr></td>
			</tr>
		</table>

		<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 >
			<tr><td width="20%"><FONT size=3 color=blue><b>Players / Coaches</b></font></td>
				<td width="10%"><FONT size=3 color=blue><b>Pass ##		</b></font></td>
				<td width="25%"><FONT size=3 color=blue><b>Team			</b></font></td>
				<td width="45%"><FONT size=3 color=blue><b>Misconducts / Injuries	</b></font></td>
			</tr>
			<tr><td colspan="4"> <hr></td>
			</tr>

			<cfif qGameMisconducts.RECORDCOUNT>
				<tr><td colspan="4"> <b>Cautioned</b></td>
				</tr>
				<CFLOOP query="qGameMisconducts">
					<cfset miscounductID = MISCONDUCT_ID>
					<tr><td valign="top"><font class="data2">#PlayerName#</font></td>
						<td valign="top"><font class="data2">#PassNo#</font></td>
						<td valign="top">
							<font class="data2">
								<cfif TeamID EQ HomeTeamID>
									#HomeTeam#
								<cfelseif TeamID EQ VisitorTeamID>
									#VisitorTeam#
								</cfif>
							</font>
						</td>
						<td valign="top">
							<cfquery name="miscDesc" dbtype="query">
								SELECT Misconduct_DESCR, Misconduct_EVENT
								FROM   qMisconducts
								WHERE  Misconduct_ID = #miscounductID#
							</cfquery>
							<font class="data2">[#miscDesc.Misconduct_EVENT#] #miscDesc.Misconduct_DESCR#</font>
						</td>
					</tr>
				</CFLOOP>
			</cfif>

			<tr><td colspan="4">&nbsp;  </td>
			</tr>
			
			<cfif qGameInjuries.RECORDCOUNT>
				<tr><td colspan="4"> <b>Injuries</b></td>
				</tr>
				<CFLOOP query="qGameInjuries">
					<tr><td valign="top"><font class="data2">#PlayerName#</font></td>
						<td valign="top"><font class="data2">#PassNo#</font></td>
						<td valign="top">
							<font class="data2">
								<cfif TeamID EQ HomeTeamID>
									#HomeTeam#
								<cfelseif TeamID EQ VisitorTeamID>
									#VisitorTeam#
								</cfif>
							</font>
						</td>
						<td valign="top">
							<cfloop from="1" to="#arrayLen(arrInjury)#" index="iJ">
								<cfif arrInjury[iJ][1] EQ MisConduct_ID>
									<font class="data2">#arrInjury[iJ][2]#</font>
								</cfif>
							</cfloop>
							<!--- <cfquery name="miscDesc" dbtype="query">
								SELECT Misconduct_DESCR
								FROM   qMisconducts
								WHERE  Misconduct_ID = #miscounductID#
							</cfquery>
							<font class="data2"> #miscDesc.Misconduct_DESCR#</font> --->
						</td>
					</tr>
				</CFLOOP>
			</cfif>
				</tr>
			<cfif qGamePlayUps.RECORDCOUNT>
				<tr><td colspan="4"><hr></td>
				</tr>
			</cfif>
		</table>
<cfif qGamePlayUps.RECORDCOUNT>
		<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 >
			<tr><td width="20%"><FONT size=3 color=blue><b>Player</b></font></td>
				<td width="10%"><FONT size=3 color=blue><b>Pass ##		</b></font></td>
				<td width="25%"><FONT size=3 color=blue><b>Team			</b></font></td>
				<td width="45%"><FONT size=3 color=blue><b>Played Up From</b></font></td>
			</tr>
			<tr><td colspan="4"> <hr></td>
			</tr>
			
				<tr><td colspan="4"> <b>Players Playing Up</b></td>
				</tr>
				<CFLOOP query="qGamePlayUps">
					<tr>
						<td valign="top"><font class="data2">#PlayerName#</font></td>
						<td valign="top"><font class="data2">#PassNo#</font></td>
						<td valign="top">
							<font class="data2">
								<cfif TeamID EQ HomeTeamID>
									#HomeTeam#
								<cfelseif TeamID EQ VisitorTeamID>
									#VisitorTeam#
								</cfif>
							</font>
						</td>
						<td valign="top">
							<font class="data2">
								<cfif MISCONDUCT_ID EQ 0>
									#PlayUpFromOther#
								<cfelse>
									#PlayUpFromTeamName#
								</cfif>
							</font>
						</td>
					</tr>
				</CFLOOP>
			
		</table>
</cfif>
		<!--  Seperator  -->
		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr>
				<td><hr></td>
			</tr>
		</table>
		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td  align="left"  valign="top"><font class="title">Comments</font>&nbsp;&nbsp;	</td>
			</tr>
			<tr><td align="left"  valign="top">	<font class="data">#Comments#</font>		</td>
			</tr>
		</table>
	<p>
		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
			<tr><td width="50%" align="left"  valign="top">
					<font class="title">Referee Signature <font class="data"> ______________________________ </font>
				</td>
				<td width="25%" align="left"  valign="top">
					<font class="title">Phone ## <font class="data"> ____________________ </font>
				</td>
				<td width="25%" align="left"  valign="top">
					<font class="title">Date <font class="data"> #dateFormat(NOW(),"mm/dd/yyyy")# </font>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
	<div id="siteInfo" align="center">
	<br /><!---NCSA League Office, P.O.Box 26, Ho-Ho-Kus, NJ 07423. Ph: (201) 652 4222 &copy; Northern Counties Soccer Association -1999-2008 All Rights Reserved  --->NCSA League Office, P.O. Box 26, Ho-Ho-Kus, NJ 07423 &copy; Northern Counties Soccer Association -1999-<cfoutput>#DateFormat(Now(),"YYYY")#</cfoutput> All Rights Reserved
	</div>


</cfoutput>
<!--- </div>
<cfinclude template="_footer.cfm"> --->
