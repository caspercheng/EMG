<cfif #FORM.submit# EQ "不開放">

<cfquery name="DSCMB_UPDATE" datasource="PKOOL">
     UPDATE DSCMB SET 
	 MB004 = 'N'
	 WHERE 1=1
		 AND MB001  IN (#PreserveSingleQuotes(FORM.check1)#)
</cfquery>
</cfif>

<cfif #FORM.submit# EQ "開放">

<cfquery name="DSCMB_UPDATE" datasource="PKOOL">
     UPDATE DSCMB SET 
	 MB004 = 'Y'
	 WHERE 1=1
		 AND MB001  IN (#PreserveSingleQuotes(FORM.check1)#)
</cfquery>
</cfif>



<cflocation url="DSCMB.cfm">