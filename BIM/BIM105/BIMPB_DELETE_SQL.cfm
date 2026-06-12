<!---人員資料刪除---> 


<cfquery name="BIMPB_DELETE" datasource="PKOOL">
     DELETE
	 FROM BIMPB
	 
	 WHERE PB001 = '#URL.PB001#'
</cfquery>

<cfquery name="BIMPF_DELETE" datasource="PKOOL">
     DELETE
	 FROM BIMPF
	 
	 WHERE PF001 = '#URL.PB001#'
</cfquery>


<cflocation url="BIMPB.cfm">