<!--- 
	FileName:	contactMerge.cfm
	Created on: 6/11/2009
	Created by: B. Cooper
	
	Purpose: (ADMIN USE) this will provide a way to search for and merge contacts
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

					<!--- <CFIF isDefined("SESSION.REGSEASON.ID")>
						<CFSET seasonID = SESSION.REGSEASON.ID >
						<CFSET seasonTxT = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
						<CFSET seasonSF = SESSION.REGSEASON.SF>
					<CFELSE>
						<CFSET seasonID = SESSION.CURRENTSEASON.ID >
						<CFSET seasonTxT = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
						<CFSET seasonSF = SESSION.CURRENTSEASON.SF>
					</CFIF> --->
					
<cfif isdefined("form.btnMerge")>
	<cfdump var=#form#>
	<cfif not isdefined("form.rdKeep") OR form.rdKeep EQ "">
		<cfthrow message="You must select a contact to keep">
	</cfif>
	<cfif not isdefined("form.chkdel") OR form.chkDel EQ "">
		<cfthrow message="You must select at least one contact to delete">
	</cfif>
	<cfinvoke
		component="#session.sitevars.cfcpath#contact"
		method="mergeContacts"
		keepContact="#form.rdKeep#"
		deleteContactList="#form.chkdel#"
		returnvariable="merged">
	
	<!--- go back to merge main screen --->
	<cflocation url="contactMerge.cfm?success=1" addtoken="No">
</cfif>
					
					
<!--- check for search string --->					
<cfif isdefined("form.btnSearch")>
	<cfset searchString=form.txtSearch>
	<cfset showFields=true>

	<!--- get fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="searchContacts" returnvariable="qContacts">
		<cfinvokeargument name="qry" value="#searchString#">
	</cfinvoke>
	
<cfelse>
	<cfset searchString="">
	<cfset showFields=false>
</cfif>


<cfoutput>
<div id="contentText">
<cfif isdefined("url.success") AND url.success EQ "1">
	<div class="success">
		Your contacts have been merged successfully
	</div>
</cfif>
<H1 class="pageheading">NCSA - Merge Contacts</H1>

	<form action="contactMerge.cfm" method="post">
		Search: <input type="text" name="txtSearch" value="#searchString#">
		<input type="Submit" name="btnSearch" value="Find Contacts">
		<br>
		<br> <hr size="1">
	
	
		<CFIF showFields>
		<!--- <cfdump var=#qFields#> --->
	
			#qContacts.recordcount# contact<cfif qContacts.recordcount NEQ 1>s</cfif> returned
			<table border="0" width="98%" cellpadding="2" cellspacing="0" class="table1">
				<tr>
					<th> Keep  </th>
					<th>Merge into contact marked keep</th>
					<th> Contact   </th>
					<th>Club</th>
				</tr>
				<CFIF qContacts.recordCount>
					<cfloop query="qContacts">
						<tr <cfif qContacts.currentRow mod 2 is 0>class="altRow"</cfif>>
							<td>
								<input type="Radio" name="rdKeep" value="#contact_id#">
							</td>
							<td>
								<input type="Checkbox" name="chkDel" value="#contact_id#">
							</td>
							<td>
								#lastname#, #firstname#
							</td>
							<td>#club_name#</td>
						</tr>
					</cfloop>
				<CFELSE>
					<tr>
						<td class="red" colspan="2"> 
							<b>Your search returned no contacts.</b> 
						</td> 
					</tr>
				</CFIF>	
			</table>
			<br>
			<input type="submit" name="btnMerge" value="Merge">
		</CFIF>
	
	</form>
</cfoutput>
</div>
<script language="JavaScript"  type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$("input[name=rdKeep]").click(function(){
			//enable all checkboxes
			$("input[name=chkDel]").removeAttr("disabled");
			
			$("input[name=chkDel]").attr('checked', false); // Checks it
			
			//disable this checkbox
			$(this).parent().next().find("input").attr("disabled", true);
			
			$("input[name=chkDel]:not(:checked)").parent().parent().css('background-color','');
			//fix checked rows
			$("input[name=chkDel]:checked").parent().parent().css('background-color','##ff5555');
			//$(this).parent().parent().siblings().css('background-color','');
			//highlight this row
			$(this).parent().parent().css('background-color','##FFFF55');
			
		});
		
		$("input[name=chkDel]").click(function(){
			//if selected, highlight, else not
			if($(this).is(":checked"))
			{
				$(this).parent().parent().css('background-color','##ff5555');
			}
			else
			{
				$(this).parent().parent().css('background-color','');
			}
		});
	});
</script>
<cfinclude template="_footer.cfm">
