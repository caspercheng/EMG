<!---模組資料更新---> 
<cfquery name="DSCMB_DELETE" datasource="PKOOL">
     DELETE DSCMB 
	 WHERE 1=1
	 	AND MB001='#URL.MB001#'
</cfquery>



<cflocation url="DSCMB.cfm">