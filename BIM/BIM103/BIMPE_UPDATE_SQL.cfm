<!---檔案資料更新---> 
<cfquery name="BIMPE_UPDATE" datasource="PKOOL">
     UPDATE BIMPE SET 
	 PE002 = '#FORM.PE002#',
	 PE003 = '#FORM.PE003#',
	 PE004 = '#FORM.PE004#',
	 PE005 = '#FORM.PE005#'
	 WHERE PE001 = '#FORM.PE001#'
</cfquery>



<cflocation url="BIMPE.cfm">