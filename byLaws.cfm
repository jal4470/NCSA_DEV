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
<div id="contentText">

<H1 class="pageheading">NCSA - By Laws</H1>
<br>
<h2></h2>

	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD> 
				aaaaa
			</TD>
		</tr>
		<cfset currentRow=1>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD class="tdUnderLine" nowrap> 
				bbbbbbbbb
			</TD>
		</tr>

	</table>	


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
