<!---模組資料更新---> 
<cfquery name="BIMPA_UPDATE" datasource="PKOOL">
     UPDATE BIMPA SET 
	 PA002 = #NUMBERFORMAT(FORM.PA002/100,"9999.9999")#,
	 PA003 = #NUMBERFORMAT(FORM.PA003/100,"9999.9999")#
	 WHERE PA001 = '#FORM.PA001#'
</cfquery>



<cflocation url="BIMPA_UPDATE.cfm">