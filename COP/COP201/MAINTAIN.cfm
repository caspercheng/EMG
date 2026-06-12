<title>異動日期維護</title>
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
<cfquery name="COPKA" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKA
	WHERE  1=1
		AND KA001 ='#URL.KB001#'
		AND KA002 ='#URL.KB002#'
		AND KA003 ='#URL.KB003#'

</cfquery>



 <!---查詢客戶訂單身資料--->
<cfquery name="COPKB" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKB
	WHERE  1=1
		AND KB001 ='#URL.KB001#'
		AND KB002 ='#URL.KB002#'
		AND KB003 ='#URL.KB003#'
	ORDER BY KB003 
</cfquery>

    
<h4 align="center">異動日期維護</h4>
<cfform action="COPKB_INSERT_SQL.cfm" method="post" id="TF001">
	<cfinput type="hidden" name="KB001" value="#URL.KB001#">
	<cfinput type="hidden" name="KB002" value="#URL.KB002#">
	<cfinput type="hidden" name="KB003" value="#URL.KB003#">
<table align="center">
	<tr>
		<td>
		<!---預計完成日--->
		預計完成日變更:					  
		<cfinput type="text" name="KB006_1" value="" size=10 mask="9999-99-99">				   
		<!---ETD新增--->
		ETD變更:					  
		<cfinput type="text" name="KB006_2" value="" size=10 mask="9999-99-99">				   
		<!---ETA新增--->
		ETA變更:					  
		<cfinput type="text" name="KB006_3" value="" size=10 mask="9999-99-99">			
		B/L變更:					  
		<cfinput type="text" name="KB006_5" value="" size=10 mask="9999-99-99">			
		尾款收款日:					  
		<cfinput type="text" name="KB006_4" value="" size=10 mask="9999-99-99">			

		<input type="submit" name="submit" value="新增" class="btn btn-primary m-1">	   
		</td>
	</tr>
</table>
		

</cfform>

<table align="center"  border="1" >
	<tr bgcolor="666666" style="color:FFF">
		<td>序號</td>
		<td>變更類別</td>
		<td>變更日期</td>
		<td>逾期原因說明</td>
		<td align="center">修改</td>
		<td align="center">取消</td>
	</tr>

   <cfloop query="COPKB" > 	
    

	<cfform action="COPKB_UPDATE_SQL.cfm" method="post">
	<cfinput type="hidden" name="KB001" value="#KB001#">
	<cfinput type="hidden" name="KB002" value="#KB002#">
	<cfinput type="hidden" name="KB003" value="#KB003#">
	<cfinput type="hidden" name="KB004" value="#KB004#">
	<cfinput type="hidden" name="KB005" value="#KB005#">

    <tr>
		<td align="center">#KB004#</td>
		<td >
		<cfif #KB005# EQ "1">1.預計完成日
		<cfelseif #KB005# EQ "2">2.ETD日
		<cfelseif #KB005# EQ "3">3.ETA日
		<cfelseif #KB005# EQ "4">4.尾款收款日
		<cfelseif #KB005# EQ "5">5.B/L日
		</cfif>	

		</td>
		<td ><cfinput type="text" name="KB006" value="#KB006#" size=10></td>
		<td ><cfif #KB005# EQ "1"><cfinput type="text" name="KB009" value="#KB009#" size=30></cfif></td>
		<td>
		<input type="submit" name="submit" value="修改" class="btn btn-secondary btn-sm m-1">
		</td>
		<td align="center"><a href="COPKB_DELETE_SQL.cfm?KB001=#KB001#&KB002=#KB002#&KB003=#KB003#&KB004=#KB004#" class="btn btn-warning btn-sm m-1" onclick = "if (! confirm('是否確認要取消此筆?')) { return false; }">取消</a></td>
	</tr>
    </cfform>
	</cfloop>			
</table>
<!---<BR>
<BR>
<h4 align="center">逾期原因說明</h4>
<cfform action="KA011_UPDATE_SQL.cfm" method="post" id="TF001">
<cfloop query="COPKA">
	<cfinput type="hidden" name="KB001" value="#URL.KB001#">
	<cfinput type="hidden" name="KB002" value="#URL.KB002#">
	<cfinput type="hidden" name="KB003" value="#URL.KB003#">
<table align="center">
	<tr>
		<td>
		<!---預計完成日--->							  
		<textarea name="KA011"  cols=100 rows=5>#KA011#</textarea>		</td>		
	</tr>
	<tr>
		<td align="center"><input type="submit" name="submit" value="更新" class="btn btn-primary m-1">	</td>
	</tr>
</table>
		
</cfloop>
</cfform>


<BR>
--->

<cfset #SESSION.COP202MSG# = "">	
<cfset #SESSION.COP202MSG_W# = "">	
<cfset #session.errorMSG#="">	 
<center><input type="button" value="結束-關閉視窗" onClick="top.window.close()" class="btn btn-outline-warning"></center>
</cfoutput>


