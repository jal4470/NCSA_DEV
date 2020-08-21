<!--- 
	FileName:	index.cfm
	Redesigned: 11/2/2016
  Author: A.Pinzone
	
MODS: mm/dd/yyyy - filastname - comments
10/12/2018 M Greenberg  (Ticket NCSA27076)
- added loop to allow more tiles
 --->

<CFSET mid = 0>
<cfinclude template="_header.cfm">
<cfoutput>

<cfset pageid = 1 >  <!--- HOME Page --->
<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
  	  FROM TBL_PAGE_SECTION
  	  WHERE pageID = #pageID#
</cfquery>

<section id="homepage_slideshow" class="slider">
	<div class="container">
		<ul class="slider_content bxslider">
			<li class="slider_item">
				<img src="assets/images/soccer_action.jpg">
				<!--- <span class="slider_title">Birth Year Mandate Information</span> --->
			</li>
			<li class="slider_item">
				<img src="assets/images/soccer_team.jpg">
				<!--- <span class="slider_title">Spring #DateFormat(now(), 'yyyy')# Flight Winners</span> --->
			</li>
		</ul>
		<span class="arrow_left slider_arrow"></span>
		<span class="arrow_right slider_arrow"></span>
	</div>
</section>

<section id="homepage_content" class="content_container">
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

<cfsavecontent variable="cf_footer_scripts">
	<script type="text/javascript">
		$(document).ready(function(){
		  $('.bxslider').bxSlider({
		    mode: 'fade',
		    auto: ($(".bxslider li").length > 1) ? true: false,
		    controls: ($(".bxslider li").length > 1) ? true: false,
		    pause: 4000,
		    speed: 1000,
		    pager: false,
		    nextSelector: '.arrow_right',
		    prevSelector: '.arrow_left',
		    nextText: '<i class="fa fa-chevron-right" aria-hidden="true"></i>',
		    prevText: '<i class="fa fa-chevron-left" aria-hidden="true"></i>'
		  });
		});
	</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">

 



 
