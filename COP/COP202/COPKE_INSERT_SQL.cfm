<cfinclude template="/EMG/menu.cfm">

<cfoutput>

<cfset MB001="">
<cfset bomno=0000>

<!---查詢是否產生過成本核價表--->
<cfquery datasource="#SESSION.COMPANY#" name="COPKG">
    SELECT *
    FROM COPKG
    WHERE  0 = 0
		AND KG002='#FORM.MB001#'
		AND KG003='#FORM.CHECKDATE#'

</cfquery>


<cfif #COPKG.RecordCount# gt 0>
	<H4 align="center" class="alert alert-danger">此品號及基準日已產生過成本核價表!!!</H4>
	<a href="COPKG_INSERT0.cfm"  class="btn btn-dark">回上一頁</a>
	<cfabort>

<cfelse>
		<!---將品號金額全部先歸零--->
		<cfquery datasource="#SESSION.COMPANY#" name="UPDATE_INVMB8">
			UPDATE INVMB
			SET MB801=0,
					MB802=0,
					MB803=0,
					MB804=0,
					MB805=0,
					MB806=0,
					MB807='',
					MB808=''
			WHERE  1=1
		</cfquery>

	<!---產生該品號多階資料至COPKG/COPKH--->
	<cfinclude template="bom2.cfm">
	
</cfif>



<cflocation url="COPKG_INSERT0.cfm">

</cfoutput>