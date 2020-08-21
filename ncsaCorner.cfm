<!--- 
	FileName:	forumMain.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

A Silverstein 8/22/2018 (Ticket 27075)
- Moved pageHeading outside of contentText div tag
- Gave table #board_contact id.
- Added local styles for table
- changed table id to cornerTable
- Replaced table header
- Added availableForum and topics classes to table

A Silverstein 8/23/2018 (Ticket 27075)
- Moved pageHeading back inside of the the contentText div tag
- Added closing tbody tag and moved the tbody tags around the cfloop
- Added styles to make table lines dark gray and text smaller
- Deleted table underline
 --->
<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<style>
		/*dark gray styles*/
		tr {
	    border: 0;
	    border-radius: 0;
	    display: table-row;
	    float: none;
	    margin: 0;
	    padding: 0;
	    width: 100%; }
	    tr:after {
	      display: none; }
	  	tr:nth-child(odd) {
	      margin: 0; }
  		tr:nth-child(even) {
	      background: #E1E1E1; }
	     thead { 
    		display: table-header-group; }
	    th{
	    	background: transparent;
	    	background-color: #FFFFFF;
		    border-top: 1px solid #AEAEAE;
		    border-bottom: 1px solid #AEAEAE;
		    color: #333;
		    font-size: 11px;
		    padding: 15px 0;
		    text-transform: uppercase; }
	    td {
		    display: table-cell;
		    float: none;
		    font-size: 11px;
		    margin: 0;
		    padding: 10px 5px;
		    text-align: center;
		    width: auto;}
	    td {
	      display: table-cell; }
	      /*dark gray styles*/
	 #cornerTable {
	  table-layout: fixed;
	  width: 100%; }

	  #cornerTable th {
	  background: transparent;
		background-color: #FFFFFF;
	    border-top: 1px solid #AEAEAE;
	    border-bottom: 1px solid #AEAEAE;
	    color: #333;
	    font-size: 11px;
	    padding: 15px 0;
	    text-transform: uppercase;
	  }
	  #cornerTable td {
	    margin-bottom: 5px;
	    padding: 10px;
	    text-align: center;
	    width: 100%;
	     }


 	  #cornerTable th.availableForum{
      		width: 100%;
  		}

  	  #cornerTable th.topics{
      		width: 100%;
  		}

  		#cornerTable td.availableForum, 
  		td.topics{
      		width: 100%;
  		}

</style>

<cfoutput>


<div id="contentText">
	<H1 class="pageheading">Welcome to NCSA CORNER forum</H1>

<br>	<!---<h2>yyyyyy </h2> --->


<cfset categoryType = "PUBLIC">
<cfif isDefined("SESSION.MENUROLEID") AND SESSION.MENUROLEID GT 0>
	<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0 >
		<cfset categoryType = "CLUBS" >
	<cfelse> 
		<cfset categoryType = "ALL">
	</cfif>
</cfif>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#FORUM" method="getForumCounts" returnvariable="qForum" >
	<cfinvokeargument name="categoryType" value="#categoryType#"> 
</cfinvoke> <!--- <cfdump var="#qForum#"> --->

<table id="cornerTable" cellspacing="0"  cellpadding="0" border="0">

	<thead class="no_mobile">
		<tr>
			<th> Available Forum</th>
			<th> Topics</th>
		</tr>
	</thead>
		<CFLOOP query="qForum">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<td align="center" > <a href="ncsaCornerList.cfm?TID=#TopicID#"> #TopicDescription# </a></td>
				<td align="center" >(#topic_total# Topics)	</td>
			</tr>
		</CFLOOP>

</TABLE>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
