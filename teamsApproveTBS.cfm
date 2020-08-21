<!--- 
	FileName:	teamsApproveTBS.cfm
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

<H1 class="pageheading">NCSA -  </H1>
<br>
<h2>  </h2>

	<!--- <span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>"> --->
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD> 				 			</TD>
		</tr>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#"> <!--- currentRow or counter --->
			<TD class="tdUnderLine" nowrap>  		</TD>
		</tr>
	</table>	


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
