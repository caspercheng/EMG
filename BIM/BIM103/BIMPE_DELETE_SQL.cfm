<!---網頁程式刪除作業---> 
<cfquery name="BIMPE_DELETE" datasource="PKOOL">
     DELETE 
	 FROM BIMPE
	 WHERE PE001 = '#TRIM(URL.PE001)#'
</cfquery>

<cfquery name="BIMPF_DELETE" datasource="PKOOL">
     DELETE 
	 FROM BIMPF
	 WHERE PF002 = '#TRIM(URL.PE001)#'
</cfquery>

<cfquery name="BIMPG_DELETE" datasource="PKOOL">
     DELETE 
	 FROM BIMPG
	 WHERE PG002 = '#TRIM(URL.PE001)#'
</cfquery>


<cfquery name="BIMPH_DELETE" datasource="PKOOL">
     DELETE 
	 FROM BIMPH
	 WHERE PH002 = '#TRIM(URL.PE001)#'
</cfquery>

<cflocation url="BIMPE.cfm">