<!--- 
	FileName:	_boardMemPage.cfm
	Redesigned: 11/2/2016
  Author: A.Pinzone
	
MODS: mm/dd/yyyy - filastname - comments
10/12/2018 M Greenberg  (Ticket NCSA27076)
- added loop to allow more tiles
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfoutput>

<cfset pageid = 8 >  <!--- Board member's Page --->
<cfquery name="qHomePageSections" datasource="#SESSION.DSN#" >
	SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
  	  FROM TBL_PAGE_SECTION	 WHERE pageID = #pageid#
</cfquery>


<section id="board_slideshow" class="slider">
  <div class="container">
    <ul class="slider_content bxslider">
      <li class="slider_item">
        <img src="assets/images/soccer_ball_on_field.jpg">
        <span class="slider_title">Welcome Board Members</span>
      </li>
    </ul>
<!---     <span class="arrow_left slider_arrow"></span>
    <span class="arrow_right slider_arrow"></span> --->
  </div>
</section>

<section id="board_members_content" class="content_container">
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

</cfoutput>




 
