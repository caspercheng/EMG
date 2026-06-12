<!---浪琩琌Τ舦--->
<cfquery name="BIMPE_CHECK" datasource="PKOOL">
	SELECT *
	FROM (
	SELECT PE001,PE002,PE003,PE004,PE005,
	             PG003 AS 琩高,PG004 AS э,PG005 AS 穝糤,PG006 AS 埃,PG007 AS 基
	FROM BIMPG
	JOIN BIMPE ON PE001=PG002
	JOIN BIMPD ON PE003=PD001
	WHERE PG001='#SESSION.DepCode#' AND PE001='#program_id#'

	UNION 

   SELECT PE001,PE002,PE003,PE004,PE005,
                PF003 AS 琩高,PF004 AS э,PF005 AS 穝糤,PF006 AS 埃,PF007 AS 基
	FROM BIMPF
	JOIN BIMPE ON PE001=PF002
	JOIN BIMPD ON PE003=PD001
	WHERE PF001='#SESSION.Code#' AND PE001='#program_id#'
	) AS A
	ORDER BY PE001
</cfquery>

<cfoutput>
<!---礚舦╭癟--->
<cfif #BIMPE_CHECK.recordcount# eq 0>
	<h4><center>⊿Τ祘Α舦</center></h4>
	<cfabort>
<!---浪琩兜舦--->	
<cfelse>
   <cfloop query="BIMPE_CHECK">
     <cfset 琩高舦 = "#琩高#">
     <cfset э舦 = "#э#">
     <cfset 穝糤舦 = "#穝糤#">
     <cfset 埃舦 = "#埃#">
     <cfset 基舦 = "#基#">
   </cfloop>	
</cfif>

</cfoutput>