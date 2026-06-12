

<cffile file="\\192.168.0.9\AGP\CF_files\INVMB_PHOTO\#TRIM(URL.MB001)#.jpg"
    action="DELETE"  filefield="fileName2">

<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE">
   UPDATE INVMB
   SET MB175=''
    WHERE 1=1
         AND MB001='#TRIM(URL.MB001)#'
</cfquery>
	
<cflocation url="INVMB_UPDATE_FORM.cfm?MB001=#URL.MB001#">