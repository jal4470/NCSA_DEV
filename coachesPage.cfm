<!--- 
	FileName:	coachesPage.cfm
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


<cfset pageid = 2 >  <!--- Coach's Page --->
<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
  	  FROM TBL_PAGE_SECTION
	 WHERE pageID = #pageid#
</cfquery>

<!--- <cfinclude template="_pagecontent.css"> --->
<!--- ======================================================================== --->

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

		<cfset articleCount = articleCount + 1>
	</cfloop>
</section>


<!------------------------------------------------------------- 
Not sure what this is, if it's no longer needed let's delete it. 
-------------------------------------------------------------->
			<!--- START get emails for pres & games cond chair --->
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
			<!--- END get emails for pres & games cond chair --->
<!--- ======================================================================== --->


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




 