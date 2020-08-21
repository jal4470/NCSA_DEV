<!--- 
	FileName:	coachespage.cfm
	Created on: 09/02/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: main coaches page - public
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfoutput>
<!--- <img src="#SESSION.sitevars.imagePath#ncsa-coaches.jpg" border="0" /> --->
<div id="contentText">


			<cfset pageid = 2 >  <!--- Coach's Page --->
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
			<cfquery name="qSection3" dbtype="query">
				SELECT sectionID, pageID, pageOrder, sectionName, sectionValue
			  	  FROM qHomePageSections
				 WHERE pageID = #pageid#
				   AND pageOrder = 3
			</cfquery>
			<cfquery name="qSection4" dbtype="query">
				SELECT sectionID, pageID, pageOrder, sectionName, sectionValue
			  	  FROM qHomePageSections
				 WHERE pageID = #pageid#
				   AND pageOrder = 4
			</cfquery>
			<cfquery name="qSection5" dbtype="query">
				SELECT sectionID, pageID, pageOrder, sectionName, sectionValue
			  	  FROM qHomePageSections
				 WHERE pageID = #pageid#
				   AND pageOrder = 5
			</cfquery>

<cfinclude template="_pagecontent.css">
<!--- ======================================================================== --->


<!--  holds everthing in the page -->
<div id="wrapper">
	<!-- This div holds evething on the right  -->
	<div id="leftContainer">
		<div class="board-image"></div>
  		<!--  this holds the image of a man kicking a ball --> 
		<div class="two-imageContainer">
			<!-- left small image -->
			<div class="small-img-container">
				<img src="assets/images/referee_right.jpg"  class="small-image-outline" alt="" width="175" height="100"><br>
				<div class="small-title">
					#qSection1.sectionName#
				</div>
				<div class="short-text"> 
					#left(qSection1.sectionValue, 150)#<cfif len(trim(qSection1.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=1">... more</a></cfif> 
				</div>
			</div>
			<!-- right small image -->
			<div class="small-img-container">
				<img src="assets/images/parents_left.jpg" class="small-image-outline" alt="" width="175" height="100"><br>
				<div class="small-title">
					#qSection2.sectionName#
				</div>
				<div class="short-text">
					#left(qSection2.sectionValue, 150)#<cfif len(trim(qSection2.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=2">... more</a></cfif> 
				</div>
			</div>
			<br class="clearboth">
		</div><!-- END OF two-imageContainer -->   

		<div class="informationtext"> <!--- Infortmation for tactic, tournaments, instruction and updates --->
		</div>
	</div><!-- end of left container -->  

	<!--  holds evething on the right  -->
	<div id="rightContainer">
		<!--smaller title image-->
		<div class="board-title"></div>
		<cfif len(trim(qSection3.sectionValue))>
			<div class="bluebox">
				<div  class="box-titles">#qSection3.sectionName#</div>
				<div class="box-text">
					#left(qSection3.sectionValue, 150)#<cfif len(trim(qSection3.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=3">... more</a></cfif> 
				</div>
			</div>
		</cfif>
		<cfif len(trim(qSection4.sectionValue))>
			<div class="whitebox2">
				<div  class="box-titles">#qSection4.sectionName#</div>
				<div class="box-text">
					#left(qSection4.sectionValue, 150)#<cfif len(trim(qSection4.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=4">... more</a></cfif> 
				</div>
			</div>
		</cfif>
		<cfif len(trim(qSection5.sectionValue))>
			<div class="bluebox">
				<div  class="box-titles">#qSection5.sectionName#</div>
				<div class="box-text">
					#left(qSection5.sectionValue, 150)#<cfif len(trim(qSection5.sectionValue)) GT 150><a href="readMore.cfm?p=#pageid#&s=5">... more</a></cfif> 
				</div>
			</div>
		</cfif>

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

		<!---<div class="whitebox2">--->
			<div  class="box-titles">Useful Links...<!--- the great game ---></div>
			<!--- <div class="box-text"> --->
			<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
				<tr><TD class="tdUnderLine">
						<ul>
                        	<li><a href="coachesList.cfm">Coaches List</a></li>
							<li><a href="fields.cfm">Field Directions (by Club)</a></li>
							<li><a href="fields.cfm?all=0">Field Directions (Alphabetically)</a></li>
							<li><a href="#SESSION.SITEVARS.DOCPATH#matchdayroster.doc">Match Roster</a> (.doc)</li>
							<li><a href="mailto:#VARIABLES.emailList#">Send EMail to President/Game Conduct Chairman</a>
							<li><a href="">Player Registration/District Commissioners</a></li>
							<li><a href="ageBracket.cfm">Age bracket for Play Group</a></li>
						</ul>
					</TD>
				</tr>
				<!--- <tr><td><hr></td></tr> --->
				<tr><td>Information For Tactic, Tournament, Instructions, Updates ...
						<ul>
                        	<li><A href="http://www.njyouthsoccer.com/travelntourn/tnt.htm">Travelling and Tournaments</A></li>
							<li><a href="http://www.njyouthsoccer.com/CoachingTechniques/CoachesCorner.htm">Coaches' Corner</a></li>
							<li><a href="http://www.BackOfTheNet.com">Local Soccer</a></li>
						</ul>
					</td>
				</tr>
			</table>	
			<!--- </div> --->
		<!---</div>--->
						
		<!--- 
		<div class="bluebox">
			<div  class="box-titles">the great game</div>
			<div class="box-text">
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pelle sque aliquam lobortis tortor. Lorem ipsum dolor sit amet, con etur adipiscing elit. Ut mollis sapien vel sapien.  	
			</div>
		</div> --->
		
	</div><!-- end of right container -->
		
	<div id="footer">
		<p><!--footer--></p>
	</div>
	<!--  end of wrapper which holds everything on the page --> 
</div>
<!--- ======================================================================== --->


</cfoutput>
</div>
<cfinclude template="_footer.cfm">




 