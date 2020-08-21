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
<cfinclude template="_header.cfm">
<style>
  div{
      margin: 5px;
  }
#address{
	color: #10069A;
	font-size: 1em;
	padding: 5px;
}
.full_address{
	text-align: center;
}
.addl_head{
	margin-bottom: 5px;
}
.addl_info{
	text-indent: 30px; 
	margin-bottom: 5px;
}
#address{
	line-height: 1.2em;
	color: #666;
    font-size: 1.15em;
    font-weight: 300;
    font-family: 'Roboto', Arial, sans-serif;
}

</style>

<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMems">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->

<cfoutput>
	
<div id="contentText">
		<H1 class="pageheading">	
			Board of Directors and Commissioners
		</H1>

		<div class="full_address">
			<span  id="address">League Office</span> <br />
			 <span  id="address">P.O. Box 26</span> <br />
			<span  id="address">Ho-Ho-Kus, NJ  07423</span>
		</div>
			<!---<br> Ph: (201)652-4222--->
	<h3 class="viewing_info_board">
		Click on the Board Member's Email address to send an email.</h3>
	<table id="board_contact" cellspacing="0" cellpadding="0">
		<thead class="no_mobile">
		<tr>
			<th class="title"> Title</th>
			<th class="name"> Name</th>
			<th class="email"> Email Address</th>
			<th class="phone"> Phone</th>
			<th class="fax"> Fax</th>
		</tr>
		</thead>

  	<!--- BOARDMEMBER_ID  	CITY  	CONTACTEMAIL  	CONTACTPHONECELL  	CONTACTPHONEFAX  	CONTACTPHONEHOME  	
CONTACTPHONEWORK  	CONTACT_ID  	  	  	NCSAEMAIL  	NCSAFAX  	  	  	  	
  	TITLE  	XREF_CONTACT_ROLE_ID  	
 --->
	<CFLOOP query="boardMems">
		<cfif ACTIVE_YN EQ "Y">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td class="title">
					#TITLE#
				</td>
				<td class="name">
					<span class="mobile_only">Name</span>
					#FIRSTNAME# #LASTNAME#
				</td>
				<td class="email">
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
				</td>
			</tr>
		</cfif>
	</CFLOOP>
</table>
<br><br>
<h1 style="text-decoration:underline;" class="addl_head">ADDITIONAL CONTACT INFORMATION</h1>
<p class="addl_info">
	If you are not sure who to contact, additional information can be found at the &quot;Contact Us&quot; page (the link is found in the footer of every NCSA page or go to <a href="http://www.ncsanj.com/contactUs.cfm">http://www.ncsanj.com/contactUs.cfm</a>). That page contains a list of topics/areas of interest and the appropriate person(s) to contact. Included on that list also are all standing NCSA Committees on topics such as New Club Applications, Games Conduct and IT.
</p>
<p class="addl_info">
	If you are still not sure who to contact, please email the Administrative Assistant, who will forward your inquiry to the correct person(s).
</p>
</div>
</cfoutput>
<cfinclude template="_footer.cfm">