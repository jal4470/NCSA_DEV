 <!--- 
	FileName:	refAssignmentDisplayPDF.cfm
	Created on: 05/07/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments


NOTE!!! any changes to this template may also need to be made to the refAssignDisplay.cfm template

 --->
 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">


<cfif isDefined("URL.wef") AND isDate(URL.wef) >
	<cfset WeekendFrom = URL.wef > 
<cfelse>
	<cfset WeekendFrom = dateFormat(now(),"mm/dd/yyyy") > 
</CFIF>
<cfif isDefined("URL.wet") AND isDate(URL.wet) >
	<cfset WeekendTo   = URL.wet >
<cfelse>
	<cfset WeekendTo   = dateFormat(dateAdd("d",7,now()),"mm/dd/yyyy") >
</CFIF>
<CFIF isDefined("URL.st") and isNumeric(URL.st) >
	<cfset assignmentStatus = URL.st>
<CFELSE>
	<cfset assignmentStatus = 0><!--- NOT ACCEPTED --->
</CFIF>
					
<CFIF assignmentStatus EQ 0>
	<!--- NOT ACCEPTED --->
	<cfset whereRefAccptYN = " is NULL ">
	<cfset pageheading = "Games not accepted by the referee">
						<cfset stsText = "NOT ACCEPTED">
<cfelse>
	<!--- REJECTED --->
	<cfset whereRefAccptYN = " = 'N' ">
	<cfset pageheading = "Games Rejected by the referee">
						<cfset stsText = "REJECTED">
</CFIF>
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 


<cfquery name="qGetGames" datasource="#SESSION.DSN#">
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division, G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.fieldAbbr, G.GAME_TYPE,
		       G.RefID, C.FirstName,  C.LastName, C.PhoneCell, C.PhoneHome, C.Email, G.Virtual_TeamName,
			   G.Ref_accept_Date, G.Ref_accept_YN, 'REF' as refType
		  from V_Games G with (nolock)  inner JOIN TBL_CONTACT C  ON C.CONTACT_ID  = g.REFID
		 Where G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.Ref_accept_Date is NULL 
		   and G.Ref_accept_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	UNION
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division, G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.fieldAbbr, G.GAME_TYPE,
			   G.AsstRefID1, C1.FirstName, C1.LastName, C1.PhoneCell, C1.PhoneHome, C1.Email,  G.Virtual_TeamName,
			   G.ARef1AcptDate,   G.ARef1Acpt_YN, 'AR1' as refType
		  from V_Games G with (nolock)   inner JOIN TBL_CONTACT C1 ON C1.CONTACT_ID = g.AsstRefID1
		 Where G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.ARef1AcptDate is NULL 
		   and G.ARef1Acpt_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	UNION
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division, G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.fieldAbbr, G.GAME_TYPE,
			   G.AsstRefID2, C2.FirstName, C2.LastName, C2.PhoneCell, C2.PhoneHome, C2.Email, G.Virtual_TeamName,
			   G.ARef2AcptDate,   G.ARef2Acpt_YN, 'AR2' as refType
		  from V_Games G with (nolock)   inner JOIN TBL_CONTACT C2 ON C2.CONTACT_ID = g.AsstRefID2
		 Where G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.ARef2AcptDate is NULL 
		   and G.ARef2Acpt_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	ORDER BY 11, 10, 2, 3
</cfquery> 

<cfdocument format="pdf" 
			marginBottom=".2"
			marginLeft=".2"
			marginRight=".2"
			marginTop=".7"
			orientation="landscape"  >	
			<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
	<cfoutput>
	<cfdocumentitem type="header" > <!--- has heading but not spaced right --->
	
		<table cellspacing="0" cellpadding="3" border="0" width="100%" >
			<!--- <tr class="tblHeading"><TD colspan="7">NCSA - #pageheading# </TD></tr> --->
			<tr><td colspan="5" align="left">
					<H1 class="pageheading">NCSA - #pageheading#</H1>
				</td>
				<td colspan="2" align="right">
					Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
				</td>
			</tr>
			<tr class="tblHeading">		
				<TD width="17%"> Date/Time </TD>
				<TD width="05%"> Pos </TD>
				<TD width="07%" > Game## </TD>
				<TD width="05%" > Div	 </TD>
				<TD width="22%" > Visitor Team 	</TD>
				<TD width="22%" > Home Team  	</TD>
				<TD width="22%" > Play Field 	</TD>
				</tr>
			</table>

	</cfdocumentitem>

		<div id="contentText">
		<table cellspacing="0" cellpadding="3" align="left" border="0" width="100%">
				<cfset holdRefID = 0>
		 		<CFLOOP query="qGetGames">
					<cfif RefID NEQ holdRefID>
						<tr bgcolor="##CCE4F1">
							<TD colspan=7 bgcolor="##CCE4F1">
									#repeatString("&nbsp;",16)# <b>#LastName#, #FirstName#</b>
								<br>#repeatString("&nbsp;",25)# (C) <cfif len(trim(PHONECELL))>#PHONECELL#<cfelse>#repeatString("&nbsp;",12)#</cfif>
									#repeatString("&nbsp;",5)#  (h) <cfif len(trim(PHONEHOME))>#PHONEHOME#<cfelse>#repeatString("&nbsp;",12)#</cfif>
									#repeatString("&nbsp;",5)# 
									email: <a href="mailTo:#EMAIL#">#EMAIL#</a>
							</TD>
						</TR>
						<cfset holdRefID = qGetGames.RefID>
					</cfif>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
						<TD width="17%" class="tdUnderLinePDF" nowrap>
							#DateFormat(Game_Date,'ddd')# #DateFormat(Game_Date,'mm/dd/yyyy')# #TimeFormat(Game_Time,'hh:mm tt')#
							<cfif len(Trim(GAME_TYPE))>
								<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
									<cfif GAME_TYPE EQ arrGameType[igt][1]>
										<br>  <SPAN class="red">#arrGameType[igt][3]#</span>
										<cfbreak>
									</cfif>
								</cfloop>
							</cfif>
						</TD>
						<TD width="05%" class="tdUnderLinePDF" align="center" >
								<CFIF REFTYPE EQ "REF">
									<b>#REFTYPE#</b>
								<CFELSE>
									#REFTYPE#
								</CFIF>
						</TD>
						<TD width="07%" class="tdUnderLinePDF" >	#Game_Id#	</TD>
						<TD width="05%" class="tdUnderLinePDF" >	#Division#	</TD>
						<TD width="22%" class="tdUnderLinePDF" >
							<cfif len(trim(VISITOR_TEAMNAME))>
								#VISITOR_TEAMNAME#
							<cfelseif len(trim(Virtual_TeamName))>
								#Virtual_TeamName#
							<cfelse>
								&nbsp;
							</cfif>
						</TD>
						<TD width="22%" class="tdUnderLinePDF" >#HOME_TEAMNAME#</TD>
						<TD width="22%" class="tdUnderLinePDF" >#fieldAbbr#</TD>
					</TR>
				</CFLOOP>
		</table>
		</DIV>
	</cfoutput>
</cfdocument>



		
 

 
 