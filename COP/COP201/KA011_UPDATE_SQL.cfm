<!---新增訂單單頭資料--->
<cfoutput>
<cfinclude template="/EMG/menu.cfm">

	<cfquery name="COPKA" datasource="#SESSION.COMPANY#">

		UPDATE COPKA 
			SET KA011='#FORM.KA011#',
					KA012='#DATEFORMAT(now(),"yyyy-mm-dd")#'+' '+ '#timeformat(now(),"HH:MM")#'
		FROM COPKA	
		WHERE 1=1
			AND KA001='#FORM.KB001#'
			AND KA002='#FORM.KB002#'
			AND KA003='#FORM.KB003#'
	</cfquery>
	
<cflocation url="MAINTAIN.cfm?KB001=#FORM.KB001#&KB002=#FORM.KB002#&KB003=#FORM.KB003#">

</cfoutput>
