<!--- 
	FileName:	injurySequence.cfm
	Created on: 06/09/2009
	Created by: B. Cooper
	
	Purpose: sequence the list of injuries
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">



<cfinvoke component="#SESSION.sitevars.cfcPath#injury" method="getInjuries" returnvariable="injuries">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
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
<H1 class="pageheading">NCSA - Sequence Injuries</H1>
<!--- <h2>yyyyyy </h2> --->

<div style="font-size:1.3em; margin:5px; font-style:italic;">
	Drag and drop to reorder injuries
</div>
	<cf_sortableTree
		currentNestingClass="currentNesting"
		helperclass="helperNesting"
		queryToSort=#injuries#
		idFieldName="injury_id"
		displayFieldName="injury_desc"
		sequenceFieldName="seq"
		componentName="#session.sitevars.cfcpath#injury"
		methodName="updatesequence"
		redirectURL="injuryList.cfm"
		noNesting=true>


</div>
</cfoutput>
<cfinclude template="_footer.cfm">



 
