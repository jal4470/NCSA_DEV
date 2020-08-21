<!--- 
	FileName:	formsManage.cfm
	Created on: 06/04/2009
	Created by: B. Cooper
	
	Purpose: displays list of forms (documents) in db
	
MODS: mm/dd/yyyy - flastname - comments
5/28/2010 B. Cooper
8005 - added external links to forms manager

 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">
	<H1 class="pageheading">NCSA - Manage Forms</H1>
	
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="1">
	</cfinvoke>
	<h2>League Info Forms</h2>
	<div>
		<table cellspacing="0" cellpadding="0" align="left" border="0" width="98%" style="margin-bottom:15px;">
			<tr class="tblHeading">
				<td> Action	 </td>
				<td> Name	 </td>
				<td> Type	 </td>
				<td> Active	 </td>
				<td> Created </td>
			</tr>
		
			<CFLOOP query="forms">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">
						<a href="formsEdit.cfm?form_id=#form_id#">Edit</a> | <a href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this file?');">Del</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<a href="formsDetails.cfm?form_id=#form_id#">#name#</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif formType EQ 1>Form<cfelse>Link</cfif>
					</td>
					<td valign="top" align="left" class="tdUnderLine"> 
						<cfif active_flag EQ "1">
							<span class="green"><b>ACTIVE</b></span>
						<cfelse>
							<span class="red"><b>NOT Active</b></span>
						</cfif>
					</td>
					<td valign="top" class="tdUnderLine"> 
						#dateformat(datecreated,"mm/dd/yyyy")# #timeformat(datecreated,"hh:mm tt")#
					</td>
				</tr>
			</CFLOOP>
			<tr>
				<td colspan="3">
					<input type="Button" name="btnAdd" value="Add Form" onclick="location.href='formsAdd.cfm?group_id=1';">
				</td>
				<td style="text-align:right;">
					<input type="Button" name="btnSeq" value="Update Sequence" onclick="location.href='formsSequence.cfm?group_id=1';">
				</td>
			</tr>
		</table>
		<div style="clear:both;"></div>
	</div>
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="2">
	</cfinvoke>
	<h2>Referee Forms</h2>
	<div>
		<table cellspacing="0" cellpadding="0" align="left" border="0" width="98%" style="margin-bottom:15px;">
			<tr class="tblHeading">
				<td> Action	 </td>
				<td> Name	 </td>
				<td> Type	 </td>
				<td> Active	 </td>
				<td> Created </td>
			</tr>
		
			<CFLOOP query="forms">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">
						<a href="formsEdit.cfm?form_id=#form_id#">Edit</a> | <a href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this file?');">Del</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<a href="formsDetails.cfm?form_id=#form_id#">#name#</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif formType EQ 1>Form<cfelse>Link</cfif>
					</td>
					<td valign="top" align="left" class="tdUnderLine"> 
						<cfif active_flag EQ "1">
							<span class="green"><b>ACTIVE</b></span>
						<cfelse>
							<span class="red"><b>NOT Active</b></span>
						</cfif>
					</td>
					<td valign="top" class="tdUnderLine"> 
						#dateformat(datecreated,"mm/dd/yyyy")# #timeformat(datecreated,"hh:mm tt")#
					</td>
				</tr>
			</CFLOOP>
			<tr>
				<td colspan="3">
					<input type="Button" name="btnAdd" value="Add Form" onclick="location.href='formsAdd.cfm?group_id=2';">
				</td>
				<td style="text-align:right;">
					<input type="Button" name="btnSeq" value="Update Sequence" onclick="location.href='formsSequence.cfm?group_id=2';">
				</td>
			</tr>
		</table>
		<div style="clear:both;"></div>
	</div>
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="3">
	</cfinvoke>
	<h2>Referee Links</h2>
	<div>
		<table cellspacing="0" cellpadding="0" align="left" border="0" width="98%" style="margin-bottom:15px;">
			<tr class="tblHeading">
				<td> Action	 </td>
				<td> Name	 </td>
				<td> Type	 </td>
				<td> Active	 </td>
				<td> Created </td>
			</tr>
		
			<CFLOOP query="forms">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">
						<a href="formsEdit.cfm?form_id=#form_id#">Edit</a> | <a href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this file?');">Del</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<a href="formsDetails.cfm?form_id=#form_id#">#name#</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif formType EQ 1>Form<cfelse>Link</cfif>
					</td>
					<td valign="top" align="left" class="tdUnderLine"> 
						<cfif active_flag EQ "1">
							<span class="green"><b>ACTIVE</b></span>
						<cfelse>
							<span class="red"><b>NOT Active</b></span>
						</cfif>
					</td>
					<td valign="top" class="tdUnderLine"> 
						#dateformat(datecreated,"mm/dd/yyyy")# #timeformat(datecreated,"hh:mm tt")#
					</td>
				</tr>
			</CFLOOP>
			<tr>
				<td colspan="3">
					<input type="Button" name="btnAdd" value="Add Form" onclick="location.href='formsAdd.cfm?group_id=3';">
				</td>
				<td style="text-align:right;">
					<input type="Button" name="btnSeq" value="Update Sequence" onclick="location.href='formsSequence.cfm?group_id=3';">
				</td>
			</tr>
		</table>
		<div style="clear:both;"></div>
	</div>
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="4">
	</cfinvoke>
	<h2>External Links</h2>
	<div>
		<table cellspacing="0" cellpadding="0" align="left" border="0" width="98%" style="margin-bottom:15px;">
			<tr class="tblHeading">
				<td> Action	 </td>
				<td> Name	 </td>
				<td> Type	 </td>
				<td> Active	 </td>
				<td> Created </td>
			</tr>
		
			<CFLOOP query="forms">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">
						<a href="formsEdit.cfm?form_id=#form_id#">Edit</a> | <a href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this file?');">Del</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<a href="formsDetails.cfm?form_id=#form_id#">#name#</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif formType EQ 1>Form<cfelse>Link</cfif>
					</td>
					<td valign="top" align="left" class="tdUnderLine"> 
						<cfif active_flag EQ "1">
							<span class="green"><b>ACTIVE</b></span>
						<cfelse>
							<span class="red"><b>NOT Active</b></span>
						</cfif>
					</td>
					<td valign="top" class="tdUnderLine"> 
						#dateformat(datecreated,"mm/dd/yyyy")# #timeformat(datecreated,"hh:mm tt")#
					</td>
				</tr>
			</CFLOOP>
			<tr>
				<td colspan="3">
					<input type="Button" name="btnAdd" value="Add Form" onclick="location.href='formsAdd.cfm?group_id=4';">
				</td>
				<td style="text-align:right;">
					<input type="Button" name="btnSeq" value="Update Sequence" onclick="location.href='formsSequence.cfm?group_id=4';">
				</td>
			</tr>
		</table>
		<div style="clear:both;"></div>
	</div>


	
	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="5">
	</cfinvoke>
	<h2>Club Documents</h2>
	<div>
		<table cellspacing="0" cellpadding="0" align="left" border="0" width="98%" style="margin-bottom:15px;">
			<tr class="tblHeading">
				<td> Action	 </td>
				<td> Name	 </td>
				<td> Type	 </td>
				<td> Active	 </td>
				<td> Created </td>
			</tr>
		
			<CFLOOP query="forms">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">
						<a href="formsEdit.cfm?form_id=#form_id#">Edit</a> | <a href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this file?');">Del</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<a href="formsDetails.cfm?form_id=#form_id#">#name#</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif formType EQ 1>Form<cfelse>Link</cfif>
					</td>
					<td valign="top" align="left" class="tdUnderLine"> 
						<cfif active_flag EQ "1">
							<span class="green"><b>ACTIVE</b></span>
						<cfelse>
							<span class="red"><b>NOT Active</b></span>
						</cfif>
					</td>
					<td valign="top" class="tdUnderLine"> 
						#dateformat(datecreated,"mm/dd/yyyy")# #timeformat(datecreated,"hh:mm tt")#
					</td>
				</tr>
			</CFLOOP>
			<tr>
				<td colspan="3">
					<input type="Button" name="btnAdd" value="Add Form" onclick="location.href='formsAdd.cfm?group_id=5';">
				</td>
				<td style="text-align:right;">
					<input type="Button" name="btnSeq" value="Update Sequence" onclick="location.href='formsSequence.cfm?group_id=5';">
				</td>
			</tr>
		</table>
		<div style="clear:both;"></div>
	</div>
	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="6">
	</cfinvoke>
	<h2>Board Documents</h2>
	<div>
		<table cellspacing="0" cellpadding="0" align="left" border="0" width="98%" style="margin-bottom:15px;">
			<tr class="tblHeading">
				<td> Action	 </td>
				<td> Name	 </td>
				<td> Type	 </td>
				<td> Active	 </td>
				<td> Created </td>
			</tr>
		
			<CFLOOP query="forms">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td class="tdUnderLine">
						<a href="formsEdit.cfm?form_id=#form_id#">Edit</a> | <a href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this file?');">Del</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<a href="formsDetails.cfm?form_id=#form_id#">#name#</a>
					</td>
					<td valign="top" class="tdUnderLine"> 
						<cfif formType EQ 1>Form<cfelse>Link</cfif>
					</td>
					<td valign="top" align="left" class="tdUnderLine"> 
						<cfif active_flag EQ "1">
							<span class="green"><b>ACTIVE</b></span>
						<cfelse>
							<span class="red"><b>NOT Active</b></span>
						</cfif>
					</td>
					<td valign="top" class="tdUnderLine"> 
						#dateformat(datecreated,"mm/dd/yyyy")# #timeformat(datecreated,"hh:mm tt")#
					</td>
				</tr>
			</CFLOOP>
			<tr>
				<td colspan="3">
					<input type="Button" name="btnAdd" value="Add Form" onclick="location.href='formsAdd.cfm?group_id=6';">
				</td>
				<td style="text-align:right;">
					<input type="Button" name="btnSeq" value="Update Sequence" onclick="location.href='formsSequence.cfm?group_id=6';">
				</td>
			</tr>
		</table>
		<div style="clear:both;"></div>
	</div>

</div>

</cfoutput>
<cfinclude template="_footer.cfm">