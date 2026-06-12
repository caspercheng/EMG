 <cfquery name="DSCMB" datasource="PKOOL">
	 SELECT *
	 FROM DSCMB
	 WHERE MB003 = '#FORM.COMPANY#'
</cfquery>

<cfoutput query="DSCMB">
	<cfset SESSION.company= #trim(MB003)#>
	<cfset SESSION.company_NAME= #MB002#>
</cfoutput>

<cfinclude template="/EMG/menu.cfm">

<cfoutput>
 已切換公司別到#SESSION.company_NAME#!
</cfoutput>