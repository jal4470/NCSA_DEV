<!--- 
	FileName:	formsSequence.cfm
	Created on: 06/05/2009
	Created by: B. Cooper
	
	Purpose: sequence the list of forms or documents
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<cfif isdefined("url.group_id")>
	<cfset group_id=url.group_id>
<cfelse>
	<cfset group_id=1>
</cfif>

<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
	<cfinvokeargument name="group_id" value="#group_id#">
</cfinvoke>

	<style type="text/css">
		.helperNesting{
			background-color:#eeeeee;
			border:2px dashed #aaaaaa;
		}
		.currentNesting{
			background-color:#ffffff;
			border:1px solid black;
		}
		.activeClass{
			border:1px solid green;
		}
		.hoverClass{
			border:1px solid red;
		}
		#dragHelper{
			font-size:11px;
		}
	</style>
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Sequence Forms</H1>
<!--- <h2>yyyyyy </h2> --->

<div style="font-size:1.3em; margin:5px; font-style:italic;">
	Drag and drop to reorder forms
</div>
	<cf_sortableTree
		currentNestingClass="currentNesting"
		helperclass="helperNesting"
		queryToSort=#forms#
		idFieldName="form_id"
		displayFieldName="name"
		sequenceFieldName="seq"
		componentName="#session.sitevars.cfcpath#form"
		methodName="updatesequence"
		redirectURL="formsManage.cfm"
		noNesting=true>


</div>
</cfoutput>
<cfinclude template="_footer.cfm">



 
