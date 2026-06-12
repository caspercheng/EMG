<cfinclude template="/EMG/menu.cfm">
<cfoutput>

<cfif #FORM.KB005# EQ "1">
		<cfquery datasource="#SESSION.COMPANY#" name="UPDATE_COPKB">
		   UPDATE COPKB  
		   SET KB006='#FORM.KB006#',
		   			KB009='#FORM.KB009#'
		   FROM COPKB
		   WHERE 1=1
		   		AND KB001='#FORM.KB001#'
		   		AND KB002='#FORM.KB002#'
		   		AND KB003='#FORM.KB003#'
		   		AND KB004='#FORM.KB004#'
		</cfquery>
<cfelse>
		<cfquery datasource="#SESSION.COMPANY#" name="UPDATE_COPKB">
		   UPDATE COPKB  
		   SET KB006='#FORM.KB006#'
		   FROM COPKB
		   WHERE 1=1
		   		AND KB001='#FORM.KB001#'
		   		AND KB002='#FORM.KB002#'
		   		AND KB003='#FORM.KB003#'
		   		AND KB004='#FORM.KB004#'
		</cfquery>


</cfif>

</cfoutput>
<!---跳到客戶訂單單身新增畫面--->
<cflocation url="MAINTAIN.cfm?KB001=#FORM.KB001#&KB002=#FORM.KB002#&KB003=#FORM.KB003#">