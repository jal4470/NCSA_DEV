<!--- 
	FileName:	ncsaCornerPost.cfm
	Created on: 11/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA CORNER forum (Admin)</H1>

<cfif isDefined("FORM.ThreadID")>
	<cfset ThreadID	= FORM.ThreadID>
<cfelseif isDefined("URL.TRID") AND isNumeric(URL.TRID)>	
	<cfset ThreadID	= URL.TRID>
<cfelse>	
	<cfset ThreadID	= "">
</cfif>	

<cfif isDefined("FORM.mainThreadID")>
	<cfset mainThreadID	= FORM.mainThreadID>
<cfelseif isDefined("URL.MTID") AND isNumeric(URL.MTID)>	
	<cfset mainThreadID	= URL.MTID>
<cfelse>	
	<cfset mainThreadID	= "">
</cfif>	

<cfif isDefined("FORM.TopicID")>
	<cfset TopicID	= FORM.TopicID>
<cfelseif isDefined("URL.TID") AND isNumeric(URL.TID)>	
	<cfset TopicID	= URL.TID>
<cfelse>
	<cfset TopicID	= "">
</cfif>

<cfif isDefined("FORM.Mode")>
	<cfset Mode		= FORM.Mode>
<cfelseif isDefined("URL.M") AND len(trim(URL.M)) EQ 1>
	<cfswitch expression="#UCASE(URL.M)#">
		<cfcase value="D">	<cfset Mode = "DISPLAY"></cfcase>
		<cfcase value="R">	<cfset Mode = "REPLY"></cfcase>
		<cfcase value="A">	<cfset Mode = "ADD"></cfcase>
	</cfswitch>
<cfelse>
	<cfset Mode		= "DISPLAY">
</cfif>

<cfset PostDate = DateFormat(now(),"mm/dd/yyyy")>
<cfset PostTime = TimeFormat(now(),"hh:mm tt")>

<cfset TopicDescription = ""><!--- <cfset TopicDescription = Session("TopicDescription") --->
<!--- <cfset TopicID		= ""> --->
<cfset RefThread	= "">
<cfset MainThread	= "">
<cfset Subject		= "">
<cfset Message		= "">
<cfset PostedBy		= "">

<cfset swErr = false>	
<cfset msg = "">

<cfif IsDefined("FORM.BACK")>
	<!--- ncsaCornerList.cfm ? tid=#VARIABLES.TopicID# & trid=#VARIABLES.mainThreadID# <CFABORT> --->
	<cflocation url="ncsaCornerAdminReplies.cfm?tid=#VARIABLES.TopicID#&trid=#VARIABLES.mainThreadID#">
</cfif>
<cfif IsDefined("FORM.REPLY")>
	<CFSET MODE = "REPLY"><!--- DISPLAY --->
</cfif>

<cfif IsDefined("FORM.POST")>
	<CFSET MODE = "ADD">
	<CFIF isDefined("FORM.POSTEDBY") and LEN(TRIM(FORM.POSTEDBY)) GT 0>
		<!--- ok --->	
		<CFSET PostedBy = FORM.POSTEDBY> 
	<CFELSE>
		<CFSET msg = msg & "Posted by is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<CFIF isDefined("FORM.MESSAGE") and LEN(TRIM(FORM.MESSAGE)) GT 0>
		<!--- ok --->	
		<CFSET Message = FORM.MESSAGE> 
	<CFELSE>
		<CFSET msg = msg & "Message is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<CFIF isDefined("FORM.Subject") and LEN(TRIM(FORM.Subject)) GT 0>
		<!--- ok --->	
		<CFSET subject = FORM.Subject> 
	<CFELSE>
		<CFSET msg = msg & "subject is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>

	<CFIF NOT swErr>
		<CFQUERY name="insertSubject" datasource="#SESSION.DSN#">
			Insert Into TBL_Forum
				(TopicID, RefThread,  Subject, Message, PostedBy, PostDate, PostTime, Released, ReleaseDate, ReleaseTime)
			Values 
				( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.TopicID#"> 
				, 0 
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Subject)#" >
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Message)#" >
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.PostedBy)#" >
				, <cfqueryparam  value="#PostDate#" >
				, <cfqueryparam  value="#PostTime#" >
				, 'Y'
				, <cfqueryparam value="#PostDate#" >
				, <cfqueryparam value="#PostTime#" >
				)
		</CFQUERY>

		<CFQUERY name="SetThreadid" datasource="#SESSION.DSN#">
			Update TBL_Forum
			   set MainThread = ThreadID
			 where TopicID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.TopicID#">
			   and RefThread = 0
			   and Subject  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Subject)#" >
			   and PostedBy = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.PostedBy)#" >
			   and PostDate = <cfqueryparam value="#PostDate#" >
			   and PostTime = <cfqueryparam value="#PostTime#" >
		</CFQUERY>
	
	 	<cflocation url="ncsaCornerAdminList.cfm?tid=#TOPICID#&trid=#mainThreadID#">
	</CFIF>

</cfif>



<cfif IsDefined("FORM.POSTREPLY")>
	<CFSET MODE = "REPLY">
	<CFIF isDefined("FORM.POSTEDBY") and LEN(TRIM(FORM.POSTEDBY)) GT 0>
		<!--- ok --->	
		<CFSET PostedBy = FORM.POSTEDBY> 
	<CFELSE>
		<CFSET msg = msg & "Posted by is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	
	<CFIF isDefined("FORM.MESSAGE") and LEN(TRIM(FORM.MESSAGE)) GT 0>
		<!--- ok --->	
		<CFSET Message = FORM.MESSAGE> 
	<CFELSE>
		<CFSET msg = msg & "Message is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	
	<CFIF isDefined("FORM.Subject") and LEN(TRIM(FORM.Subject)) GT 0>
		<!--- ok --->	
		<CFSET subject = FORM.Subject> 
	<CFELSE>
		<CFSET msg = msg & "subject is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>

	 <CFIF NOT swErr>
		<!--- lets insert the post! --->
		<cfset swReleasYN = "N">
		<CFIF isDefined("SESSION.MENUROLEID") AND SESSION.MENUROLEID GT 0>
			<cfquery name="qOKtoRelease" datasource="#SESSION.DSN#">
				select role_id 
				  from TLKP_ROLE 
				 WHERE roleType in ('SU','BU','CU') 
				   AND ROLE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.MENUROLEID#">
			</cfquery>
			<CFIF qOKtoRelease.RECORDCOUNT>
				<cfset swReleasYN = "Y">
			</CFIF>
		</CFIF>  

		<cfquery name="getMainThread" datasource="#SESSION.DSN#">
			Select TopicId, MainThread 
			  from TBL_Forum
			 Where ThreadID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.ThreadID#">
    	</cfquery>	
	
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#FORUM" method="InsertForumPost" >
			<cfinvokeargument name="TopicID"	value="#getMainThread.TopicID#">
			<cfinvokeargument name="RefThread"	value="#FORM.ThreadID#">
			<cfinvokeargument name="MainThread" value="#getMainThread.mainThread#">
			<cfinvokeargument name="Subject"	value="#FORM.Subject#">
			<cfinvokeargument name="Message"	value="#FORM.Message#">
			<cfinvokeargument name="PostedBy"	value="#FORM.PostedBy#">
			<cfinvokeargument name="swReleasYN"	value="#VARIABLES.swReleasYN#">
		</cfinvoke>

	 	<cflocation url="ncsaCornerAdminReplies.cfm?tid=#TOPICID#&trid=#mainThreadID#">
	
	</CFIF>	 

</cfif>


<cfif IsDefined("FORM.RELEASE")>
	<CFIF isDefined("FORM.POSTEDBY") and LEN(TRIM(FORM.POSTEDBY)) GT 0>
		<!--- ok --->	
		<CFSET PostedBy = FORM.POSTEDBY> 
	<CFELSE>
		<CFSET msg = msg & "Posted by is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<CFIF isDefined("FORM.MESSAGE") and LEN(TRIM(FORM.MESSAGE)) GT 0>
		<!--- ok --->	
		<CFSET Message = FORM.MESSAGE> 
	<CFELSE>
		<CFSET msg = msg & "Message is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<CFIF isDefined("FORM.Subject") and LEN(TRIM(FORM.Subject)) GT 0>
		<!--- ok --->	
		<CFSET subject = FORM.Subject> 
	<CFELSE>
		<CFSET msg = msg & "subject is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	 <CFIF NOT swErr>
		<!--- No errors, lets release the post.... --->
		
		<cfquery name="releasePost" datasource="#SESSION.DSN#">
			Update TBL_Forum
			   set Released = 'Y'
				 , ReleaseDate = getdate()
				 , ReleaseTime = getdate()
				 , Subject	   = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Subject#">
				 , Message	   = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.Message#">
				 , PostedBy	   = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#FORM.PostedBy#">
			 Where ThreadID    = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#FORM.ThreadID#">
		</cfquery>
		<cflocation url="ncsaCornerAdminReplies.cfm?tid=#VARIABLES.TopicID#&trid=#VARIABLES.mainThreadID#">
	</CFIF>	 
</cfif>

<cfif IsDefined("FORM.DELETE")>
	<!---	 Lets delete this post --->
		<cfquery name="releasePost" datasource="#SESSION.DSN#">
			Delete from tbl_Forum Where ThreadID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#FORM.ThreadID#">
	</cfquery>
		<cflocation url="ncsaCornerAdminReplies.cfm?tid=#VARIABLES.TopicID#&trid=#VARIABLES.mainThreadID#">
</cfif>


<cfswitch expression="#MODE#">
	<cfcase value="DISPLAY">
		<cfquery name="qForum" datasource="#SESSION.DSN#">
			Select f.TopicID, f.RefThread, f.MainThread, f.Subject
				 , f.Message, f.PostDate, f.PostTime, f.PostedBy
				 , t.TopicDescription
			  from TBL_FORUM f inner Join TBL_ForumTopics t ON t.TopicID = f.TopicID
			 Where f.ThreadID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#"> 
			 
			 ORDER BY f.PostDate, f.PostTime
		</cfquery> <!--- Where f.MainThread = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#">   --->

		<cfif qForum.RECORDCOUNT>
			<cfset TopicDescription		= qForum.TopicDescription>
			<cfset TopicID		= qForum.TopicID>
			<cfset RefThread	= qForum.RefThread>
			<cfset MainThread	= qForum.MainThread>
			<cfset Subject		= qForum.Subject>
			<cfset Message		= qForum.Message>
			<cfset PostDate 	= DateFormat(qForum.PostDate,"mm/dd/yyyy")>
			<cfset PostTime 	= TimeFormat(qForum.PostTime,"hh:mm tt")>
			<cfset PostedBy		= qForum.PostedBy>
		<cfelse>
			<cfset TopicDescription	= "">
			<!--- <cfset TopicID		= ""> --->
			<cfset RefThread	= "">
			<cfset MainThread	= "">
			<cfset Subject		= "">
			<cfset Message		= "">
			<cfset PostDate 	= "">
			<cfset PostTime 	= "">
			<cfset PostedBy		= "">
		</cfif>
	</cfcase>
	<cfcase value="REPLY">
		<cfquery name="qForum" datasource="#SESSION.DSN#">
			Select f.TopicId, f.Subject , t.TopicDescription, 
					f.Message, f.PostDate, f.PostTime, f.PostedBy
			  from TBL_FORUM f inner Join TBL_ForumTopics t ON t.TopicID = f.TopicID
			 Where ThreadID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#">
		</cfquery>
		<cfif qForum.recordCount>
			<cfset TopicID = qForum.TopicID>
			<cfset Subject = "Re: " & Trim(qForum.Subject)>
		<CFELSE>
			<!--- <cfset TopicID = ""> --->
			<cfset Subject = "">
		</cfif>
	</cfcase>
</cfswitch>

<cfset PresidentForum = "">
<cfset DisplayOnly	   = "">

<CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) GT 0>
		<cfset PostedBy = SESSION.USER.CLUBname>
		<cfset PresidentForum = "Y">
		<cfset DisplayOnly	   = "disable">
</CFIF> 

<h2>Forum Posting - 
	<cfswitch expression="#MODE#">
		<cfcase value="DISPLAY">Display Message</cfcase>
		<cfcase value="ADD">Add New Topic/Subject</cfcase>
		<cfcase value="REPLY">Reply</cfcase>
	</cfswitch>
	- #Trim(TopicDescription)#
</h2>

<br>	

<CFSET required = "">
<cfif  Mode NEQ "DISPLAY"> 
	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
</cfif>
<FORM name="MessageMaintain" action="ncsaCornerAdminPost.cfm" method="post"> 
<INPUT type="hidden" name="Mode" value="#Mode#" >
<INPUT type="hidden" name="ThreadID" value="#ThreadID#">
<INPUT type="hidden" name="TopicID"	 value="#TopicID#">
<INPUT type="hidden" name="mainThreadID"	 value="#mainThreadID#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">

	<cfif  Trim(Mode) EQ "REPLY" and qForum.recordCount>
		<tr class="tblHeading">
			<TD colspan="2">Replying to Post:</TD>
		</tr>
		<TR><TD class="tdUnderLine"  width="15%" align="right">	<b>Post Date/Time: </b>	</TD>
			<TD class="tdUnderLine"  width="85%" align="left" > #DateFormat(qForum.PostDate,"mm/dd/yyyy")# &nbsp;&nbsp; #TimeFormat(qForum.PostTime,"hh:mm tt")# 	</TD>
		</TR>
		<TR><TD class="tdUnderLine"  align="right">	 <B>Posted By: </B> 		</TD>
			<TD class="tdUnderLine" align="left" >	 #qForum.PostedBy#
			</TD>
		</TR>
		<TR><TD class="tdUnderLine"  align="right">	 <B>Subject: </B> 		</TD>
			<TD class="tdUnderLine" align="left" >   #qForum.Subject#
			</TD>
		</TR>
		<TR><TD class="tdUnderLine"  align="right">  <B>Message: </B>		</TD>
			<TD class="tdUnderLine" align="left" >   #qForum.Message#
			</TD>
		</TR>
	</cfif>
	<tr class="tblHeading">
			<TD colspan="2">&nbsp;</TD>
	</tr>
<!---  --->
	<CFIF swERR>
		<tr><TD colspan="2" class="tdUnderLine">
				<span class="red"> <b>#msg#</b> </span>	
			</TD>
		</tr>
	</CFIF>
	<TR><TD class="tdUnderLine" align="right">	<b>Post Date/Time: </b>	</TD>
		<TD class="tdUnderLine" align="left" > #PostDate# &nbsp;&nbsp; #PostTime# 	</TD>
	</TR>
	<TR><TD class="tdUnderLine"  align="right">	#REQUIRED# <B>Posted By: </B> 		</TD>
		<TD class="tdUnderLine" align="left" >
			<!--- <cfif  Mode EQ "DISPLAY">
				#PostedBy#
			<cfelse> --->
<!---				<cfif PresidentForum EQ "Y">
					<b>#PostedBy#</b> <INPUT type=hidden style="WIDTH: 350px; HEIGHT: 25px"  name="PostedBy" value= "#PostedBy#">--->
				<!---<cfelse>--->
					<span class="red">  Please include your FULL NAME in "Posted by", Anonymous Posts will be discarded.  </span>	
					<br>	
					<INPUT style="WIDTH: 350px; HEIGHT: 25px"  name="PostedBy" value= "#PostedBy#">
				<!---</cfif>--->
			<!--- </cfif>  --->
		</TD>
	</TR>
	<TR><TD class="tdUnderLine"  align="right">	#REQUIRED# <B>Subject: </B> 		</TD>
		<TD class="tdUnderLine" align="left" >
			<!--- <cfif Mode eq "DISPLAY">
				#Subject#
			<cfelse> --->
				<INPUT style="WIDTH: 350px; HEIGHT: 25px"  name="Subject" value= "#Subject#">
			<!--- </cfif> ---> 
		</TD>
	</TR>
	<TR><TD class="tdUnderLine"  align="right">	#REQUIRED# <B>Message: </B>		</TD>
		<TD class="tdUnderLine" align="left" >
			<!--- <cfif  Mode eq "DISPLAY" >
				#Message#
			<cfelse> --->
				<TEXTAREA name="Message" rows=5  cols=65>#Trim(Message)#</TEXTAREA>
			<!--- </cfif>  --->
		</TD>
	</TR>

	<tr><td colspan="2" align="center">
			<span class="red">Postings will be displayed after being reviewed for objectionable language</span>
		</td>
	</tr>

	<TR align="center">
    	<TD class="tdUnderLine" colspan="2">
			<cfif mode EQ "ADD">
					<INPUT type="submit" name="POST" value="Post"		>
			<cfelseif mode EQ "REPLY">
				<INPUT type="submit"  Name="POSTREPLY" value="Post Reply"	>
			<cfelse>
				<INPUT type="submit"  Name="RELEASE" value="Release"	>
				<INPUT type="submit"  name="DELETE"  value="Delete"	 onclick="GoDelete()"	>
			</cfif>
			<INPUT type="submit"   Name="BACK" value="Back"	 >
		</TD>
	</TR>
</table>	
</FORM>

<!--- <cfdump var="#qForum#"> --->
<script language="javascript">
function GoDelete()
{	var DeleteYN;
	DeleteYN = confirm ("Are you sure To DELETE the Posting");
	if (DeleteYN) 
	{	self.document.MessageMaintain.SUBMIT.value	= "DELETE";
		self.document.MessageMaintain.action		= "ncsaCornerAdminPost.cfm";
		self.document.MessageMaintain.submit();
	}
}
</script>

	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
