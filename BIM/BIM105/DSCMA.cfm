<title>人員帳號新增作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM105" >
<cfset program_name = "部門組織維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.MA001")><cfset #FORM.MA001#=""></cfif>
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif>

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


<center><h4>人員帳號新增作業</h4></center>

<cfoutput>

<!---資料查詢介面--->
<cfform action="DSCMA.cfm" method="post">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>工號</td><td><cfinput type="Text" name="MA001" size="10" maxlength="10"  value=""></td>	 
	  <td>名稱</td><td><cfinput type="Text" name="MA002" size="10" maxlength="10"  value=""></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
         </tr>
	</table>
</cfform>

<!---查詢人員資料--->
<cfquery name="DSCMA" datasource="PKOOL">
	SELECT *
	FROM DSCSYS..DSCMA
    LEFT JOIN BIMPB ON PB001=MA001
	WHERE PB001 IS NULL 
	<cfif FORM.MA001 IS NOT ""> AND  MA001 LIKE  '%#FORM.MA001#%' </cfif>	
	<cfif FORM.MA002 IS NOT ""> AND  MA002 LIKE  '%#FORM.MA002#%' </cfif>
	ORDER BY MA001
</cfquery>
	
<cfform action="BIMPB_INSERT_SQL.cfm" enctype="multipart/form-data"  method="post" name='myform' >
	
<table border="1" align="center">

    <TR >
        <td colspan="20"><cfinput type="submit" name="submit" value="新增"  class="btn btn-primary m-1"></td>
    </tr>	

    <TR bgcolor="666666" style="color:FFF">
		<td>全選<cfinput type='checkbox' name='Check_ctr' value='yes' onClick="Check(document.myform.check_list)"></td>
        <td align="center">項次</td>
        <td align="center">工號</td>
        <td align="center">名稱</td>
    </tr>	
    
    <cfloop query="DSCMA">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr  bgcolor="#bgcolor#">
	    <td align="center"><cfinput type="checkbox" name='check1' id='check_list' checked="no"  value="'#Trim(MA001)#'" class="largerCheckbox" /></td>
        <td align="center">#CurrentRow#</td>
        <td>#MA001#</td>
        <td>#MA002#</td>
    </tr>
    </cfloop>
    
</table>

</cfform>

<center><a href="BIMPB.cfm" class="btn btn-dark">回上一頁</a></center>

<cfinclude template="/EMG/footer.cfm">

</cfoutput>
