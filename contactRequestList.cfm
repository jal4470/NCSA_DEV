<!--- 
	FileName:	contactRequestList.cfm
	Created on: 10/30/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

9/12/2012 - J. Rab - Added new logic for approvals, rejections, and roles

 --->
 
<!--------------------------->
<!--- Set local variables --->
<!--------------------------->
 
<cfif isDefined("form.filter_status")>
	<cfset filter_status = form.filter_status>
<cfelse>
	<cfset form.filter_status = 1>
</cfif>
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Contact Request List</H1>
<!---<br>  <h2>yyyyyy </h2> --->

<cfset err = "">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getClubRequestedContacts" returnvariable="clubRequestedContacts">
	<cfinvokeargument name="ApproveSts" value="pending">
</cfinvoke><!--- <cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#"> --->

<!--- <cfdump var="#clubRequestedContacts#"> --->
<cfquery name="clubRequestedContacts" dbtype="query">
	SELECT 		* 
	FROM 		clubRequestedContacts
	WHERE		current_status <> 2 <!--- 2 = Approved, no roles assigned --->
	AND			current_status <> 4 <!--- 4 = Approved, but not active --->
	<cfif filter_status NEQ "">
	AND			current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#filter_status#">
	</cfif>
	ORDER BY	LastName,firstName
</cfquery>

<br>
<!--- <cfif isDefined("clubRequestedContacts") and clubRequestedContacts.RECORDCOUNT>
	<br> Number of Requested Users: #clubRequestedContacts.RECORDCOUNT#
</cfif> --->
<form name="frmContact" action="ContactRequestList.cfm" method="post">
	<!--- <span class="red">Fields marked with * are required</span> <CFSET required = "<FONT color=red>*</FONT>"> --->
	<div align="center" style="background:##333399;color:white;padding-left:3px;padding-top:3px;border-top-left-radius:15px;border-top-right-radius:15px; width: 672px;"><strong>Show:</strong>
	
				<select name="filter_status" id="filter_status" onchange="javascript:document.getElementById('subFilter2').click();">
					<option value="" <cfif filter_status EQ "">selected="selected"</cfif>>All</option>
					<option value="1" <cfif filter_status EQ 1>selected="selected"</cfif>>Waiting For Approval</option>
					<option value="3" <cfif filter_status EQ 3>selected="selected"</cfif>>Rejected</option>
				</select>
			<input type="Submit" value="Go!" id="subFilter2">
	</div>
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="675">
		<tr class="tblHeading">
			<TD colspan="4"> Requested Contacts </TD>
		</tr>
		
</cfoutput>
		<CFIF isDefined("clubRequestedContacts")>
			<tr class="tblHeading">
				<TD width="02%" align="right">&nbsp;  </TD>
				<td width="15%" > Last, First Name	</td>
				<td width="20%"> Club </td>
				<td width="30%"> Rejected Comments</td>
			</tr>
			<cfoutput query="clubRequestedContacts" group="contact_id">
				<cfset edit_page = "contactRequestDisplay.cfm">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
						<TD class="tdUnderLine" valign="middle">&nbsp;  </TD> 
						<TD class="tdUnderLine" valign="middle"> 
							<cfif len(trim(REJECT_COMMENT))><A href="#edit_page#?c=#contact_ID#">#LastName#, #firstName#</A> <span style="color:red;font-weight:bold;">(Rejected)</span><cfelse><A href="#edit_page#?c=#contact_ID#">#LastName#, #firstName#</A></cfif>
						</TD>
						<TD class="tdUnderLine">
							<cfset rolelist="">
							<cfoutput>
								<cfif roledisplayname NEQ "">
									<cfset rolelist=listappend(rolelist,roledisplayname)>
								</cfif>
							</cfoutput>
							<CFIF len(trim(roleDisplayName))>
								<span class="red"> (#trim(roleDisplayName)#) </span> - 
							</CFIF>
							#CLUB_NAME# 
						</td>
						<td class="tdUnderLine">
							#REJECT_COMMENT#
						</td>
					</tr>
			
			</cfoutput>
			<!--- <CFLOOP query="clubRequestedContacts">
				<cfif APPROVE_YN NEQ "Y">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
						<TD class="tdUnderLine" valign="middle"> &nbsp; </TD> 
						<TD class="tdUnderLine" valign="middle"> 
							<A href="contactRequestDisplay.cfm?c=#contact_ID#">#LastName#, #firstName#</A>
						</TD>
						<TD class="tdUnderLine">
							<CFIF len(trim(roleDisplayName))>
								<span class="red"> (#trim(roleDisplayName)#) </span> - 
							</CFIF>
							#CLUB_NAME#
						</td>
					</tr>
				</cfif>
			</CFLOOP> --->
			
		</CFIF> 
	</table>
</form>

</div>
<cfinclude template="_footer.cfm">




