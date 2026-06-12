<cfinclude template="/EMG/menu.cfm">

<cfquery name="BIMPH_DELETE" datasource="PKOOL">
	DELETE
	FROM BIMPH
	WHERE PH001= '#FORM.PH001#' AND PH002='#FORM.PH002#'
</cfquery>


<!---查詢勾選的多公司資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT *
	FROM DSCMB
	WHERE MB003 IN  (#PreserveSingleQuotes(FORM.check1)#)
</cfquery>

<cfoutput>

	<cfloop query="DSCMB">


		<cfquery name="BIMPH_INSERT" datasource="PKOOL">
			INSERT INTO BIMPH(PH001,PH002,PH003)
			VALUES('#FORM.PH001#','#FORM.PH002#','#MB003#')
		</cfquery>
		
	</cfloop>
	
</cfoutput>

<cflocation url="BIMPF.cfm?PB001=#FORM.PH001#">