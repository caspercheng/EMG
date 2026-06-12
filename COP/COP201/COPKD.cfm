<title>預交日延遲</title>
<!---CSS--->
<style>
	table {border-collapse: collapse;font-family: "Microsoft JhengHei","微軟正黑體",arial,sans-serif !important;}
	input.largerCheckbox { width: 22px;  height: 22px;  } 
	body{font-family: "Microsoft JhengHei","微軟正黑體",arial,sans-serif !important;}
</style>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="/css/bootstrap.min.css">

<cfif  NOT IsDefined("session.COP202MSG")> <cfset #session.COP202MSG#="">	</cfif>
<cfif  NOT IsDefined("session.COP202MSG_W")> <cfset #session.COP202MSG_W#="">	</cfif>
<cfif  NOT IsDefined("session.errorMSG")> <cfset #session.errorMSG#="">	</cfif>
 <cfif  NOT IsDefined("session.payclass")> <cfset #session.payclass#="">	</cfif>
<cfset session.sn = "">
<!---依前端勾選條件，查詢客戶訂單內容--->

<cfoutput>

<script>
  function setFocus() {
    var loginForm = document.getElementById("TF001");
      loginForm["PB002_2"].focus();
  }
</script>

<!---按F2，表示完成--->
<script>
	function keyFunction() {
	　if (event.keyCode==113) {
	　　document.location="finish.cfm";
	　  } 
	}
</script>
<script>document.onkeydown=keyFunction;</script>

<body onLoad="setFocus();" >

 <!---查詢客戶訂單資料--->
<cfquery name="COPKD" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKD
	WHERE  1=1
		AND KD001 ='#URL.KA001#'

</cfquery>


<cfif #COPKD.recordcount# eq 0>
<cfquery name="COPKD_INSERT" datasource="#SESSION.COMPANY#">
 INSERT COPKD (KD001,KD002)
 VALUES ('#URL.KA001#','')
 </cfquery>
</cfif>

 <!---查詢客戶訂單資料--->
<cfquery name="COPKD1" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKD
	WHERE  1=1
		AND KD001 ='#URL.KA001#'

</cfquery>

<h4 align="center">延遲原因說明</h4>
<cfform action="KD002_UPDATE_SQL.cfm" method="post" id="TF001">
<cfloop query="COPKD1">
	<cfinput type="hidden" name="KD001" value="#URL.KA001#">
<table align="center">
	<tr>
		<td>
		<!---預計完成日--->							  
		<textarea name="KD002"  cols=100 rows=5>#KD002#</textarea>		</td>		
	</tr>
	<tr>
		<td align="center"><input type="submit" name="submit" value="更新" class="btn btn-primary m-1">	</td>
	</tr>
</table>
		
</cfloop>
</cfform>


<BR>


<cfset #SESSION.COP202MSG# = "">	
<cfset #SESSION.COP202MSG_W# = "">	
<cfset #session.errorMSG#="">	 
<center><input type="button" value="結束-關閉視窗" onClick="top.window.close()" class="btn btn-outline-warning"></center>
</cfoutput>


