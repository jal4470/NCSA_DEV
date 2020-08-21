<!---
File: sortableTree.cfm
Created By: Brian Cooper
Date Created: 07/11/2008
Purpose: provide a module to aid in sorting and moving elements within a tree structure
Version: 1.1.1

Attributes REQUIRED:
	queryToSort: 		the query object containing the elements to build the tree
	parentIdFieldName: 	the field name in the query for the parent ID
						Not required if noNesting is true
	IdFieldName: 		the field name in the query for the ID
	displayFieldName: 	the field name in the query of the text to display
	sequenceFieldName: 	the field name in the query to use for initial sorting of the tree
	topLevelID: 		the ID of the top level element in the tree, usually blank or 0 or -1 or something
						Not required if noNesting is true
	componentName:		the name of the component to call to process the serialized tree string
	methodName:			the name of the method used to process the serialized tree string
	redirectURL:		the url to redirect to after completion

Attributes Optional:
	currentNestingClass: the CSS class to use for the current nesting level
	helperClass: 		the CSS class to use to show where the element will be positioned
	noNesting:			boolean indicates if nesting should be allowed/expected.
						If true, sortableTree acts as a linear list sorter.
						Default: false
	acceptClass:		the CSS class used to determine what elements are sortable.  Use this class to change the style of the
						list elements. Copy the .default-sortable-element-class > div selector below to your stylesheet
						and change the name and style as you'd like.
						Default: default-sortable-element-class


Module Dependencies:
	assets/jquery-1.1.4.js
	assets/interface.js
	assets/inestedsortable.js
	assets/jquery.json.js
	sortableTree_action.cfm
	json.cfc

Output:
	Calls method [methodName] in [componentName] with one argument: tree
	tree is a string.
	If noNesting is false, tree is of the format [[nodeID]:[parentNodeID]:[sequence]&]...
		example: '14:1:1&15:1:2&16:15:1&'
		(notice the trailing &)
	If noNesting is true, tree is of the format [[nodeID]:[sequence]&]...

	the called method is used to handle the actual processing and saving of the new tree structure.
	stored procedure examples are included in examples.txt

Uses jQuery nestedsortable plugin
Documentation: http://code.google.com/p/nestedsortables/wiki/NestedSortableDocumentation


CHANGELOG

Version 1.1
-added optional attribute acceptClass

Version 1.1.1 (11/6/08)
-fixed bugs

07/10/2017 A.Pinzone (Ticket NCSA22821)
-- Removed nesting javascript.
-- Updated linear javascript to pass "itemID:sequence" already formatted.
-- Replaced nestedsortable plugin with jQuery Sortable.

 --->

<cfif not (isdefined("attributes.queryToSort") AND isdefined("attributes.componentName")
		AND isdefined("attributes.IdFieldName") AND isdefined("attributes.displayFieldName")
		AND isdefined("attributes.sequenceFieldName") AND isdefined("attributes.methodName"))>
	<cfthrow message="Required attributes missing from sortableTree invocation.">
</cfif>

<cfif not isdefined("attributes.parentIdFieldName") AND (not isdefined("attributes.noNesting") OR attributes.noNesting EQ false)>
	<cfthrow message="Required attributes missing from sortableTree invocation.">
</cfif>

<cfif not isdefined("attributes.topLevelID") AND (not isdefined("attributes.noNesting") OR attributes.noNesting EQ false)>
	<cfthrow message="Required attributes missing from sortableTree invocation.">
</cfif>

 <cfif not isdefined("attributes.redirectURL")>
 	<cfset attributes.redirectURL = "">
 </cfif>

 <cfif not isdefined("attributes.helperClass")>
 	<cfset attributes.helperClass = "">
 </cfif>

 <cfif not isdefined("attributes.currentNestingClass")>
 	<cfset attributes.currentNestingClass = "">
 </cfif>

 <cfif not isdefined("attributes.topLevelID")>
 	<cfset attributes.topLevelID = "">
 </cfif>

 <cfif not isdefined("attributes.noNesting")>
 	<cfset attributes.noNesting=false>
 </cfif>

 <cfif not isdefined("attributes.acceptClass")>
 	<cfset attributes.acceptClass="default-sortable-element-class">
 </cfif>

<style type="text/css">
 	#sortable-list-container{
		list-style-type:none;
		list-style-image:none;
	}
 	#sortable-list-container li {
		list-style-type:none;
		list-style-image:none;
	}
	#sortable-list-container li > span {
		background-color: #f8f8f8;
		display:block;
		margin: 5px;
		padding: 3px;
		color:black;
	}
 	#sortable-list-container .sort-pointer{
		cursor:move;
	}
	.sortable-list-page-list{
		display:block;
		list-style-image:none;
		list-style-position:outside;
		list-style-type:none;
		margin:0pt;
		padding:0pt;
	}

	body.dragging, 
	body.dragging * {
  		cursor: move !important }

	.dragged {
	  position: absolute;
	  opacity: .5;
	  z-index: 2000; }
</style>


<cfoutput>

	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/vendor/jquery.sortable.js"></script>

	<script language="JavaScript">
		var jq = $.noConflict();
		jq(document).ready(function($){

			var adjustment;

			var sort = $("##sortable-list-container").sortable({
			  group: 'simple_with_animation',
			  pullPlaceholder: false,
			  // animation on drop
			  onDrop: function  ($item, container, _super) {

			  	// Serialize data and initialize array
			  	var myObject = sort.sortable("serialize"),
			  		sortOrder = [];

			  	// Pass order to array with "itemID:sequence" format
			  	for ( var i = 1; i < myObject[0].length; i++ ) {
			  		sortOrder.push( myObject[0][i]['itemId'] + ':' + i );
			  	}

			  	// Update hidden tree input w/ json packet
			  	$('input[name=tree]').val(JSON.stringify(sortOrder));

			    var $clonedItem = $('<li/>').css({height: 0});
			    $item.before($clonedItem);
			    $clonedItem.animate({'height': $item.height()});

			    $item.animate($clonedItem.position(), function  () {
			      $clonedItem.detach();
			      _super($item, container);
			    });

			  },

			  // set $item relative to cursor position
			  onDragStart: function ($item, container, _super) {
			    var offset = $item.offset(),
			        pointer = container.rootGroup.pointer;

			    adjustment = {
			      left: pointer.left - offset.left,
			      top: pointer.top - offset.top
			    };

			    _super($item, container);
			  },
			  onDrag: function ($item, position) {
			    $item.css({
			      left: position.left - adjustment.left,
			      top: position.top - adjustment.top
			    });
			  }
			});

			function viewData() {
				var treeData = $("##sortable-list-container").sortable('serialize');
				console.log(treeData);
			}

		});
	</script>
</cfoutput>

	<!--- build list here --->
	<cfif not isdefined("attributes.noNesting") OR attributes.noNesting EQ false>
		<cfquery dbtype="query" name="getTop">
			select #attributes.parentIdFieldName#, #attributes.IdFieldName#, #attributes.displayFieldName#, #attributes.sequenceFieldName#
			from attributes.queryToSort
			where <cfif attributes.topLevelID EQ "">#attributes.parentIdFieldName# is null<cfelse>#attributes.parentIdFieldName# = #attributes.topLevelID#</cfif>
			order by #attributes.sequenceFieldName#
		</cfquery>

		<cfset buildList(getTop, true)>
	<cfelse>
		<cfquery dbtype="query" name="sortedQuery">
			select * from attributes.queryToSort
			order by #attributes.sequenceFieldName#
		</cfquery>
		<cfset buildLinearList(sortedQuery)>
	</cfif>


	<cfoutput>
		<form name="sortableListForm" action="sortableTree_action.cfm" method="post" style="margin-top:20px;">
			<input type="Hidden" name="tree" value="">
			<input type="hidden" name="listID" value="sortable-list-container">
			<input type="Hidden" name="componentName" value="#attributes.componentName#">
			<input type="Hidden" name="methodName" value="#attributes.methodName#">
			<input type="Hidden" name="redirectURL" value="#attributes.redirectURL#">
			<input type="Hidden" name="noNesting" value="#iif(isdefined("attributes.noNesting"),attributes.noNesting,false)#">
			<input type="button" value="Cancel" onClick="window.location='#attributes.redirectURL#';">&nbsp;<input type="Submit" value="Save">
		</form>
	</cfoutput>
	<noscript>
		you don't have scripting enabled. Javascript must be enabled in order to use this page.
	</noscript>



<cffunction access="private" name="buildList">
	<cfargument name="list" type="query" required="Yes">
	<cfargument name="topFlag" type="boolean" default="false">

	<cfset var childQry = "">
	<cfset var thisid = "">

	<cfoutput>
		<!--- <cfdump var=#arguments.list#> --->
		<ul class="sortable-list-page-list" <cfif arguments.topFlag>id="sortable-list-container"</cfif>>

			<cfloop query="arguments.list">

				<cfset idvalue = #arguments.list[attributes.idFieldName]#>
				<cfset displayname = #arguments.list[attributes.displayFieldName]#>
				<cfset displayname = replace(replace(displayname,">","","all"),"<","","all")>
				<cfset thisid = #arguments.list[attributes.idFieldName]#>
				<li class="#attributes.acceptClass# sort-pointer" id="sortable-list-element-#idvalue#">
					<span>#displayname#</span>

					<!--- get children --->
					<cfquery dbtype="query" name="childQry">
						select #attributes.parentIdFieldName#, #attributes.IdFieldName#, #attributes.displayFieldName#,
							#attributes.sequenceFieldName#
						from attributes.queryToSort
						where #attributes.parentIdFieldName# = #thisid#
						order by #attributes.sequenceFieldName#
					</cfquery>
					<cfset buildList(childQry)>
				</li>
			</cfloop>
		</ul>
	</cfoutput>
</cffunction>

<cffunction access="private" name="buildLinearList">
	<cfargument name="list" type="query" required="Yes">

	<cfoutput>
		<ul class="sortable-list-page-list" id="sortable-list-container">

			<cfloop query="arguments.list">

				<cfset idvalue = #arguments.list[attributes.idFieldName]#>
				<cfset displayname = #arguments.list[attributes.displayFieldName]#>
				<cfset displayname = #htmleditformat(displayname)#>
				<li class="#attributes.acceptClass# sort-pointer" id="sortable-list-element-#idvalue#" data-item-id="#idvalue#">
					<span>#displayname#</span>
				</li>
			</cfloop>
		</ul>
	</cfoutput>

</cffunction>