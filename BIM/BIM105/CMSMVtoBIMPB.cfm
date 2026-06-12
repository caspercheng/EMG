<!---新增員工---> 
<cfquery name="CMSMV" datasource="EMG">
	SELECT *
    FROM CMSMV
    WHERE MV023 = ''
</cfquery>

<cfoutput>

<cfloop query="CMSMV">

<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	WHERE PB001='#MV001#'
</cfquery>

<cfif #BIMPB.recordcount# eq 0>
    
	 <cfquery name="BIMPB_INSERT" datasource="PKOOL">
		INSERT INTO BIMPB(PB001,PB002,PB003,PB004,PB005,PB006,PB007,PB008,PB009)
		VALUES('#MV001#','#MV002#','#MV047#','#MV001#','#MV004#',
		                '#MV020#','N','','')
	</cfquery>
	
</cfif>

</cfloop>


<!---刪除員工
<cfquery name="CMSMV" datasource="EMG">
	SELECT *
    FROM CMSMV
    WHERE MV023 <> ''
</cfquery>


<cfquery name="BIMPB_CHECK" datasource="PKOOL">
	SELECT *
	FROM BIMPB
    LEFG JOIN EMG..CMSMV ON MV001=PB001
	WHERE  MV001 IS NULL
</cfquery>

<cfloop query="BIMPB_CHECK">    
	 <cfquery name="BIMPB_DELETE" datasource="PKOOL">
		DELETE BIMPB
		FROM BIMPB
		WHERE PB001='#PB001#'
	</cfquery>
</cfloop>
---> 
</cfoutput>
更新完成！