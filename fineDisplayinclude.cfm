<!--- 
	FileName:	fineDisplayInclude.cfm
	Created on: 10/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: USED IN fineDisplay.cfm and finePrint.cfm
	
MODS: mm/dd/yyyy - filastname - comments

 --->
<cfoutput> 

<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="getFineInfo" returnvariable="qFineInfo">
	<cfinvokeargument name="FineID" value="#VARIABLES.fineID#">
</cfinvoke>

<cfif qFineInfo.RECORDCOUNT LT 1>
	<cflocation url="finesListAll.cfm"> 
</cfif>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="gFineStatus">
	<cfinvokeargument name="listType" value="FINESTATUS"> 
</cfinvoke> 

<CFSWITCH expression="#ucase(qFineInfo.status)#">
	<cfcase value="P"> <!--- P = Paid	 --->  <cfset statusDesc = gFineStatus[1][2]> </cfcase>
	<cfcase value="I"> <!--- I = Invoiced ---> <cfset StatusDesc = gFineStatus[2][2]> </cfcase>
	<cfcase value="W"> <!--- W = Waived	--->   <cfset StatusDesc = gFineStatus[3][2]> </cfcase>
	<cfcase value="D"> <!--- D = Deleted --->  <cfset StatusDesc = gFineStatus[4][2]> </cfcase>
	<cfcase value="">  <!---			 --->  <cfset StatusDesc = gFineStatus[5][2]> </cfcase>
	<cfcase value="E"> <!--- E = Appealed ---> <cfset StatusDesc = gFineStatus[6][2]> </cfcase>
	<cfcase value="U"> <!--- U = Unpaid	--->   <cfset StatusDesc = gFineStatus[7][2]> </cfcase>
	<cfdefaultcase>							   <cfset StatusDesc = qFineInfo.Status> </cfdefaultcase>
</CFSWITCH>

<CFSET FineDate = dateFormat(qFineInfo.FineDateCreated ,"mm/dd/yy")>

<FORM name="FineDisplay" action="fineDisplay.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="80%">
<tr class="tblHeading">
	<TD colspan="2" align="center">
		<b> NORTHERN COUNTIES SOCCER ASSOCIATION </b>
	</TD>
</tr>
<tr><td width="50%"><B>Fine Control Number:</B> 		<u>#qFineInfo.FINE_ID#</u>	</td>
	<td width="50%"><b>Fine Date</B>					<u>#FineDate#</u>				</td>
</tr>
<tr><td colspan="2">	&nbsp;		</td>
</tr>
<tr><td colspan="2"><b>Club Name:</b> <u>#qFineInfo.Club_Name#</u>	</td>
</tr>
<tr><td colspan="2"><b>Team Fined:</b> <u>#qFineInfo.TeamName#</u>	</td>
</tr>
<tr><td colspan="2">	&nbsp;		</td>
</tr>
<tr><td colspan="2"><b>Fine Desc:</b> <u>#qFineInfo.Description#</u> 	</td>
</tr>

<CFIF qFineInfo.Game_ID GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGameInfo">
		<cfinvokeargument name="gameID"		value="#qFineInfo.Game_ID#"> 
	</cfinvoke>

	<tr><td colspan="2">	&nbsp;		</td>
	</tr>
	<tr><td colspan="2"><b>Game: </b> <u>#qGameInfo.GAME_ID#</u> 	</td>
	</tr>
	<tr><td colspan="2"><b>Date/Time: </b>  
						<u>#dateFormat(qGameInfo.game_date, "mm/dd/yy")#</u> 
						 @ #TimeFormat(qGameInfo.game_time, "hh:mm tt")# 	
		</td>
	</tr>
	<tr><td colspan="2"><b>Teams: </b> 
				<u>#qGameInfo.Visitor_TeamName#&nbsp;(#qGameInfo.Score_visitor#)</u> v/s <u>#qGameInfo.HOME_TeamName#&nbsp;(#qGameInfo.Score_home#)</u></font>
		</td>
	</tr>
	<tr><td colspan="2"><b>Field </b> <u>#qGameInfo.fieldName#</u> 	</td>
	</tr>
</CFIF>
<tr><td colspan="2">	&nbsp;		</td>
</tr>
<tr><td><b>Amount Fined:</b>	<u>$ #qFineInfo.Amount#</u>
	</td>
	<td><b>Status:</b>			<u>#VARIABLES.statusDesc#</u>
	</td>
</tr>
<tr><td><b>Check ##:</b>			<u>#qFineInfo.CheckNo#</u> </td>
	<td>&nbsp;</td>
</tr>
<tr><td colspan="2">	&nbsp;		</td>
</tr>
<tr><td colspan="2">  <b>Comments:</b>  <u>#qFineInfo.Comments# </u> 	</td>
</tr>
<tr><td colspan="2">	<hr size="1" width="100%">		</td>
</tr>
<cfif qFineInfo.AppealAllowed_YN EQ "Y">
	<tr><td colspan="2">
			<b>Club Only:</b>&nbsp;&nbsp;
				<INPUT style="WIDTH: 20px; HEIGHT: 21px" size=1> Accept &nbsp;&nbsp;&nbsp;
				<INPUT style="WIDTH: 20px; HEIGHT: 21px" size=1> Appeal (Must enter reason)
		</td>
	</tr>
	<tr><td colspan="2">
			<b>Reason (must enter if appealing)</b>
		</td>
	</tr>
	<tr><td colspan="2">
			&nbsp;<INPUT style="WIDTH: 776px; HEIGHT: 167px" size=74>
		</td>
	</tr>
<cfelse>
	<tr><td colspan="2">
			<b>Appeal Not Allowed</b>&nbsp;&nbsp;
		</td>
	</tr>
</cfif>

<tr><td colspan="2">
		<font color=red size=2 face=arial>
			<b>Important:</b>
			<cfif qFineInfo.AppealAllowed_YN EQ "Y">
				Payment/Appeal must be submitted within 30 days from the fine date
			<cfelse>
				Payment must be submitted within 30 days from the fine date
			</cfif>
		</font>
	</td>
</tr>
<tr><td colspan="2">	&nbsp;		</td>
</tr>
<tr><td colspan="2">	Mail Checks/Response to:		</td>
</tr>
<tr><td colspan="2"> 	<span class="red"><b>NCSA League Office, P.O.Box 26, Ho-Ho-Kus, NJ 07423</b></span> 	</td>
</tr>
</table>
</FORM>
</cfoutput>
