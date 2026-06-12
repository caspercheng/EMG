<!---新增訂單單頭資料--->
<cfoutput>
<cfinclude template="/EMG/menu.cfm">

	<cfquery name="COPKD" datasource="#SESSION.COMPANY#">

		UPDATE COPKD 
			SET KD002='#FORM.KD002#'

		FROM COPKD	
		WHERE 1=1
			AND KD001='#FORM.KD001#'
	</cfquery>
	
<cflocation url="COPKD.cfm?KA001=#FORM.KD001#">

</cfoutput>
