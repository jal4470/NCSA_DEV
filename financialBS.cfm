<!--- 
	FileName:	financialBS.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
12/17/08 - AA - initialized fields to zero instead of spaces
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

<CFIF isDefined("FORM.SAVE")>
	<!--- <cfset Mode				 = trim(form.Mode) > --->
	<cfset bsID				 = trim(form.BSID) >
	<cfset StmtDate			 = trim(form.StmtDate) >
	<cfset Title			 = trim(form.Title) >
	<cfset ACashChecking	 = trim(form.ACashChecking) >
	<cfset ACashSaving		 = trim(form.ACashSaving) >
	<cfset ATotalCurrentAsset = trim(form.ATotalCurrentAsset) >
	<cfset AFixed			 = trim(form.AFixed) >
	<cfset ATotalAssets		 = trim(form.ATotalAssets) >
	<cfset LClubBonds		 = trim(form.LClubBonds) >
	<cfset LTotalCurrentLiab = trim(form.LTotalCurrentLiab) >
	<cfset ERetainedEarnings = trim(form.ERetainedEarnings) >
	<cfset LETotalLiabEquity = trim(form.LETotalLiabEquity) >

	<CFIF bsID EQ 0>
		<!--- INSERT --->
		<cfquery name="qInsertBalSheet" datasource="#SESSION.DSN#">
			INSERT into tbl_balanceSheet
			   ( Title, ACashChecking, ACashSaving, ATotalCurrentAsset
			   , AFixed, ATotalAssets, LClubBonds, LTotalCurrentLiab
			   , ERetainedEarnings, LETotalLiabEquity, STATEMENTDATE 
			   )
			values
			  ( <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Title#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ACashChecking#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ACashSaving#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ATotalCurrentAsset#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#AFixed#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ATotalAssets#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#LClubBonds#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#LTotalCurrentLiab#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ERetainedEarnings#" >
			  , <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#LETotalLiabEquity#" >
			  , <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#StmtDate#" >
			  )
		</cfquery>
		<CFLOCATION url="financialList.cfm">
	<CFELSE>
		<!--- UPDATE --->
		<cfquery name="qUpdBalSheet" datasource="#SESSION.DSN#">
			Update tbl_balanceSheet	
			   SET Title			= <cfqueryparam cfsqltype="CF_SQL_VARCHAR"   value="#Title#" >
				 , ACashChecking	= <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#ACashChecking#" >
				 , ACashSaving		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#ACashsaving#" >
				 , ATotalCurrentAsset = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ATotalCurrentAsset#" >
				 , AFixed			= <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#AFixed#" >
				 , ATotalAssets		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#ATotalAssets#" >
				 , LClubBonds		= <cfqueryparam cfsqltype="CF_SQL_NUMERIC"   value="#LClubBonds#" >
				 , LTotalCurrentLiab = <cfqueryparam cfsqltype="CF_SQL_NUMERIC"  value="#LTotalCurrentLiab#" >
				 , ERetainedEarnings = <cfqueryparam cfsqltype="CF_SQL_NUMERIC"  value="#ERetainedEarnings#" >
				 , LETotalLiabEquity = <cfqueryparam cfsqltype="CF_SQL_NUMERIC"  value="#LETotalLiabEquity#" >
				 , STATEMENTDATE			 = <cfqueryparam cfsqltype="CF_SQL_DATE"     value="#StmtDate#" >
			 Where BALANCESHEETID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#BSID#" >
		</cfquery>

		<CFLOCATION url="financialList.cfm">
	</CFIF>
</CFIF>

<CFIF isDefined("FORM.BSID") AND isNumeric(FORM.BSID)>
	<CFSET BalSheetID = FORM.BSID>
<CFELSEIF isDefined("URL.BSID") AND isNumeric(URL.BSID)>
	<CFSET BalSheetID = URL.BSID>
<CFELSEIF NOT isDefined("URL.BSID")>
	<CFSET BalSheetID = 0>
</CFIF>

<CFSET pageMode = "EDIT">

<cfset BSID					= "" >
<cfset StmtDate				= dateFormat(Now(),"mm/dd/yyyy") >
<cfset Title				= "" >
<cfset ACashChecking		= 0 >
<cfset ACashSaving			= 0 >
<cfset ATotalCurrentAsset	= 0 >
<cfset AFixed				= 0 >
<cfset ATotalAssets			= 0 >
<cfset LClubBonds			= 0 >
<cfset LTotalCurrentLiab	= 0 >
<cfset ERetainedEarnings	= 0 >
<cfset LETotalLiabEquity	= 0 >
        

<cfquery name="qBalSheet" datasource="#SESSION.DSN#">
		SELECT  BALANCESHEETID, STATEMENTDATE, Title, ACashChecking, ACashSaving, 
				ATotalCurrentAsset, AFixed, ATotalAssets, LClubBonds, 
				LTotalCurrentLiab, ERetainedEarnings, LETotalLiabEquity
		  FROM  tbl_balanceSheet
		 WHERE  BALANCESHEETID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.BalSheetID#">
</cfquery>

<cfif qBalSheet.RECORDCOUNT>
	<cfset BSID					= qBalSheet.BALANCESHEETID >
	<cfset StmtDate				= qBalSheet.STATEMENTDATE >
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
<table cellspacing="0" cellpadding="0" align="left" border="0" width="75%">
	<tr class="tblHeading">
		<TD colspan="3" align="left" >
			 &nbsp; &nbsp; &nbsp; &nbsp;
			<CFIF PageMode EQ "EDIT">
				Update Balance Sheet
			<cfelse>
				Insert Balance Sheet
			</CFIF>
		</TD>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<TD width="40%" align="right">
			<b>Statement Date: </b>
		</TD>
		<td width="30%" align="left">
			<cfif PageMode EQ "EDIT">
				&nbsp; &nbsp; 
				<input size="9" name="StmtDate" value="#StmtDate#" readonly >  
				&nbsp;  <!--- <cfset dpMM = datePart("m",VARIABLES.StmtDate)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.StmtDate)> --->
				<a href="javascript:show_calendar('BalanceSheet.StmtDate');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
					<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
				</a>
			<cfelse>
				 #StmtDate#
			</cfif>	
		</td>
		<td width="30%" >&nbsp;		</td>
	</TR>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td  align=right>	<b>Statement Title</b>	</td>
		<td colspan="2"  align=left>	
				&nbsp; &nbsp; 
				<cfif PageMode EQ "EDIT">
					<input name="Title"  size="50" value="#Title#" >	
				<cfelse>
					  #Title# 
				</cfif>	
		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
			<td colspan="3">&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left>	<b><u>ASSETS:</u></b>	</td>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Cash-checking</b></td>
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="ACashChecking" size=10 value="#ACashChecking#">
				<cfelse>
					<b>#ACashChecking#</b>
				</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Cash-savings</b></td>
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="ACashSaving" size=10 value="#ACashSaving#">
				<cfelse>
					<b>#ACashSaving#</b>
				</cfif>
		</td>
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
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="ATotalCurrentAsset" size=10 value="#ATotalCurrentAsset#">
				<cfelse>
					<b>#ATotalCurrentAsset#</b>
				</cfif>
		</td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Fixed assets</b></td>
		<td >&nbsp;		</td>
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="AFixed" size=10 value="#AFixed#">
				<cfelse>
					<b>#AFixed#</b>
				</cfif>
		</td>
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
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="ATotalAssets" size=10 value="#ATotalAssets#">
				<cfelse>
					<b>#ATotalAssets#</b>
				</cfif>
		</td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td ><hr>		</td>
	</tr>

	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left>	<b><u>LIABILITIES AND EQUITY</u></b>	</td>
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
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="LClubBonds" size=10 value="#LClubBonds#">
				<cfelse>
					<b>#LClubBonds#</b>
				</cfif>
		</td>
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
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="LTotalCurrentLiab" size=10 value="#LTotalCurrentLiab#">
				<cfelse>
					<b>#LTotalCurrentLiab#</b>
				</cfif>
		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>EQUITY:</b></td>
		<td colspan="2" >&nbsp;		</td>
	<tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Retained Earnings</b></td>
		<td >&nbsp;		</td>
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="ERetainedEarnings" size=10 value="#ERetainedEarnings#">
				<cfelse>
					<b>#ERetainedEarnings#</b>
				</cfif>
		</td>
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
		<td align="center"> 
				<cfif PageMode EQ "EDIT">
					<input name="LETotalLiabEquity" size=10 value="#LETotalLiabEquity#">
				<cfelse>
					<b>#LETotalLiabEquity#</b>
				</cfif>
		</td>
	</tr>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td ><hr>		</td>
	</tr>
	<cfif  PageMode EQ "EDIT" >
		<cfset ctRow = ctRow + 1>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
			<td colspan="3" align="center">
				<INPUT type="submit" name="save" value="Save"  >
				<INPUT type="submit" name="back" value="Back"  >
            </TD>
		</TR>
	</cfif>
</table>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
