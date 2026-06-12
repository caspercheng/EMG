<!---人員通知刪除---> 

<cfquery name="BIMPK_DELETE" datasource="PKOOL">
     DELETE BIMPK
     FROM BIMPK
     WHERE PK001='#URL.PK001#' AND PK002='#URL.PK002#'
</cfquery>

<cflocation url="BIMPK.cfm?PI001=#URL.PK001#">
