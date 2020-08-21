<!--- 
	FileName:	financialOSDisplay.cfm
	Created on: 10/27/2008
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
<H1 class="pageheading">NCSA - Statement of Operations</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfif isDefined("FORM.BACK")>
	<CFLOCATION url="financialList.cfm">
</cfif>
 
<CFIF isDefined("URL.OSID") AND isNumeric(URL.OSID)>
	<CFSET operStmtID = URL.OSID>
<CFELSEIF NOT isDefined("URL.OSID")>
	<CFSET operStmtID = 0>
</CFIF>

<cfset  OSID				= 0 >
<cfset 	StmtDate			= dateFormat(NOW(),"mm/dd/yyyy") >
<cfset 	Title				= "" >
<cfset 	IRegFee				= "" >
<cfset 	IFines				= "" >
<cfset 	IOther				= "" >
<cfset 	IInterest			= "" >
<cfset 	ITotalIncome		= "" >
<cfset 	EStateFees			= "" >
<cfset 	EAdminPersonnel		= "" >
<cfset 	EPhoneNet			= "" >
<cfset 	EMeeting			= "" >
<cfset 	EExpenseSupplies	= "" >
<cfset 	ERefereeFee			= "" >
<cfset 	EAssignorFee		= "" >
<cfset 	ESelectTeam			= "" >
<cfset 	EPromo				= "" >
<cfset 	ETrophies			= "" >
<cfset 	EWebsiteCost		= "" >
<cfset 	ETotalExpense		= "" >
<cfset 	NetIncome			= "" >
<cfset 	Comments			= "" >

<cfquery name="qOperStat" datasource="#SESSION.DSN#">
		SELECT  OP_STMNT_ID, STMTDATE, Title, IRegFee, IFines, IOther, IInterest, ITotalIncome,
				EStateFees, EAdminPersonnel, EPhoneNet, EMeeting, EExpenseSupplies, 
				ERefereeFee, EAssignorFee, ESelectTeam, EPromo, ETrophies, EWebsiteCost, 
				ETotalExpense, NetIncome, Comments 
		  FROM  tbl_operatingstatement
		 WHERE  OP_STMNT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.operStmtID#">
</cfquery>

<CFIF qOperStat.recordCount>
		<cfset OSID				= qOperStat.OP_STMNT_ID>
		<cfset StmtDate			= DateFormat(qOperStat.STMTDATE,"mm/dd/yyyy")>
		<cfset Title			= qOperStat.Title>
		<cfset IRegFee			= qOperStat.IRegFee>
		<cfset IFines			= qOperStat.IFines>
		<cfset IOther			= qOperStat.IOther>
		<cfset IInterest		= qOperStat.IInterest>
		<cfset ITotalIncome		= qOperStat.ITotalIncome>
		<cfset EStateFees		= qOperStat.EStateFees>
		<cfset EAdminPersonnel	= qOperStat.EAdminPersonnel>
		<cfset EPhoneNet		= qOperStat.EPhoneNet>
		<cfset EMeeting			= qOperStat.EMeeting>
		<cfset EExpenseSupplies = qOperStat.EExpenseSupplies>
		<cfset ERefereeFee		= qOperStat.ERefereeFee>
		<cfset EAssignorFee		= qOperStat.EAssignorFee>
		<cfset ESelectTeam		= qOperStat.ESelectTeam>
		<cfset EPromo			= qOperStat.EPromo>
		<cfset ETrophies		= qOperStat.ETrophies>
		<cfset EWebsiteCost		= qOperStat.EWebsiteCost>
		<cfset ETotalExpense	= qOperStat.ETotalExpense>
		<cfset NetIncome		= qOperStat.NetIncome>
		<cfset Comments			= qOperStat.Comments>
</CFIF>


<cfset ctRow = 0>
<FORM name="OperationStmt" action="financialOS.cfm"  method="post">
<!--- <input type="hidden" name="Mode" value="#MODE#"> --->
<input type="hidden" name="OSID"	 value="#operStmtID#">
<table cellspacing="0" cellpadding="0" align="left" border="0" width="65%">
	<tr class="tblHeading">
		<TD colspan="3" align="left" >
			 &nbsp; &nbsp; &nbsp; &nbsp; Operating Statement
		</TD>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<TD width="40%" align="right">	<b>Statement Date: </b> 	</TD>
		<td width="30%" align="left">	&nbsp; &nbsp; 	 #StmtDate#		</TD>
		<td width="30%" >&nbsp;		</td>
	</TR>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td  align=right>	<b>Statement Title</b>	</td>
		<td colspan="2"  align=left>  &nbsp; &nbsp;  #Title# </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
			<td colspan="3">&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left class="linktxt">	<b>INCOME:</b>	</td>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Registered fees, net</b> </td>
		<td align=Right> #numberFormat(IRegFee, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Fines</b>					</td>
		<td align=Right> #numberFormat(IFines, "9,999")# 	</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Other Income</b> </td>
		<td align=Right> #numberFormat(IOther, "9,999")# 		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Interest Income</b> </td>
		<td align=Right> #numberFormat(IInterest, "9,999")# 		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left> &nbsp;	</td>
		<td align=Right> <hr>			</td>
		<td align=left> &nbsp; &nbsp; &nbsp; &nbsp;  #numberFormat(ITotalIncome, "9,999")# 	</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left  class="linktxt"> <b>OPERATING EXPENSES:</b>	</td>
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td colspan="3"> &nbsp; </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>State fees</b> </td>
		<td align=Right> #numberFormat(EStateFees, "9,999")# 		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right">	<b>Administrative personnel</b>	</td>
		<td align=Right>	#numberFormat(EAdminPersonnel, "9,999")#		</td>
		<td align=Right>	&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Telephone & internet</b>	</td>
		<td align=Right>	#numberFormat(EPhoneNet, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Meetings costs</b></td>
		<td align=Right>	#numberFormat(EMeeting, "9,999")#			</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Office expense & supplies</b> </td>
		<td align=Right>	#numberFormat(EExpenseSupplies, "9,999")#			</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Referee fees</b> </td>
		<td align=Right>	#numberFormat(ERefereeFee, "9,999")#			</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Assignor fees</b> </td>
		<td align=Right>	#numberFormat(EAssignorFee, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Summer select team expenses</b> </td>
		<td align=Right>	#numberFormat(ESelectTeam, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Promotional expenses</b> </td>
		<td align=Right>	#numberFormat(EPromo, "9,999")#			</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> 	<b>Trophies</b> </td>
		<td align=Right>	#numberFormat(ETrophies, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Website costs</b> </td>
		<td align=Right>	#numberFormat(EWebsiteCost, "9,999")#		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Right> &nbsp;	</td>
		<td align=Right> <hr>	</td>
		<td align=left> &nbsp; &nbsp; &nbsp; &nbsp;	#numberFormat(ETotalExpense, "9,999")#			</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td align=Right> <hr>    </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> 	<b>Net income (loss)</b>	</td>
		<td >&nbsp;		</td>
		<td align=Right>	#numberFormat(NetIncome, "9,999")#				</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td align=Right> <hr>    </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Right> <b>Comments:</b>&nbsp;		 </td>
		<td colspan="2" align="left">	#Comments#	</td>
	</tr>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td colspan="3" align="center">
				<INPUT type="submit" name="back" value="Back"  >
           </TD>
	</TR>
</TABLE>
</form>


	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
