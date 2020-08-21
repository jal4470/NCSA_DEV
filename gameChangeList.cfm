<!--- 
	FileName:	gameChangeList.cfm
	Created on: 10/08/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/06/09 - aarnone - ticket:7309 - virtual team changes for state cup and non league games
03/20/09 - aarnone - added parens around statusclauses
03/25/09 - aarnone - For status of Accepted, changed "original" values to be pulled from the logs
					- changed inner to left join in "qALLChangeRequests"
04/02/09 - aarnone - added a row to display comments
7/29/2014 - JLechuga - Modified query to return latest game change request
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Game Change Request Log</H1>
<br>
<cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1 > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
	 <h2>Authorize Change </h2>
</cfif>

<cfif isDefined("url.gid") AND isNumeric(url.gid)>
	<cfset selGid = url.gid>
<cfelse>
	<cfset selGid = 0>
</cfif>


<CFIF isDEfined("FORM.STATTYPE")>
	<cfset statType = FORM.STATTYPE>
<CFELSE>
	<cfset statType = "PEND">
</CFIF>


<!--- 
Y=accepted
R=rejected
D=pending
 --->
<cfswitch expression="#UCASE(STATTYPE)#">
	<cfcase value="ALL">
		<CFSET StatusClause  = " ( a.Approved is NULL OR a.Approved in('Y','R','D') ) ">
	</cfcase>
	<cfcase value="PEND">
		<CFSET StatusClause  = " ( a.APPROVED IS NULL OR a.APPROVED = 'D' ) ">
	</cfcase>
	<cfcase value="ACC">
		<CFSET StatusClause  = " a.APPROVED = 'Y' ">
	</cfcase>
	<cfcase value="REJ">
		<CFSET StatusClause  = " a.APPROVED = 'R' ">
	</cfcase>
</cfswitch>

<!--- Hat to chenge query, it was returning dupe rows of requests for games instead of just the last game request
	there will be an issue with getting the COMMENTS

<cfquery name="qChangeRequests" datasource="#SESSION.dsn#">
	SELECT A.GAME_ID, A.NewDate, A.NewTime, F.FIELDABBR as NEW_FIELD_ABBR,
		   D.HOME_TeamName, D.VISITOR_TeamName, D.Virtual_TeamName, 
		   A.ApprovedDate, A.ApprovedTime, A.Comments,
		   D.GAME_DATE, D.GAME_TIME, D.FieldAbbr, D.DIVISION, D.game_Type,
		   A.RequestDate, A.RequestTime, A.APPROVED,
	       A.GAME_CHANGE_REQUEST_ID 
	 FROM  TBL_Game_Change_Request A INNER JOIN V_Games   D ON A.GAME_ID  = D.Game
									 INNER JOIN TBL_FIELD F on f.FIELD_ID = A.NEWFIELD
	WHERE #preserveSingleQuotes(VARIABLES.StatusClause)#
		<cfif SESSION.USER.CLUBID GT 1 >
			   AND (D.HOME_Club_ID = #SESSION.USER.CLUBID# or D.VISITOR_Club_ID = #SESSION.USER.CLUBID# )
		</cfif>
	ORDER BY  D.HOME_TeamName, A.RequestDate DESC, A.RequestTime DESC
</cfquery> <!---  D.GAME_DATE, D.GAME_TIME
			-- -- Order by D.HOME_TeamName, A.GAME_ID, A.GAME_CHANGE_REQUEST_ID  DESC 
			-- -- Where (A.Approved is Null or A.Approved not in ('Y','D')) 
			--->
 --->

<!--- This will return all the "latest" game change requests get the specific type of requests by doing a QOQ afterwards --->
<cfquery name="qChangeRequests" datasource="#SESSION.dsn#">
	SELECT distinct A.GAME_ID, A.NewDate, A.NewTime, F.FIELDABBR as NEW_FIELD_ABBR, 
			D.HOME_TeamName, D.VISITOR_TeamName, D.Virtual_TeamName,   
			A.ApprovedDate, A.ApprovedTime,--,  A.Comments,
        	a.origDateTime, e.fieldabbr, D.DIVISION, D.game_Type, 
			A.RequestDate, A.RequestTime, A.APPROVED,
            A.GAME_CHANGE_REQUEST_ID , SUBSTRING(a.comments,1,datalength(a.comments)) as comments
      FROM  V_Games D INNER JOIN TBL_Game_Change_Request A WITH (nolock) ON A.GAME_ID  = D.Game
                      left JOIN TBL_FIELD F WITH (nolock)               on f.FIELD_ID = A.NEWFIELD
					  left join tbl_field e on e.field_id=a.origFieldID
     where a.game_change_request_id = (select top 1 game_change_request_id
										from tbl_game_change_request with (nolock) where game_id = a.game_id 
										order by requestDate desc)
			and  #preserveSingleQuotes(VARIABLES.StatusClause)#
		<cfif SESSION.USER.CLUBID GT 1 ><!--- restrict to logged in club --->
			   AND (D.HOME_Club_ID = #SESSION.USER.CLUBID# or D.VISITOR_Club_ID = #SESSION.USER.CLUBID# )
		</cfif>
      ORDER BY  A.GAME_ID, D.HOME_TeamName, A.RequestDate DESC, A.RequestTime DESC
</cfquery> 		

<!--- <cfquery name="qChangeRequests" dbtype="query">
	SELECT * FROM qALLChangeRequests
</cfquery>		 --->	
<!--- <cfset rIDlist = valueList(qChangeRequests.GAME_CHANGE_REQUEST_ID)>
<cfif listLen(rIDlist) EQ 0>
	<cfset rIDlist = "0">
</cfif>

<cfquery name="qCRcomments" datasource="#SESSION.dsn#">
	SELECT Comments, GAME_CHANGE_REQUEST_ID 
      FROM TBL_Game_Change_Request with (nolock)
     WHERE game_change_request_id IN (#rIDlist#)
</cfquery> 		
			 --->
			
			
<cfset holdGameID = "">
<FORM name="Games" action="GameChangeList.cfm"  method="post">
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr><TD colspan="8"> 
				Select Status: 
				<select name="statType" >
					<option value="PEND" <cfif statType eq "PEND">selected</cfif> >Pending</option>
					<option value="ALL"  <cfif statType eq "ALL">selected</cfif> >Show All</option>
					<option value="ACC"  <cfif statType eq "ACC">selected</cfif> >Accepted</option>
					<option value="REJ"  <cfif statType eq "REJ">selected</cfif> >Rejected</option>
				</select>
				<input type="Submit" name="getRequests" value="Get Requests">
			</TD>
		</tr>
		<!--- <tr><TD colspan="8"> 
				<span class="red"><b>Click on the Game to view detail</b></span>
			</TD>
		</tr> --->
		<tr class="tblHeading">
			<TD width="08%" align="center"> Game## </TD>
			<TD width="10%" align="left"> Changed To </TD>
			<TD width="10%" align="left"> Changed From </TD>
			<TD width="05%" align="left"> Div </TD>
			<TD width="20%"> HomeTeam </TD>
			<TD width="20%"> VisitorTeam </TD>
			<TD width="17%"> Play Field </TD>
			<TD width="10%"> Status </TD>
		</tr>
		<cfset ctGame = 0>
		<cfset ctloop = 0>
		<cfset holdGameID = qChangeRequests.GAME_ID>
	</table>
	    
	<div style="overflow:auto; height:500px; border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="98%">
		<CFIF listFind(SESSION.constant.CUROLES, SESSION.MENUROLEID) GT 0>
			<!--- its a club user so SUPRESS links --->
			<cfset swShowLink = 0>
		<CFELSE>
			<!--- its NOT a club user so SHOW links --->
			<cfset swShowLink = 1>
		</CFIF>

		<CFLOOP query="qChangeRequests">
			<cfset ctloop = ctloop + 1>
			<cfif trim(holdGameID) NEQ Trim(GAME_ID)>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">  
					<TD colspan="8" height="1" > <hr size="1">		</TD>
				</tr>
				<cfset ctGame = ctGame + 1>
				<cfset holdGameID = GAME_ID>
			</cfif>
			
			
			<cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1  >
				<cfset processLink = "gameChangeProcess.cfm?gcrid=" & GAME_CHANGE_REQUEST_ID >
			<CFELSE>
				<cfset processLink = "gameChangeREQedit.cfm?gid=" & GAME_ID >
			</cfif>
			
			
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">  
				<!--- <TD width="08%" align="center" onclick="toggle_visibility('chg#ctloop#')" onmouseover="this.style.cursor='hand'"  >
					<span class="linktxt">#GAME_ID#</span> 
				</TD>
				<TD width="10%" align="center" onclick="toggle_visibility('chg#ctloop#')" onmouseover="this.style.cursor='hand'"  >
					<span class="linktxt">#dateFormat(NewDate,"mm/dd/yy")# <br> #timeFormat(NewTime,"hh:mm tt")#</span>
				</TD>
				<TD width="10%" align="center" onclick="toggle_visibility('chg#ctloop#')" onmouseover="this.style.cursor='hand'"  >
					<span class="linktxt">#dateFormat(GAME_DATE,"mm/dd/yy")# <br> #timeFormat(GAME_TIME,"hh:mm tt")#</span>
				</TD>  --->
				<TD width="07%" align="center" onmouseover="this.style.cursor='hand'"  >
					<!--- supress links for clubs --->
					<CFIF swShowLink> <a href="#processLink#">	
					</CFIF>
					#GAME_ID#
					<CFIF swShowLink> </a> 
					</CFIF>
				</TD>
				<TD width="10%" align="center" onmouseover="this.style.cursor='hand'"  >
					<CFIF swShowLink> <a href="#processLink#">	
					</CFIF>
					#dateFormat(NewDate,"mm/dd/yy")# <br> #timeFormat(NewTime,"hh:mm tt")#
					<CFIF swShowLink> </a> 
					</CFIF>
				</TD>
				<TD width="10%" align="center" onmouseover="this.style.cursor='hand'"  >
					<CFIF swShowLink> <a href="#processLink#">	
					</CFIF>
						#dateFormat(origDateTime,"mm/dd/yy")# <br> #timeFormat(origDateTime,"hh:mm tt")#
					<CFIF swShowLink> </a> 
					</CFIF>
				</TD>
				
				<TD width="05%" align="center">#Division#</TD>
				<TD width="22%"> #HOME_TeamName#</TD>
				<TD width="22%"> 
					<span class="red">
						<cfswitch expression="#ucase(game_Type)#">
							<cfcase value="N">NL </cfcase>
							<cfcase value="C">SC </cfcase>
							<cfcase value="F">FR </cfcase>
							<cfdefaultcase>&nbsp; &nbsp;</cfdefaultcase>
						</cfswitch>
					</span>
					<cfif len(trim(VISITOR_TeamName))>
						#VISITOR_TeamName#
					<cfelseif len(trim(Virtual_TeamName))>
						#Virtual_TeamName#
					<cfelse>
						&nbsp; 
					</cfif>
				</TD>
				<TD width="21%"> 
						(new) #NEW_FIELD_ABBR#
					<br>(orig) 
							#FieldAbbr#
				</TD>
				<cfswitch expression="#UCASE(Trim(Approved))#">
					<cfcase value="Y">	
						<cfset showStat = "Accepted" > 
						<cfset swHand = 0>
						<cfset statDateTime = dateFormat(ApprovedDate,"mm/dd/yy") & "<br>" & timeFormat(ApprovedTime,"hh:mm tt")>
					</cfcase>
					<cfcase value="R">	
						<cfset showStat = "<span class=""red"">Rejected</span>" > 
						<cfset swHand = 0>
						<cfset statDateTime = dateFormat(ApprovedDate,"mm/dd/yy") & "<br>" & timeFormat(ApprovedTime,"hh:mm tt")>
					</cfcase>
					<cfdefaultcase>		
						<cfset showStat = "<b>Pending</b>" > 
						<cfset swHand = 1>
						<cfset statDateTime = dateFormat(RequestDate,"mm/dd/yy") & "<br>" & timeFormat(RequestTime,"hh:mm tt")>
					</cfdefaultcase>
				</cfswitch>
				<cfif swHand>
					<TD width="08%" nowrap align="center" onclick="toggle_visibility('chg#ctloop#')" onmouseover="this.style.cursor='hand'" >
						#showStat# <br> #statDateTime#
					</TD>
				<cfelse>
					<TD width="08%" nowrap align="center" >
						#showStat# <br> #statDateTime#
					</TD>
				 </cfif>
			</tr>
			
			
<!--- 			<cfquery name="qoqComments" dbtype="query">
				SELECT COMMENTS FROM  qChangeRequests WHERE GAME_CHANGE_REQUEST_ID = #GAME_CHANGE_REQUEST_ID#
			</cfquery>
			
			
			
			<CFIF qoqComments.RECORDCOUNT> --->
				<tr><td colspan="3" >&nbsp;</td>
					<td colspan="5" >Comments: #Trim(qChangeRequests.Comments)# </td>
				</tr>
			<!---</CFIF>		  --->		
			<!--- this row is toggled on amd off --->
			<tr id="chg#ctloop#"  bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#" style="Display:none" >
				<TD colspan="8" align="center">
					<TABLE cellspacing="0" cellpadding="5" align="center" border="0" width="85%" >
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Game</b></span></TD>
							<TD align="left">#GAME_ID#</TD>
							<TD align="left"><span class="red">Existing Values</span></TD>
						</TR>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Division</b></span></TD>
							<TD align="left">#Trim(Division)#</TD>
							<TD align="left"><span class="red">&nbsp;</span></TD>
						</TR>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Game Date</b></span></TD>
							<td align="left">#dateFormat(NewDate,"mm/dd/yyyy")# #dateFormat(NewDate,"ddd")# </td>
							<TD align="left"><span class="red">#dateFormat(origDateTime,"mm/dd/yyyy")# #dateFormat(origDateTime,"ddd")#</span></TD>
						</TR>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Game Time</b></span></TD>
							<td align="left">#timeFormat(NewTime,"hh:mm tt")#			</td>
							<TD align="left"><span class="red">#timeFormat(origDateTime,"hh:mm tt")#</span></TD>
						</TR>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Home Team</b></span></TD>
							<TD align="left">#HOME_TeamName#</TD>
							<TD align="left"><span class="red">&nbsp;</span></TD>
						</tr>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Visitor Team</b></span></TD>
							<TD align="left">#VISITOR_TeamName#</TD>
							<TD align="left"><span class="red">&nbsp;</span></TD>
						</tr>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>PlayField</b></span> </TD>
							<TD align="left">#NEW_FIELD_ABBR#	</td>
							<TD align="left"><span class="red">#Trim(FieldAbbr)#</span>	</TD>
						</TR>
						<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
							<TD align="right"><span class="red"><b>Reason for change/Games Chairman comments</b></span></TD>
							<TD align="left" colspan="2" > 
								<!--- <cfquery name="qoqComments" dbtype="query">
									SELECT COMMENTS FROM  qCRcomments WHERE GAME_CHANGE_REQUEST_ID = #GAME_CHANGE_REQUEST_ID#
								</cfquery> --->
								<!--- <CFIF qoqComments.RECORDCOUNT> --->
									#Trim(qChangeRequests.Comments)#
								<!--- </CFIF> --->									
							</TD>
						</TR>
						<cfif SESSION.MENUROLEID EQ 19 OR SESSION.MENUROLEID EQ 1   > <!---  19="GAMESCHAIR" 1="ASSTADMIN" --->
							<!--- AND LEN(TRIM(Approved)) EQ 0 --->
							<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">
								<TD colspan="3" align="center"><a href="gameChangeProcess.cfm?gcrid=#GAME_CHANGE_REQUEST_ID#">Change Approval</a></TD>
							</TR>
						</cfif>
					</TABLE>
				</TD>
			</tr>
			<!--- </div> ---> <!--- </cfif> --->
		</CFLOOP>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctGame)#">  
					<TD colspan="8" height="1" > <hr size="1">		</TD>
				</tr>
	</table>	
	</div>
</FORM>

</cfoutput>
</div>

<script language="javascript">
function toggle_visibility(id) 
{	var e = document.getElementById(id);
	if(e.style.display == 'block')
		e.style.display = 'none';
	else
		e.style.display = 'block';
}
</script>



<cfinclude template="_footer.cfm">
