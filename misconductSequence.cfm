<!--- 
	FileName:	misconductSequence.cfm
	Created on: 8/6/2009
	Created by: B. Cooper
	
	Purpose: sequence the list of misconducts
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">



<cfquery name="qGetMisconduct" datasource="#SESSION.DSN#">
	SELECT A.misconduct_id, A.misconduct_descr, A.Misconduct_event, a.seq, Count(b.Game) as usedInGames
	  from tlkp_Misconduct A left outer join V_RefRptDtl b on A.misconduct_id = b.MisconductID
	 Group by A.misconduct_id, A.misconduct_descr, A.Misconduct_event, a.seq
	 order by a.seq
</cfquery>

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
<H1 class="pageheading">NCSA - Sequence Misconducts</H1>
<!--- <h2>yyyyyy </h2> --->

<div style="font-size:1.3em; margin:5px; font-style:italic;">
	Drag and drop to reorder misconducts
</div>
	<cf_sortableTree
		currentNestingClass="currentNesting"
		helperclass="helperNesting"
		queryToSort=#qGetMisconduct#
		idFieldName="misconduct_id"
		displayFieldName="misconduct_descr"
		sequenceFieldName="seq"
		componentName="#session.sitevars.cfcpath#misconduct"
		methodName="updatesequence"
		redirectURL="refereeMisconductList.cfm"
		noNesting=true>


</div>
</cfoutput>
<cfinclude template="_footer.cfm">



 
