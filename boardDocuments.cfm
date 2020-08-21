<!--- 
	FileName:	refFormsDnld.cfm
	Created on: 02/27/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
5/28/2010 B. Cooper
8005 - added external links to forms manager

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<!--- <div id="contentText">

<cfoutput>
<H1 class="pageheading">NCSA - Referee Forms</H1>
<br>
<br> #repeatString("&nbsp;",5)# <A href="http://images.ussoccer.com/Documents/cms/ussf/referee%20game%20report.doc">USSF Match Report and Supplemental Report</A> &nbsp;(.doc)
<br>
<br> #repeatString("&nbsp;",5)# <A href="http://images.ussoccer.com/Documents/cms/ussf/doc_6_290.doc">USSF Assessment of Game Officials</A> &nbsp;(.doc)
<br>
<br> #repeatString("&nbsp;",5)# <A href="http://images.ussoccer.com/Documents/cms/ussf/doc_6_292.doc">USSF Assessor Feedback Form</A> &nbsp;(.doc)
<br>
<br> #repeatString("&nbsp;",5)# <A href="#SESSION.sitevars.docPath#REFeval.doc">Referee evaluation</A> &nbsp;(.doc)
<br>
<br> #repeatString("&nbsp;",5)# <A href="#SESSION.sitevars.docPath#matchdayform.doc">Match Day Form</A> &nbsp;(.doc)
<br>
<br> #repeatString("&nbsp;",5)# <A href="#SESSION.sitevars.docPath#Unpaid_Refree_Form.doc">Unpaid Refree Form</A> &nbsp;(.doc)
<br>
<!--- <br> #repeatString("&nbsp;",5)# <A href="#SESSION.sitevars.docPath#NCSA_Rules_Fall2008.doc">NCSA Rules of Competition </A> &nbsp;(.doc) --->
<br> #repeatString("&nbsp;",5)# <A href="#SESSION.sitevars.docPath#NCSA_Rules_Spring_2009.pdf">NCSA Rules of Competition </A> &nbsp;(.pdf)
<br>
<br> 
<hr size="1">
	#repeatString("<br>",5)#
	<font size="2">
			<A href="http://www.adobe.com/products/acrobat/readstep2.html">
				<img border="0" src="<cfoutput>#SESSION.sitevars.imagePath#</cfoutput>adobe_reader.gif" width="71" height="27">&nbsp;Download Adobe Acrobat reader
			</A>
	</font>
</cfoutput>





</div> --->

 <!--- get the forms --->
 <cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
	<cfinvokeargument name="group_id" value="6">
</cfinvoke>


<cfoutput>
<div class="contentText">
	 
		<H1 class="pageheading">NCSA - Board Documents</H1>
		
		<cfloop query="forms">
			<br>
			<br> #repeatString("&nbsp;",5)# <a href="formsView.cfm?form_id=#form_id#">#forms.name#</a><cfif formType EQ 1> (.#forms.extension#)</cfif>
		</cfloop>
		
		
		<div style="border-top:1px solid ##CCCCCC; margin-top:20px; padding-top:30px;">
			<A href="http://www.adobe.com/products/acrobat/readstep2.html" target="_blank">
				<img border="0" src="<cfoutput>#SESSION.sitevars.imagePath#</cfoutput>adobe_reader.gif" width="71" height="27">&nbsp;Download Adobe Acrobat reader
			</A>
		</div>

</div>
</cfoutput>

<cfinclude template="_footer.cfm">
