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
		 ORDER BY LASTNAME, FIRSTNAME
</cfquery>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="30%">Name / Address</TD>
		<TD width="30%" align="left">Email / Phone numbers</TD>
		<TD width="40%" align="center">Club </TD>
	</tr>
</table>
	<cfset emaillist = "">	

<div style="overflow:auto;height:400px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="1" align="center" border="0" width="97%">
	<CFLOOP query="AllContacts">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
			<TD width="30%"  valign="top" > 
				#LastName#, #FirstNAme# 
			</TD>
			<TD width="30%" align="left"> <a href="mailto:#email#">#email#</a></TD>
			<TD width="40%" align="right"> #CLUB_NAME#</TD>
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
<!--- <br> All emails: start[
<br>
<br> #emailList# 
<br>
<br> ]end	 --->


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
