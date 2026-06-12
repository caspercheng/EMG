<!---新增部門---> 
<cfquery name="CMSME" datasource="EMG">
	SELECT *
	FROM CMSME
</cfquery>

<cfoutput>
	<cfloop query="CMSME">

	<cfquery name="BIMPC" datasource="PKOOL">
		SELECT *
		FROM BIMPC
		WHERE PC001='#ME001#'
	</cfquery>

	<cfif #BIMPC.recordcount# eq 0>
		
		<cfquery name="BIMPC_INSERT" datasource="PKOOL">
			INSERT INTO BIMPC(PC001,PC002,PC003,PC004,PC005)
			VALUES('#ME001#','#ME002#','','','')
		</cfquery>
	</cfif>

    </cfloop>
</cfoutput>


更新完成！