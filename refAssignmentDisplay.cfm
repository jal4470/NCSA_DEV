<!--- 
	FileName:	refAssignmentDisplay.cfm
	Created on: 11/10/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/26/09 - aarnone - virt team and gametype added.
05/07/09 - aarnone - T3711 - printer friendly - made pdf a seperate pop up.

NOTE!!! any changes to this template may also need to be made to the refAssignDisplayPDF.cfm template
--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">
<!--- <br>  --->

<cfif isDefined("FORM.WeekendFrom")>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy") > 
<cfelse>
	<cfset WeekendFrom = dateFormat(now(),"mm/dd/yyyy") > 
</CFIF>

<cfif isDefined("FORM.WeekendTo")>
	<cfset WeekendTo   = dateFormat(FORM.WeekendTo,"mm/dd/yyyy") >
<cfelse>
	<cfset WeekendTo   = dateFormat(dateAdd("d",7,now()),"mm/dd/yyyy") >
</CFIF>

<CFIF isDefined("URL.st") and isNumeric(URL.st) >
	<cfset assignmentStatus = URL.st>
<CFELSEIF isDefined("FORM.assignmentStatus")>
	<cfset assignmentStatus = FORM.assignmentStatus>
<CFELSE>
	<cfset assignmentStatus = 0><!--- NOT ACCEPTED --->
</CFIF>

<CFIF assignmentStatus EQ 0>
	<!--- NOT ACCEPTED --->
	<cfset whereRefAccptYN = " is NULL ">
	<H1 class="pageheading">NCSA - Games not accepted by the referee</H1>
	<cfset stsText = "NOT ACCEPTED">
<cfelse>
	<!--- REJECTED --->
	<cfset whereRefAccptYN = " = 'N' ">
	<H1 class="pageheading">NCSA - Games Rejected by the referee</H1>
	<cfset stsText = "REJECTED">
</CFIF>

<cfquery name="qGetGames" datasource="#SESSION.DSN#">
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division, G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.fieldAbbr, G.GAME_TYPE,
		       G.RefID, C.FirstName,  C.LastName, C.PhoneCell, C.PhoneHome, C.Email, G.Virtual_TeamName,
			   G.Ref_accept_Date, G.Ref_accept_YN, G.REF_REJECTED_GAME_COMMENT as rejected_game_comment, 'REF' as refType
		  from V_Games G with (nolock)  inner JOIN TBL_CONTACT C  ON C.CONTACT_ID  = g.REFID
		 Where G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.Ref_accept_Date is NULL 
		   and G.Ref_accept_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	UNION
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division, G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.fieldAbbr, G.GAME_TYPE,
			   G.AsstRefID1, C1.FirstName, C1.LastName, C1.PhoneCell, C1.PhoneHome, C1.Email,  G.Virtual_TeamName,
			   G.ARef1AcptDate,   G.ARef1Acpt_YN,G.AR1_REJECTED_GAME_COMMENT as rejected_game_comment, 'AR1' as refType
		  from V_Games G with (nolock)   inner JOIN TBL_CONTACT C1 ON C1.CONTACT_ID = g.AsstRefID1
		 Where G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.ARef1AcptDate is NULL 
		   and G.ARef1Acpt_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	UNION
		select G.GAME_ID, G.GAME_DATE, G.GAME_TIME, G.Division, G.HOME_TEAMNAME, G.VISITOR_TEAMNAME, G.fieldAbbr, G.GAME_TYPE,
			   G.AsstRefID2, C2.FirstName, C2.LastName, C2.PhoneCell, C2.PhoneHome, C2.Email, G.Virtual_TeamName,
			   G.ARef2AcptDate,   G.ARef2Acpt_YN,G.AR2_REJECTED_GAME_COMMENT as rejected_game_comment, 'AR2' as refType
		  from V_Games G with (nolock)   inner JOIN TBL_CONTACT C2 ON C2.CONTACT_ID = g.AsstRefID2
		 Where G.GAME_DATE between <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> 
		 					   and <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> 
		   and G.ARef2AcptDate is NULL 
		   and G.ARef2Acpt_YN #preserveSingleQuotes(VARIABLES.whereRefAccptYN)#
	ORDER BY 11, 10, 2, 3
</cfquery> 



<cfif qGetGames.RECORDCOUNT>
	<h2>There are #qGetGames.RECORDCOUNT# referee #VARIABLES.stsText# games between: #DateFormat(VARIABLES.WeekendFrom,'mm/dd/yyyy')# and #DateFormat(VARIABLES.WeekendTo,'mm/dd/yyyy')# </h2>
</cfif>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrGameType">
	<cfinvokeargument name="listType" value="GAMETYPE"> 
</cfinvoke> 

<table cellspacing="0" cellpadding="5" align="center" border="0" width="825px" >
<TR><TD colspan="7">
		<FORM name="refAssgnDisplay" action="refAssignmentDisplay.cfm" method="post">
			<input type="hidden" name="assignmentStatus" value="#VARIABLES.assignmentStatus#">
			<B>From</B> &nbsp;
			<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9"> 
			<input type="Hidden" name="DOWfrom"  value="">
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendFrom)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendFrom)>
					<a href="javascript:show_calendar('refAssgnDisplay.WeekendFrom','refAssgnDisplay.DOWfrom','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>
			&nbsp;&nbsp;&nbsp;
			<B>To</B> &nbsp;
			<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
			<input type="Hidden" name="DOWto"  value="">
			&nbsp;  <cfset dpMM = datePart("m",VARIABLES.WeekendTo)-1>
					<cfset dpYYYY = datePart("yyyy",VARIABLES.WeekendTo)>
					<a href="javascript:show_calendar('refAssgnDisplay.WeekendTo','refAssgnDisplay.DOWto','#dpMM#','#dpYYYY#');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
						<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
					</a>
			&nbsp;&nbsp;&nbsp;
			<input type="SUBMIT" name="Go"  value="Get Games" >
			
			<input type="Submit" name="printme" value="Printer Friendly" >  
		</FORM>
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
</TR>
</table>	


<CFIF IsDefined("qGetGames")>
	<cfsavecontent variable="printerfriendlyData">
	<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
		<cfset holdRefID = 0>
 		<CFLOOP query="qGetGames">
			<cfif RefID NEQ holdRefID>
				<tr bgcolor="##CCE4F1">
					<TD colspan=7 bgcolor="##CCE4F1">
						#repeatString("&nbsp;",16)# 
						<b>#LastName#, #FirstName#</b>
						<br>#repeatString("&nbsp;",25)# 
						(C) <cfif len(trim(PHONECELL))>#PHONECELL#<cfelse>#repeatString("&nbsp;",12)#</cfif>
						#repeatString("&nbsp;",5)# 
						(h) <cfif len(trim(PHONEHOME))>#PHONEHOME#<cfelse>#repeatString("&nbsp;",12)#</cfif>
						#repeatString("&nbsp;",5)# 
						email: <a href="mailTo:#EMAIL#">#EMAIL#</a>
					</TD>
				</TR>
				<cfset holdRefID = qGetGames.RefID>
			</cfif>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<TD width="17%" class="tdUnderLine" nowrap>
					#DateFormat(Game_Date,'ddd')# 
					#DateFormat(Game_Date,'mm/dd/yyyy')# 
					#TimeFormat(Game_Time,'hh:mm tt')#
					<cfif len(Trim(GAME_TYPE))>
						<cfloop from="1" to="#arrayLen(arrGameType)#" step="1" index="iGt">
							<cfif GAME_TYPE EQ arrGameType[igt][1]>
								<br>  <SPAN class="red">#arrGameType[igt][3]#</span>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
				</TD>
				<TD width="05%" class="tdUnderLine" align="center" >
						<CFIF REFTYPE EQ "REF">
							<b>#REFTYPE#</b>
						<CFELSE>
							#REFTYPE#
						</CFIF>
				</TD>
				<TD width="07%" class="tdUnderLine" >
					#Game_Id#
				</TD>
				<TD width="05%" class="tdUnderLine" >#Division#</TD>
				<TD width="22%" class="tdUnderLine" >
							<cfif len(trim(VISITOR_TEAMNAME))>
								#VISITOR_TEAMNAME#
							<cfelseif len(trim(Virtual_TeamName))>
								#Virtual_TeamName#
							<cfelse>
								&nbsp;
							</cfif>
				</TD>
				<TD width="22%" class="tdUnderLine" >#HOME_TEAMNAME#</TD>
				<TD width="22%" class="tdUnderLine" >#fieldAbbr#</TD>
			</TR>
			<cfif len(trim(rejected_game_comment))>
				<TR bgcolor="##fefbd8">
					<td colspan="7" align="center">Comments:#rejected_game_comment#</td>
				</TR>
			</cfif>
		</CFLOOP>
	</table>
	</cfsavecontent>

		<div style="overflow:auto; height:500px; border:1px ##cccccc solid;">
			#printerfriendlyData#
		</div> 

	<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
		<!--- This will pop up a window that will display the page in a pdf --->
		<script> window.open('refAssignmentDisplayPDF.cfm?st=#VARIABLES.assignmentStatus#&wef=#VARIABLES.WeekendFrom#&wet=#VARIABLES.WeekendTo#','popwin'); </script> 
	</CFIF>
		<!--- <cfdocument format="pdf" orientation="landscape" >
			<cfdocumentitem type="header">
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="98%">
			<tr>
				<td colspan="7">
					<CFIF assignmentStatus EQ 0>		<!--- NOT ACCEPTED --->
						NCSA - Games not accepted by the referee
					<cfelse>					<!--- REJECTED --->
						NCSA - Games Rejected by the referee
					</CFIF>
				</td>
			</tr>
			<tr>
				<TD width="17%"> Date/Time </TD>
				<TD width="05%"> Pos </TD>
				<TD width="07%" > Game## </TD>
				<TD width="05%" > Div	 </TD>
				<TD width="22%" > Visitor Team 	</TD>
				<TD width="22%" > Home Team  	</TD>
				<TD width="22%" > Play Field 	</TD>
			</TR>
		</table>	
		</cfdocumentitem>
		#printerFriendlyData#
		</cfdocument> 
	<CFELSE>
		<div style="overflow:auto; height:500px; border:1px ##cccccc solid;">
			#printerfriendlyData#
		</div> 
	</CFIF>--->



</CFIF>


	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
