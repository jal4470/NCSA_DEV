<!--- 
	FileName:	_refereePage.cfm
	Created on: 12/08/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: This page is called by the login page, the normal HEADER and FOOTER are not required here.
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfoutput>
 
<cfset pageid = 5 >  <!--- referee's Page --->
<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
  	  FROM TBL_PAGE_SECTION
	 WHERE pageID = #pageid#
</cfquery>

<!--- <cfinclude template="_pagecontent.css"> --->
<!--- ======================================================================== --->

<section id="referee_slideshow" class="slider">
	<div class="container">
		<ul class="slider_content bxslider">
			<li class="slider_item">
				<img src="assets/images/soccer_referee.jpg">
				<span class="slider_title">Welcome to Referee Corner</span>
			</li>
		</ul>
<!--- 		<span class="arrow_left slider_arrow"></span>
		<span class="arrow_right slider_arrow"></span> --->
	</div>
</section>

<section id="referee_content" class="content_container">
	<cfset articleCount = 1>
	<cfloop query="qHomePageSections">

      <cfquery name="PageImage" datasource="#SESSION.DSN#">
      SELECT image_id, image_desc, image_path
          FROM tlkp_page_section_image
       WHERE image_id = <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#qHomePageSections.image_id#">
    </cfquery>

	<cfif len(trim(qHomePageSections.sectionValue))>
		<article class="article section_#articleCount#">
			<div class="container">
				<header class="article_header"><h2>#qHomePageSections.sectionName#</h2></header>
				<div class="article_content">
				<aside class="article_image"><img src="#pageImage.image_path#" alt="#pageImage.image_desc#"></aside>
				<section class="article_text">#qHomePageSections.sectionValue#</section>
				</div>
				<footer class="read_more">Read More</footer>
			</div>
		</article>
	</cfif>

		<cfset articleCount = articleCount + 1>
	</cfloop>
</section>
</cfoutput>
