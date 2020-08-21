<!--- 
	FileName:	injuryList.cfm
	Created on: 06/08/2009
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Injury List</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfinvoke
	component="#application.sitevars.cfcpath#.injury"
	method="getInjuries"
	returnvariable="injuries">
<!--- <cfdump var=#qGetInjuries#> --->


<FORM name="Injuries" action="injuryList.cfm"  method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="150" align=left>&nbsp;</TD>
		<TD align=left>Injury</TD>
	</tr>
	<CFLOOP query="injuries">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD align="center" class="tdUnderLine">
				<!--- <INPUT type="radio"  value="#misconduct_id#"   name="MisconductID" onclick="SetDltBtn(#usedInGames#)"> --->
				<a href="injuryAdd.cfm?injury_id=#injury_id#" >Edit</a>
				- 
				<a href="injuryDelete.cfm?injury_id=#injury_id#" onclick="return confirm('Are you sure you want to remove this injury?');">Delete</a>
			</TD>
			<TD class="tdUnderLine" align="left"> #injury_desc# </TD>
		</tr>
	</CFLOOP>
	<tr><TD colspan="2" align="left" class="tdUnderLine">
			#repeatString("&nbsp;",8)# <a href="injuryAdd.cfm" > Add a new Injury</a> - <a href="injurySequence.cfm">Sequence</a>
		</TD>
	</tr>
</table>
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
