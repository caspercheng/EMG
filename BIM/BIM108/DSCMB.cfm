<title>公司別維護作業</title>

<cfinclude template="/EMG/menu.cfm">


<!---設定此程式代號--->
<cfset program_id = "BIM108" >
<cfset program_name = "公司別維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<!---查詢資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT *
	FROM DSCMB
</cfquery>


<script>
	function Check(chk){
		if(document.myform.Check_ctr.checked==true){
			for (i = 0; i < chk.length; i++)
				chk[i].checked = true ;
		}else{
			for (i = 0; i < chk.length; i++)
				chk[i].checked = false ;
		}
	}
</script>

<cfoutput>

<center><h4>公司別維護作業</h4></center>
	
<cfform action="MB004_UPDATE.cfm" enctype="multipart/form-data"  method="post" name='myform'>
<cfif #新增權限# eq "Y"><a href="DSCMB_INSERT.cfm"class="btn btn-primary btn-sm m-1">新增</a></cfif>
<cfif #修改權限# eq "Y"><cfinput type="submit" name="submit" value="開放" class="btn btn-success btn-sm m-1"></cfif>
<cfif #修改權限# eq "Y"><cfinput type="submit" name="submit" value="不開放" class="btn btn-secondary btn-sm m-1"></cfif>

<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

    <tr bgcolor="666666" style="color:FFF">
		<td>項目</td>
        <td>公司代號</td>
        <td>公司名稱</td>
        <td>資料庫名稱</td>
        <td>開放否</td>
        <td>修改</td>
        <td>刪除</td>
    </tr>	

  </thead>

<tbody>
    
    <cfloop query="DSCMB">
	
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    
    <tr bgcolor="#bgcolor#">
		 <td align="center"><cfinput type="checkbox" name='check1' id='check_list' checked="no" class="largerCheckbox"  value="'#Trim(MB001)#'"/></td>        
			<td align="center">#MB001#</td>
			<td align="center">#MB002#</td>
			<td align="center">#MB003#</td>
			<td align="center">
			<cfif #MB004# EQ "Y">
				V
			</cfif>
		</td>
		<td align="center"><cfif #修改權限# eq "Y"><a href="DSCMB_UPDATE.cfm?MB001=#MB001#" class="btn btn-success btn-sm">修改</a></cfif></td>
		<td align="center"><cfif #刪除權限# eq "Y"><a href="DSCMB_DELETE_SQL.cfm?MB001=#MB001#" class="btn btn-secondary btn-sm">刪除</a></cfif></td>
    </tr>

    </cfloop>
    
</tbody>
</table>

</div>

</cfform>
</cfoutput>

<cfinclude template="/EMG/footer.cfm">
