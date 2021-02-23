<!--- 
	FileName:	boardContacts.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to list out all the board member's contact info
	
MODS: mm/dd/yyyy - flastname - comments
7-29-2014	-	J. Danz	-	(TICKET NCSA15487) - added "ADDITONAL CONTACT INFORMATION" section below the table. added 10px to the bottom margin of the table to create some space, added width 100% in order to fix an issue with the new text.
7/30/2018 M Greenberg (Ticket NCSA27075) - updated style of page to include new style

A Silverstein 8/28/18 (Ticket 27075)
-Moved header inside of contentText div
-Added new style to address id 
-Added line height of 1.2em to the address id.

 --->
<CFSET mid = 1>


<CFIF isDefined("FORM.board_category_id")>
	<cfset board_category_id = FORM.board_category_id>
<CFELSE>
	<cfset board_category_id = 0>
</CFIF>
<cfquery name="getBMCategory" datasource="#application.dsn#">
	Select board_category_id,
			parent_board_category_id,
			board_category_desc 
	from 
			tlkp_board_category where status_id = 1
</cfquery>

<cfinclude template="_header.cfm">
<cfsavecontent variable="localStyle">
	<link href="css/boardContacts.css" rel="stylesheet" /> 
</cfsavecontent>
<cfhtmlhead text="#localStyle#">


<cfoutput>
<div id="contentText">
	<H1 class="pageheading">	
		Board of Directors and League Contacts
	</H1>
	<div class="full_address">
		<span  id="address">League Office</span> <br />
		<span  id="address">P.O. Box 26</span> <br />
		<span  id="address">Ho-Ho-Kus, NJ  07423</span>
	</div>
	<div>
		<p>
			NCSA is an IRS approved 501c3 not-for-profit corporation organized under the laws of New Jersey.  NCSA is sanctioned by US Club Soccer, a national affiliate of the USSF.
		</p>
		<p>
			NCSA is administered by a volunteer board of directors with assistance from one paid employee.  You can locate the name and position of the person you are trying to reach by selecting from these categories: OFFICERS/ADMINISRATIVE, OPERATIONS, and COMMISSIONERS.  Officers and Administrative includes President, Vice-Presidents, Secretary, Treasurer, Past President and our Administrative Assistant.  Operations includes Games Chairs, Cup Chair, Games Conduct, Rules Chair, Referee Assignors, Referee Compliance, Referee Development and Webmaster.  Commissioners are the main contact for coaches and are divided by gender and age group; they handle flighting of teams, monitor scores and assist coaches with almost any issue. 
		</p>
	</div>

	<div class="board-category">
		<FORM action="#cgi.script_name#" method="post">
			<div class="select_box">
				<select id="board_category_id" name="board_category_id">
					<option value="0">Select One</option>
					<CFLOOP query="getBMCategory">
						<option value="#board_category_id#" <cfif variables.board_category_id EQ board_category_id> selected</cfif> >#board_category_desc#</option>
					</CFLOOP>
				</select> 
			</div>
			<button type="submit" name="getTeams" class="gray_btn no_mobile">Enter</button>
		</FORM>
	</div>

	<CFIF VARIABLES.board_category_id GT 0>

		<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMems">
			<cfinvokeargument name="DSN" value="#SESSION.DSN#">
			<cfinvokeargument name="board_category_id" value="#variables.board_category_id#">
		</cfinvoke> <!--- <cfdump var="#boardMems#">  --->


			

					<!---<br> Ph: (201)652-4222--->
			<h3 class="viewing_info_board">
				Click on name for contact info.</h3>
			<table id="board_contact" cellspacing="0" cellpadding="0" class="no_mobile">
				<thead class="no_mobile">
				<tr>
					<th class="title"> Title</th>
					<th class="responsibility">Area of Responsibility</th>
					<th class="name"> Name Of League Contact</th>
<!--- 					<th class="email"> Email Address</th> 
					<th class="phone"> Phone</th>
					<th class="fax"> Fax</th>--->
				</tr>
				</thead>

			<!--- BOARDMEMBER_ID  	CITY  	CONTACTEMAIL  	CONTACTPHONECELL  	CONTACTPHONEFAX  	CONTACTPHONEHOME  	
		CONTACTPHONEWORK  	CONTACT_ID  	  	  	NCSAEMAIL  	NCSAFAX  	  	  	  	
			TITLE  	XREF_CONTACT_ROLE_ID  	
		--->
			<CFLOOP query="boardMems">
				<cfif ACTIVE_YN EQ "Y">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
						<td class="title responsibility">
<!--- 							<span class="mobile_only">Name</span> --->
							#TITLE#
						</td>
						
						<td class="name">
						<span class="mobile_only">Area of Responsibility</span> <!--- 	--->
							<p><div class="ow">#trim(RESPONSIBILITY_DESC)#</div></p>
						</td>
						
						<td class="coach_column">
							<span class="mobile_only">Name</span> <!--- --->
							
							
							<div class="more_link2">
							<a href="##" class="more_link2">#FIRSTNAME# #LASTNAME#</a>
								<cfif contact_id neq 0>
									<div class="more_info2">
										<div class="close">X</div>
										<div class="container">
											<h2>#FIRSTNAME# #LASTNAME#</a></h2>
											<ul class="more_info_list">	
												<li><span>Email:</span> <a href="mailto: #contactEmail#">#contactEmail#</li>
												<li><span>Cell Phone:</span> #contactPhoneCell#</li>
												<li><span>Home Phone:</span> #contactPhoneHome#</li>
											</ul>
										</div>
									</div>
								</cfif>
							</div>

						</td>

						<!---<td class="email">
							<span class="mobile_only">Email</span>
							<a href="mailto:#NCSAEMAIL#"> #NCSAEMAIL# </a>
						</td>
 						<td class="phone"> 
							<span class="mobile_only">Phone</span>
							#NCSAPHONE#
						</td>
						<td class="fax">
							<span class="mobile_only">Fax</span>
							#NCSAFAX#
						</td>--->
					</tr>
				</cfif>
			</CFLOOP>
		</table>
		<CFLOOP query="boardMems">

			<div class="card">
			<div class="mobile_only title responsibility" >#TITLE#</div>
			<div class="mobile_only">Area of Responsibility</div>
			<p><div class="ow">#trim(RESPONSIBILITY_DESC)#</div></p>
			<div class="mobile_only">Name</div>
			<div class="more_link2">
				<a href="##" class="more_link2">#FIRSTNAME# #LASTNAME#</a>
				<cfif contact_id neq 0>
					<div class="more_info2">
						<div class="close">X</div>
						<div class="container">
							<h2>#FIRSTNAME# #LASTNAME#</a></h2>
							<ul class="more_info_list">	
								<li><span>Email:</span> <a href="mailto: #contactEmail#">#contactEmail#</a></li>
								<li><span>Cell Phone:</span> #contactPhoneCell#</li>
								<li><span>Home Phone:</span> #contactPhoneHome#</li>
							</ul>
						</div>
					</div>
				</cfif>
			</div>
			</div>
		</CFLOOP>

	</CFIF>

	<div class="additional-info">
		<h1 style="text-decoration:underline;" class="addl_head">ADDITIONAL CONTACT INFORMATION</h1>
		<p class="addl_info">
			If you are not sure who to contact, additional information can be found at the &quot;Contact Us&quot; page (the link is found in the footer of every NCSA page or go to <a href="http://www.ncsanj.com/contactUs.cfm">http://www.ncsanj.com/contactUs.cfm</a>). That page contains a list of topics/areas of interest and the appropriate person(s) to contact. Included on that list also are all standing NCSA Committees on topics such as New Club Applications, Games Conduct and IT.
		</p>
		<p class="addl_info">
			If you are still not sure who to contact, please email the Administrative Assistant, who will forward your inquiry to the correct person(s).
		</p>
	</div>
</div>		
</cfoutput>



<cfsavecontent variable="cf_footer_scripts">

	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>
	<script>
		$(function() {
				// Initialize select2
				$('.more_link2').click(function(e){
					e.preventDefault();
					
					_target = $(this).next(".more_info2");
					
					_target.fadeIn(1000).addClass('active');
					
				});

				$('#board_category_id').change(function() {
					this.form.submit();
				});
				
				$('.close').click(function(){
					$(".more_info2").fadeOut(1000).removeClass('active');
				});

				// $('.more_link2').mouseleave(function(e){
				// 	e.preventDefault();
				// 	_target = $(".more_info2");
				// 	//console.log(_target);

				// 	_target.fadeOut(1000).removeClass('active');

				// });  

		});
	</script>
</cfsavecontent>



<cfinclude template="_footer.cfm">