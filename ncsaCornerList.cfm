<!--- 
	FileName:	ncsaCornerList.cfm
	Created on: 11/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
A Silverstein 8/23/2018 (Ticket 27075)
	-Added cornerTable id to table
	-Added style tag with cornerTable styles
	-took warning message outside of the form and placed it underneath the h2 tag (Also placed the span inside of a div).
	-replaced table header with modern table header
	-Added margin to the top of the warningMessage
	-Added styles to make table lines dark gray and table text smaller
	-Deleted table underline
	-Added styling for the new Subject button and the back button
	-Gave submit buttons styling on hover
	-Added id headerStyle to h2 tag and added css
	-Got rid of hard widths on table headers to make page mobile responsive
 --->
 
<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA CORNER forum</H1>


<CFIF isDefined("FORM.BACK")>
	<cflocation url="ncsaCorner.cfm">
</CFIF>

<CFIF isDefined("URL.TID") AND isNumeric(URL.TID)>
	<cfset TopicID = URL.TID>
<CFELSEIF isDefined("FORM.TopicID")>
	<cfset TopicID = FORM.TopicID>
<CFELSE>
	<cfset TopicID = 0>
</CFIF>

<CFIF isDefined("FORM.NewThreadID")>
	<CFSET NewThreadID = FORM.NewThreadID>
<CFELSE> 
	<CFSET NewThreadID = "">
</CFIF>

<CFIF isDefined("FORM.ADD")>
	<!--- ADD SUBJECT --->
	<cflocation url="ncsaCornerPost.cfm?TID=#TopicID#&trid=0&M=A">	
</CFIF>

<cfset latestDate = dateFormat(now(),"mm/dd/yyyy")>
<cfquery name="qMaxPostDate" datasource="#SESSION.DSN#">
	Select max(postdate) as maxDate 
	  from TBL_Forum 
	 Where TopicId = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
</cfquery>

<cfif qMaxPostDate.RECORDCOUNT AND isDate(qMaxPostDate.maxDate)>
	<cfset latestDate = dateFormat(qMaxPostDate.maxDate,"mm/dd/yyyy")>
</cfif>
<cfset LatestDate = DateAdd("d", -1, LatestDate)>


<cfquery name="qTopicDesc" datasource="#SESSION.DSN#">
	Select TopicDescription 
	  from TBL_ForumTopics
	 Where TopicID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
	<cfif isDefined("SESSION.MENUROLEID") AND SESSION.MENUROLEID GT 0>
		<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0 >
			and Category = 'CLUBS'
		</cfif>
	<cfelse>
		 and Category = 'PUBLIC' 
	</cfif>
</cfquery>

<cfif qTopicDesc.recordCount>
	<cfset TopicDescription = qTopicDesc.TopicDescription>
<cfelse>
	<cfset TopicDescription = "">
</cfif>


<cfquery name="qThreads" datasource="#SESSION.DSN#">
	SELECT  B.ThreadID, B.RefThread, B.Subject, B.PostDate, B.PostTime, B.MainThread, B.PostedBy
	  from  TBL_Forum A INNER JOIN TBL_Forum B ON a.ThreadID = b.MainThread
	  where a.TopicID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
	   and a.refthread = 0			
	   and b.Released  = 'Y'		
	 order by A.PostDate Desc, A.PostTime Desc, B.PostDate, B.PostTime 
</cfquery>

<cfquery name="qTopThreads" dbtype="query">
	SELECT *
	  FROM qThreads 
	 where refthread = 0
</cfquery>

<style type="text/css">
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
	      background: ##E1E1E1; }
	     thead { 
    		display: table-header-group; }
	    th{
	    	background: transparent;
	    	background-color: ##FFFFFF;
		    border-top: 1px solid ##AEAEAE;
		    border-bottom: 1px solid ##AEAEAE;
		    color: ##333;
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
	  ##cornerTable {
	  table-layout: fixed;
	  width: 100%; }
	  /*dark gray styles*/
	 
	  ##cornerTable th {
	    background: transparent;
	    border-top: 1px solid ##AEAEAE;
	    border-bottom: 1px solid ##AEAEAE;
	    color: ##333;
	    font-size: 11px;
	    padding: 15px 0;
	    text-transform: uppercase;
	  }
	  ##cornerTable td {
	    margin-bottom: 5px;
	    padding: 10px;
	    text-align: center;
	    width: 100%;
	     }
	  ##headerStyle{
  			color:##334d55;
    		font-family: 'Roboto', Arial, sans-serif;
  		}

 	  ##cornerTable th.availableForum{
      		width: 100%;
  		}

  	  ##cornerTable th.topics{
      		width: 100%;
  		}

  		##cornerTable td.availableForum, 
  		td.topics{
      		width: 100%;
  		}

  		##warningContainer{
  			margin-bottom:10px;
  			margin-top:5px;
  		}

		##submitButton{
			margin-right: 5px;
			 margin-top:5px;
			 height:30px;
			 border-radius: 2px 10px;
			 background-color:##ddd;
			 color:##1a1a1a;
			 border: ##ccc 1px solid;
			 cursor: pointer;
		}

		##submitButton:hover {
      background-color: ##ccc; }

	</style>

<h2 id="headerStyle">#VARIABLES.TopicDescription#</h2>
<div id="warningContainer">
	<span class="red">Postings will be displayed after being reviewed for objectionable language</span>
</div>
<FORM name="MessageList" action="ncsaCornerList.cfm" method="post">

<table id="cornerTable" cellspacing="0" cellpadding="5" align="center" border="0" width="99%">
	<cfif NewThreadID EQ "">
		
	</cfif>
	<thead class="no_mobile">
		<tr>
			<th > Subjects </th>
			<th > Replies</th>
			<th > Posted By </th>
			<th > Date/ Time</th>
		</tr>
	</thead>
	<CFLOOP query="qTopThreads">
		<cfquery name="qReplies" dbtype="query">
			SELECT *
			  FROM qThreads 
			 where MAINTHREAD = #THREADID#
			   and refthread  = #THREADID#
		</cfquery>
		
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" onmouseover="this.style.cursor = 'hand'" >			
			<TD>
				<cfif qReplies.RECORDCOUNT>
					<a href="ncsaCornerReplies.cfm?TID=#TopicID#&trid=#ThreadID#">#Subject#</a>
				<cfelse>
					<a href="ncsaCornerPost.cfm?trid=#ThreadID#&mtid=#ThreadID#&m=d" onclick="return DisplayPosting(#ThreadId#)">#Subject#</a>
				</cfif>				
				<cfif PostDate GTE LatestDate>
					<span class="red">New</span>
				</cfif>
	 		</TD>
 			<TD>
				<cfif qReplies.RECORDCOUNT and qReplies.RECORDCOUNT EQ 1>
					(1 reply)
				<cfelse> <!--- if qReplies.RECORDCOUNT and qReplies.RECORDCOUNT gt 1> --->
					(#qReplies.RECORDCOUNT# replies)
				</cfif>
			</TD>
 			<TD>#trim(PostedBy)#</TD>
 			<TD>#dateFormat(PostDate,"mm/dd/yyyy")# #timeFormat(PostTime,"hh:mm tt")#</TD>
		</TR>

	</CFLOOP>
</TABLE>

	<INPUT type="hidden" name="Mode" >
	<INPUT type="hidden" name="ThreadID">
	<INPUT type="hidden" name="TopicID"		value="#VARIABLES.TopicID#">
	<INPUT type="hidden" name="NewThreadID" value="#VARIABLES.NewThreadID#">
	<table cellSpacing="0" cellPadding="0" width="100%" border="0">
		<tr><td align="center">
			<INPUT id="submitButton" type="submit" name="Add"	 value="New Subject" >
			<INPUT id="submitButton" type="submit" name="Back" value="Back"		 >
			</td>
		</tr>
	</table>
</FORM>

<script language="javascript">
var cForm = document.all;
var lastRow;
function DisplayDetail(idx)
{	lastVal = lastRow;
	for (var index = 1; index < 100; index++)
	{	itm1 = "TRD" + idx + index ;
		Hdr1 = "HDR" + idx;
		var elem1 = cForm (Hdr1);
		var obj   = document.getElementById  (itm1);

		if ( obj )
			document.all ( itm1 ).style.display = "inline";
		
		if (lastRow > 0)
		{	Hdr2 = "HDR" + lastRow;
			itm2 = "TRD" + lastRow + index
			var obj2   = document.getElementById  (itm2);

			if ( obj2 )
				document.all ( itm2 ).style.display = "none";
		}
	}
	if (idx == lastRow)
		idx = 0;
	lastRow = idx;
}
</script>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
