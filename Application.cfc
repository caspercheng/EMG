<!--- 
 Filename: Application.cfc
 Created by: Raymond Camden (ray@camdenfamily.com)
 Please Note: Executes for every page request
--->

<cfcomponent output="false">

  <!--- Name the application. --->
  <cfset this.name="CIS">
  <!--- Turn on session management. --->
  <cfset this.sessionManagement=true>
  
  <cffunction name="onApplicationStart" output="false" returnType="void">

    <!--- Any variables set here can be used by all our pages --->
    <cfset APPLICATION.datasource="PKOOL">
    <cfset APPLICATION.companyName = "LY">

  
  </cffunction>

  <cffunction name="onRequestStart" output="false" returnType="void">
  
  
	<cfinclude template="ForceUserLogin.cfm">
    
  </cffunction>
  
   <cffunction name="onRequestEnd" output="false" returnType="void">
  
  	<cfinclude template="footer.cfm">
    
  </cffunction>
 
</cfcomponent>

