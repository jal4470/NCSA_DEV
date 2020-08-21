<!--- 
	FileName:	mission.cfm
	Created on: 08/06/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: displays NCSA mission statement
	
MODS: mm/dd/yyyy - flastname - comments
7/31/2018 M Greenberg (Ticket NCSA27075) - updated to be responsive 

 --->
<CFSET mid = 5>
<cfinclude template="_header.cfm">

<cfset pageid = 10 >  <!--- pres message Page --->
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

<div id="contentText">

<H1 class="pageheading"><cfoutput>#qSection1.sectionName#</cfoutput></H1>

<table border="0" cellpadding="" cellspacing="0" width="100%">
	<tr><td valign="top">
			<div align="center">
				<table border="1" cellpadding="10" cellspacing="0" height="700" bordercolor="#000000">
					<tr><td valign="top">
							<cfoutput>#qSection1.sectionValue#</cfoutput>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</div>
<cfinclude template="_footer.cfm">