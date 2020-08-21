<!--- 
	FileName:	playersPage.cfm
	Redesigned: 11/2/2016
  Author: A.Pinzone
	
MODS: mm/dd/yyyy - filastname - comments
8/30/2018 M Greenberg (Ticket NCSA27076)
- updated content style so "read more" button shows.
10/12/2018 M Greenberg  (Ticket NCSA27076)
- added loop to allow more tiles

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">
			<cfset pageid = 3 >  <!--- PLAYER's Page --->
			<cfquery name="qHomePageSections" datasource="#SESSION.DSN#">
				SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
			  	  FROM TBL_PAGE_SECTION
				 WHERE pageID =  #pageID#
			</cfquery>
<!--- <cfinclude template="_pagecontent.css"> --->
<!--- ======================================================================== --->
<section id="coaches_slideshow" class="slider">
  <div class="container">
    <ul class="slider_content bxslider">
      <li class="slider_item">
        <img src="assets/images/soccer_action.jpg">
        <span class="slider_title">Welcome to the Player Sideline!</span>
      </li>
    </ul>
  </div>
</section>

<section id="players_content" class="content_container">
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
