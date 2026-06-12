

<cffile file="\\192.168.0.9\AGP\CF_files\BOMMF\#TRIM(URL.MF001)#_#URL.MF004#.PDF"
    action="DELETE"  filefield="fileName1"  >

<!---圖面上傳人員及時間--->
<cfquery datasource="#SESSION.COMPANY#" name="BOMMF_UPDATE">
   UPDATE BOMMF
   SET MF031=''
    WHERE 1=1
         AND MF001='#URL.MF001#'
         AND MF004='#URL.MF004#'
</cfquery>
	
<cflocation url="INVMB_UPDATE_FORM.cfm?MB001=#URL.MF001#">