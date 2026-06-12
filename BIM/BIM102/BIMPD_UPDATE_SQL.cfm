<!---模組資料更新---> 
<cfquery name="BIMPD_UPDATE" datasource="PKOOL">
     UPDATE BIMPD SET 
	 PD002 = '#FORM.PD002#',
	 PD003 = '#FORM.PD003#'
	 WHERE PD001 = '#FORM.PD001#'
</cfquery>



<cflocation url="BIMPD.cfm">