<!--- This function returns a string which includes all current URL --->
<!--- variables, properly formatted for easy passing along in URLs. --->
<!--- In addition, it includes the URLToken from CLIENT or SESSION. --->
<cffunction name="passURLVars" returnType="string" output="false">
  <!--- There is one optional argument: a list of variables *not* to pass --->
  <cfargument name="exceptions" default="">
  
  <cfset var passVars = "">
  <cfset var v = "">
  
  <!--- The exception list should always include the URLToken variables --->
  <cfset exceptions = listAppend(Exceptions, "jsessionid,cftoken,cfid")>
  
  <!--- If defined, start with URLToken; if not, start with empty string --->
  <cfif isDefined("SESSION.urlToken")>
    <cfset passVars = SESSION.urlToken> 
  <cfelseif isDefined("CLIENT.urlToken")>
    <cfset passVars = CLIENT.urlToken> 
  </cfif>
  
  <!--- Loop over all URL variables, adding to PassVars along the way --->
  <!--- But, skip any variables in the Exceptions list --->
  <cfloop list="#structKeyList(URL)#" index="v">
    <cfif not listFindNoCase(exceptions, v)>
      <cfset passVars = listAppend(passVars, "#v#=#urlEncodedFormat(URL[v])#", "&")>
    </cfif>
  </cfloop>  

  <!--- Return result to calling process --->
  <cfreturn passVars>
</cffunction>

<!--- This function returns string which includes all current form --->
<!--- variables, properly formatted as hidden form fields. --->
<cffunction name="passFormVars" returnType="string" output="false">
  <!--- There is one optional argument: a list of variables *not* to pass --->
  <cfargument name="exceptions" default="">
  
  <cfset var passVars = "">
  <cfset var v = "">
  <cfset var lastPartOfVarName = "">
  
  <!--- Exception list should always include automatic FIELDNAMES variable --->
  <cfset exceptions = listAppend(exceptions, "FIELDNAMES")>
    
  <!--- Loop over all FORM variables, adding to PassVars along the way --->
  <!--- But, skip any variables in the Exceptions list, or variables --->
  <!--- that end in the reserved validation suffixes, like _required --->
  <cfloop list="#structKeyList(FORM)#" index="v">
    <cfif not listFindNoCase(exceptions, v)>
      <cfset lastPartOfVarName = ListLast(v, "_")>
      
      <cfif not listFindNoCase("required,date,integer,float", lastPartOfVarName)>
        <cfset passVars = passVars & 
        '<input type="hidden" name="#v#" value="#htmlEditFormat(FORM[v])#">'>
      </cfif>
    </cfif>
  </cfloop>  

  <!--- Return result to calling process --->
  <cfreturn passVars>
</cffunction>

