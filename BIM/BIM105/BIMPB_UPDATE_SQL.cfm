<!---人員資料更新---> 

<cfif #FORM.submit# eq "更新">

<cfquery name="BIMPB_UPDATE" datasource="PKOOL">
     UPDATE BIMPB SET 
	 PB002 = '#FORM.PB002#',
	 PB009 = '#FORM.PB009#',
	 PB004 = '#FORM.PB004#',
	 PB005 = '#FORM.PB005#',
	 PB006 = '#FORM.PB006#'
	 
	 WHERE PB001 = '#TRIM(FORM.old_PB001)#'
</cfquery>

</cfif>

<cfif #FORM.submit# eq "停用">

<cfquery name="BIMPB_UPDATE" datasource="PKOOL">
     UPDATE BIMPB SET 
	 PB007 = 'Y'
	 
	 WHERE PB001 = '#TRIM(FORM.old_PB001)#'
</cfquery>

</cfif>

<cfif #FORM.submit# eq "復職">

<cfquery name="BIMPB_UPDATE" datasource="PKOOL">
     UPDATE BIMPB SET 
	 PB007 = 'N'
	 
	 WHERE PB001 = '#TRIM(FORM.old_PB001)#'
</cfquery>

</cfif>

<cflocation url="BIMPB.cfm">