<!--- 
	FileName:	regAppNewClub.cfm
	Created on: 09/05/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<CFIF isDefined("FORM.HISTORY")>
	<cflocation url="regAppNewClubHistory.cfm">
</CFIF>


<cfinvoke component="#SESSION.sitevars.cfcpath#registration" method="getNewClubRequests" returnvariable="qGetClubRequests">
</cfinvoke>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - New Club Applications</H1>
<h2>Pending Applications</h2>

<form action="regAppNewClub.cfm" method="post">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td width="05%"> Id </td>
		<td width="20%"> Club</td>
		<td width="20%"> Address</td>
		<td width="10%"> Town</td>
		<td width="10%"> State</td>
		<td width="10%"> ZIP</td>
		<td width="25%"> Request Date</td>
	</tr>
</table>	

<div style="overflow:auto;height:400px;border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<CFLOOP query="qGetClubRequests">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="05%" class="tdUnderLine" nowrap> #ID#		</TD>
			<TD width="20%" class="tdUnderLine" nowrap> <a href="regNewClubDetail.cfm?ID=#ID#">#Club#</a>		</TD>
			<TD width="20%" class="tdUnderLine" nowrap> #Address#	</TD>
			<TD width="10%" class="tdUnderLine" nowrap> #Town#, 	</TD>
			<TD width="10%" class="tdUnderLine" nowrap> #State# 	</TD>
			<TD width="10%" class="tdUnderLine" nowrap> #Zip#		</TD>
			<TD width="25%" class="tdUnderLine" nowrap> #DateFormat(RequestDate,"mm/dd/yyyy")# #TimeFormat(RequestDate,"hh:mmtt")# 	</TD>
		</tr>
	</CFLOOP>
</table>	
</div>

	<input type="Submit" name="history" value="View History">

</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
