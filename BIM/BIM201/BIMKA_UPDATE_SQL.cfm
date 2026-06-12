<!---公佈欄資料更新---> 
<cfquery name="BIMKA_UPDATE" datasource="EAGLE">
     UPDATE BIMKA SET 
	 KA002 = '#FORM.KA002#',
	 KA003 = '#FORM.KA003#',
	 KA004 = '#FORM.KA004#'
	 WHERE KA001 = '#FORM.KA001#'
</cfquery>

<cflocation url="BIMKA.cfm">