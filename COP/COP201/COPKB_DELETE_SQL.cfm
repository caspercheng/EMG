<cfinclude template="/EMG/menu.cfm">
<cfoutput>

		<cfquery datasource="#SESSION.COMPANY#" name="DELETE_COPKB">
		   DELETE COPKB  
		   FROM COPKB
		   WHERE 1=1
		   		AND KB001='#URL.KB001#'
		   		AND KB002='#URL.KB002#'
		   		AND KB003='#URL.KB003#'
		   		AND KB004='#URL.KB004#'
		</cfquery>

</cfoutput>
<!---跳到客戶訂單單身新增畫面--->
<cflocation url="MAINTAIN.cfm?KB001=#URL.KB001#&KB002=#URL.KB002#&KB003=#URL.KB003#">