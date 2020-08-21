<!--- 
	FileName:	financialList.cfm
	Created on: 10/27/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Financial Statements List</H1>
<br><!--- <br> <h2>yyyyyy </h2> --->

<CFIF isDefined("FORM.editOS") and isDefined("FORM.operStatementID")>
	<cflocation url="financialOS.cfm?m=e&osid=#FORM.operStatementID#">
</CFIF>
<CFIF isDefined("FORM.addos")>
	<cflocation url="financialOS.cfm?m=a">
</CFIF>

<CFIF isDefined("FORM.editBS") and isDefined("FORM.balSheetID")>
	<cflocation url="financialBS.cfm?bsid=#FORM.balSheetID#">
</CFIF>
<CFIF isDefined("FORM.addBS")>
	<cflocation url="financialBS.cfm">
</CFIF>


<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="getOpStmntID" returnvariable="qOperST">
</cfinvoke>		<!--- <cfdump var="#qOperST#"> --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#FINEFEES" method="getBalShID" returnvariable="qBalSh">
</cfinvoke>		<!--- <cfdump var="#qBalSh#"> --->


<CFIF isDefined("SESSION.MENUROLEID") AND ( SESSION.MENUROLEID EQ 1 OR SESSION.MENUROLEID EQ 5)>
	<!--- SESSION.MENUROLEID = 1 = "ASSTADMIN"
		  SESSION.MENUROLEID = 5 = "TREASURER"
	 --->
	 <cfset swShowAddEdit = true>
<CFELSE>
	 <cfset swShowAddEdit = false>
</CFIF>


<form action="financialList.cfm" method="post" >
<table cellspacing="2" cellpadding="5" align="left" border="0" width="100%">
	<tr class="tblHeading">
		<td width="50%">Statement of Operation</td>
		<td width="50%">Balance Sheet</td>
	</tr>

	<tr><td valign="top"> <!--- table ST of OP --->
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
				<cfif swShowAddEdit> <!--- show all occurances and radio button --->
					<cfloop query="qOperST">
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
							<td class="tdUnderLine">
								<input type="Radio" name="operStatementID" value="#OP_STMNT_ID#">  
								<a href="financialOSDisplay.cfm?osid=#OP_STMNT_ID#">
									#dateFormat(StmtDate,"mm/dd/yyyy")# - #TITLE#
								</a>
							</td>
						</tr>
					</cfloop>
				<cfelse> <!--- only show latest --->
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
						<td class="tdUnderLine">
							<a href="financialOSDisplay.cfm?osid=#qOperST.OP_STMNT_ID#">
								#dateFormat(qOperST.StmtDate,"mm/dd/yyyy")# - #qOperST.TITLE#
							</a>
						</td>
					</tr>
				</cfif>
			</table>

		</td>
		<td valign="top"> <!--- table Bal Sh ---> 
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
				<cfif swShowAddEdit> <!--- show all occurances and radio button --->
					<cfloop query="qBalSh">
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
							<td class="tdUnderLine">
								<input type="Radio" name="balSheetID" value="#BALANCESHEETID#">  
								<a href="financialBSDisplay.cfm?bsid=#BALANCESHEETID#">
									#dateFormat(STATEMENTDATE,"mm/dd/yyyy")# - #TITLE#
								</a>
							</td>
						</tr>
					</cfloop>
				<cfelse> <!--- only show latest --->
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
						<td class="tdUnderLine">
							<a href="financialBSDisplay.cfm?bsid=#qBalSh.BALANCESHEETID#">
								#dateFormat(qBalSh.STATEMENTDATE,"mm/dd/yyyy")# - #qBalSh.TITLE#
							</a>
						</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>	
	<cfif swShowAddEdit>
		<tr><td colspan="2">
				<table width="100%">
					<tr><td colspan="2"> <hr size="1"> </td> </tr>
					<tr><td align="center">
							<INPUT type="submit" name="editOS" value="Edit Stmt of Oper." >
							<INPUT type="submit" name="addos"  value="Add Stmt of Oper."  >
						</td>
						<td align="center">
							<INPUT type="submit" name="editBS" value="Edit Balance Sheet" >
							<INPUT type="submit" name="addBS"  value="Add Balance Sheet"  >
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
	
</table>
</FORM>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">


