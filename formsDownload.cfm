<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
03/26/09 - aarnone - update spring 2009 rules
 --->
 
 <!--- get the forms --->
 <cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
	<cfinvokeargument name="group_id" value="1">
</cfinvoke>
 
<CFSET mid = 1>
<cfinclude template="_header.cfm">
<style>
#contentText{
	padding-left: 85px; }
@media screen and (max-width: 768px){
	.pageHeading{
		font-size: 24px; }
	a{
		font-size: .675em; }
}
</style>
<cfoutput>
<div id="contentText">
	 
		<H1 class="pageheading">League/State Forms</H1>
		
		<cfloop query="forms">
			<br>
			<br> #repeatString("&nbsp;",5)# <a href="formsView.cfm?form_id=#form_id#">#forms.name#</a><cfif formType EQ 1> (.#forms.extension#)</cfif>
		</cfloop>
		
		
		<div style="border-top:1px solid ##CCCCCC; margin-top:20px; padding-top:30px;">
			<A href="http://www.adobe.com/products/acrobat/readstep2.html">
				<img border="0" src="<cfoutput>#SESSION.sitevars.imagePath#</cfoutput>adobe_reader.gif" width="71" height="27">&nbsp;Download Adobe Acrobat reader
			</A>
		</div>

</div>
</cfoutput>
<cfinclude template="_footer.cfm">
