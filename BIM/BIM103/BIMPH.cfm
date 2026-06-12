<title>公司別權限設定</title>
<cfinclude template="/EMG/menu.cfm">

<cfoutput>

<center><h4>公司別權限設定</h4></center>

<!---查詢多公司資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT  MB001,MB002,MB003,'no' as che
	FROM DSCMB
	WHERE 	1=1
	--	AND MB001 IN  ('KS','FS','XC','LY','NLY','KK','HJ','FS_A','FS_B','XC_B','KK_A','TEST','XC_TEST','FS_TEST')
	    AND MB001 NOT IN
	   (SELECT MB001
		FROM BIMPH
		JOIN DSCMB ON MB003=PH003
		WHERE PH001='#URL.PF001#' AND PH002='#URL.PF002#')

	
	union 
	
		SELECT MB001,MB002,MB003,'yes' as che
		FROM BIMPH
		JOIN DSCMB ON MB003=PH003
		WHERE PH001='#URL.PF001#' AND PH002='#URL.PF002#'


</cfquery>

<!---查詢多公司資料--->
<cfquery name="BIMPE" datasource="PKOOL">
	SELECT *
	FROM BIMPE
	WHERE PE001='#URL.PF002#'
</cfquery>

<cfloop query="BIMPE"><cfset pro_name=#PE002#></cfloop>

<!---資料查詢介面--->
<cfform action="BIMPH_INSERT.cfm" method="post">
	<table align="center"  border="1">
	    <tr><td bgcolor="666666" style="color:FFF">使用者工號：</td> <td><cfinput type="Text" name="PH001" size="10" maxlength="20"  value="#URL.PF001#" readonly="yes"></td>	 </tr>
	    <tr><td bgcolor="666666" style="color:FFF">程式代號：</td> <td><cfinput type="Text" name="PH002" size="10" maxlength="20"  value="#URL.PF002#" readonly="yes"></td>	 </tr>
	    <tr><td bgcolor="666666" style="color:FFF">適用公司別：</td> <td><cfloop query="DSCMB"><cfinput type="checkbox" name='check1' id='check_list' checked="#che#" style="zoom: 1.5"  value="'#Trim(MB003)#'"/>#MB002#</cfloop></td></tr>
	    <tr><td colspan="3" align="center"><input type="submit" name="submit" value="權限設定"></td></tr>
	</table>
</cfform>

<h4><center><a href="BIMPF.cfm?PE001=#URL.PF002#" class="btn btn-dark btn-sm m-1">回上一頁</a></center></h4>
</cfoutput>
