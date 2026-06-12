<!---公佈欄資料更新---> 
<cfquery name="BIMKA_DELETE" datasource="EAGLE">
     DELETE 
	 FROM  BIMKA
	 WHERE KA001 = '#URL.KA001#'
</cfquery>

<cflocation url="BIMKA.cfm">