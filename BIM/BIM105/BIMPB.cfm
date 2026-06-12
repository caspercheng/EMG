<title>人員帳號維護作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM105" >
<cfset program_name = "人員資料維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.PB000")><cfset #FORM.PB000#=""></cfif>
<cfif NOT IsDefined("FORM.PB001")><cfset #FORM.PB001#=""></cfif>
<cfif NOT IsDefined("FORM.PB002")><cfset #FORM.PB002#=""></cfif>

<cfoutput>

<h4 align="center">人員帳號維護作業</h4>

<!---資料查詢介面--->
<cfform action="BIMPB.cfm" method="post">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>工號</td> <td><cfinput type="Text" name="PB001" size="10" maxlength="10"  value=""></td>	 
	  <td>姓名</td> <td><cfinput type="Text" name="PB002" size="10" maxlength="10"  value=""></td>
	  <td>含失效</td> <td><cfinput type="checkbox" name="PB000"  checked="no" style="zoom: 1.5"></td>
	  <td colspan="1" align="center"><cfinput type="submit" name="submit" value="查詢" ></td>
     </tr>
	</table>
</cfform>

<!---查詢人員資料--->
<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	LEFT JOIN (SELECT PC001,PC002,PB002 AS PCPB002 FROM BIMPC LEFT JOIN BIMPB ON PC003=PB001) AS BIMPC ON PB005=PC001
    LEFT JOIN EMG..COPMA ON MA001=PB009
	WHERE 1=1 
	<cfif FORM.PB000 IS NOT  "on"> AND  PB007 in ('N')</cfif>
	<cfif FORM.PB001 IS NOT ""> AND  PB001 LIKE  '%#FORM.PB001#%' </cfif>	
	<cfif FORM.PB002 IS NOT ""> AND  PB002 LIKE  '%#FORM.PB002#%' </cfif>
	ORDER BY PB001
</cfquery>

	
<a href="CMSMVtoBIMPB.cfm" class="btn btn-primary m-1">同步人員帳號</a>
	
<div style="height:auto;">
<table id="myTable01" class="fancyTable" >
<thead>

    <tr bgcolor="666666" style="color:FFF">
        <th>項次</th>
        <th>工號</th>
        <th>名稱</th>
        <th>部門</th>
        <th>客戶代號</th>
        <th>E-Mail</th>
        <th>在職否</th>
        <th>修改</th>
        <th>人員權限設定</th>
        <th>刪除</th>
    </tr>	
	
</thead>
<tbody>
   
    <cfloop query="BIMPB">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#CurrentRow#</td>
        <td align="center">#PB001#</td>
        <td align="center">#PB002#</td>
        <td align="center">#PC002#</td>
        <td align="center">#PB009#-#MA002#</td>
        <td align="center">#PB006#</td>
        <td align="center"><cfif #PB007# EQ "N">在職<cfelse>離職</cfif></td>
	   <td align="center"><cfif #修改權限# eq "Y"><a href="BIMPB_UPDATE.cfm?PB001=#PB001#"  class="btn btn-success btn-sm m-1">修改</a></cfif></td>
	   <td align="center"><cfif #修改權限# eq "Y"><a href="BIMPF.cfm?PB001=#PB001#" class="btn btn-info btn-sm m-1">權限設定</a></cfif></td>
	   <td align="center"><cfif #刪除權限# eq "Y"><a href="BIMPB_DELETE_SQL.cfm?PB001=#PB001#" onclick = "if (! confirm('是否確認要刪除?')) { return false; }" class="btn btn-secondary btn-sm m-1">刪除</a></cfif></td>
    </tr>

    </cfloop>
    
</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
