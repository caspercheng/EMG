<!---人員權限複製作業---> 

<!---刪除原本權限---> 
<cfquery name="BIMPF_DELETE" datasource="PKOOL">
     DELETE
	 FROM BIMPF
	 WHERE PF001='#TRIM(FORM.PF001)#'
</cfquery>

<!---刪除原本權限---> 
<cfquery name="BIMPH_DELETE" datasource="PKOOL">
     DELETE
	 FROM BIMPH
	 WHERE PH001='#TRIM(FORM.PF001)#'
</cfquery>

<!---查詢複製來源人員權限---> 
<cfquery name="BIMPF" datasource="PKOOL">
     SELECT *
	 FROM BIMPF
	 WHERE PF001='#TRIM(FORM.PB001)#'
</cfquery>

<cfoutput>

<cfloop query="BIMPF">

	<cfquery name="BIMPF_INSERT" datasource="PKOOL">
		 INSERT INTO BIMPF(PF001,PF002,PF003,PF004,PF005,PF006,PF007,PF008)
		 
		 VALUES('#TRIM(FORM.PF001)#','#PF002#','#PF003#','#PF004#','#PF005#',
						'#PF006#','#PF007#','#PF008#')
	</cfquery>

	<!---新增公司別權限---> 
	<cfquery name="BIMPH_INSERT" datasource="PKOOL">
		INSERT INTO BIMPH(PH001,PH002,PH003)
		VALUES('#FORM.PF001#','#PF002#','AGP')
	</cfquery>

</cfloop>

</cfoutput>

<cflocation url="BIMPF.cfm?PB001=#FORM.PF001#">
