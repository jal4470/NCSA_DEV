<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
5/27/2010 B. Cooper
8005 - added faq to page content editor

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">


<cfset pageid = 12 >  <!--- FAQ Page --->
<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue
  	  FROM TBL_PAGE_SECTION
	 WHERE pageID = #pageid#
</cfquery>
<cfquery name="qSection1" dbtype="query">
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue
  	  FROM qHomePageSections
	 WHERE pageID = #pageid#
	   AND pageOrder = 1
</cfquery>


<cfoutput>
<div id="contentText">

<H1 class="pageheading">#qsection1.sectionname#</H1>
<br>

#qsection1.sectionvalue#


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
