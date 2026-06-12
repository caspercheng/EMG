<cfinclude template="/EMG/menu.cfm">

<!---查詢勾選的多公司資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT *
	FROM DSCMB
	WHERE MB003 IN  (#PreserveSingleQuotes(FORM.check1)#)
</cfquery>

<cfoutput>

	<cfloop query="DSCMB">

		<cfquery name="ADMMF_DELETE" datasource="#TRIM(MB003)#">
			DELETE
			FROM ADMMF
			WHERE MF001= '#FORM.MG001#'
		</cfquery>

		<cfquery name="ADMMG_DELETE" datasource="#TRIM(MB003)#">
			DELETE
			FROM ADMMG
			WHERE MG001= '#FORM.MG001#'
		</cfquery>
	
		<cfquery name="ADMMF" datasource="#TRIM(MB003)#">
			INSERT INTO ADMMF
			SELECT *
			FROM #SESSION.COMPANY#..ADMMF
			WHERE MF001= '#FORM.MG001#'
		</cfquery>
		
		<cfquery name="ADMMG" datasource="#TRIM(MB003)#">
			INSERT INTO ADMMG
			SELECT *
			FROM #SESSION.COMPANY#..ADMMG
			WHERE MG001= '#FORM.MG001#'
		</cfquery>
	
	</cfloop>
	
</cfoutput>
權限 複製成功 