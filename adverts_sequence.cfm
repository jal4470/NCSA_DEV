<!--- 
	FileName:	adverts_sequence.cfm
	Created on: 2/11/2011
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
07/31/2017 - apinzone - 22821
-- Fixed sorting by updating plugin and adjusting logic.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<div id="contentText">
<H1 class="pageheading">NCSA - Sequence Advertising</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfinvoke
	component="#application.sitevars.cfcpath#.ad"
	method="getAdsToSequence"
	returnvariable="ads">


<h2>Sequence Advertisements</h2>

<cfsavecontent variable="customCSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css">
	<style type="text/css">
		#sortContainer li{
			font-size: 1.2em;
			margin: 0 3px 3px;
			padding: 0.4em 0.4em 0.4em 1.5em;
			list-style-type:none;
			position: relative;
		}
		#sortContainer li span{
			position: absolute;
			left: 5px; top: 50%;
			margin-top: -8px; /* based on 16x16 icon size */
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#customCSS#">
	
<cfoutput>
	<ul id="sortContainer">
		<cfloop query="ads">
			<li id="adid_#ad_id#" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>ad #ad_id#: #title#</li>
		</cfloop>
	</ul>
	
	<form id="sortForm" action="adverts_sequence_action.cfm" method="post">
		<input type="hidden" name="sequence">
		<input type="submit" name="btnCancel" value="Cancel">
		<input type="submit" name="btnSave" value="Save">
	</form>
</cfoutput>

</div>

<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(function(){
			$('#sortContainer').sortable();
			
			$('#sortForm').submit(function(){
				//serialize sequence
				$('input[name=sequence]').val($('#sortContainer').sortable('serialize'));
			});
		});
	</script>
</cfsavecontent>

<cfinclude template="_footer.cfm"> 
