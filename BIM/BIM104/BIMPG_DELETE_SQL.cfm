<!---部門權限刪除---> 


<cfquery name="BIMPG_DELETE" datasource="PKOOL">
     DELETE BIMPG
     FROM BIMPG
     WHERE PG001='#URL.PG001#' AND PG002='#URL.PG002#'
</cfquery>

<cflocation url="BIMPG.cfm?PC001=#URL.PG001#">
