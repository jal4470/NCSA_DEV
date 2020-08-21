<!--- 
	FileName:	financialOS.cfm
	Created on: 10/27/2008
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
<H1 class="pageheading">NCSA - Statement of Operations</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfif isDefined("FORM.BACK")>
	<CFLOCATION url="financialList.cfm">
</cfif>
 
<CFIF isDefined("FORM.SAVE")>
	<!--- <cfset Mode			= trim(Form.Mode)> --->
	<cfset OSID				= trim(Form.OSID)>
	<cfset StmtDate			= trim(Form.StmtDate)>
	<cfset Title			= trim(Form.Title)>
	<cfset IRegFee			= trim(Form.IRegFee)>
	<cfset IFines			= trim(Form.IFines)>
	<cfset IOther			= trim(Form.IOther)>
	<cfset IInterest		= trim(Form.IInterest)>
	<cfset ITotalIncome		= trim(Form.ITotalIncome)>
	<cfset EStateFees		= trim(Form.EStateFees)>
	<cfset EAdminPersonnel	= trim(Form.EAdminPersonnel)>
	<cfset EPhoneNet		= trim(Form.EPhoneNet)>
	<cfset EMeeting			= trim(Form.EMeeting)>
	<cfset EExpenseSupplies	= trim(Form.EExpenseSupplies)>
	<cfset ERefereeFee		= trim(Form.ERefereeFee)>
	<cfset EAssignorFee		= trim(Form.EAssignorFee)>
	<cfset ESelectTeam		= trim(Form.ESelectTeam)>
	<cfset EPromo			= trim(Form.EPromo)>
	<cfset ETrophies		= trim(Form.ETrophies)>
	<cfset EWebsiteCost		= trim(Form.EWebsiteCost)>
	<cfset ETotalExpense	= trim(Form.ETotalExpense)>
	<cfset NetIncome		= trim(Form.NetIncome)>
	<cfset Comments			= trim(Form.Comments)>


	<CFIF OSID EQ 0>
		<!--- INSERT --->
		<cfquery name="qInsertOPST" datasource="#SESSION.DSN#">
			INSERT into tbl_operatingstatement
				( TITLE, IREGFEE, IFINES, IOTHER, IINTEREST, ITOTALINCOME
				, ESTATEFEES, EADMINPERSONNEL, EPHONENET, EMEETING
				, EEXPENSESUPPLIES, EREFEREEFEE, EASSIGNORFEE, ESELECTTEAM
				, EPROMO, ETROPHIES, EWEBSITECOST, ETOTALEXPENSE
				, NETINCOME, COMMENTS, STMTDATE
				)
			VALUES
				( <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Title#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IRegFee#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IFines#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IOther#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IInterest#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ITotalIncome#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EstateFees#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EAdminPersonnel#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EPhoneNet#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EMeeting#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EExpenseSupplies#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ERefereeFee#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EAssignorFee#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ESelectTeam#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EPromo#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ETrophies#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EWebsiteCost#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ETotalExpense#" >
				, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#NetIncome#" >
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Comments#" >
				, <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#StmtDate#" >
				)
		</cfquery>

		<CFLOCATION url="financialList.cfm">


	<CFELSE>
		<!--- UPDATE --->
		<cfquery name="qUpdateOPST" datasource="#SESSION.DSN#">
			UPDATE tbl_operatingstatement
			   SET  TITLE			=  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Title#" >
				 ,  IREGFEE			=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IRegFee#" >
				 ,  IFINES			=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IFines#" >
				 ,  IOTHER			=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IOther#" >
				 ,  IINTEREST		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#IInterest#" >
				 ,  ITOTALINCOME	=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ITotalIncome#" >
				 ,  ESTATEFEES		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EStateFees#" >
				 ,  EADMINPERSONNEL	=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EAdminPersonnel#" >
				 ,  EPHONENET		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EPhoneNet#" >
				 ,  EMEETING		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EMeeting#" >
				 ,  EEXPENSESUPPLIES = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EExpenseSupplies#" >
				 ,  EREFEREEFEE		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ERefereeFee#" >
				 ,  EASSIGNORFEE	=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EAssignorFee#" >
				 ,  ESELECTTEAM		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ESelectTeam#" >
				 ,  EPROMO			=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EPromo#" >
				 ,  ETROPHIES		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ETrophies#" >
				 ,  EWEBSITECOST	=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#EWebsiteCost#" >
				 ,  ETOTALEXPENSE	=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ETotalExpense#" >
				 ,  NETINCOME		=  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#NetIncome#" >
				 ,  COMMENTS		=  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Comments#" >
				 ,  STMTDATE		=  <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#StmtDate#" >
			 Where  OP_STMNT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#OSID#" >
		</cfquery>
				( , , , , , 
				, , , , 
				, , , , 
				, , , , 
				, , , 

		<CFLOCATION url="financialList.cfm">

	</CFIF>

</CFIF> 
 
 
 
<CFIF isDefined("FORM.OSID") AND isNumeric(FORM.OSID)>
	<CFSET operStmtID = FORM.OSID>
<CFELSEIF isDefined("URL.OSID") AND isNumeric(URL.OSID)>
	<CFSET operStmtID = URL.OSID>
<CFELSEIF NOT isDefined("URL.OSID")>
	<CFSET operStmtID = 0>
</CFIF>

<CFSET pageMode = "EDIT">

<cfset  OSID				= 0 >
<cfset 	StmtDate			= dateFormat(NOW(),"mm/dd/yyyy") >
<cfset 	Title				= "" >
<cfset 	IRegFee				= 0 >
<cfset 	IFines				= 0 >
<cfset 	IOther				= 0 >
<cfset 	IInterest			= 0 >
<cfset 	ITotalIncome		= 0 >
<cfset 	EStateFees			= 0 >
<cfset 	EAdminPersonnel		= 0 >
<cfset 	EPhoneNet			= 0 >
<cfset 	EMeeting			= 0 >
<cfset 	EExpenseSupplies	= 0 >
<cfset 	ERefereeFee			= 0 >
<cfset 	EAssignorFee		= 0 >
<cfset 	ESelectTeam			= 0 >
<cfset 	EPromo				= 0 >
<cfset 	ETrophies			= 0 >
<cfset 	EWebsiteCost		= 0 >
<cfset 	ETotalExpense		= 0 >
<cfset 	NetIncome			= 0 >
<cfset 	Comments			= "" >

<cfquery name="qOperStat" datasource="#SESSION.DSN#">
		SELECT  OP_STMNT_ID, STMTDATE, TITLE, IREGFEE, IFINES, IOTHER, IINTEREST, ITOTALINCOME,
				ESTATEFEES, EADMINPERSONNEL, EPHONENET, EMEETING, EEXPENSESUPPLIES, 
				EREFEREEFEE, EASSIGNORFEE, ESELECTTEAM, EPROMO, ETROPHIES, EWEBSITECOST, 
				ETOTALEXPENSE, NETINCOME, COMMENTS 
		  FROM  tbl_operatingstatement
		 WHERE  OP_STMNT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.operStmtID#">
</cfquery>

<CFIF qOperStat.recordCount>
		<cfset OSID				= qOperStat.OP_STMNT_ID>
		<cfset StmtDate			= DateFormat(qOperStat.StmtDate,"mm/dd/yyyy")>
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
<table cellspacing="0" cellpadding="0" align="left" border="0" width="95%">
	<tr class="tblHeading">
		<TD colspan="3" align="left" >
			 &nbsp; &nbsp; &nbsp; &nbsp;
			<CFIF PageMode EQ "EDIT">
				Update Operating Statement
			<cfelse>
				Insert Operating Statement
			</CFIF>
		</TD>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<TD width="40%" align="right">
			<b>Statement Date: </b>
		</TD>
		<td width="30%" align="left">
			&nbsp; &nbsp; 
			<cfif PageMode EQ "EDIT">
				<input size="9" name="StmtDate" value="#StmtDate#" readonly >  
				&nbsp;  <!--- <cfset dpMM = datePart("m",VARIABLES.StmtDate)-1>
						<cfset dpYYYY = datePart("yyyy",VARIABLES.StmtDate)> --->
				<a href="javascript:show_calendar('OperationStmt.StmtDate');" 
						onmouseover="window.status='Date Picker';return true;" 
						onmouseout="window.status='';return true;"> 
					<img src="#SESSION.siteVars.imagePath#cal.gif" width="20" height="18" alt="" border="0">
				</a>
			<cfelse>
				 #StmtDate#
			</cfif>	
		</TD>
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
		<td align=Left>	<b><u>INCOME:</u></b>	</td>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Registered fees, net</b> </td>
		<td align=Right> 
				<cfif PageMode EQ "EDIT">
					<input name=IRegFee size=10 value="#IRegFee#">
				<cfelse>
					<b>#IRegFee#</b>
				</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Fines</b>					</td>
		<td align=Right>
			<cfif PageMode EQ "EDIT">
				<input name=IFines size=10 value="#IFines#">
			<cfelse>
				<b>#IFines#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Other Income</b> </td>
		<td align=Right>
			<cfif PageMode EQ "EDIT" >
				<input name=IOther size=10 value="#IOther#">
			<cfelse>
				<b>#IOther#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Interest Income</b> </td>
		<td align=Right>
			<cfif PageMode EQ "EDIT">
				<input name="IInterest" size=10 value="#IInterest#">
			<cfelse>
				<b>#IInterest#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left> &nbsp;	</td>
		<td align=Right> <hr>			</td>
		<td align=left> &nbsp; &nbsp; &nbsp; &nbsp;
				<cfif PageMode EQ "EDIT">
					<input name="ITotalIncome" size=10 value="#ITotalIncome#">
				<cfelse>
					<b>#ITotalIncome#</b>
				</cfif>
		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Left> <b><u>OPERATING EXPENSES:</u></b>	</td>
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
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
					<input name="EStateFees" size=10 value="#EStateFees#">
			<cfelse>
					<b>#EStateFees#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right">	<b>Administrative personnel</b>	</td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EAdminPersonnel" size=10 value="#EAdminPersonnel#">
			<cfelse>
				<b>#EAdminPersonnel#</b>
			</cfif>
		</td>
		<td align=Right>	&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Telephone & internet</b>	</td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EPhoneNet" size=10 value="#EPhoneNet#">
			<cfelse>
				<b>#EPhoneNet#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"><b>Meetings costs</b></td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EMeeting" size=10 value="#EMeeting#">
			<cfelse>
				<b>#EMeeting#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Office expense & supplies</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EExpenseSupplies" size=10 value="#EExpenseSupplies#">
			<cfelse>
				<b>#EExpenseSupplies#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Referee fees</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="ERefereeFee" size=10 value="#ERefereeFee#">
			<cfelse>
				<b>#ERefereeFee#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Assignor fees</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EAssignorFee" size=10 value="#EAssignorFee#">
			<cfelse>
				<b>#EAssignorFee#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Summer select team expenses</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="ESelectTeam" size=10 value="#ESelectTeam#">
			<cfelse>
				<b>#ESelectTeam#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Promotional expenses</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EPromo" size=10 value="#EPromo#">
			<cfelse>
				<b>#EPromo#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> 	<b>Trophies</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="ETrophies" size=10 value="#ETrophies#">
			<cfelse>
				<b>#ETrophies#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align="right"> <b>Website costs</b> </td>
		<td align=Right>
			<cfif  PageMode EQ "EDIT" >
				<input name="EWebsiteCost" size=10 value="#EWebsiteCost#">
			<cfelse>
				<b>#EWebsiteCost#</b>
			</cfif>
		</td>
		<td >&nbsp;		</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Right> &nbsp;	</td>
		<td align=Right> <hr>	</td>
		<td align=left> &nbsp; &nbsp; &nbsp; &nbsp;
			<cfif  PageMode EQ "EDIT" >
				<input name="ETotalExpense" size=10 value="#ETotalExpense#">
			<cfelse>
				<b>#ETotalExpense#</b>
			</cfif>
		</td>
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
		<td align=Right>
				<cfif  PageMode EQ "EDIT" >
					<input name="NetIncome" size=10 value="#NetIncome#">
				<cfelse>
					<b>#NetIncome#</b>
				</cfif>
			</td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td >&nbsp;		</td>
		<td >&nbsp;		</td>
		<td align=Right> <hr>    </td>
	</tr>
	<cfset ctRow = ctRow + 1>
	<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,ctRow)#">
		<td align=Right> <b>Comments</b> </td>
		<td colspan="2" align="left">
				<cfif  PageMode EQ "EDIT" >
					<TEXTAREA name="Comments" rows=6  cols=60>#Trim(Comments)#</TEXTAREA>
				<cfelse>
					#Comments#
				</cfif>
		</td>
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
</TABLE>
</form>


	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
