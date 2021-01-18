<!--- 
	FileName:	rptContactInfo.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfif isdefined("form.active_yn")>
	<cfset active_yn = form.active_yn>
<cfelse>
	<cfset active_yn = 'Y'>
</cfif>


<cfoutput>
<div id="contentText">


<H1 class="pageheading">NCSA - Contact Info</H1>
<!--- <br><h2>yyyyyy </h2> 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">--->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getALLContacts" returnvariable="clubContactsALL">
</cfinvoke>
	
<cfquery name="AllContacts" dbtype="query">
		SELECT *
		  FROM clubContactsALL
		 WHERE LASTNAME IS NOT NULL
		 <cfif len(trim(active_yn))>
			 and active_yn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#active_yn#">
		 </cfif>
		 ORDER BY LASTNAME, FIRSTNAME
</cfquery>
<FORM name="Contacts" action="#cgi.script_name#"  method="post">
<table>
	<tr><td colspan="4"><b>Active</b>

				<SELECT name="active_yn"> 
					<OPTION value="" >Select All</OPTION>
					<OPTION value="Y" <cfif active_yn EQ 'Y' >selected</cfif> >Y</OPTION>
					<OPTION value="N" <cfif active_yn EQ 'N' >selected</cfif> >N</OPTION>
				</SELECT>
			<input type="SUBMIT" name="Go"  value="Go" >  
	
		</td>
	</tr>
</table>
</FORM>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="30%">Name / Address</TD>
		<TD width="30%" align="left">Email / Phone numbers</TD>
		<TD width="30%" align="center">Club </TD>
		<TD  width="10%" align="left">Active</TD>
	</tr>

<!--- 	<cfset emaillist = "">	 --->
	<tr>
		<td colspan="4">
			<div style="overflow:auto;height:400px;border:1px ##cccccc solid;">
				<table cellspacing="0" cellpadding="1" align="center" border="0" width="100%">
				<CFLOOP query="AllContacts">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
						<TD width="30%"  valign="top" > 
							#LastName#, #FirstNAme# 
						</TD>
						<TD width="30%" align="left"> <a href="mailto:#email#">#email#</a></TD>
						<TD width="30%" align="right"> #CLUB_NAME#</TD>
						<TD width="10%" align="center">#ACTIVE_YN#</TD>
					</tr>
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
						<TD class="tdUnderLine" valign="top" > 
							    #repeatString("&nbsp;",5)# #address# 
							<br>#repeatString("&nbsp;",5)# #city#, #state# #zipcode#
						</TD>
						<TD class="tdUnderLine" align="left">
							(h)<cfif len(trim(phoneHome))>  #phoneHome#</cfif> &nbsp;
							 <br> (c)<cfif len(trim(phoneCell))> #phoneCell#</cfif> &nbsp;
						</TD>
						<TD class="tdUnderLine" align="left">
							(w)<cfif len(trim(phoneWork))>  #phoneWork#</cfif> &nbsp;
							<br>(f)<cfif len(trim(phoneFax))>   #phoneFax# </cfif> &nbsp;
						</TD>
					</tr>
					<!--- <cfset emailList = emailList & email & "; " >  --->
				</CFLOOP>
				</table>
			</div>
		</td>
	</tr>
</table>
<!--- <br> All emails: start[
<br>
<br> #emailList# 
<br>
<br> ]end	 --->


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
