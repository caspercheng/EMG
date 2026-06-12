
<cfquery datasource="EMG" name="COPKG_DELETE">
    DELETE
    FROM COPKG
    WHERE  0 = 0
	AND KG001 = '#URL.KG001#'
</cfquery>

<cfquery datasource="EMG" name="COPKH_DELETE">
    DELETE
    FROM COPKH
    WHERE  0 = 0
	AND KH001 = '#URL.KG001#'
</cfquery>

<cflocation url="COPKG.cfm">