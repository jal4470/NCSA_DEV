<!--- 
	FileName:	refereeMisconductList.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - MisConduct List</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfquery name="qGetMisconduct" datasource="#SESSION.DSN#">
	SELECT A.misconduct_id, A.misconduct_descr, A.Misconduct_event, a.seq, Count(b.Game) as usedInGames
	  from tlkp_Misconduct A left outer join V_RefRptDtl b on A.misconduct_id = b.MisconductID
	 Group by A.misconduct_id, A.misconduct_descr, A.Misconduct_event, a.seq
	 order by a.seq
</cfquery> <!--- <cfdump var="#qGetMisconduct#"> --->


<FORM name="Misconduct" action="refereeMisconductlist.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="15%" align=left>&nbsp;</TD>
		<TD width="15%" align=left>Event</TD>
		<TD width="70%" align=left>MisConduct</TD>
	</tr>
	<CFLOOP query="qGetMisconduct">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD align="center" class="tdUnderLine">
				<!--- <INPUT type="radio"  value="#misconduct_id#"   name="MisconductID" onclick="SetDltBtn(#usedInGames#)"> --->
				<INPUT type="hidden" value="#usedInGames#" name="recCount">
				<a href="refereeMisconductProcess.cfm?editmid=#misconduct_id#" >Edit</a>
				- 
				<cfif usedInGames GT 0>
					<a href="javascript:alert('You cannot remove this entry because it is used in games.');" >Delete</a>
				<cfelse>
					<a href="refereeMisconductProcess.cfm?deletemid=#misconduct_id#">Delete</a>
				</cfif>
			</TD>
			<TD class="tdUnderLine" align="left"> #Misconduct_event# </TD>
			<TD class="tdUnderLine" align="left"> #misconduct_descr# </TD>
		</tr>
	</CFLOOP>
	<tr><TD colspan="3" align="left" class="tdUnderLine">
			<a href="refereeMisconductProcess.cfm?addmid=0" > #repeatString("&nbsp;",8)# Add a new Misconduct</a> - <a href="misconductSequence.cfm">Sequence</a>
		</TD>
	</tr>
</table>
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
