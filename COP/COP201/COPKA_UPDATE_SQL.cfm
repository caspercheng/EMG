<!---新增訂單單頭資料--->
<cfoutput>
<cfinclude template="/EMG/menu.cfm">

	<cfquery name="COPKA" datasource="#SESSION.COMPANY#">

		UPDATE COPKA 
			SET KA005='#FORM.KA005#',
					KA006='#FORM.KA006#',
					KA007='#FORM.KA007#',
					KA014='#FORM.KA014#',
					KA021='#FORM.KA021#'
		FROM COPKA	
		WHERE 1=1
			AND KA001='#FORM.KA001#'
			AND KA002='#FORM.KA002#'
			AND KA003='#FORM.KA003#'
	</cfquery>
	
<cflocation url="COPKA.cfm?KA001=#URL.KA001#&KA004=#URL.KA004#">

</cfoutput>
