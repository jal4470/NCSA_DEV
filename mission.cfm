<!--- 
	FileName:	mission.cfm
	Created on: 08/06/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: displays NCSA mission statement
	
MODS: mm/dd/yyyy - flastname - comments
7/31/2018 M Greenberg (Ticket NCSA27075) - updated style of page to make responsive

 --->
<CFSET mid = 1>
<cfinclude template="_header.cfm">
<style>
	#mission{font-size:.9em;line-height: 1.25em;}
	div{ margin: 5px;}
	.statement{
		width: 100%;
		float: left;
		box-sizing: inherit;
   		border: 1px solid #000000;
		border-radius: 2px 10px;
   		padding: 8px;
   		margin: 8px;}
	.about{
		width: 100%;
		float: left;
		box-sizing: inherit;
		display: inline-block;
    	border: 1px solid #000000;
		border-radius: 2px 10px;
   		padding: 8px;
   		margin-top: 8px;}
   	@media screen and (min-width:1024px){
   		#mission{font-size:1em;line-height: 1.25em;}
		.about{
			width:49%;
			margin: 5px 0px;
			float: left;
			display: inline-block;}
		.statement{
			width: 49%;
			display: inline-block;}
	}
	.statement > ul,
	ol {
	  margin-top: 0;
	  margin-bottom: 0;
	  padding-left: 35px;
	}
	.statement > ul > li {
	  display: list-item;
	  list-style-type:disc;
	}
</style>

<cfset pageid = 9 >  <!--- about us Page --->
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
<cfquery name="qSection2" dbtype="query">
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue
  	  FROM qHomePageSections
	 WHERE pageID = #pageid#
	   AND pageOrder = 2
</cfquery>

<div id="contentText">
	<div id="mission">
		<cfoutput>
			<div class="about">
				<p align="center">
					<H1 class="pageheading" align="center">#qSection1.sectionName#</H1>
				</p>
				<div align="justify">
					#qSection1.sectionValue#
				 </div>
			</div> 
		</cfoutput>
		<cfoutput>
			<div class="statement">
				<p align="center">
					<H1 class="pageheading" align="center">#qSection2.sectionName#</H1>
				</p>
				#qSection2.sectionValue#
			</div>
		</cfoutput>
	</div>
</div>
<cfinclude template="_footer.cfm">