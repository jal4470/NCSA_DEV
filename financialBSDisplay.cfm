<!--- 
	FileName:	financialBSDisplay.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="JavaScript" src="DatePicker.js"></script>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Balance Sheet</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfif isDefined("FORM.BACK")>
	<CFLOCATION url="financialList.cfm">
</cfif>


<CFIF isDefined("URL.BSID") AND isNumeric(URL.BSID)>
	<CFSET BalSheetID = URL.BSID>
<CFELSEIF NOT isDefined("URL.BSID")>
	<CFSET BalSheetID = 0>
</CFIF>

<cfset BSID					= "" >
<cfset StmtDate				= dateFormat(Now(),"mm/dd/yyyy") >
<cfset Title				= "" >
<cfset ACashChecking		= "" >
<cfset ACashSaving			= "" >
<cfset ATotalCurrentAsset	= "" >
<cfset AFixed				= "" >
<cfset ATotalAssets			= "" >
<cfset LClubBonds			= "" >
<cfset LTotalCurrentLiab	= "" >
<cfset ERetainedEarnings	= "" >
<cfset LETotalLiabEquity	= "" >
        

<cfquery name="qBalSheet" datasource="#SESSION.DSN#">
		SELECT  BALANCESHEETID, STATEMENTDATE, Title, ACashChecking, ACashSaving, 
				ATotalCurrentAsset, AFixed, ATotalAssets, LClubBonds, 
				LTotalCurrentLiab, ERetainedEarnings, LETotalLiabEquity
		  FROM  tbl_balanceSheet
		 WHERE  BALANCESHEETID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.BalSheetID#">
</cfquery>

<cfif qBalSheet.RECORDCOUNT>
	<cfset BSID					= qBalSheet.BALANCESHEETID >
	<cfset StmtDate				= dateFormat(qBalSheet.STATEMENTDATE,"mm/dd/yyyy") >
	<cfset Title				= qBalSheet.Title >
	<cfset ACashChecking		= qBalSheet.ACashChecking >
	<cfset ACashSaving			= qBalSheet.ACashSaving >
	<cfset ATotalCurrentAsset	= qBalSheet.ATotalCurrentAsset >
	<cfset AFixed				= qBalSheet.AFixed >
	<cfset ATotalAssets			= qBalSheet.ATotalAssets >
	<cfset LClubBonds			= qBalSheet.LClubBonds >
	<cfset LTotalCurrentLiab	= qBalSheet.LTotalCurrentLiab >
	<cfset ERetainedEarnings	= qBalSheet.ERetainedEarnings >
	<cfset LETotalLiabEquity	= qBalSheet.LETotalLiabEquity >
</cfif>


<cfset ctRow = 0>
<FORM name="BalanceSheet" action="financialBS.cfm"  method="post">
<!--- <input type="hidden" name="Mode" value="#Mode#"> --->
<input type="hidden" name="BSID"	 value="#BalSheetID#">
<table cellspacing="0" cellpadding="0" align="left" border="0" width="55%">
	<tr class="tblHeading">
		<TD colspan="3" align="left" >
			 &nbsp; &nbsp; &nbsp; &nbsp;
				Balance Sheet
		</TD>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<TD width="40%" align="right">			<b>Statement Date: </b>		</TD>
		<td width="30%" align="left">			&nbsp; &nbsp; &nbsp;	 #StmtDate#		</td>
		<td width="30%" >&nbsp;		</td>
	</TR>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td  align=right>	<b>Statement Title</b>	</td>
		<td colspan="2"  align=left>	&nbsp; &nbsp; &nbsp;  #Title# 		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
			<td colspan="3">&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left  class="linktxt"><b>ASSETS:</b>	</td>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Cash-checking</b></td>
		<td align="right"> #numberFormat(ACashChecking, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Cash-savings</b></td>
		<td align="right"> #numberFormat(ACashSaving, "9,999")# </td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td ><hr>		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Total current Assets</b></td>
		<td >&nbsp;		</td>
		<td align="right">  #numberFormat(ATotalCurrentAsset, "9,999")# 	</td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Fixed assets</b></td>
		<td >&nbsp;		</td>
		<td align="right"> #numberFormat(AFixed, "9,999")# </td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td ><hr>		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Total assets</b></td>
		<td >&nbsp;		</td>
		<td align="right">  #numberFormat(ATotalAssets, "9,999")#  </td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td ><hr>		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=left  class="linktxt"> <b>LIABILITIES AND EQUITY:</b>	</td>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Club bonds payable</b></td>
		<td align="right">  #numberFormat(LClubBonds, "9,999")#  </td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td ><hr>		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Total current liabilities</b></td>
		<td >&nbsp;		</td>
		<td align="right">  #numberFormat(LTotalCurrentLiab, "9,999")#  </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="left" class="linktxt"> <b>EQUITY:</b> </td>
		<td colspan="2" >&nbsp;		</td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Retained Earnings</b></td>
		<td >&nbsp;		</td>
		<td align="right">  #numberFormat(ERetainedEarnings, "9,999")# 		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td ><hr>		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Total liability and equity</b></td>
		<td >&nbsp;		</td>
		<td align="right">  #numberFormat(LETotalLiabEquity, "9,999")# </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td ><hr>		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td colspan="3" align="center">
				<INPUT type="submit" name="back" value="Back"  >
           </TD>
	</TR>
</table>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
