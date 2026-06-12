<!---系統別資料更新---> 


<cfquery name="BIMPC_UPDATE" datasource="PKOOL">
     UPDATE BIMPC SET 
	 PC003 = '#FORM.PC003#'
	 WHERE PC001 = '#trim(FORM.PC001)#'
</cfquery>



<cflocation url="BIMPC.cfm">