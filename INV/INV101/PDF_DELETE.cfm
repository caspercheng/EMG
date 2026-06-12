

<cffile file="\\192.168.0.9\AGP\CF_files\INVMB\#TRIM(URL.MB001)#.PDF" action="DELETE"  filefield="fileName3"  >

<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE">
   UPDATE INVMB
   SET MB174=''
    WHERE 1=1
         AND MB001='#TRIM(URL.MB001)#'
</cfquery>
	
<cflocation url="INVMB_UPDATE_FORM.cfm?MB001=#URL.MB001#">