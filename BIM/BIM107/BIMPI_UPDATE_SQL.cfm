<!---Mail程式更新---> 
<cfquery name="BIMPI_UPDATE" datasource="PKOOL">
     UPDATE BIMPI SET 
	 PI002 = '#FORM.PI002#',
	 PI003 = '#FORM.PI003#',
	 PI004 = '#FORM.PI004#'
	 WHERE PI001 = '#FORM.PI001#'
</cfquery>



<cflocation url="BIMPI.cfm">