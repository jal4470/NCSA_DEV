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

5/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Games Ref Assignment Schedule</H1>
<!--- <br> <h2>yyyyyy </h2> --->
<cfset FirstTime	 = "Y">
<cfset RecCount		 = 0>
<cfset RecCountDate	 = 0>
<cfset RecCountGrand = 0>


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

<CFIF SESSION.MENUROLEID EQ 23> <!--- 23=ref assignor --->
	<CFSET refAssignor = session.user.contactRoleID>
<cfelse>
	<CFSET refAssignor = 0 >
</CFIF>

<!--- <cfif isDefined("FORM.GO")> --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGames">
		<cfinvokeargument name="fromdate"	value="#DateFormat(VARIABLES.WeekendFrom,"mm/dd/yyyy")#">
		<cfinvokeargument name="todate"		value="#DateFormat(VARIABLES.WeekendTo,"mm/dd/yyyy")#">
		<cfinvokeargument name="orderBy"	value="DateFAbbrTime">
	</cfinvoke>
<!--- </cfif> --->


<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%" >
<TR><TD align="left" nowrap>
	<FORM name="Games" action="refAssignmentReport.cfm"  method="post">
		<B>From</B> &nbsp;
		<INPUT name="WeekendFrom" value="#VARIABLES.WeekendFrom#" size="9">
		#repeatString("&nbsp;",3)#
		<B>To</B> &nbsp;
		<INPUT name="WeekendTo" value="#VARIABLES.WeekendTo#" size="9">
		#repeatString("&nbsp;",3)#
		<input type="SUBMIT" name="Go"  value="Get Games" >  
		#repeatString("&nbsp;",50)#
		<CFIF IsDefined("qGames")>
			<input type="Submit" name="printpdf" value="printer friendly" >
		</CFIF>
	</FORM>
	</td>
	<TD align="right" nowrap>
		<CFIF IsDefined("qGames")>
			<FORM name="printme" action="refAssignmentReportcsv.cfm"  method="post">
				<INPUT type="Hidden" name="WeekendFrom" value="#VARIABLES.WeekendFrom#" > 
				<INPUT type="Hidden" name="WeekendTo" 	value="#VARIABLES.WeekendTo#"   >
				<input type="Submit" name="printcsv"    value="csv file" >
			</FORM>
		</CFIF>
	</td>
</tr>
</table>	

<CFIF IsDefined("qGames")>
	<cfset holdDate = qGames.game_date > <!--- seed w/first date --->
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="05%">Game</TD>
			<TD width="04%">Div</TD>
			<TD width="18%">Date/Time</TD>
			<TD width="16%">PlayField</TD>
			<TD width="35%">Teams</TD>
			<td width="22%">Referee</td>
		</TR>
	</table>	
	
	<div style="overflow:auto; height:500px; border:1px ##cccccc solid;"> 
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="98%">
	<cfloop query="qGames">
		<cfif holdDate NEQ game_date>
			<tr bgcolor="##CCE4F1">
				<td colspan="6" align="center">
					<br>&nbsp;
					Total number of Games on <b>#dateFormat(holdDate,"mm/dd/yyyy")# = #RecCountDate# </b>
					<br>&nbsp;
				</td>
			</tr>
			<cfset RecCountDate	= 0>
			<cfset holdDate = GAME_DATE>
		</cfif>
		
		<cfif len(trim(COMMENTS)) GT 0>
			<!--- supress underline if a comment is found, comment will put in underline --->
			<cfset classValue = "">
		<cfelse>
			<cfset classValue = "class='tdUnderLine'">
		</cfif>
		
		

		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="05%" valign="top" #classValue# >
				#game_id#
			</TD>
			<TD width="04%" valign="top" #classValue# >
				#Division#
			</TD>
			<TD width="18%" valign="top" #classValue# >
				#dateFormat(game_date,"ddd")# #dateFormat(game_date,"mm/dd/yy")# #timeFormat(game_time,"hh:mm tt")#
				<cfswitch expression="#game_type#">
					<cfcase value="C"><br><span class="red">State Cup</span></cfcase>
					<cfcase value="N"><br><span class="red">Non League</span></cfcase>
					<cfcase value="F"><br><span class="red">Friendly</span></cfcase>
				</cfswitch>
			</TD>
			<TD width="16%" valign="top" #classValue# >
				&nbsp;#fieldAbbr#
			</TD>
			<TD width="35%" valign="top" #classValue# >
				(H) #Home_TeamName#  
				<br>(V) 
					<cfif len(trim(Visitor_TeamName))>
						#Visitor_TeamName# 
					<cfelse>
						#Virtual_TeamName#
					</cfif>
			</TD>
			<TD width="22%" valign="top" #classValue# >
				<!--- Head Referee --->
				<cfif Ref_accept_YN EQ "Y">	    <span class="green"><b>A</b></span>
				<cfelseif Ref_accept_YN EQ "N">	<span class="red"><b>D</b></span>
				<cfelse>	&nbsp;
				</cfif>
				REF: <cfif len(trim(REFID))>
						<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo">
							<cfinvokeargument name="contactID" value="#REFID#">
						</cfinvoke>
						<cfif qContactInfo.recordCount>	#qContactInfo.LastName#, #qContactInfo.firstName#
						<cfelse>	n/a
						</cfif>
					 </cfif>
				<br><!--- Asst Referee 1 ---> 
				<cfif ARef1Acpt_YN EQ "Y">		<span class="green"><b>A</b></span>
				<cfelseif ARef1Acpt_YN EQ "N">	<span class="red"><b>D</b></span>
				<cfelse>		&nbsp;
				</cfif>
				AR1: <cfif len(trim(AsstRefId1))>
						<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo1">
							<cfinvokeargument name="contactID" value="#AsstRefId1#">
						</cfinvoke>
						<cfif qContactInfo1.recordCount> #qContactInfo1.LastName#, #qContactInfo1.firstName#
						<cfelse>	n/a
						</cfif>
					 </cfif>
				<br><!--- ASST Referee 2 --->
					<cfif ARef2Acpt_YN EQ "Y">		<span class="green"><b>A</b></span>
					<cfelseif ARef2Acpt_YN EQ "N">	<span class="red"><b>D</b></span>
					<cfelse>		&nbsp;
					</cfif>
				AR2: <cfif len(trim(AsstRefId2))>
						<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qContactInfo2">
							<cfinvokeargument name="contactID" value="#AsstRefId2#">
						</cfinvoke>
						<cfif qContactInfo2.recordCount> #qContactInfo2.LastName#, #qContactInfo2.firstName#
						<cfelse>	n/a
						</cfif>
					 </cfif>
			</TD>
		</TR>
		<cfif len(trim(COMMENTS)) GT 0>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td class="tdUnderLine">&nbsp;
				</td>
				<TD colspan="5" class="tdUnderLine"> 
					Comments: #Comments#
				</TD>
			</TR>
		</cfif>
			
			<cfset RecCount		 = RecCount + 1 >
			<cfset RecCountDate	 = RecCountDate + 1 >
			<cfset RecCountGrand = RecCountGrand + 1 >
	</cfloop>
	<tr bgcolor="##CCE4F1">
		<td colspan="6" align="center">
			<br>&nbsp;
				Total number of Games on <b>#dateFormat(holdDate,"mm/dd/yyyy")# = #RecCountDate#</b> 
			<br>&nbsp;
		</td>
	</tr>
	</table>
	</DIV>

	<TABLE cellSpacing=0 cellPadding=5 width="100%" border=0>
			<tr bgcolor="##CCE4F1">
				<td colspan="6" align="center">
					<b> Grand Total for Games between #WeekendFrom# and #WeekendTo# = #RecCountGrand# </b>
				</td>
			</tr>
	</table>
</CFIF>


<CFIF isDefined("FORM.printpdf") >
	<!--- This will pop up a window that will display the page in a pdf --->
	<script> window.open('refAssignmentReportPDF.cfm?wef=#VARIABLES.WeekendFrom#&wet=#VARIABLES.WeekendTo#&rep=pdf','popwin'); </script> 
</CFIF>

<cfsavecontent variable="cf_footer_scripts">
<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('input[name=WeekendFrom],input[name=WeekendTo]').datepicker();
	});
</script>
</cfsavecontent>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
