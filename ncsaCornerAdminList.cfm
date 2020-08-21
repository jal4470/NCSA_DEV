<!--- 
	FileName:	ncsaCornerAdminList.cfm
	Created on: 11/26/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	12/17/08 - AA - fixed error when qMaxPostDate.maxDate is empty.
	05/20/09 - AA - T:7763
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA CORNER forum (Admin) </H1>

<CFIF isDefined("FORM.BACK")>
	<cflocation url="ncsaCornerAdmin.cfm">
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
	<cflocation url="ncsaCornerAdminPost.cfm?TID=#TopicID#&trid=0&M=A">	
</CFIF>


<cfquery name="qMaxPostDate" datasource="#SESSION.DSN#">
	Select max(postdate) as maxDate 
	  from TBL_Forum 
	 Where TopicId = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
</cfquery>

<cfif qMaxPostDate.RECORDCOUNT AND isDate(qMaxPostDate.maxDate)>
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
	SELECT  B.ThreadID, B.RefThread, B.Subject,   B.MainThread, A.PostedBy, A.PostDate, A.PostTime   
	  from  TBL_Forum A INNER JOIN TBL_Forum B ON a.ThreadID = b.MainThread
	  where a.TopicID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
	   and a.refthread = 0			
	  -- and b.Released  = 'Y'		
	 order by  B.MainThread  
</cfquery> <!--- qThreads<cfdump var="#qThreads#"> --->

<cfquery name="qTopThreads" dbtype="query">
	SELECT *
	  FROM qThreads 
	 where refthread = 0
	 order by PostDate DESC, PostTime DESC
</cfquery>

<cfquery name="qNewPosts" datasource="#SESSION.DSN#">
	SELECT  B.ThreadID, B.RefThread, B.Subject, B.MainThread 
	  from  TBL_Forum A INNER JOIN TBL_Forum B ON a.ThreadID = b.MainThread
	  where a.TopicID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.TopicID#">
	   and a.refthread = 0			
	   and b.Released  IS NULL
</cfquery> <!--- qNewPosts<cfdump var="#qNewPosts#"> --->


<h2>#VARIABLES.TopicDescription#</h2>
<FORM name="MessageList" action="ncsaCornerAdminList.cfm" method="post">

<table cellspacing="0" cellpadding="5" align="center" border="0" width="99%">
	<tr class="tblHeading">
		<TD width="50%"> Subject </TD>
		<TD width="10%"> New Posts </TD>
		<TD width="20%"> Posted By </TD>
		<TD width="20%"> Date/ Time </TD>
	</tr>
	<CFLOOP query="qTopThreads">
		<cfquery name="qReplies" dbtype="query">
			SELECT *  FROM qThreads 
			 where MAINTHREAD = #THREADID#
			   and refthread  = #THREADID#
		</cfquery><!--- qReplies<cfdump var="#qReplies#"> --->
		<cfquery name="qGetNewPosts" dbtype="query">
			SELECT * from qNewPosts
			 where MAINTHREAD = #THREADID#
		</cfquery><!--- qGetNewPosts<cfdump var="#qGetNewPosts#"> --->
		
		<!--- <CFIF qGetNewPosts.RECORDCOUNT> --->
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#" onmouseover="this.style.cursor = 'hand'" >			
				<TD class="tdUnderLine">
					<a href="ncsaCornerAdminReplies.cfm?TID=#TopicID#&trid=#ThreadID#">#Subject#</a>
		 		</TD>
	 			<TD class="tdUnderLine"> &nbsp;
					<CFIF qGetNewPosts.RECORDCOUNT>
						<span class="red">#qGetNewPosts.RECORDCOUNT# New Posts</span>
					</CFIF>
				</TD>
				<TD class="tdUnderLine">#trim(PostedBy)#</TD>
 				<TD class="tdUnderLine">#dateFormat(PostDate,"mm/dd/yyyy")# #timeFormat(PostTime,"hh:mm tt")#</TD>
			</TR> 
		<!--- </CFIF> --->
	</CFLOOP>
</TABLE>

	<INPUT type="hidden" name="ThreadID">
	<INPUT type="hidden" name="TopicID"		value="#VARIABLES.TopicID#">
	<INPUT type="hidden" name="NewThreadID" value="#VARIABLES.NewThreadID#">
	<table cellSpacing="0" cellPadding="0" width="100%" border="0">
		<tr><td align="center">
			<INPUT type="submit" name="Add"	 value="New Subject" >
			<INPUT type="submit" name="Back" value="Back"		 >
			</td>
		</tr>
	</table>
</FORM>



</cfoutput>
</div>
<cfinclude template="_footer.cfm">
