<!--- 
	FileName:	fineTypeList.cfm
	Created on: 09/22/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: add/edit/delete fine types
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>

<div id="contentText">

<H1 class="pageheading">NCSA - Fine Types</H1>
<br>
<!--- <h2>yyyyyy </h2> --->

<!--- <span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>"> --->



<FORM name="Fines" action="fineTypeProcess.cfm"  method="post">
<input type="hidden" name="Mode"   value="">
<table cellspacing="0" cellpadding="2" align="left" border="0" width="90%">
	<tr class="tblHeading">
		<TD width="10%" align=left> &nbsp;</TD>
		<TD width="80%" align=left> Fine</TD>
		<TD width="10%" align=left>Amount</TD>
	</tr>
	<CFQUERY name="getFines" datasource="#SESSION.DSN#">
		Select A.FINETYPE_ID, A.DESCRIPTION, A.Amount, Count(b.FINE_ID) as recCount
		  from TLKP_Fine_Type A left outer join TBL_Fines b on A.FINETYPE_ID = b.FINETYPE_ID
		 Group by A.FINETYPE_ID, A.DESCRIPTION, A.Amount
	</CFQUERY>
	<CFLOOP query="getFines">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD align="center" class="tdUnderLine"> 
				<INPUT type="radio"  value="#FINETYPE_ID#"   name="FineTypeId">
				<INPUT type="hidden" value="#recCount#" name="recCount">
			</TD>
			<TD class="tdUnderLine"> #DESCRIPTION#
			</TD>
			<TD align="right" class="tdUnderLine"> #dollarFormat(Amount)#
			</TD>
		</tr>
	</CFLOOP>
	<tr>
		<td align="center" colspan="3">
			<INPUT type="SUBMIT" value="Add"	name="Add"		>
			<INPUT type="SUBMIT" value="Edit"	name="Edit"		>
			<INPUT type="SUBMIT" value="Delete" name="Delete"	>
		</td>
	</tr>
</table>	


</FORM>

 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
