<!--- 
	FileName:	gamesConduct.cfm
	Created on: 12/02/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 4> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfoutput>
<div id="contentText">
<!--<H1 class="pageheading">NCSA - Games Conduct</H1>-->
<!--- <h2>under construction </h2> --->

			<cfset pageid = 7 >  <!--- GAMES CONDUCT's Page --->
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
			
<cfinclude template="_pagecontent.css">
<!--- ======================================================================== --->

<!--  holds everthing in the page -->
<div id="wrapper">
	<!-- This div holds evething on the right  -->
	<div id="leftContainer">
		<div class="conducts-image">
		</div>
	</div><!-- end of left container -->  
	
	<!--  holds evething on the right  -->
	<div id="rightContainer">
		<!--smaller title image-->
		<div class="conducts-title">
		</div>
		<cfif len(trim(qSection1.sectionValue))>
			<div class="conducts">
				<div  class="box-titles">
					#qSection1.sectionName#
				</div>
				<div class="box-text">
					#left(qSection1.sectionValue, 450)#<cfif len(trim(qSection1.sectionValue)) GT 450><a href="readMore.cfm?p=#pageid#&s=1">... more</a></cfif> 
				</div>
			</div>
		</cfif>
	</div><!-- end of right container -->
	<div id="conduct-long-box">
		<div class="box-titles">
			#qSection2.sectionName#
		</div>
  		<div class="box-text">
			#left(qSection2.sectionValue, 4000)#<cfif len(trim(qSection2.sectionValue)) GT 4000><a href="readMore.cfm?p=#pageid#&s=2">... more</a></cfif> 
		</div>
	</div>
	<div id="footer">
		<p><!--footer--></p>
	</div>
 <!--  end of wrapper which holds everything on the page --> 
</div>

<!--- ======================================================================== --->

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
