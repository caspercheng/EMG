<!---场舦俱у狡籹---> 

<!---埃ヘ场舦---> 
<cfquery name="BIMPG_DELETE" datasource="PKOOL">
	DELETE
	FROM BIMPG
	WHERE PG001='#FORM.PG001#'
</cfquery>

<!---琩高ㄓ方场腹---> 
<cfquery name="BIMPG" datasource="PKOOL">
	SELECT *
	FROM BIMPG
	WHERE PG001='#FORM.PC001#'
</cfquery>

<cfoutput>

<cfloop query="BIMPG">
	<cfquery name="BIMPG_INSERT" datasource="PKOOL">
		 INSERT INTO BIMPG(PG001,PG002,PG003,PG004,PG005,PG006,PG007)

		 VALUES('#TRIM(FORM.PG001)#','#PG002#','#PG003#','#PG004#','#PG005#',
						'#PG006#','#PG007#')
	</cfquery>
</cfloop>

</cfoutput>

<cflocation url="BIMPG.cfm?PC001=#FORM.PG001#">
