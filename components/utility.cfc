<cfcomponent>

<cffunction name="listIntersect" output="no" returntype="string" 
	hint="returns values from list 1 which are contained in list 2">
	<cfargument name="list1" type="string" required="yes" />
	<cfargument name="list2" type="string" required="yes" />
	<cfargument name="chDelimiter" type="string" required="no"
		    default="," />
	<cfscript>
	var aLstSand  = listToArray(arguments.list1,arguments.chDelimiter);
	var aLstSieve = listToArray(arguments.list2,arguments.chDelimiter);
	aLstSand.retainAll(aLstSieve);
	return arrayToList(aLstSand,arguments.chDelimiter);
	</cfscript>
</cffunction>

</cfcomponent>