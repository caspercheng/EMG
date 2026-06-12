<!---模組資料更新---> 
<cfquery name="DSCMB_UPDATE" datasource="PKOOL">
     UPDATE DSCMB SET 
	 MB001 = '#FORM.MB001#',
	 MB002= '#FORM.MB002#',
	 MB003= '#FORM.MB003#'
	 WHERE MB001 = '#FORM.OLD_MB001#'
</cfquery>



<cflocation url="DSCMB_UPDATE.cfm?MB001=#FORM.MB001#">