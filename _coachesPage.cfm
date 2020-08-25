<!--- 
	FileName:	_coachespage.cfm
	Created on: 2/21/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: main coaches page - public
	
MODS: mm/dd/yyyy - filastname - comments
10/12/2018 M Greenberg  (Ticket NCSA27076)
- added loop to allow more tiles
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfoutput>



<cfset pageid = 2 >  <!--- Coach's Page --->
<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, Image_id
  	  FROM TBL_PAGE_SECTION
	 WHERE pageID = #pageid#
</cfquery>

<section id="coaches_slideshow" class="slider">
	<div class="container">
		<ul class="slider_content bxslider">
			<li class="slider_item">
				<img src="assets/images/soccer_coach.jpg">
				<span class="slider_title">Welcome to Coaches Corner!</span>
			</li>
		</ul>
<!--- 		<span class="arrow_left slider_arrow"></span>
		<span class="arrow_right slider_arrow"></span> --->
	</div>
</section>

<section id="coaches_content" class="content_container">
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
	<!--- 	<cfif len(trim(qSection2.sectionValue))>
			<article class="article section_two">
				<div class="container">
					<header class="article_header"><h2>#qSection2.sectionName#</h2></header>
					<div class="article_content">
						<aside class="article_image"><img src="assets/images/soccer_ball_on_field.jpg" alt="#qSection2.sectionName#"></aside>
						<section class="article_text">#qSection2.sectionValue#</section>
					</div>
					<footer class="read_more">Read More</footer>
				</div>
			</article>
		</cfif>
		<cfif len(trim(qSection3.sectionValue))>
			<article class="article section_three">
				<div class="container">
					<header class="article_header"><h2>#qSection3.sectionName#</h2></header>
					<div class="article_content">
						<aside class="article_image"><img src="assets/images/soccer_referee.jpg" alt="#qSection3.sectionName#"></aside>
						<section class="article_text">#qSection3.sectionValue#</section>
					</div>
					<footer class="read_more">Read More</footer>
				</div>
			</article>
		</cfif>
		<cfif len(trim(qSection4.sectionValue))>
			<article class="article section_four">
				<div class="container">
					<header class="article_header"><h2>#qSection4.sectionName#</h2></header>
					<div class="article_content">
						<aside class="article_image"><img src="assets/images/soccer_cone_drills.jpg" alt="#qSection4.sectionName#"></aside>
						<section class="article_text">#qSection4.sectionValue#</section>
					</div>
					<footer class="read_more">Read More</footer>
				</div>
			</article>
		</cfif>
		<cfif len(trim(qSection5.sectionValue))>
			<article class="article section_five">
				<div class="container">
					<header class="article_header"><h2>#qSection5.sectionName#</h2></header>
					<div class="article_content">
						<aside class="article_image"><img src="assets/images/soccer_team.jpg" alt="#qSection5.sectionName#"></aside>
						<section class="article_text">#qSection5.sectionValue#</section>
					</div>
					<footer class="read_more">Read More</footer>
				</div>
			</article>
		</cfif> --->
		<cfset articleCount = articleCount + 1>
	</cfloop>
</section>


<!------------------------------------------------------------- 
Not sure what this is, if it's no longer needed let's delete it. 
-------------------------------------------------------------->
			<cfset presContactID = 0>
			<cfset GameCondContactID = 0>
			<cfinvoke component="#SESSION.SITEVARS.CFCPATH#CONTACT" method="getRoleContacts" returnvariable="qPresident">
				<cfinvokeargument name="roleID"   value="2" >
				<cfinvokeargument name="seasonID" value="#SESSION.CURRENTSEASON.ID#">
			</cfinvoke>	<!--- <cfdump var="#qPresident#"> --->
			<CFIF qPresident.recordCount>
				<cfset presContactID = qPresident.contact_id>
			<CFELSE>
				<cfif isDefined("SESSION.REGSEASON")>
					<cfinvoke component="#SESSION.SITEVARS.CFCPATH#CONTACT" method="getRoleContacts" returnvariable="qPresident">
						<cfinvokeargument name="roleID"   value="2" >
						<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
					</cfinvoke>	<!--- <cfdump var="#qPresident#"> --->
					<CFIF qPresident.recordCount>
						<cfset presContactID = qPresident.contact_id>
					</cfif>
				</CFIF>
			</CFIF>
			<cfinvoke component="#SESSION.SITEVARS.CFCPATH#CONTACT" method="getRoleContacts" returnvariable="qGameCondChair">
				<cfinvokeargument name="roleID"   value="20" >
				<cfinvokeargument name="seasonID" value="#SESSION.CURRENTSEASON.ID#">
			</cfinvoke>	<!--- <cfdump var="#qGameCondChair#"> --->
			<CFIF qGameCondChair.recordCount>
				<cfset GameCondContactID = qGameCondChair.contact_id>
			<CFELSE>
				<cfif isDefined("SESSION.REGSEASON")>
					<cfinvoke component="#SESSION.SITEVARS.CFCPATH#CONTACT" method="getRoleContacts" returnvariable="qGameCondChair">
						<cfinvokeargument name="roleID"   value="20" >
						<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
					</cfinvoke>	<!--- <cfdump var="#qGameCondChair#"> --->
					<CFIF qGameCondChair.recordCount>
						<cfset GameCondContactID = qGameCondChair.contact_id>
					</CFIF>
				</CFIF>
			</CFIF>
			<cfset emailList = "">
			<cfif presContactID GT 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qPresInfo">
					<cfinvokeargument name="contactID" value="#VARIABLES.presContactID#">
				</cfinvoke>
				<cfif qPresInfo.recordCount>
					<cfset emailList = qPresInfo.EMAIL>
				</cfif>
			</cfif>
			
			<CFIF GameCondContactID GT 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getContactInfo" returnvariable="qGameCondInfo">
					<cfinvokeargument name="contactID" value="#VARIABLES.GameCondContactID#">
				</cfinvoke> 
				<cfif qGameCondInfo.recordCount >
					<cfif len(trim(emailList)) GT 0>
						<CFSET emailList = emailList & ";">
					</cfif>
					<cfset emailList = emailList & qGameCondInfo.EMAIL>
				</cfif>
			</cfif>	

</cfoutput>




 