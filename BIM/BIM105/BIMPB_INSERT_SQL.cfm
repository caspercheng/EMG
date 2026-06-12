<!---新增員工---> 
<cfquery name="DSCMA" datasource="PKOOL">
	SELECT *
    FROM DSCSYS..DSCMA
	WHERE MA001 IN  (#PreserveSingleQuotes(FORM.check1)#)
</cfquery>

<cfoutput>

<cfloop query="DSCMA">

<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	WHERE PB001='#MA001#'
</cfquery>

<cfif #BIMPB.recordcount# eq 0>
    
	 <cfquery name="BIMPB_INSERT" datasource="PKOOL">
		INSERT INTO BIMPB(PB001,PB002,PB003,PB004,PB005,PB006,PB007)
		VALUES('#trim(MA001)#','#MA002#','','#trim(MA001)#','10000','','N')
	</cfquery>
	
</cfif>

</cfloop>
</cfoutput>


<cflocation url="BIMPB.cfm">