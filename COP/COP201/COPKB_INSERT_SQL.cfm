<cfinclude template="/EMG/menu.cfm">
<cfoutput>

	<cfif #FORM.KB006_1# NEQ "">
	<!---查詢當月客戶訂單最大號--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPKB_KB004">
		SELECT MAX(KB004) +1 AS MAX_KB004,ISNULL(MAX(KB006),'') old_KB006_1
		FROM COPKB
		WHERE  0 = 0
			AND KB001 = '#FORM.KB001#'
			AND KB002 = '#FORM.KB002#'
			AND KB003 = '#FORM.KB003#'
			AND KB005='1'
	</cfquery>
	
	<!---若當月份無資料，自動帶出第一筆--->
	<cfloop query="COPKB_KB004">
		<cfif #MAX_KB004# EQ "">
			<cfset SN = "11">
		<cfelse>
			<cfset SN = "#NUMBERFORMAT(MAX_KB004,"00")#">
		</cfif>
			<cfset old_KB006_1= "#old_KB006_1#">
	</cfloop>
	
	
		<cfquery datasource="#SESSION.COMPANY#" name="INSERT_COPKB">
		   INSERT COPKB  (KB001,KB002,KB003,KB004,KB005,KB006,KB007,KB008)
		   VALUES ('#FORM.KB001#','#FORM.KB002#','#FORM.KB003#','#SN#','1', '#FORM.KB006_1#','#old_KB006_1#','#DATEFORMAT(NOW(),"yyyymmdd")#')
		</cfquery>
	</cfif>
	
	<cfIf #FORM.KB006_2# NEQ "">
		<!---查詢當月客戶訂單最大號--->
	<cfquery datasource="#SESSION.COMPANY#" name="COPKB_KB004">
		SELECT MAX(KB004) +1 AS MAX_KB004,ISNULL(MAX(KB006),'') old_KB006_2
		FROM COPKB
		WHERE  0 = 0
			AND KB001 = '#FORM.KB001#'
			AND KB002 = '#FORM.KB002#'
			AND KB003 = '#FORM.KB003#'
			AND KB005='2'

	</cfquery>
	
	<!---若當月份無資料，自動帶出第一筆--->
	<cfloop query="COPKB_KB004">
		<cfif #MAX_KB004# EQ "">
			<cfset SN = "21">
		<cfelse>
			<cfset SN = "#NUMBERFORMAT(MAX_KB004,"00")#">
		</cfif>
			<cfset old_KB006_2 = "#old_KB006_2#">
	
	</cfloop>
	
		<cfquery datasource="#SESSION.COMPANY#" name="INSERT_COPKB">
		   INSERT COPKB  (KB001,KB002,KB003,KB004,KB005,KB006,KB007,KB008)
		   VALUES ('#FORM.KB001#','#FORM.KB002#','#FORM.KB003#','#SN#','2', '#FORM.KB006_2#', '#old_KB006_2 #','#DATEFORMAT(NOW(),"yyyymmdd")#')
		</cfquery>
	</cfIf>
	
	<cfif #FORM.KB006_3# NEQ "">
			<!---查詢當月客戶訂單最大號--->
		<cfquery datasource="#SESSION.COMPANY#" name="COPKB_KB004">
			SELECT MAX(KB004) +1 AS MAX_KB004,ISNULL(MAX(KB006),'') old_KB006_3
			FROM COPKB
			WHERE  0 = 0
				AND KB001 = '#FORM.KB001#'
				AND KB002 = '#FORM.KB002#'
				AND KB003 = '#FORM.KB003#'
				AND KB005='3'
		</cfquery>
		
		<!---若當月份無資料，自動帶出第一筆--->
		<cfloop query="COPKB_KB004">
			<cfif #MAX_KB004# EQ "">
				<cfset SN = "31">
			<cfelse>
				<cfset SN = "#NUMBERFORMAT(MAX_KB004,"00")#">
			</cfif>
			<cfset old_KB006_3 = "#old_KB006_3#">
		</cfloop>

		<cfquery datasource="#SESSION.COMPANY#" name="INSERT_COPKB">
		   INSERT COPKB  (KB001,KB002,KB003,KB004,KB005,KB006,KB007,KB008)
		   VALUES ('#FORM.KB001#','#FORM.KB002#','#FORM.KB003#','#SN#','3', '#FORM.KB006_3#', '#old_KB006_3 #', '#DATEFORMAT(NOW(),"yyyymmdd")#')
		</cfquery>
	</cfif>
	
		<cfif #FORM.KB006_4# NEQ "">
			<!---查詢當月客戶訂單最大號--->
		<cfquery datasource="#SESSION.COMPANY#" name="COPKB_KB004">
			SELECT MAX(KB004) +1 AS MAX_KB004,ISNULL(MAX(KB006),'') old_KB006_4
			FROM COPKB
			WHERE  0 = 0
				AND KB001 = '#FORM.KB001#'
				AND KB002 = '#FORM.KB002#'
				AND KB003 = '#FORM.KB003#'
				AND KB005='4'
		</cfquery>
		
		<!---若當月份無資料，自動帶出第一筆--->
		<cfloop query="COPKB_KB004">
			<cfif #MAX_KB004# EQ "">
				<cfset SN = "41">
			<cfelse>
				<cfset SN = "#NUMBERFORMAT(MAX_KB004,"00")#">
			</cfif>
			<cfset old_KB006_4 = "#old_KB006_4#">
		</cfloop>

		<cfquery datasource="#SESSION.COMPANY#" name="INSERT_COPKB">
		   INSERT COPKB  (KB001,KB002,KB003,KB004,KB005,KB006,KB007,KB008)
		   VALUES ('#FORM.KB001#','#FORM.KB002#','#FORM.KB003#','#SN#','4', '#FORM.KB006_4#', '#old_KB006_4 #', '#DATEFORMAT(NOW(),"yyyymmdd")#')
		</cfquery>
	</cfif>
	
	<cfif #FORM.KB006_5# NEQ "">
			<!---查詢當月客戶訂單最大號--->
		<cfquery datasource="#SESSION.COMPANY#" name="COPKB_KB004">
			SELECT MAX(KB004) +1 AS MAX_KB004,ISNULL(MAX(KB006),'') old_KB006_5
			FROM COPKB
			WHERE  0 = 0
				AND KB001 = '#FORM.KB001#'
				AND KB002 = '#FORM.KB002#'
				AND KB003 = '#FORM.KB003#'
				AND KB005='5'
		</cfquery>
		
		<!---若當月份無資料，自動帶出第一筆--->
		<cfloop query="COPKB_KB004">
			<cfif #MAX_KB004# EQ "">
				<cfset SN = "51">
			<cfelse>
				<cfset SN = "#NUMBERFORMAT(MAX_KB004,"00")#">
			</cfif>
			<cfset old_KB006_5 = "#old_KB006_5#">
		</cfloop>

		<cfquery datasource="#SESSION.COMPANY#" name="INSERT_COPKB">
		   INSERT COPKB  (KB001,KB002,KB003,KB004,KB005,KB006,KB007,KB008)
		   VALUES ('#FORM.KB001#','#FORM.KB002#','#FORM.KB003#','#SN#','5', '#FORM.KB006_5#', '#old_KB006_5 #', '#DATEFORMAT(NOW(),"yyyymmdd")#')
		</cfquery>
	</cfif>

</cfoutput>
<!---跳到客戶訂單單身新增畫面--->
<cflocation url="MAINTAIN.cfm?KB001=#FORM.KB001#&KB002=#FORM.KB002#&KB003=#FORM.KB003#">