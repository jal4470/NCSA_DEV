<!--- 
	FileName:	ncsaCornerAdmin.cfm
	Created on: 11/26/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">  

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Corner Menu (Admin) </H1>
<br> <!--- <h2>Available Forums </h2> --->

<CFQUERY name="qNewPosts" datasource="#SESSION.DSN#">
	 	Select f.TopicID, Count(*) as topic_total 
	  From TBL_FORUM f 
	 Where f.Released IS NULL 
	 and f.mainthread in (select mainthread from tbl_forum where refthread = 0)
	 Group by f.TopicID
</CFQUERY>	<!--- <cfdump var="#qNewPosts#"> --->

<cfinvoke component="#SESSION.SITEVARS.cfcPath#FORUM" method="getForumCounts" returnvariable="qForum" >
	<cfinvokeargument name="categoryType" value="ALL"> 
</cfinvoke> <!--- <cfdump var="#qForum#"> --->

<table cellspacing="0" cellpadding="5" align="center" border="0" width="80%">
	<tr class="tblHeading">
		<TD colspan="2">Available Forum</TD>
	</tr>
	<CFLOOP query="qForum">
		<cfset ctNewPosts = 0>
		<cfif qNewPosts.RECORDCOUNT>
			<CFQUERY name="getNewCount" dbtype="query">
				select topic_total 
				  from qNewPosts
				 where TopicID = #TOPICID#
			</CFQUERY>
			<cfif getNewCount.RECORDCOUNT>
				<cfset ctNewPosts = getNewCount.topic_total >
			</cfif>
		</cfif> 
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<td width="25%" class="tdUnderLine">  
				<!--- <cfif ctNewPosts> --->
					<a href="ncsaCornerAdminList.cfm?TID=#TopicID#"> #TopicDescription# </a> 
				<!--- <cfelse>
					#TopicDescription#
				</cfif> --->
			</td>
			<td width="75%" class="tdUnderLine">
				<a href="ncsaCornerAdminList.cfm?TID=#TopicID#"> 
					(#topic_total# Topics)	
					<cfif ctNewPosts>
						<span class="red"> (#ctNewPosts# NEW Postings)</span>
					</cfif>
				</a> 
			</td>
		</TR>
	</CFLOOP>
</TABLE>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
