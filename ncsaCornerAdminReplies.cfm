<!--- 
	FileName:	ncsaCornerAdminReplies.cfm
	Created on: 11/26/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA CORNER forum (Admin)</H1>


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
	<cflocation url="ncsaCornerAdminList.cfm?tid=#VARIABLES.TopicID#">
<CFELSE>
	<cfset ThreadID = 0>
</CFIF>
<CFSET mainTid = ThreadID>

<CFIF isDefined("FORM.BACK")>
	<cflocation url="ncsaCornerAdminList.cfm?tid=#VARIABLES.TopicID#">
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
	SELECT  B.ThreadID, B.RefThread, B.Subject, B.PostDate, B.PostTime, B.MainThread, B.PostedBy, B.MESSAGE, B.RELEASED
	  from  TBL_Forum A INNER JOIN TBL_Forum B ON a.ThreadID = b.MainThread
	 where  a.TopicID    = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
	   and  a.MainThread = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#">	
	 order  by 	B.MainThread, B.RefThread,B.ThreadID
</cfquery>
<!---   order  by A.PostDate Desc, A.PostTime Desc, B.PostDate, B.PostTime  --->
<cfquery name="qRefThread" dbtype="query">
	SELECT DISTINCT RefThread  from qThreads  order by RefThread
</cfquery>
<cfset listRefThreads = valueList(qRefThread.RefThread)>

<!--- <cfdump var="#listRefThreads#"> --->


 
<h2>#VARIABLES.TopicDescription#</h2>
<FORM name="MessageList" action="ncsaCornerAdminReplies.cfm" method="post">
<INPUT type="hidden" name="ThreadID">
<INPUT type="hidden" name="TopicID"		value="#VARIABLES.TopicID#">
<INPUT type="hidden" name="NewThreadID" value="#VARIABLES.NewThreadID#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr><td colspan="3">&nbsp; <span class="red">Click on the Post to Release/Update/Delete </span></td>
	</tr>
	<tr class="tblHeading">
		<TD width="10%"> Status </TD>
		<TD width="30%"> Posted By </TD>
		<TD width="60%"> Subject </TD>
	</tr>
	<CFLOOP list="#listRefThreads#" index="iRefT">
		<cfquery name="qPosts" dbtype="query">
			SELECT  ThreadID, RefThread, Subject, PostDate, PostTime, MainThread, PostedBy, MESSAGE, RELEASED
			  from  qThreads
			 where  RefThread    = #iRefT#
			 order  by 	MainThread, RefThread, ThreadID
		</cfquery>	
		<CFLOOP query="qPosts">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" onmouseover="this.style.cursor = 'hand'" >			
				<TD class="tdUnderLine" valign="top">
					<a href="ncsaCornerAdminPost.cfm?tid=#TopicID#&mtid=#mainTid#&trid=#ThreadID#" >
						<CFIF RELEASED EQ "Y">
							<span class="red">Released</span>
						<CFELSE>
							<span class="green">New</span>
						</CFIF>
					</a>
				</TD>
				<TD class="tdUnderLine" valign="top">
					<a href="ncsaCornerAdminPost.cfm?tid=#TopicID#&mtid=#mainTid#&trid=#ThreadID#" >
			 			#dateFormat(PostDate,"mm/dd/yyyy")# #timeFormat(PostTime,"hh:mm tt")#
						By: #trim(PostedBy)#
					</a>
				</TD>
				<TD class="tdUnderLine" valign="top">
					<a href="ncsaCornerAdminPost.cfm?tid=#TopicID#&mtid=#mainTid#&trid=#ThreadID#&m=r">Reply</a>
					#repeatString("&nbsp;",4)#	
					<b>#Subject#</b>
					<cfif PostDate GTE LatestDate>	<span class="red">New</span>	</cfif>
					<CFIF RefThread EQ 0> 			 (original post)				</CFIF>
		 		</TD>
			</TR>
		</CFLOOP>
	
	</CFLOOP>
 

	<tr><td colspan="2" align="center">
			<INPUT type="submit" name="Back" value="Back">		
		</td>
	</tr>
</TABLE>
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
<!--- <cfdump var="#qThreads#"> --->