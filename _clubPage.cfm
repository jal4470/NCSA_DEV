<!--- 
	FileName:	_clubPage.cfm
	Created on: 
	Created by: 
	
	Purpose: This page is called by the login page, the normal HEADER and FOOTER are not required here.
	
MODS: mm/dd/yyyy - filastname - comments
08/14/2017 - A.Pinzone - NCSA27024 
-- Fixed broken image.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfoutput>
 
	<cfset pageid = 6 >  <!--- CLUB's Page --->
	<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
		SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
	  	  FROM TBL_PAGE_SECTION
		 WHERE pageID = #pageid#
	</cfquery>


<!--- <cfinclude template="_pagecontent.css"> --->
<!--- ======================================================================== --->

<!--- Need a Slideshow Plugin, this is just a hard coded sample --->
<section id="clubs_slideshow" class="slider">
	<div class="container">
		<ul class="slider_content">
			<li class="slider_item">
				<img src="assets/images/soccer_team.jpg">
				<span class="slider_title"><a href="">Welcome to The Club House</a></span>
			</li>
		</ul>
<!--- 		<span class="arrow_left slider_arrow"><i class="fa fa-chevron-left" aria-hidden="true"></i></span>
		<span class="arrow_right slider_arrow"><i class="fa fa-chevron-right" aria-hidden="true"></i></span> --->
	</div>
</section>

<section id="board_members_content" class="content_container">
	<cfdump var="#qHomePageSections.sectionID#">
	<cfloop query="qHomePageSections">

	<cfquery name="PageImage" datasource="#SESSION.DSN#">
      SELECT image_id, image_desc, image_path
          FROM tlkp_page_section_image
       WHERE image_id = <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#qHomePageSections.image_id#">
    </cfquery>

		<article class="article">
			<div class="container">
				<header class="article_header"><h2>#sectionName#</h2></header>
				<!--- NEED LOGIC AROUND PICTURE - IF DOESN'T HAVE A PICTURE, ADD A NO-PIC CLASS TO PARENT FOR SIZING PURPOSES --->
				<div class="article_content">
					<aside class="article_image"><img src="#pageImage.image_path#" alt="#pageImage.image_desc#"></aside>
					<section class="article_text">#sectionValue#</section>
				</div>
				<footer class="read_more">Read More</footer>
			</div>
		</article>
	</cfloop>
</section>
	
<!--  holds everthing in the page -->
<!---
<div id="wrapper">
	<!-- This div holds evething on the right  -->
	<div id="leftContainer">

		<div class="club-image"></div>
  
 		<!--  this holds the image of a man kicking a ball --> 
  
		<div class="two-imageContainer">
			<!-- left small image -->
			<div class="small-img-container">
				<img src="assets/images/club_left.jpg" class="small-image-outline" alt="" width="175" height="100"><br>
				<div class="small-title">#qSection1.sectionName#</div>
				<div class="short-text"> #left(qSection1.sectionValue, 150)#<cfif len(trim(qSection1.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=1">... more</a></cfif></div>
			</div>
			<!-- right small image -->
			<div class="small-img-container">
				<img src="assets/images/club_right.jpg" class="small-image-outline" alt="" width="175" height="100"><br>
				<div class="small-title">#qSection2.sectionName#</div>
				<div class="short-text"> #left(qSection2.sectionValue, 150)#<cfif len(trim(qSection2.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=2">... more</a></cfif></div>
			</div>
			<br class="clearboth">
		</div><!-- END OF two-imageContainer -->   

		<div class="informationtext"><!---  Infortmation for tactic, tournaments, instruction and updates --->
		</div>
	</div><!-- end of left container -->  

	<!--  holds evething on the right  -->
	<div id="rightContainer">
		<!--smaller title image-->
		<div class="club-title"></div>
		<div class="bluebox">
			<div  class="box-titles">#qSection3.sectionName#</div>
		  	<div class="box-text">#left(qSection3.sectionValue, 150)#<cfif len(trim(qSection3.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=3">... more</a></cfif></div>
		 </div>
		<div class="whitebox2">
			<div  class="box-titles">#qSection4.sectionName#</div>
			<div class="box-text">#left(qSection4.sectionValue, 150)#<cfif len(trim(qSection4.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=4">... more</a></cfif></div>
		</div>
		<div class="bluebox">
			<div  class="box-titles">#qSection5.sectionName#</div>
			<div class="box-text">#left(qSection5.sectionValue, 150)#<cfif len(trim(qSection5.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=5">... more</a></cfif></div>
		</div>
		<!--- <div class="whitebox2">
		  <div  class="box-titles">the great game</div>
		    <div class="box-text">
		      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pelle sque aliquam lobortis tortor. Lorem ipsum dolor sit amet, con etur adipiscing elit. Ut mollis sapien vel sapien.    </div>
		 </div>
		 
		<div class="bluebox">
		  <div  class="box-titles">the great game</div>
		  	<div class="box-text">
		  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pelle sque aliquam lobortis tortor. Lorem ipsum dolor sit amet, con etur adipiscing elit. Ut mollis sapien vel sapien.  	</div>
		 </div> --->
	</div><!-- end of right container -->
	<div id="footer">
		<p><!--footer--></p>
	</div>
<!--  end of wrapper which holds everything on the page --> 
</div>

<!--- ======================================================================== --->

</div><!--- END div id="contentText" --->
--->
</cfoutput>

<!--- <cfinclude template="_footer.cfm"> --->
