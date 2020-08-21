<!--- 
	FileName:	ncsaCornerReplies.cfm
	Created on: 11/20/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	12/17/08 - AA - fixed error when hitting back button in an empty forum, no topics
	
	A Silverstein 8/24/2018 (Ticket 27075)
	- Added postInfo Id to table
	- Added style tags and styles for table
	- Took post warning <span> message out of table and gave it the space class
	- Reformatted table in coldfusion
	- Added br tag between post date/time and reply link
	- Added warning message underneath h2 tag
	- Placed reply link inside of its own td at the bottom of th table and gave it margin-right:18px
	- Added spacer inside of title1 tag
	- Added 18px line height to message
	- Moved table  row and header inside of loop
	- Added styles to h2 tags
	- Added headerStyle id to h2 tag
	- Added 15px of line-height to #postInfo td
 --->
 
<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<style>
			#postInfo {
		  table-layout: fixed;
		  width: 100%; 
		  display: inline-block;
			}

		  #postInfo tr {

		    border: 1px solid #d1d1d1;
		    border-radius: 2px 10px;
		
		    margin-bottom: 20px;
		    padding: 5px;
		    width: 100%; 
		}
	

		  #postInfo th {
		    background: transparent;
		    border-top: 1px solid #AEAEAE;
		    border-bottom: 1px solid #AEAEAE;
		    color: #333;
		    font-size: 11px;
		    padding: 15px 0;
		    text-transform: uppercase;
		  }
	

		  #postInfo td {
		    display: block;
		    float: left;
		    margin-bottom: 5px;
		    padding: 5px;
		    text-align: center;
		    width: 100%;
		    line-height: 15px;

		     }
		 

		.title1{
			    background: #FFDD5A;
			    border-radius: 2px 10px;
			    color: #111;
			    display: block;
			    font-weight: bold;
			    padding: 10px;
			    text-align: center;
			    width: 100%;
		}

		.col_title{
			    border-bottom: 1px solid #ddd;
			    color: #999;
			    display: block;
			    font-size: 12px;
			    margin-bottom: 5px;
			    text-align: left;
			    text-transform: uppercase;
		}
		#replyTarea{
			border:1px solid rgb(169, 169, 169);
			display: block;
		    margin-left: auto;
		    margin-right: auto;
		}

			.submitButton{
			margin-right: 5px;
			 margin-top:5px;
			 height:30px;
			 border-radius: 2px 10px;
			 background-color:#ddd;
			 color:#1a1a1a;
			 border: #ccc 1px solid;
			 cursor: pointer;
		}

		.submitButton:hover {
      background-color: #ccc; 
  		}

  		#replyTarea{
  			width:400px;
  			height:100px;
  		} 

  		.replyInput{
  			width:350px;
  			height:25px;
  		}

  		.space{
  			margin-top:5px;
  			margin-bottom:3px;
  		}

  		.red{
  			font-size: 12px;
  		}
  		h2 {
  			margin-bottom:3px;
  		}

  		#headerStyle{
  			color:#334d55;
    		font-family: 'Roboto', Arial, sans-serif;
  		}

  		#replyButton{
  			margin-right:18px;
  		}

  		#messageStyle{
  			line-height: 18px;
  		}


</style>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA CORNER forum</H1>


<CFIF isDefined("URL.TID") AND isNumeric(URL.TID)>
	<cfset TopicID = URL.TID>
<CFELSEIF isDefined("FORM.TopicID") AND isNumeric(FORM.TopicID)>
	<cfset TopicID = FORM.TopicID>
<CFELSE>
	<cfset TopicID = 0>
</CFIF>
<CFIF isDefined("URL.TRID") AND isNumeric(URL.TRID)>
	<cfset ThreadID = URL.TRID>
<CFELSEIF isDefined("URL.TRID") AND len(trim(URL.TRID)) EQ 0>
	<!--- aa12/17/08 - thread is empty, go back to begining --->
	<cflocation url="ncsaCornerList.cfm?tid=#VARIABLES.TopicID#">
<CFELSE>
	<cfset ThreadID = 0>
</CFIF>
<CFSET mainTid = ThreadID>

<CFIF isDefined("FORM.BACK")>
	<cflocation url="ncsaCornerList.cfm?tid=#VARIABLES.TopicID#">
</CFIF>

<CFIF isDefined("FORM.NewThreadID")>
	<CFSET NewThreadID = FORM.FORM.NewThreadID>
<CFELSE> 
	<CFSET NewThreadID = "">
</CFIF>

<cfquery name="qMaxPostDate" datasource="#SESSION.DSN#">
	Select max(postdate) as maxDate 
	  from TBL_Forum 
	 Where TopicId = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
</cfquery>
<cfif qMaxPostDate.RECORDCOUNT>
	<cfset latestDate = dateFormat(qMaxPostDate.maxDate,"mm/dd/yyyy")>
<cfelse>
	<cfset latestDate = dateFormat(now(),"mm/dd/yyyy")>
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
	SELECT  B.ThreadID, B.RefThread, B.Subject, B.PostDate, B.PostTime, B.MainThread, B.PostedBy, B.MESSAGE
	  from  TBL_Forum A INNER JOIN TBL_Forum B ON a.ThreadID = b.MainThread
	 where  a.TopicID    = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
	   and  a.MainThread = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#">	
	   and  b.Released   = 'Y'		
	 order  by 	B.MainThread, B.RefThread,B.ThreadID
</cfquery>
<!---   order  by A.PostDate Desc, A.PostTime Desc, B.PostDate, B.PostTime  --->
<cfquery name="qRefThread" dbtype="query">
	SELECT DISTINCT RefThread  from qThreads  order by RefThread
</cfquery>
<cfset listRefThreads = valueList(qRefThread.RefThread)> <!--- <cfdump var="#listRefThreads#"> --->


<h2><span id="headerStyle">#VARIABLES.TopicDescription#</span></h2>
<span class="red space"><b>Postings will be displayed after being reviewed for objectionable language</b></span>

<FORM name="MessageList" action="ncsaCornerReplies.cfm" method="post">
<INPUT type="hidden" name="ThreadID">
<INPUT type="hidden" name="TopicID"		value="#VARIABLES.TopicID#">
<INPUT type="hidden" name="NewThreadID" value="#VARIABLES.NewThreadID#">
<table id="postInfo"  cellspacing="0" cellpadding="5" align="center" border="0" width="100%">




	<CFLOOP list="#listRefThreads#" index="iRefT">
		<cfquery name="qPosts" dbtype="query">
			SELECT  ThreadID, RefThread, Subject, PostDate, PostTime, MainThread, PostedBy, MESSAGE
			  from  qThreads
			 where  RefThread    = #iRefT#
			 order  by 	MainThread, RefThread, ThreadID
		</cfquery>	

		<cfset LastThreadId = 0 >
		<cfset Indent = 0 >
		<CFSET ctLOOP = 1>

		<CFLOOP query="qPosts">
			<cfif RefThread eq 0>
				<cfset Indent = 0>
			</cfif>
			
			<!--- 
			<cfif RefThread GT LastThreadId>	<cfset Indent = Indent + 1 >	</cfif>
			<cfif RefThread LT LastThreadId>	<cfset Indent = Indent - 1 >	</cfif>
			<cfif Indent LT 0 >					<cfset Indent = 0 >				</cfif> 
			--->

			<CFIF ctLoop GT 1>
				<cfset indent = ctLoop - 1>
			</CFIF>
			<cfset noOfSpaces = indent * 4>
			<!--- <CFSET LastThreadId = RefThread >  --->
				<tr>
					<td class="title1">
						&nbsp;
					</td>
					<td >
						<span class="col_title" >Post Date/Time</span>
						#dateFormat(PostDate,"mm/dd/yyyy")# #timeFormat(PostTime,"hh:mm tt")#
						
					</td>
					<td >
						<span class="col_title" >Posted By </span>
							#trim(PostedBy)#	
					<td >
						<span class="col_title" >Subject</span>
							#Subject#

						<cfif PostDate GTE LatestDate>	<span class="red">New</span>	</cfif>
						<CFIF RefThread EQ 0> 			 (original post)				</CFIF>
					</td>
					<td id="messageStyle">
						<span class="col_title" >Message</span>
						 #repeatString("&nbsp;",variables.noOfSpaces)#	#message#
					</td>
					<td >
						#repeatString("&nbsp;",4)#	<a href="ncsaCornerPost.cfm?tid=#TopicID#&mtid=#mainTid#&trid=#ThreadID#&m=r" id="replyButton" onclick="return DisplayPosting(#ThreadId#)">Reply</a>
					</td>
				


			</TR>
			<CFSET ctLOOP = ctLOOP + 1>
		</CFLOOP>
	
	</CFLOOP>
 

	<tr><td colspan="2" align="center">
			<INPUT class="submitButton" type="submit" name="Back" value="Back">		
		</td>
	</tr>
</TABLE>
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">