<!---製程圖面上傳檔案--->
<cfif  #FORM.fileName1# NEQ ""> 

<cffile destination="\\192.168.0.9\AGP\CF_files\BOMMF\#TRIM(FORM.MF001)#_#FORM.MF004#.PDF"
    action="upload" nameconflict="overwrite" filefield="fileName1"  result="myfile1">

<!---圖面上傳人員及時間--->
<cfquery datasource="#SESSION.COMPANY#" name="BOMMF_UPDATE">
   UPDATE BOMMF
   SET MF031='#SESSION.CNNAME#,#DATEFORMAT(NOW(),"YYYY-MM-DD")#(#TIMEFORMAT(NOW(),"HH:MM")#)'
    WHERE 1=1
         AND MF001='#FORM.MF001#'
         AND MF004='#FORM.MF004#'
</cfquery>
</cfif>




<cflocation url="INVMB_UPDATE_FORM.cfm?MB001=#FORM.MF001#">