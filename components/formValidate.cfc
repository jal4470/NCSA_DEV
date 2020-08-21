<cfcomponent>


<!--- =================================================================== --->
<cffunction name="validateFields" access="public" returntype="struct">
	<!--- --------
		09/02/08 - AArnone - New function: formValidate 
							It validates form fields based on hidden attributes and Returns a structure of results.

		For each form field to be validated it must have an associated hidden field ("_ATTRIBUTES" added to field name). For example...
				<INPUT TYPE="text" NAME="xxx1">
				<INPUT TYPE="hidden" NAME="xxx1_ATTRIBUTES" VALUE="type=phone~required=1">

				a tilde (~) separates the attributes in the list in the form attribute = value.
				
				ATTRIBUTE	REQUIRED? 	VALUES			COMMENTS
				---------   ---------   --------------  ------------------------------------------------------------
				TYPE		Yes			EMAIL			x@y.z, checks for valid TLD
										PHONE			Numbers only, punctuation ignored, ten digits 
										NUMERIC			Numbers only 0-9
										NUMGTZERO		Numbers only 1-9 gteater than 0
										ALPHA			Alpha characters only
										ALPHANUMERIC	Only allows letters and numbers
										ZIPCODE			Numbers only, five or nine digits, dash at position 6 ignored
										DATE
										TIME   
										NOSPECIALCHAR	Only allows alphanumeric, "-", "_", ",", ".", "'", "/" and " " 
										STATE			Two-letter abbreviations of the 50 US States plus the District of Columbia
										GENERIC			(doesn't check content; useful for using optional attributes)     
										PLAYLEVEL		must be ALPHA valued A-G
				
				REQUIRED	No			0 | 1 			Defaults to 0 (simply checks that value is not 0-length string) 
				
				MINLENGTH	No							minimum string length
				         
				FIELDNAME	No							Used by generic error message. If not supplied uses FORM.fieldname
	

							
		Returns:
			stFormVal.Errors		number of errors found
			stFormVal.ErrorMessage	Text of errors separated by <BR> tags. If no errors this string will be null.
			stFormVal.FieldsPassed	Comma-delimited list of fields that have passed testing
			stFormVal.FieldsFailed	Comma-delimited list of fields that have failed testing
	
		These last two values can be useful in building dynamic queries.
		Please note: only fields that have been given "_ATTRIBUTES" will be in either of these lists
--->
	<cfargument name="formFields" type="struct"	required="Yes">

	<CFSET Errors		= 0 >
	<CFSET ErrorMessage	= "" >
	<CFSET FieldsPassed	= "" >
	<CFSET FieldsFailed	= "" >


	<!--- Check that they've passed the info and that it's a structure --->
	<CFIF NOT IsDefined("ARGUMENTS.formFields")>
	    <CFSET errors = 1>	
		<CFSET ErrorMessage = "ERROR! Form fields not found">
	<CFELSEIF NOT IsStruct(ARGUMENTS.formFields)>
		<CFSET errors = 1>	
		<CFSET ErrorMessage = "ERROR! Form fields STRUCTURE not found">
    </CFIF>

	<CFIF errors>
		<CFSET stFormVal = structNew()>
		<CFSET stFormVal.Errors 	  = VARIABLES.Errors>
		<CFSET stFormVal.ErrorMessage = VARIABLES.ErrorMessage>
		<CFSET stFormVal.FieldsPassed = "">
		<CFSET stFormVal.FieldsFailed = "">

		<cfreturn stFormVal>
	</CFIF> 
	
	<CFSET FORMSTRUCT = ARGUMENTS.formFields>
	<!--- Loop throught the collection and do the validation --->

	<CFLOOP LIST="#FORMSTRUCT.FIELDNAMES#" INDEX="NDX" >
	    <CFSET FormValue = Trim(Evaluate("FORMSTRUCT." & NDX))>
	
	    <CFIF IsDefined("FORMSTRUCT.#NDX#_ATTRIBUTES")>
	        <CFSET AttributeList = FORMSTRUCT[NDX & "_ATTRIBUTES"]>
	        <!--- Loop through the list of attributes and set variables --->
	        <!--- Initialize variables first --->
	        <CFSET type = "">
	        <CFSET required = 0>
	        <CFSET minlength = 0>
	        <CFSET fieldname = "">
	        <CFLOOP INDEX="ATTR" LIST="#AttributeList#" DELIMITERS="~">
	            <CFSET equalsignlocation = Find("=", Trim(ATTR))>
	            <!--- If an = is found --->
	            <!--- Find the attribute name and value --->
	            <CFIF equalsignlocation>
	                <CFSET attrname = Left(Trim(ATTR), equalsignlocation - 1)>
	                <CFSET attrvalue = Right(Trim(ATTR), Len(Trim(ATTR)) - equalsignlocation)>
					<!--- Set the variable --->            
	            	<CFSET temp = SetVariable(attrname, attrvalue)>
	            </CFIF>
	        </CFLOOP> <!--- Done setting variables --->
	        
	        <!--- Initialize variable for pass/fail on this field --->
	        <CFSET Failure = 0>
	        
	        <!--- Now evaluate value based on settings --->
	        <CFIF NOT Len(Trim(VARIABLES.fieldname))>
	            <!--- If they haven't provided a fieldname use the form variable name --->
	            <CFSET fieldname = NDX>
	        </CFIF>
	
	        <!--- Evaluate required --->
	        <CFIF VARIABLES.required>
	            <CFIF NOT Len(VARIABLES.FormValue)>
	                <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " is a required field.<BR>">
	            </CFIF>
	        </CFIF>
	        
	        <!--- Only check fields if they're required or have a value --->
	        <CFIF Len(VARIABLES.FormValue) OR VARIABLES.required>
	        <!--- Evaluate type --->
	        <CFSWITCH EXPRESSION="#VARIABLES.type#">

	            <CFCASE VALUE="FIELDABBRCHARS">
	                <CFIF REFind("[^- 0-9A-Za-z&()./']",VARIABLES.FormValue)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " contains invalid characters. (only letters, numbers, dash [-], ampersand [&], comma [,], period [.], quote ['], slash [/], parens [()] and space [ ] are allowed.)<BR>">
	                </CFIF>
	            </CFCASE>



	            <CFCASE VALUE="EMAIL">
	                <!--- Possible Regular expression that could be used:
	                    /^[a-z][a-z0-9_\.\-]+@[a-z0-9_\.\-]+\.[a-z]{2,3}$/i
	                 --->
	                <!--- Do e-mail validation here... --->
	                <CFSET threeletterTLDs = "com,org,net,gov,mil,edu,int,aero,biz,coop,info,museum,name,pro">
	                <!--- 2 letter TLDs valid as of July 22, 2000 --->
	                <!--- See: http://www.iana.org/cctld/cctld-whois.htm --->
	                <CFSET twoletterTLDs = "ac,ad,ae,af,ag,ai,al,am,an,ao,aq,ar,as,at,au,aw,az,ba,bb,bd,be,bf,bg,bh,bi,bj,bm,bn,bo,br,bs,bt,bv,bw,by,bz,ca,cc,cd,cf,cg,ch,ci,ck,cl,cm,cn,co,cr,cu,cv,cx,cy,cz,de,dj,dk,dm,do,dz,ec,ee,eg,eh,er,es,et,fi,fj,fk,fm,fo,fr,ga,gd,ge,gf,gg,gh,gi,gl,gm,gn,gp,gq,gr,gs,gt,gu,gw,gy,hk,hm,hn,hr,ht,hu,id,ie,il,im,in,io,iq,ir,is,it,je,jm,jo,jp,ke,kg,kh,ki,km,kn,kp,kr,kw,ky,kz,la,lb,lc,li,lk,lr,ls,lt,lu,lv,ly,ma,mc,md,mg,mh,mk,ml,mm,mn,mo,mp,mq,mr,ms,mt,mu,mv,mw,mx,my,mz,na,nc,ne,nf,ng,ni,nl,no,np,nr,nu,nz,om,pa,pe,pf,pg,ph,pk,pl,pm,pn,pr,ps,pt,pw,py,qa,re,ro,ru,rw,sa,sb,sc,sd,se,sg,sh,si,sj,sk,sl,sm,sn,so,sr,st,sv,sy,sz,tc,td,tf,tg,th,tj,tk,tm,tn,to,tp,tr,tt,tv,tw,tz,ua,ug,uk,um,us,uy,uz,va,vc,ve,vg,vi,vn,vu,wf,ws,ye,yt,yu,za,zm,zr,zw">
	                <CFSET invalidchars = "~`!##$%^&*()=+}]{[\|;:/?><, ">
	                <!--- Find invalid characters --->
	                <CFIF FindOneOf(VARIABLES.invalidchars,VARIABLES.FormValue,1)>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " contains invalid characters.<BR>">
	                </CFIF> <!--- Find invalid characters --->
	                
	                <CFSET elements = ListLen(VARIABLES.FormValue, "@")>
	                <CFSET formatokay = 1>
	                <!--- Is there something@something? --->
	                <CFIF VARIABLES.elements EQ 2>
	                    <CFSET mailbox = ListFirst(VARIABLES.FormValue, "@")>
	                    <CFSET postoffice = ListRest(VARIABLES.FormValue, "@")>
	                    <CFIF ListLen(VARIABLES.postoffice, ".") GTE 2>
	                        <CFSET TLD = ListLast(VARIABLES.postoffice, ".")>
	                        <CFIF NOT ListFindNoCase(VARIABLES.threeletterTLDs,VARIABLES.TLD)>
	                            <CFIF NOT ListFindNoCase(VARIABLES.twoletterTLDs,VARIABLES.TLD)>
	                                <CFSET formatokay = 0>
	                            </CFIF>
	                        </CFIF>
	                    <CFELSE>
	                        <!--- There's no . in the machine name --->
	                        <CFSET formatokay = 0>
	                    </CFIF>
	                <CFELSE>
	                    <!--- There's no @ sign or no text before and/or after the @ --->
	                    <CFSET formatokay = 0>
	                </CFIF> <!--- Is there something@something? --->
	                
	                <CFIF NOT formatokay>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & "The format of " &  VARIABLES.fieldname & " is invalid. [use the format: name@domain.tld]<BR>">
	                </CFIF>
	                
	            </CFCASE> <!--- EMAIL --->
	            
	            <CFCASE VALUE="PHONE">
	                <!--- Do telephone number validation here... --->
	                <!--- Remove non-number characters generally found in phone numbers --->
	                <CFSET badnum = 0>
	                <CFSET newnum = REReplace(VARIABLES.FormValue,"[-() ]","","ALL")>
	                <CFIF REFind("[^0-9]",VARIABLES.newnum)>
	                    <!--- 
	                        After removing some characters, there are still non-numbers
	                        left over.
	                     --->
	                     <CFSET badnum = 1>
	                <CFELSEIF Len(newnum) NEQ 10>
	                    <!--- There are not 10 numbers remaining  --->
	                    <CFSET badnum = 1>
	                </CFIF>
	                <CFIF VARIABLES.badnum>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " is not a valid telephone number. [use the format: 212-555-1212]<BR>">
	                </CFIF>
	            </CFCASE>
	            
	            <CFCASE VALUE="NUMERIC">
	                <!--- Check that string contains only numbers --->
	                <CFIF REFind("[^0-9]",VARIABLES.FormValue)>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " can only contain numbers. <BR>">
	                </CFIF>
	            </CFCASE> <!--- NUMERIC --->
	            
	            <CFCASE VALUE="NUMGTZERO">
	                <!--- Check that string contains only numbers --->
	                <CFIF REFind("[^0-9]",VARIABLES.FormValue) AND VARIABLES.FormValue LT 1>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " must be greater than zero. <BR>">
	                </CFIF>
	            </CFCASE> <!--- NUMERIC --->
	            
	            <CFCASE VALUE="ALPHA">
	                <!--- Check that string contains only letters --->
	                <CFIF REFind("[^A-Za-z]",VARIABLES.FormValue)>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " can only contain letters.<BR>">
	                </CFIF>
	            </CFCASE> <!--- ALPHA --->
	
	            <CFCASE VALUE="ALPHANUMERIC">
	                <!--- Check that string contains only letters and numbers --->
	                <CFIF REFind("[^0-9A-Za-z]",VARIABLES.FormValue)>
	                    <CFSET Errors = IncrementValue(VARIABLES.Errors)>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " can only contain letters and numbers.<BR>">
	                </CFIF>
	            </CFCASE> <!--- ALPHANUMERIC --->
	            
	            <CFCASE VALUE="ZIPCODE">
	                <!--- 
	                    Zip code is five digits with an optional four. Check that value
	                    is five or nine digits only, ignoring a dash between digits five
	                    and six if it exists.
	                 --->
	                 <CFSET testzip = "">
	                 <CFIF Len(VARIABLES.FormValue) EQ 5>
	                    <CFSET testzip = VARIABLES.FormValue>
	                 <CFELSEIF Len(VARIABLES.FormValue) GT 5>
	                    <!--- Check for a dash and remove if applicable --->
	                    <CFIF Find("-",VARIABLES.FormValue) EQ 6>
	                        <CFSET testzip = Replace(VARIABLES.FormValue,"-","")>
	                    <CFELSE>
	                        <CFSET testzip = VARIABLES.FormValue>
	                    </CFIF>
	                 </CFIF>
	                 
	                 <CFIF (Len(VARIABLES.testzip) NEQ 5 AND Len(VARIABLES.testzip) NEQ 9) OR REFind("[^0-9]",VARIABLES.testzip)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " is not a valid ZIP code. [use the format: 01234 or 01234-5678]<BR>">
	                </CFIF>
	            </CFCASE> <!--- ZIPCODE --->
	            
	            <CFCASE VALUE="DATE">
	                <CFIF NOT IsDate(VARIABLES.FormValue)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " is not a valid date. [use the format: MM/DD/YYYY]<BR>">
	                </CFIF>
	            </CFCASE>
	
	            <CFCASE VALUE="TIME">
	                <CFIF NOT IsDate(VARIABLES.FormValue)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " is not a valid time. [use the format: HH:MM:SS PM]<BR>">
	                </CFIF>
	            </CFCASE>
	            
	            <CFCASE VALUE="NOSPECIALCHAR">
	                <CFIF REFind("[^- _0-9A-Za-z,\./']",VARIABLES.FormValue)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " contains invalid characters. (only letters, numbers, dash [-], underscore [_], comma [,], period [.], quote ['], slash [/] and space [ ] are allowed.)<BR>">
	                </CFIF>
	            </CFCASE>
	            
	            <CFCASE VALUE="STATE">
	                <!--- List of state abbreviations found at http://www.framed.usps.com/ncsc/lookups/usps_abbreviations.htm#states --->
	                <CFSET StateList = "AL,AK,AZ,AR,CA,CO,CT,DE,DC,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VT,VA,WA,WV,WI,WY">
	                <CFIF NOT ListFindNoCase(VARIABLES.StateList,VARIABLES.FormValue)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & "The value entered into " & VARIABLES.fieldname & " is not a valid state abbreviation.<BR>">
	                </CFIF>
	            </CFCASE>
	            
	            <CFCASE VALUE="PLAYLEVEL">
	                <!--- List of VALID NCSA playlevels --->
	                <CFSET playLevelList = "A,B,C,D,E,F,G">
	                <CFIF NOT ListFindNoCase(VARIABLES.playLevelList,VARIABLES.FormValue)>
	                    <CFSET Errors = Errors + 1>
	                    <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                    <CFSET ErrorMessage = VARIABLES.ErrorMessage & "The value entered into " & VARIABLES.fieldname & " is not a valid level (A,B,C,D,E,F,G).<BR>">
	                </CFIF>
	            </CFCASE>
	            
	            <CFCASE VALUE="GENERIC">
	                <!--- Don't check any format --->
	            </CFCASE>
	
	            <CFDEFAULTCASE>
	                <!--- They've used an invalid type or forget to set one --->
	                <CFSET Errors = Errors + 1>
	                <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                <CFSET ErrorMessage = VARIABLES.ErrorMessage & "Incorrect 'TYPE' definition for " & VARIABLES.fieldname & ".<BR>">
	            </CFDEFAULTCASE>
	        </CFSWITCH>
	        
	        <!--- Evaluate minlength --->
	        <CFIF VARIABLES.minlength>
	            <!--- They've defined a minimum length --->
	            <CFIF Len(VARIABLES.FormValue) LT VARIABLES.minlength>
	                <CFSET Errors = Errors + 1>
	                <CFSET Failure = IncrementValue(VARIABLES.Failure)>
	                <CFSET ErrorMessage = VARIABLES.ErrorMessage & VARIABLES.fieldname & " must be at least " & VARIABLES.minlength & " characters.<BR>">
	            </CFIF>
	        </CFIF>        
	        
	        </CFIF> <!--- CFIF Len(VARIABLES.FormValue) OR VARIABLES.required --->
	        
	        <CFIF VARIABLES.Failure>
	            <!--- The fieldname has failed one or more checks --->
	            <CFSET FieldsFailed = ListAppend(VARIABLES.FieldsFailed,NDX)>
	        <CFELSE>
	            <!--- The fieldname has passed --->
	            <CFSET FieldsPassed = ListAppend(VARIABLES.FieldsPassed,NDX)>
	        </CFIF>
	        
	    </CFIF> <!--- IsDefined("FORM.#NDX#_ATTRIBUTES") --->    
	</CFLOOP>

	<CFSET stFormVal = structNew()>
	<CFSET stFormVal.Errors 	  = VARIABLES.Errors>
	<CFSET stFormVal.ErrorMessage = VARIABLES.ErrorMessage>
	<CFSET stFormVal.FieldsPassed = VARIABLES.FieldsPassed>
	<CFSET stFormVal.FieldsFailed = VARIABLES.FieldsFailed>
	
	<cfreturn stFormVal>
</cffunction>
	



<!--- ------------
END OF formValidate.cfc
------------- --->
</cfcomponent>