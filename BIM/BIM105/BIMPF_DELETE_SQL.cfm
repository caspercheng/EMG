<!---人員權限刪除---> 

<cfquery name="BIMPF_DELETE" datasource="PKOOL">
     DELETE BIMPF
     FROM BIMPF
     WHERE PF001='#URL.PF001#' AND PF002='#URL.PF002#'
</cfquery>

<!---人員權限公司別刪除---> 
<cfquery name="BIMPH_DELETE" datasource="PKOOL">
     DELETE BIMPH
     FROM BIMPH
     WHERE PH001='#URL.PF001#' AND PH002='#URL.PF002#'
</cfquery>

<cflocation url="BIMPF.cfm?PB001=#URL.PF001#">
