<title>訂單成本核價表新增</title>
<cfoutput>
<script>
  function setFocus() {
    var loginForm = document.getElementById("TF001");
      loginForm["KC004"].focus();
  }
</script>

<body onLoad="setFocus();" >

<cfinclude template="/EMG/menu.cfm">


<h4 align="center">訂單成本核價表新增</h4>

<cfform action="COPKE_INSERT_SQL.cfm" method="post" enctype="multipart/form-data">

<table border="1" align="center" style="font-size:20px">

	<tr>
	  <td   bgcolor="666666" style="color:FFF">品號</td>
	  <td>
	  <cfinput type="text" name="MB001" value="" size=20>
	  </td>
	  <td   bgcolor="666666" style="color:FFF">基準日</td>
	  <td>
	  <cfinput type="text" name="CHECKDATE" mask="9999-99-99" size=10>
	  </td>
   </tr>

	<tr>	
		<td colspan="4" align="center">
		<input type="submit" name="submit" value="多階展出" class="btn btn-primary">
		</td>
	</tr>
	
</table>

</cfform>


<h4><center><a href="COPKG.cfm" class="btn btn-dark">回上一頁</a></center></h4>

 </cfoutput>

