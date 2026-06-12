<!---圖面上傳檔案--->
<cfif  #FORM.fileName1# NEQ ""> 

<cffile destination="\\192.168.0.9\AGP\CF_files\INVMB\#TRIM(FORM.MB001)#.PDF"
    action="upload" nameconflict="overwrite" filefield="fileName1"  result="myfile1">

<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE">
   UPDATE INVMB
   SET MB174='#SESSION.CNNAME#,#DATEFORMAT(NOW(),"YYYY-MM-DD")#(#TIMEFORMAT(NOW(),"HH:MM")#)'
    WHERE 1=1
         AND MB001='#FORM.MB001#'
</cfquery>
	
</cfif>

<!---圖面上傳檔案--->
<cfif  #FORM.fileName3# NEQ ""> 

<cffile destination="\\192.168.0.9\AGP\CF_files\INVMB\#TRIM(FORM.MB001)#_check.PDF"
    action="upload" nameconflict="overwrite" filefield="fileName3"  result="myfile3">
	
</cfif>

<!---圖片上傳檔案--->
<cfif  #FORM.fileName2# NEQ ""> 

<cffile destination="\\192.168.0.9\AGP\CF_files\INVMB_PHOTO\#TRIM(FORM.MB001)#.jpg"
    action="upload" nameconflict="overwrite" filefield="fileName2"  result="myfile2">

<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE">
   UPDATE INVMB
   SET MB175='#SESSION.CNNAME#,#DATEFORMAT(NOW(),"YYYY-MM-DD")#(#TIMEFORMAT(NOW(),"HH:MM")#)'
    WHERE 1=1
         AND MB001='#FORM.MB001#'
</cfquery>
	
</cfif>

<cfquery datasource="#SESSION.COMPANY#" name="INVMB_UPDATE">
   UPDATE INVMB
   SET MB002='#FORM.MB002#',
          MB003='#FORM.MB003#',
          MB004='#FORM.MB004#',
          MB006='#FORM.MB006#',
          MB036=#FORM.MB036#,
          MB039=#FORM.MB039#
    WHERE 1=1
         AND MB001='#FORM.MB001#'
</cfquery>


<cflocation url="INVMB.cfm">