<!--- 
	FileName:	gameSchedulepdf.cfm
	Created on: 05/28/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: Display game schedule/scores based on parameter:
			gameSchedule.cfm?by=tm = by TEAM
			gameSchedule.cfm?by=cl = by CLUB 		(default case)
			gameSchedule.cfm?by=dv = by DIVISION
			gameSchedule.cfm?by=fl = by FIELD
			gameSchedule.cfm?by=dt = by DATE
			gameSchedule.cfm?by=nn = by nonNCSA ????
	
MODS: mm/dd/yyyy - filastname - comments



NOTE!!! Changes to this file may also need to be applied to gameSchedule.cfm
 --->
 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<!--- <cfinclude template="_checkLogin.cfm"> public page, login not needed--->

<cfdump var="#URL#">


<CFIF isDefined("URL.BY")>
	<CFSET schedBY = URL.BY>
<CFELSE>
	<CFSET schedBY = "">
</CFIF>

<CFIF isDefined("URL.TID")>
	<CFSET teamIDselected = URL.TID>
<CFELSE>
	<CFSET teamIDselected = 0>
</CFIF>

<CFIF isDefined("URL.CID")>
	<CFSET clubIDselected = URL.CID>
<CFELSE>
	<CFSET clubIDselected = 0>
</CFIF>

<CFIF isDefined("URL.DIV")>
	<CFSET divSelected = URL.DIV>
<CFELSE>
	<CFSET divSelected = 0>
</CFIF>

<CFIF isDefined("URL.FROM")>
	<CFSET dateSelectedFrom = URL.FROM>
<CFELSE>
	<CFSET dateSelectedFrom = 0>
</CFIF>

<CFIF isDefined("URL.TO")>
	<CFSET dateSelectedTo = URL.TO>
<CFELSE>
	<CFSET dateSelectedTo = 0>
</CFIF>

<CFIF isDefined("URL.FID")>
	<CFSET fieldSelected = URL.FID>
<CFELSE>
	<CFSET fieldSelected = 0>
</CFIF>


<cfset printerFriendlyHeader = "">
<cfset printerFriendlyData	 = "">

<CFSWITCH expression="#VARIABLES.schedBY#">
	<CFCASE value="tm"><!--- BY TEAM --->
		<CFSET h1text = "by Team">
	</CFCASE>
	<CFCASE value="dv"><!--- BY DIVISION --->
		<CFSET h1text = "by Division">
	</CFCASE>
	<CFCASE value="fl"><!--- BY FIELD --->
		<CFSET h1text = "by Field">
	</CFCASE>
	<CFCASE value="dt"><!--- BY DATE --->
		<CFSET h1text = "by Date">
	</CFCASE>
	<CFCASE value="nn"><!--- BY NON NCSA --->
		<CFSET h1text = "by NON NCSA games">
	</CFCASE>
	<cfdefaultcase><!--- BY CLUB --->
		<CFSET h1text = "by Club">
	</cfdefaultcase>
</CFSWITCH>



<!--- use query instead of session because it is a public page --->
<CFQUERY name="qGetSchedDisplay" datasource="#SESSION.DSN#">
	SELECT _VALUE
	  FROM TBL_GLOBAL_VARS
	 WHERE _NAME = 'AllowSchedDisplay'
</CFQUERY>
<CFSET swDisplaySched = qGetSchedDisplay._VALUE>

<CFIF swDisplaySched EQ "N" >
	<span class="red"><b>The schedule is currently not available.</b></span>
<cfelse>

	<CFSWITCH expression="#VARIABLES.schedBY#">
		<CFCASE value="tm"><!--- BY TEAM --->
			<CFIF isDefined("VARIABLES.teamIDselected") AND teamIDselected GT 0>
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="teamID"  value="#VARIABLES.teamIDselected#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>
		</CFCASE>

		<CFCASE value="dv"><!--- BY DIVISION --->
			<CFIF isDefined("VARIABLES.divSelected") AND divSelected GT 0 >
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="division" value="#VARIABLES.divSelected#">
					<cfinvokeargument name="notLeague" value="N">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  <!--- <cfinvokeargument name="date" 	  value="#FORM.DATE#"> --->
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="fl"><!--- BY FIELD --->
			<CFIF isDefined("VARIABLES.fieldSelected") AND fieldSelected GT 0 >
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fieldID" value="#VARIABLES.fieldSelected#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="dt"><!--- BY DATE --->
			<CFIF isDefined("VARIABLES.dateSelectedFrom") AND dateSelectedFrom GT 0 >
				<CFSET fromDate = dateSelectedFrom>
				<CFSET toDate   = 0>
				<CFIF dateSelectedTo GT 0>
					<CFIF dateSelectedTo GT dateSelectedFrom>
						<CFSET toDate   = dateSelectedTo>
					</CFIF>
				</CFIF>	
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fromDate" value="#VARIABLES.fromDate#">
					<cfinvokeargument name="toDate"   value="#VARIABLES.toDate#">
					<cfinvokeargument name="notLeague" value="">
				</cfinvoke> 
			</CFIF>	
		</CFCASE>
	
		<CFCASE value="nn"><!--- BY NON NCSA --->
			<CFIF isDefined("VARIABLES.dateSelectedFrom") AND dateSelectedFrom GT 0 >
				<CFSET fromDate = dateSelectedFrom>
				<CFSET toDate   = 0>
				<CFIF dateSelectedTo GT 0>
					<CFIF dateSelectedTo GT dateSelectedFrom>
						<CFSET toDate   = dateSelectedTo>
					</CFIF>
				</CFIF>	
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="fromDate" value="#VARIABLES.fromDate#">
					<cfinvokeargument name="toDate"   value="#VARIABLES.toDate#">
					<cfinvokeargument name="notLeague" value="Y">
				</cfinvoke> 
				<cfquery name="qGames" dbtype="query">
					SELECT * FROM qGames
					ORDER BY GAME_TYPE
				</cfquery>
			</CFIF>	
		</CFCASE>
	
		<cfdefaultcase><!--- BY CLUB --->
			<CFIF isDefined("VARIABLES.clubIDselected") AND clubIDselected GT 0>
				<cfinvoke component="#SESSION.sitevars.cfcPath#game" method="getGameSchedule" returnvariable="qGames">
					<cfinvokeargument name="clubID"  value="#VARIABLES.clubIDselected#">
					<cfinvokeargument name="notLeague" value="">
					<cfinvokeargument name="seasonID" value="#session.currentseason.id#">
				</cfinvoke>  
			</CFIF>
		</cfdefaultcase>
	</CFSWITCH> 
</CFIF><!--- IF swDisplaySched EQ "N"  --->


<CFIF isDefined("qGames") AND qGames.RECORDCOUNT>

	<cfdocument format="pdf" 
			marginBottom=".4"
			marginLeft=".3"
			marginRight=".3"
			marginTop=".4"  >
			<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
			<cfoutput>
		<cfdocumentitem type="header" > <!--- has heading but not spaced right --->
			<link rel="STYLESHEET" type="text/css" href="2col_leftNav.css">	
			<div id="contentText">
			<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
				<tr><td colspan="6" align="left">
						<br>
						<H1 class="pageheading">NCSA Games Schedule - #variables.h1text# </H1>
					</td>
					<td colspan="4" align="right">
						Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
					</td>
				</tr>
				<CFIF schedBY NEQ "nn">
					<tr class="tblHeading">
						<TD width="14%"> Date/Time	</TD>
				   	 	<TD width="06%"> type 		</TD>
				    	<TD width="05%"> Game## 	</TD>
				    	<TD width="05%"> Div 		</TD>
						<TD width="14%"> Field 		</TD>
						<TD width="20%"> Home Team	</TD>
						<TD width="20%"> Visitor Team</TD>
						<TD width="05%"> HS 		</TD>
						<TD width="05%"> VS 		</TD>
						<TD width="06%"> REF 		</TD>
					</tr>
				<CFELSE>
					<tr><td colspan="10" >
							<hr size="1" width="100%" align="left">
						</td>
					</tr>
				</CFIF>
			</table>
			</div>

		</cfdocumentitem>

			<div id="contentText">
				<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
					<cfset gameTypeHOLD = "">
					<CFLOOP query="qGames">
						<CFIF schedBY EQ "nn">
							<CFIF GAME_TYPE NEQ gameTypeHOLD>
								<tr><TD colspan="10" align="center"> 
										<H2>
										<cfswitch expression="#game_type#">
											<cfcase value="F">Friendly</cfcase>
											<cfcase value="C">State Cup</cfcase>
											<cfcase value="P">Playoff</cfcase>
											<cfcase value="N">Non League</cfcase>
											<cfdefaultcase>&nbsp;</cfdefaultcase>
										</cfswitch>
										Games
										</H2>
									</TD>
							    </tr>
								<tr class="tblHeading">
									<TD width="10%" > Date/Time	</TD>
					   	 			<TD width="05%" > type 		</TD>
					    			<TD width="05%" > Game## 	</TD>
					    			<TD width="05%" > Div 		</TD>
									<TD width="15%" > Field 		</TD>
									<TD width="20%" > Home Team	</TD>
									<TD width="20%" > Visitor Team</TD>
									<TD width="05%" > HS 		</TD>
									<TD width="05%" > VS 		</TD>
									<TD width="10%" > REF 		</TD>
								</tr>
							<cfset gameTypeHOLD = GAME_TYPE>
							</CFIF>
						</CFIF>
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
							<TD width="10%" class="tdUnderLine" nowrap> 
							    #UCASE(DATEFORMAT(GAME_DATE,"ddd"))# 
								&nbsp; 
								#DATEFORMAT(GAME_DATE,"mm/dd/yy")# 
			 				 	#repeatString("&nbsp;",2)#
								#TIMEFORMAT(GAME_TIME,"hh:mm tt")# 
							</TD>
							<TD width="05%" class="tdUnderLine" nowrap> 
								<cfswitch expression="#game_type#">
									<cfcase value="F">Friendly</cfcase>
									<cfcase value="C">State Cup</cfcase>
									<cfcase value="P">Playoff</cfcase>
									<cfcase value="N">Non League</cfcase>
									<cfdefaultcase>&nbsp;</cfdefaultcase>
								</cfswitch>
							</TD>
							<TD width="05%" class="tdUnderLine"> #game_id# &nbsp;	</TD>
							<TD width="05%" class="tdUnderLine"> #Division# &nbsp;	</TD>
							<TD width="15%" class="tdUnderLine"> #fieldAbbr#		</TD>
							<TD width="20%" class="tdUnderLine"> <!--- HOME TEAM NAME, bold if selecting CLUB or TEAM  --->
								<cfset swBold = false> 
								<CFIF Home_CLUB_ID EQ clubIDselected>
									<cfset swBold = true>
								<CFELSEIF Home_Team_ID EQ teamIDselected>
									<cfset swBold = true>
								</CFIF>
								<cfif swBold><b></cfif> #Home_TeamName# <cfif swBold></b></cfif>
								&nbsp;
							</TD>
							<TD width="20%" class="tdUnderLine"> <!--- VISITOR TEAM NAME, bold if selecting CLUB or TEAM, 
													 IF name is blank then it could be a write-in for STATECUP or NONLEAGUE GAMES  --->
								<CFIF len(trim(Visitor_TeamName)) AND len(trim(Virtual_TeamName)) EQ 0>
									<cfset swBold = false>
									<CFIF Visitor_CLUB_ID EQ clubIDselected>
										<cfset swBold = true>
									<CFELSEIF Visitor_Team_ID EQ teamIDselected>
										<cfset swBold = true>
									</CFIF>
									<cfif swBold><b></cfif> #Visitor_TeamName# <cfif swBold></b></cfif>
								<CFELSE><!--- state cup or non league game --->
									#Virtual_TeamName#
								</CFIF>
								&nbsp;
							</TD>
							<TD width="05%" class="tdUnderLine"> &nbsp; #Score_Home# 			</TD>
							<TD width="05%" class="tdUnderLine"> &nbsp; #Score_visitor# 		</TD>
							<TD width="10%" class="tdUnderLine"> &nbsp; 
								<CFIF len(trim(RefID))>
									<cfif Ref_accept_YN EQ "Y"><span class="green">Accepted</span></cfif>
								</CFIF> 
							</TD>
				 		</tr>
					</CFLOOP>
				</table>
			</div>
		</cfoutput>
	</cfdocument>
</CFIF>


