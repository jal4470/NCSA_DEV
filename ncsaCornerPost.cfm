<!--- 
	FileName:	ncsaCornerPost.cfm
	Created on: 11/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
 A Silverstein 8/23/2018 (Ticket 27075)
 - Added local styles to update the table styles
 - gave table the id postinfo
 - reformatted coldfusion inside of cfif eq reply
 - reformatted full table in coldfusion
 - Added a table row around table after cfif at line 372
 - Added closing cfif tag on line 396
 - Added <b> tag around POST DATE/TIME
 - Added extra br tags after inputs
 - Added border to text area
 - Added styling for button submit
 - Added the submitButton class to all of the button inputs
 - Added hover event to submitButton with css
 - Added classes to the textarea and the text input tags and gave them a break point to make them mobile responsive.
 - Made ther red font smaller
 - removed br tag between header and red text and added margin.
 - Added margin of 3px to bottom of h2 tag.
 - Added styles to h2 tags
 - Added HeaderStyles id to H2 tag
 - Added 15px of line-height to #postInfo td

 A Silverstein 8/27/2018
 - restyled replyInput class to match input boxes on ncsaRef.cfm
 - restyled textarea to have the same styling
 - Got rid of media query and made the width of form inputs 90%
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
		    line-height:15px;
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
  			color: #1a1a1a;
  			border: 1px solid #ccc;
  			width:90%;
  			height:100px;
  		} 

  		.replyInput{
	   -webkit-appearance: none;
	    background: #fff;
	    border: 1px solid #ccc;
	    color: #1a1a1a;
	    margin-bottom: 10px;
	    padding: 10px;
	    font: 16px 'Roboto', Arial, sans-serif;
	    outline: 0;
	  	width:90% ;
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
  		.g-recaptcha{
  			margin-left: 30%;
  		}
  		
</style>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA CORNER forum</H1>

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
		<cfcase value="D"><cfset Mode = "DISPLAY"></cfcase>
		<cfcase value="R"><cfset Mode = "REPLY"></cfcase>
		<cfcase value="A"><cfset Mode = "ADD"></cfcase>
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
<!--- <cfif isdefined("Form")>
	<cfdump var="#form#">
	<cfdump var="#cgi#">
</cfif> --->

<!--- <cfif isdefined("form") and structKeyExists(FORM,"submit")>
	
</cfif> --->

<cfif IsDefined("FORM.BACK")>
	<!--- ncsaCornerList.cfm ? tid=#VARIABLES.TopicID# & trid=#VARIABLES.mainThreadID# <CFABORT> --->
	<cflocation url="ncsaCornerReplies.cfm?tid=#VARIABLES.TopicID#&trid=#VARIABLES.mainThreadID#">
</cfif>
<cfif IsDefined("FORM.REPLY")>
	<CFSET MODE = "REPLY"><!--- DISPLAY --->
</cfif>

<cfif IsDefined("FORM.POST")>
	<cfset recaptcha = FORM["g-recaptcha-response"] >
	<cfhttp url="https://www.google.com/recaptcha/api/siteverify" method="POST">
		<cfhttpparam type="formfield" name="secret" value="#Application.sitevars.captchaSecret#">
		<cfhttpparam type="formfield" name="response" value="#recaptcha#">
		<cfhttpparam type="formfield" name="remoteip" value="#CGI.REMOTE_ADDR#">
	</cfhttp>
	<!--- <cfdump var="#DeserializeJSON(cfhttp.filecontent)#"> --->
	<cfset captchaResponse = DeserializeJSON(cfhttp.filecontent)>
	
	<CFSET MODE = "ADD">

	<CFIF isDefined("FORM.POSTEDBY")>
		<!--- ok --->	
		<CFSET PostedBy = FORM.POSTEDBY> 
	<CFELSE>
		<CFSET msg = msg & "Posted by is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<CFIF isDefined("FORM.MESSAGE")>
		<!--- ok --->	
		<CFSET Message = FORM.MESSAGE> 
	<CFELSE>
		<CFSET msg = msg & "Message is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<CFIF isDefined("FORM.Subject")>
		<!--- ok --->	
		<CFSET subject = FORM.Subject> 
	<CFELSE>
		<CFSET msg = msg & "subject is a required field.<BR>">
		<cfset swErr = true>	
	</CFIF>
	<cfif captchaResponse.success neq 'YES'>
		<CFSET msg = msg & "You must click the &quot;I'm not a robot box&quot; below in order to submit a completed form<br/>">
		<cfset swErr = true>	
	</cfif>
	<CFIF NOT swErr>
		<CFQUERY name="insertSubject" datasource="#SESSION.DSN#">
			Insert Into TBL_Forum
				(TopicID, RefThread,  Subject, Message, PostedBy, PostDate, PostTime)
			Values 
				( #FORM.TopicID# 
				, 0 
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Subject)#" >
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Message)#" >
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.PostedBy)#" >
				, <cfqueryparam cfsqltype="CF_SQL_DATE"    value="#PostDate#" >
				, <cfqueryparam cfsqltype="CF_SQL_TIME"    value="#PostTime#" >
				)
		</CFQUERY>

		<CFQUERY name="SetThreadid" datasource="#SESSION.DSN#">
			Update TBL_Forum
			   set MainThread = ThreadID
			 where TopicID = #FORM.TopicID#
			   and RefThread = 0
			   and Subject  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.Subject)#" >
			   and PostedBy = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Trim(FORM.PostedBy)#" >
			   and PostDate = <cfqueryparam value="#PostDate#" >
			   and PostTime = <cfqueryparam value="#PostTime#" >
		</CFQUERY>
	
	 	<cflocation url="ncsaCornerList.cfm?tid=#TOPICID#&trid=#mainThreadID#">
	</CFIF>

</cfif>


<cfif IsDefined("FORM.POSTREPLY")>

	<cfset recaptcha = FORM["g-recaptcha-response"] >
	<cfhttp url="https://www.google.com/recaptcha/api/siteverify" method="POST">
		<cfhttpparam type="formfield" name="secret" value="#Application.sitevars.captchaSecret#">
		<cfhttpparam type="formfield" name="response" value="#recaptcha#">
		<cfhttpparam type="formfield" name="remoteip" value="#CGI.REMOTE_ADDR#">
	</cfhttp>
	<!--- <cfdump var="#DeserializeJSON(cfhttp.filecontent)#"> --->
	<cfset captchaResponse = DeserializeJSON(cfhttp.filecontent)>
	<cfif captchaResponse.success neq 'YES'>
		<CFSET msg = msg & "You must click the &quot;I'm not a robot box&quot; below in order to submit a completed form<br/>">
		<cfset swErr = true>	
	</cfif>

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

	 	<cflocation url="ncsaCornerReplies.cfm?tid=#TOPICID#&trid=#mainThreadID#">
	
	</CFIF>	 

</cfif>



<cfswitch expression="#MODE#">
<!--- 	<cfcase value="ADD">
		<cfset Subject	= "" >
		<cfset Message	= "" >
		<cfset PostedBy	= "" >
	</cfcase> --->
	<cfcase value="DISPLAY">
		<cfquery name="qForum" datasource="#SESSION.DSN#">
			Select f.TopicID, f.RefThread, f.MainThread, f.Subject
				 , f.Message, f.PostDate, f.PostTime, f.PostedBy
				 , t.TopicDescription
			  from TBL_FORUM f inner Join TBL_ForumTopics t ON t.TopicID = f.TopicID
			 Where f.MainThread = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#"> 
			 ORDER BY f.PostDate, f.PostTime
		</cfquery> <!--- Where f.ThreadID >= <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ThreadID#">  --->

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
		<!---<cfset PostedBy = SESSION.USER.CLUBname>--->
		<cfset PresidentForum = "Y">
		<cfset DisplayOnly	   = "disable">
</CFIF> 

<h2 id="headerStyle" >Forum Posting - 
	<cfswitch expression="#MODE#">
		<cfcase value="DISPLAY">Display Message</cfcase>
		<cfcase value="ADD">Add New Topic/Subject</cfcase>
		<cfcase value="REPLY">Reply</cfcase>
	</cfswitch>
	- #Trim(TopicDescription)# 
</h2>


<CFSET required = "">
<cfif  Mode NEQ "DISPLAY"> 
	<span class="red space">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
</cfif>
<FORM name="MessageMaintain" action="ncsaCornerPost.cfm" method="post"> 
<INPUT type="hidden" name="Mode" value="#Mode#" >
<INPUT type="hidden" name="ThreadID" value="#ThreadID#">
<INPUT type="hidden" name="TopicID"	 value="#TopicID#">
<INPUT type="hidden" name="mainThreadID"	 value="#mainThreadID#">
<table id="postInfo" cellspacing="0" cellpadding="5" align="center" border="0" width="100%">

	<cfif  Trim(Mode) EQ "REPLY" and qForum.recordCount>
			<tr>
				<td class="title1">Replying to Post</td>
				<td >
					<span class="col_title" >Post Date/Time</span>
					 #DateFormat(qForum.PostDate,"mm/dd/yyyy")# &nbsp;&nbsp; #TimeFormat(qForum.PostTime,"hh:mm tt")#
				</td>
				<td >
					<span class="col_title" >Posted By </span>
						#qForum.PostedBy#		
				<td >
					<span class="col_title" >Subject</span>
					#qForum.Subject#
				</td>
				<td >
					<span class="col_title" >Message</span>
					 #qForum.Message#
				</td>
			</tr>
	</cfif>

	<tr>
		<td class="title1">
				&nbsp;
		</td>

		<CFIF swERR>
				<TD >
					<span class="red"> <b>#msg#</b> </span>	
				</TD>
		</CFIF>

	
		<td >	
			<span class="col_title" ><b> Post Date/Time</b> </span> 
			 #PostDate# &nbsp;&nbsp; #PostTime# 	
		</td>


		<td >	
			<span class="col_title" >	#REQUIRED# <B>Posted By </B>  </span> 
			<cfif  Mode EQ "DISPLAY">
				#PostedBy#
			<cfelse>
				<span class="red">  Please include your FULL NAME in "Posted by", Anonymous Posts will be discarded.  </span>	
					<br/><br/><INPUT class="replyInput"  name="PostedBy" value="#PostedBy#">
			</cfif>		
		</td>



		<td >	
			<span class="col_title" > 	#REQUIRED# <B>Subject </B> </span> 
			<cfif Mode eq "DISPLAY">
				#Subject#
			<cfelse>	
					<br/><INPUT class="replyInput" name="Subject" value= "#Subject#">
			</cfif> 
		</td>




		<td >	
			<span class="col_title" > 	#REQUIRED# <B>Message </B>	 </span> 
			<cfif  Mode eq "DISPLAY" >
				#Message#
			<cfelse>
					<TEXTAREA id="replyTarea" name="Message" >#Trim(Message)#</TEXTAREA>
			</cfif> 
		</td>
	

	
		<td colspan="2" align="center">
			<span class="red">Postings will be displayed after being reviewed for objectionable language</span>
		</td>
	</tr>
	<cfif  Mode NEQ "DISPLAY"> 
		<script src="https://www.google.com/recaptcha/api.js" async defer></script>
		<tr>	
			<td colspan="2">
				<div class="g-recaptcha" data-sitekey="#Application.sitevars.captchaSiteKey#"></div>
				<input type="hidden" name="captcha">
			</td>
		</tr>
		<tr>
	</cfif>	
    	<TD class="tdUnderLine" colspan="2">
			<cfswitch expression="#Mode#">
				<cfcase value= "DISPLAY">	<INPUT class="submitButton" type="submit"  Name="REPLY" value="Reply"	>
				</cfcase>	
				<cfcase value= "ADD">		<INPUT class="submitButton" type="submit" name="POST" value="Post"		>
				</cfcase>
				<cfcase value="REPLY" >		<INPUT class="submitButton" type="submit" name="POSTREPLY" value="Post Reply" >
				</cfcase>
			</cfswitch>
			<INPUT class="submitButton" type="submit"   Name="BACK" value="Back"	 >
		</TD>
	</tr>
</table>	
</FORM>



<!--- <cfdump var="#qForum#"> --->

	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
