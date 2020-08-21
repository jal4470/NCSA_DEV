<!--- 
	FileName:	readMore.cfm
	Created on: 12/08/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfoutput>
<div id="contentText">
<!--- ---------------------- --->
<cfif isdefined("URL.p") and isNumeric(URL.p)>
	<cfset pageID = URL.p>
<cfelse>
	<cflocation url="index.cfm">
</cfif>

<cfif isdefined("URL.s") and isNumeric(URL.s)>
	<cfset pageOrder = URL.s>
<cfelse>
	<cflocation url="index.cfm">
</cfif>

<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT s.sectionID, s.pageID, s.pageOrder, s.sectionName, s.sectionValue, p.Pagename
  	  FROM TBL_PAGE_SECTION s INNER JOIN TBL_PAGE p ON p.pageID = s.pageID
	 WHERE s.pageID = #pageID#
	 AND s.pageOrder = #pageOrder#
</cfquery>

<H1 class="pageheading">NCSA - #qHomePageSections.Pagename#</H1>
<!--- <H2> #qHomePageSections.sectionName#</H1> --->

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr><TD align="right" >
			<cfswitch expression="#VARIABLES.pageID#">
				<cfcase value="1"> <a href="index.cfm">      Back </a> </cfcase>
				<cfcase value="2"> <a href="coachesPage.cfm">Back </a> </cfcase>
				<cfcase value="3"> <a href="playersPage.cfm">Back </a> </cfcase>
				<cfcase value="4"> <a href="parentsPage.cfm">Back </a> </cfcase>
				<cfcase value="5"> <a href="loginhome.cfm">  Back </a> </cfcase>
				<cfcase value="6"> <a href="loginhome.cfm">  Back </a> </cfcase>
				<cfcase value="7"> <a href="gamesConduct.cfm">  Back </a> </cfcase>
			</cfswitch>
			
		</TD> 		
	</tr>
	<tr class="tblHeading"> <TD>&nbsp; #qHomePageSections.sectionName#</TD> </tr>
</table>	
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="90%">
		<tr class="readMoreText">
			<TD align="justify" > 
				#qHomePageSections.sectionValue#		
			</TD> 		
		</tr>
	</table>	



 
<!--- ---------------------- --->
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
