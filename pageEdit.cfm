<!--- 
	FileName:	pageEdit.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/16/2009 - aarnone - modified page to limit "Games Conduct Chairman role" to edit "Games Conduct Page" only.
5/27/2010 B. Cooper
8005 - added contact us and faq to page content editor
10/9/2018 - M Greenberg (NCSA27076)
-article re-architure

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<style>
	.row{
		margin-bottom: 20px;}
	.Heading{
		margin: 0px 0px 10px 0px;
		line-height: 100%;}
	.page{
		margin: 5px 0px 5px 10%;}
	.fa-plus-square{
		font-size: 25px;
		padding-left: 20px;}
	#add:hover,
	#add:focus{
      text-decoration: none;
      color: #726102;}
	#add{
		color:#9A8206;}
	.imagepreview.active{
		display: block;
		height:10%;
	}
	.previewBtn{
		color: #1a1a1a;
		border-color: #1a1a1a;
		margin-left: 10px;
	}
	.previewBtnAdd{
		color: #1a1a1a;
		border-color: #1a1a1a;
		margin-left: 10px;
	}
	.previewPopup {
	  display:none;
	  overflow-y: auto;
/*	  max-height: 100%;*/}
	.pageSections{
		border: 1px solid #eee;
		border-radius: 0px 0px 15px 15px;
		margin-bottom: 5px;
	}
  .pageSections.active {
    border-radius: 2px 10px;
    margin: 0;
    overflow-y: scroll;
    position: fixed;
    top: 5%; 
    left: 20%; right: 20%;
   	z-index: 102;
    width: 65%;
	max-height: 90%; }
   .pageSections > .container {
	 	padding: 20px; }
 .Heading, #label, #mceu_15{
	display: block;
	  }
.pageSections.active > .container {
    height:100%;
    padding: 100px 20px 20px 20px; }
.pageSections.active .Heading,.pageSections.active #label,.pageSections.active #mceu_15{
	display: none;
  }
.pageSections.active  .PopTitle{
	padding-right: 30px;
/*		background: #efefef;*/
	position: relative;
	transform: translateY(7%);
/*		border-bottom: 1px solid #ddd;*/
	margin: -20px -20px 10px;
	padding: 15px;
	border-radius: 4px;
  	}
 .pageSections.active .PopValue{
	background: #fff;
	padding: 10px;
	}
.pageSections.active .sectionTitle{
	color: #9a8206;
	font-size: 1.5em;
	padding-bottom: 5px;
	text-transform: uppercase;
	background: #eaeaea;
	width: 100%;
	text-align: center;
	resize: none;
	margin-left: 20px;
	border: 1px solid #eaeaea;
} 
.pageSections.active .sectionContent{
/*		color: #9a8206;*/
	white-space: pre;
	line-height: 1.3;
	display: block;
	font-size: 1.2em;
	padding-bottom: 5px;
	width: 95%;
	text-align: left;
	resize: none;
	margin-left: 20px;
	margin-right: 20px;
	min-height: 250px;
/*	max-height: 1000px;*/
	max-height: 95%;
	} 
	.pageSections.active .sectionContent p br {
		content: ' ';}
	.pageSections.active .sectionContent p br:after {
		content: ' ';}
	.pageSections.active .container_modal{
		background: #eaeaea;
/*		margin-left: 15%;*/
	}
	.pageSections.active .closebtn{
		display:inline;
		border: 0;
		font-size: 1.4em;
		height: 40px;
		min-width: 0;
		text-align: center;
		width: 40px;
		background-color: #9a8206;
	}
/*	Add style*/
	.pageSectionsAdd.active {
    border-radius: 2px 10px;
    margin: 0;
    overflow-y: scroll;
    position: fixed;
    top: 5%; 
    left: 20%; right: 20%;
   	z-index: 102;
    width: 65%;
	max-height: 90%; }
   .pageSections > .container {
	 	padding: 20px; }
 .Heading, #label, #mceu_15{
	display: block;
	  }
.pageSectionsAdd.active > .container {
    height:100%;
    padding: 100px 20px 20px 20px; }
.pageSectionsAdd.active .Heading,.pageSectionsAdd.active #label,.pageSectionsAdd.active #mceu_15{
	display: none;
  }
.pageSectionsAdd.active  .PopTitle{
	padding-right: 30px;
/*		background: #efefef;*/
	position: relative;
	transform: translateY(7%);
/*		border-bottom: 1px solid #ddd;*/
	margin: -20px -20px 10px;
	padding: 15px;
	border-radius: 4px;
  	}
 .pageSectionsAdd.active .PopValue{
	background: #fff;
	padding: 10px;
	}
.pageSectionsAdd.active .sectionTitle{
	color: #9a8206;
	font-size: 1.5em;
	padding-bottom: 5px;
	text-transform: uppercase;
	background: #eaeaea;
	width: 100%;
	text-align: center;
	resize: none;
	margin-left: 20px;
	border: 1px solid #eaeaea;
} 
.pageSectionsAdd.active .sectionContent{
/*		color: #9a8206;*/
	white-space: pre;
	line-height: 1.3;
	display: block;
	font-size: 1.2em;
	padding-bottom: 5px;
	width: 95%;
	text-align: left;
	resize: none;
	margin-left: 20px;
	margin-right: 20px;
	min-height: 250px;
/*	max-height: 1000px;*/
	max-height: 95%;
	} 
	.pageSectionsAdd.active .sectionContent p br {
		content: ' ';}
	.pageSectionsAdd.active .sectionContent p br:after {
		content: ' ';}
	.pageSectionsAdd.active .container_modal{
		background: #eaeaea;
/*		margin-left: 15%;*/
	}
	.pageSectionsAdd.active .closebtn{
		display:inline;
		border: 0;
		font-size: 1.4em;
		height: 40px;
		min-width: 0;
		text-align: center;
		width: 40px;
		background-color: #9a8206;
	}
	.closebtn{
		border: 2px solid #9a8206;
		border-radius: 2px 10px;
		color: #fff;
		cursor: pointer;
		display: none;
		line-height: 30px;
		margin: 0;
		text-align: center;
	}
	.pageSections.active iframe{
		height: 400px;
	}
	.pageSections.active .pageSections{
		display: none;
		width: 0px;
		height: 0px;
	}
	.pageSections.active .row{
		margin-bottom: 0px;
	}
	.pageSections.active .Image{
		display: none;
	}

	.pageSectionsAdd.active iframe{
		height: 400px;
	}
	.pageSectionsAdd.active .pageSectionsAdd{
		display: none;
		width: 0px;
		height: 0px;
	}
	.pageSectionsAdd.active .row{
		margin-bottom: 0px;
	}
	.pageSectionsAdd.active .Image{
		display: none;
	}
	.imageLabel {
		width:85%;
		padding-left: 10px;
		padding-bottom: 5px;
		float: right;
	}
	a.image_title>.imageLabel { display: none; }
	a.image_title:hover>.imageLabel { display: block; }

	.dropdown-wrapper{
	  width:100%;
	}
	.dropdown-wrapper .image-select {
	    padding: 12px 25px 12px 25px;
	    position: relative;
	    border: 1px solid #ccc;
	    height: 40px;
	    width: 40%;
	}
	.image-select:after{
	    background: #fff;
	    color: #777;
	    content: '\f107';
	    cursor: pointer;
	    font-family: 'FontAwesome';
	    font-size: 1.7em;
	    height: 36px;
	    line-height: 36px;
	    pointer-events: none;
	    position: absolute;
	      top: 1px; right: 1px;
	    text-align: center;
	    width: 36px; 
	}
	.dropdown-wrapper .image-select.chosen {
	    color: #333;
	}
	.dropdown-wrapper .image-select .down-icon, .image-select .up-icon {
	    position: absolute;
	    right: 8px;
	    top: 7px;
	}
	.dropdown-wrapper .image-dropdown .dropdown-menu {
	    background: #fffef3;
	    box-shadow: none;
	    border-radius: 0px;
	}
	.dropdown-wrapper .image-dropdown .image-select, .dropdown-wrapper .image-dropdown .dropdown-menu>li {
	    cursor: pointer;
	}
	.dropdown-wrapper .image-dropdown .dropdown-menu>li>a:focus, .dropdown-wrapper .image-dropdown .dropdown-menu>li>a:hover {
	    background: none;
	}
	.dropdown-wrapper .image-disabled{
	    pointer-events: none;
	}
	.image-hide{
	  display:none;
	}
	ul.dropdown-menu{
	  list-style-type: none;
	}
	ul.dropdown-menu{
	  margin:0px;
	  padding:5px;
	  border: 1px solid #ccc;

	}
	ul.dropdown-menu li{
	  padding:5px 0px;
	}
	.red_btn{
		background-color: #ff3333;
		margin: 5px 0px 5px 5px;
		border-color:gray;
	}
	.modal_hidden{
		display:none;
	}
	.modal_active{
		display:block;
	}
</style>
<cfoutput>
<div id="contentText">

<CFIF SESSION.MENUROLEID EQ 20>
	<cfset pageTitle="NCSA – Games Conduct Page Edit">
	<cfset restrictGC=true>
<cfelse>
	<cfset pageTitle="NCSA - Page Edit">
	<cfset restrictGC=false>
</CFIF>
<H1 class="pageheading">#pageTitle#</H1>
<br>	<!---  <h2>yyyyyy </h2> --->

<CFIF isDefined("FORM.PAGEID")>
	<cfset pageIDselected = FORM.PAGEID>
<cfelse>
	<cfset pageIDselected = 0>
</CFIF>

<cfquery name="qPages" datasource="#SESSION.DSN#" >
	SELECT PAGEID, PAGENAME
	  FROM TBL_PAGE
	  order by pagename
</cfquery>

<cfquery name="PageImage" datasource="#SESSION.DSN#">
  SELECT image_id, image_desc, image_path
      FROM tlkp_page_section_image
   order by image_desc
</cfquery>


<cfquery name="getSectionID" datasource="#SESSION.DSN#" >
	SELECT MAX(sectionID) as maxSectionID
	  FROM TBL_PAGE_SECTION
</cfquery>

<cfif PAGEIDSELECTED GT 0>
<!--- 
get the max Page Order Number --->
<cfquery name="getMaxPage" datasource="#SESSION.DSN#" >
	SELECT max(pageOrder) as maxPage
	  FROM TBL_PAGE_SECTION
	  where pageID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.pageIDselected#">
</cfquery>

<cfset newPageorder = getMaxPage.maxPage + 1> 
</cfif>

<cfquery name="getImage" datasource="#SESSION.DSN#">
  SELECT image_id, image_desc, image_path
      FROM tlkp_page_section_image
</cfquery>

<!--- <cfdump var="#form#"> --->
<!--- added to make sure sectionID is correct, did not always give correct sectionID on save --->
<CFIF isDefined("FORM.maxID")>
	<cfset newMaxSectionID = form.maxID> 
<cfelse>
	<cfset newMaxSectionID = getSectionID.maxSectionID + 1> 
</CFIF>
<cftry>
<CFIF isDefined("form.FIELDNAMES") and FindNoCase("DeleteThis_",form.FIELDNAMES)>
	<cfset deleteSectionID = ListLast(ListGetAt(form.fieldNames,ListContainsNoCase(form.FIELDNAMES,"DeleteThis_")),"_")>
	<CFQUERY name="deleteSectionName" datasource="#SESSION.DSN#">
		Delete from TBL_PAGE_SECTION where sectionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deleteSectionID#">
	</CFQUERY> 
<CFELSEIF isDefined("form.FIELDNAMES") and FindNoCase("Save_",form.FIELDNAMES)> 

	<CFLOOP collection="#FORM#" item="iFm">
		<!--- loop form looking for "SAVE"s --->
		<CFIF ucase(listFirst(ifm,"_")) EQ "SAVE">
			<!--- "save" was found, get ID and look for newcontent --->
			<cfset updSectionID = listLast(ifm,"_")>
			<CFLOOP collection="#FORM#" item="iCon">
				<cfif ucase(listFirst(iCon,"_")) EQ "SAVE" AND listLast(iCon,"_") EQ newMaxSectionID>
					<CFQUERY name="qCreateSectionName" datasource="#SESSION.DSN#">
						INSERT INTO TBL_PAGE_SECTION (sectionID,pageID,pageOrder,sectionName,sectionValue,image_id)
						VALUES (
							<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#newMaxSectionID#">,
							<cfqueryparam cfsqltype="CF_SQL_INTEGER"  value="#PAGEIDSELECTED#">,
							<cfqueryparam cfsqltype="CF_SQL_INTEGER"  value="#newPageorder#">,
							<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="">,
							<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="">,
							<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="1">)
					</CFQUERY>
				</cfif>
<!--- 				<cfif ucase(listFirst(iCon,"_")) EQ "DELETE" AND listLast(iCon,"_") EQ updSectionID>
					<CFQUERY name="qCreateSectionName" datasource="#SESSION.DSN#">
						DELETE FROM TBL_PAGE_SECTION 
						where sectionID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#updSectionID#">
					</CFQUERY>
				</cfif>
 --->				<cfif ucase(listFirst(iCon,"_")) EQ "NEWSECTVAL" AND listLast(iCon,"_") EQ updSectionID>
					<!--- WE FOUND THE CONTENT --->
					<cfset updSectionVal = trim(FORM[iCon]) >
					<CFQUERY name="qUpdateSection" datasource="#SESSION.DSN#">
						UPDATE TBL_PAGE_SECTION
						   SET sectionValue = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#updSectionVal#">
						 WHERE sectionID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#updSectionID#">
					</CFQUERY>
				</cfif>
				<cfif ucase(listFirst(iCon,"_")) EQ "IMAGEID" AND listLast(iCon,"_") EQ updSectionID>
					<!--- WE FOUND THE CONTENT --->
					<cfset updImageId = trim(FORM[iCon]) >
					<CFQUERY name="qUpdateSection" datasource="#SESSION.DSN#">
						UPDATE TBL_PAGE_SECTION
						   SET image_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#updImageId#">
						 WHERE sectionID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#updSectionID#">
					</CFQUERY>
				</cfif>
				<cfif ucase(listFirst(iCon,"_")) EQ "NEWSECTNAME" AND listLast(iCon,"_") EQ updSectionID>
					<!--- WE FOUND THE SECTION NAME --->
					<cfset updSectionName = trim(FORM[iCon]) >
					<CFQUERY name="qUpdateSectionName" datasource="#SESSION.DSN#">
						UPDATE TBL_PAGE_SECTION
						   SET sectionName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#updSectionName#">
						 WHERE sectionID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#updSectionID#">
					</CFQUERY>
				</cfif>
			</CFLOOP>
		</CFIF>	

	</CFLOOP>
</CFIF>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>

<FORM action="pageEdit.cfm" method="post" id="pageEdit">

	<CFIF restrictGC>
		<!--- This page is being accessed by the GAMES CONDUCT CHAIR, so limit to games conduct page --->
		<cfquery name="qGameCondPage" dbtype="query">
			SELECT PAGEID 
			  FROM qPages
			 WHERE PAGENAME = 'Games Conduct'
		</cfquery>
		
		<CFSET pageIDselected = qGameCondPage.PAGEID>
		<input type="Hidden" name="pageID" value="#pageIDselected#">
	<CFELSE>

		<!--- all others --->
		<label class="select_label" for="clubid">Select a page and click Enter to see the page's content</label>
		<div class="select_box">
			<select id="pageid" name="pageID">
				<option value="0">Select a Page...</option>
					<CFLOOP query="qPages">
						<option value="#PAGEID#" <cfif pageIDselected eq PAGEID>selected</cfif>  >#PAGENAME#</option>
					</CFLOOP>
			</select>
		</div>
		<button type="submit" name="getTeams" class="gray_btn select_btn">Enter</button>
	</CFIF>

	<CFIF pageIDselected GT 0>

		<cfquery name="qPageName" dbtype="query" >
			SELECT pageNAme  FROM qPages  WHERE pageID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.pageIDselected#">
		</cfquery>

		<h3 class="viewing_info"><span>Viewing:</span> #qPageName.pageNAme#<br></h3>

		<p style="margin-bottom: 20px;">Section Title and Section Values for #qPageName.pageNAme#  </p>

			<cfquery name="qPageSections" datasource="#SESSION.DSN#" >
				SELECT sectionID, pageID, pageOrder, sectionName, sectionValue, image_id
			  	  FROM TBL_PAGE_SECTION
				 WHERE pageID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.pageIDselected#">
				 ORDER BY pageOrder
			</cfquery>
			<!--- <cfdump var="#qPageSections#"> --->
		<div id="add_div"><!--- needed div for add button functionality --->
 		<cfloop query="qPageSections">
 			<div class="pageSections">
 				<div class="container_modal">
				<div class="Heading" data-page-order="#PageOrder#" data-max-id="#newMaxSectionID#">
					Number #PageOrder#
					<button type="submit" class="yellow_btn page" value="Submit" id="submit" size="38" name="Save_#sectionID#" >Save</button>
					<button type="button" class="grey_btn previewBtn" value="Preview" size="38" name="preview_#sectionID#"  data-section-id="#sectionID#" >Preview</button>
					<button type="submit" class="red_btn delete" id="delete" value="Delete" size="38" name="DeleteThis_#SECTIONID#" data-section-id="#SECTIONID#" >Delete</button>
					<div class="closebtn"><i class="fa fa-times" aria-hidden="true"></i></div>
				</div>
				<div class="row PopTitle">
					<div class="col">
						<div id="label"><label>Section Title</label></div>
						<textarea class="sectionTitle" name="newSectName_#sectionID#"  cols="85" rows="1">#htmleditformat(sectionName)#</textarea>
					</div>
				</div>
				<div class="row PopValue">
					<div class="col valueCol">
						<div id="label"><label>Section Content</label></div>
						<div id="divtextboxVal_#sectionID#"><textarea class="sectionContent" name="newSectVal_#sectionID#" cols="85" rows="5">#htmleditformat(sectionValue)#</textarea></div>
					</div>
				</div>

				<div class="row Image">
					<div class="col">
						<div id="label"><label>Section Image</label></div>
							<div class="dropdown-wrapper">
							<div class="image-dropdown dropdown" data-section-id="#sectionID#">
								<div class="image-select">
									<span class="image-select-content image-#sectionID#" name="ImageID_#qPageSections.sectionID#"></span>
									<i class="fa fa-angle-down down-icon"></i>
								</div>
								<ul id="imageid" class="dropdown-menu dropdown-#sectionID# image-hide">
								<CFLOOP query="PageImage">
								 <cfquery name="getImage" datasource="#SESSION.DSN#">
							      SELECT image_id, image_desc, image_path
							          FROM tlkp_page_section_image
							       WHERE image_id = <cfqueryparam cfsqltype="cf_sql_integer" VALUE="#qPageSections.image_id#">
							    </cfquery>
										<li value="#image_id#" name="ImageID_#qPageSections.sectionID#" <cfif qPageSections.image_id eq image_id> class="selected"<cfelseif qPageSections.image_id EQ "" AND image_id EQ 1>class="selected"</cfif>><label for="Image"><a class="image_title">#image_desc#<img src="#image_path#" class="imageLabel" /></a></label></li>								
									</CFLOOP>
								</ul>
							</div><!--- image-dropdown dropdown --->
							</div><!--- dropdown-wrapper --->
						</div><!--- col --->
					</div><!--- Row Image --->
				</div><!--- container_modal	 --->		
			</div><!--- Page Sections --->
		</cfloop>
		</div><!--- add_div --->
	<p style="margin-bottom: 20px;" ><a id="add"><i class="fa fa-plus-square"></i>&nbsp;<strong>Add another section</strong></a></p>
	</CFIF>		
</FORM>

</cfoutput>
</div>

<div id="calendar_popup modaldelete" class="modal modal_hidden">
	<hgroup id="modal_title">
		<h2>Are you sure you want to delete this section?</h2>
	</hgroup>
	<Cfoutput>
		<button id="calendar_close"  class="gray_btn" type="button">Cancel</button>
		<button id="calendar_submit" class="yellow_btn" type="submit">Send Email</button>
	</Cfoutput>
</div>


<cfsavecontent variable="cf_footer_scripts">
<!--- <script src="//cdn.tinymce.com/4/tinymce.min.js"></script> --->

<script src="js\vendor\tinymce\tinymce.min.js"></script>

<script>
$(function() {

	$('.delete').click(function(event){
		// $('#modaldelete').removeClass('modal_hidden');
		// $('#modaldelete').addClass('modal_active');
		// $('#veil').addClass('active');

		return confirm("are you sure you want to delete this article?");
	});
	//creates another div for entering new page content
	$('#add').on('click', function(event){
		 event.preventDefault();
		 var pageOrder = ($('.Heading').last().data('page-order')) + 1;
		 var sectionID = ($('.Heading').last().data('max-id'));
		 var content = "<div class='pageSectionsAdd'><div class='container_modal'><div class='Heading' data-page-order='" + pageOrder + "'data-max-id='" + sectionID +"'>Number " + pageOrder + "<button type='submit' id='submit' class='yellow_btn page' value='Submit' size='38' name='Save_" + sectionID + "' onclick=''>Save</button><button type='button' class='grey_btn previewBtnAdd' value='Preview' size='38' name='preview_" + sectionID +  "' data-section-id='"+sectionID+"' onclick=''>Preview</button></div><div class='row PopTitle'><div class='col'><div id='label'><label>Section Title</label></div><textarea class='sectionTitle' name='newSectName_"+ sectionID +"' value='' cols='85' rows='1'></textarea></div></div><div class='row PopValue'><div class='col'><div id='label'><label>Section Content</label></div><textarea class='sectionContent' name='newSectVal_" + sectionID + "' value='' cols='85' rows='5'></textarea></div></div><div class='row Image'><div class='col'><div id='label'><label>Section Image</label></div><div class='dropdown-wrapper'><div class='image-dropdown dropdown' data-section-id='" + sectionID + "'><div class='image-select'><span class='image-select-content image-" + sectionID + "'></span><i class='fa fa-angle-down down-icon'></i></div><ul id='imageid' class='dropdown-menu dropdown-" + sectionID + " image-hide' name='ImageID_" + sectionID + "'><CFLOOP query='PageImage'><li value='<cfoutput>#image_id#</cfoutput>' <cfif image_id eq 1> class='selected'</cfif>><label for='Image'><a><cfoutput>#image_desc#</cfoutput><img src='<cfoutput>#image_path#</cfoutput>' class='imageLabel'></a></label></li></CFLOOP></ul></div></div></div></div></div>";
		 $('#add_div').append(content);

		 // needed for dropdown, picks the selected image from dropdown
		 $('.dropdown').each(function(i){
			var ID = $(this).data('section-id')
			$('.image-'+ ID).text($('.dropdown-' + ID +'> li.selected').text());
		});

		 $('.image-dropdown').on('click',function() {
			var ID = $(this).data('section-id')
			var downdown = '.dropdown-' + ID; 
		  	$('.dropdown-' + ID).toggleClass('image-hide');
		  	$('.image-'+ ID).text($('.dropdown-' + ID +'> li.selected').text());
			var newOptions = $('.dropdown-' + ID +' > li');
		
		 newOptions.on('click',function() {
		  $('.image-'+ ID).text($(this).text());
		  $('.dropdown-' + ID +' > li').removeClass('selected');
		  $(this).addClass('selected');
		});
		});

	$(".previewBtnAdd").click(function(event){
	event.preventDefault();
	var sectionValue = $(this).closest('.pageSectionsAdd');
	console.log(sectionValue);
	var content = $(this).closest('.sectionContent');
	var ID = $(this).data('section-id');
	var sectionVal = 'divtextboxVal_' + ID;
	var newsectionVal = 'newSectVal_' + ID;

	    if ( sectionValue.hasClass('active') ) {
	      sectionValue.removeClass('active');
	      $('#veil').removeClass('active');
	      $('textarea').prop('disabled', false);
	      var textArea = $('<textarea class="sectionContent" name="'+newsectionVal+'" cols="85" rows="5" />');
      	  var oldText = $('#'+sectionVal).html();
      	  $('#'+sectionVal).replaceWith(textArea);
	       $(textArea).empty().append(oldText);
	       tinyMCE.get(sectionVal).setContent(oldText);
	       addTinyMCE();
	    }
	    //create text for modal
	    else  {
	      sectionValue.addClass('active');
	      $('#veil').addClass('active');
	      tinymce.remove('.sectionContent');
	      $('textarea').prop('disabled', true);
	      var div = $('<div id="'+ sectionVal +'" />');
	      //needed due to html needed on second and above creation fo modal
	      if(!$('textarea').hasClass("modal_text")){
			var oldText = $('#'+sectionVal).text();
	      }else{
	      	var oldText = $('#'+sectionVal).html();
	      }
	   //   console.log(oldText);
      	  $('#'+sectionVal).replaceWith(div);
      	  $(div).empty().append(oldText);	
	    }
	    //if veil is clicked
	    $('#veil').click(function(){
	      sectionValue.removeClass('active');
	      $('#veil').removeClass('active');
	      $('html, body').removeClass('locked');
	      $('textarea').prop('disabled', false);
	      var textArea = $('<textarea class="sectionContent modal_text" name="'+newsectionVal+'" id="'+sectionVal+'"cols="85" rows="5">');
      	  var oldText = $('#'+sectionVal).html();
      	  $('#'+sectionVal).replaceWith(textArea);
      	  addTinyMCE();
      	  $(textArea).empty().append(oldText);
      	  tinyMCE.get(sectionVal).setContent(oldText);
      	  //created texarea but does not show, as TinyMCE shows
      	  $(textArea).css('display', 'none');


	    });

		scrollLock();

 	});

  	 });
	
  $(".previewBtn").click(function(event){
	event.preventDefault();
	var sectionValue = $(this).closest('.pageSections');
	var content = $(this).closest('.sectionContent');
	var ID = $(this).data('section-id');
	var sectionVal = 'divtextboxVal_' + ID;
	var newsectionVal = 'newSectVal_' + ID;

	    if ( sectionValue.hasClass('active') ) {
	      sectionValue.removeClass('active');
	      $('#veil').removeClass('active');
	      $('textarea').prop('disabled', false);
	      var textArea = $('<textarea class="sectionContent" name="'+newsectionVal+'" cols="85" rows="5" />');
      	  var oldText = $('#'+sectionVal).html();
      	  $('#'+sectionVal).replaceWith(textArea);
	       $(textArea).empty().append(oldText);
	       tinyMCE.get(sectionVal).setContent(oldText);
	       addTinyMCE();
	       // $(textArea).empty().append(oldText);
	       // tinyMCE.get(sectionVal).setContent(oldText);
	    }
	    //create text for modal
	    else  {
	      sectionValue.addClass('active');
	      $('#veil').addClass('active');
	      tinymce.remove('.sectionContent');
	      $('textarea').prop('disabled', true);
	      var div = $('<div id="'+ sectionVal +'" />');
	      //needed due to html needed on second and above creation fo modal
	      if(!$('textarea').hasClass("modal_text")){
			var oldText = $('#'+sectionVal).text();
	      }else{
	      	var oldText = $('#'+sectionVal).html();
	      }
      	  $('#'+sectionVal).replaceWith(div);
      	  $(div).empty().append(oldText);	
	    }
	    //if veil is clicked
	    $('#veil').click(function(){
	      sectionValue.removeClass('active');
	      $('#veil').removeClass('active');
	      $('html, body').removeClass('locked');
	      $('textarea').prop('disabled', false);
	      var textArea = $('<textarea class="sectionContent modal_text" name="'+newsectionVal+'" id="'+sectionVal+'"cols="85" rows="5">');
      	  var oldText = $('#'+sectionVal).html();
      	  $('#'+sectionVal).replaceWith(textArea);
      	  addTinyMCE();
      	  $(textArea).empty().append(oldText);
      	  tinyMCE.get(sectionVal).setContent(oldText);
      	  //created texarea but does not show, as TinyMCE shows
      	  $(textArea).css('display', 'none');


	    });

		scrollLock();

 	});

  	$('#submit').on('click', function(event){
		var NewsectionID = ($('.Heading').last().data('max-id')) + 1;
		$('#pageEdit').append(	'<input type="Hidden" name="maxID" value="'+ NewsectionID +'">' );
	});
  	//locks page so you can't scroll
	function scrollLock() {
    var page = $('html, body');

    if (page.hasClass('locked')) {
      page.removeClass('locked');
    }
    else {
      page.addClass('locked');
    }
  } 
});

// creates each line item for dropdown 
$('.dropdown').each(function(i){
	var ID = $(this).data('section-id')
	$('.image-'+ ID).text($('.dropdown-' + ID +'> li.selected').text());
});
// creates actual dropdown
$('.image-dropdown').click(function() {
	var ID = $(this).data('section-id')
	var downdown = '.dropdown-' + ID; 
  	$('.dropdown-' + ID).toggleClass('image-hide');
  	$('.image-'+ ID).text($('.dropdown-' + ID +'> li.selected').text());
	var newOptions = $('.dropdown-' + ID +' > li');

newOptions.click(function() {
  $('.image-'+ ID).text($(this).text());
  $('.dropdown-' + ID +' > li').removeClass('selected');
  $(this).addClass('selected');
  var selected = $(this).val()
  //adds hidden input to update DB
  $('#pageEdit').append('<input type="Hidden" name="ImageID_'+ID+'" value="'+selected+'">' );
});

});

</script>
  <script>
  	tinymce.init({ 
  		selector:'.sectionContent',
  		menubar: false,
  		statusbar: false,
  		height: 200,
  		plugins: [
		    'advlist autolink lists link image charmap print preview anchor',
		    'searchreplace visualblocks code fullscreen',
		    'insertdatetime media table contextmenu paste code'
		  ],
  		toolbar: 'undo redo | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image'
  	});
  	//added TinyMCE for modal
  	function addTinyMCE(){  	
  	tinymce.init({ 
  		selector:'.sectionContent',
  		menubar: false,
  		statusbar: false,
  		height: 200,
  		plugins: [
		    'advlist autolink lists link image charmap print preview anchor',
		    'searchreplace visualblocks code fullscreen',
		    'insertdatetime media table contextmenu paste code'
		  ],
  		toolbar: 'undo redo | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image'
  	});}
  </script>
</cfsavecontent>
<cfinclude template="_footer.cfm">