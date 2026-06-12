<!---CSS--->
<style>
  table {border-collapse: collapse;}

</style>
<title>批號數量查詢</title>

<h4><center>批號數量查詢</center></h4>


<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  *	    
    FROM INVMB
	WHERE 1=1 
    AND  MB001 like '#URL.MB001#' 
	ORDER BY MB001
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="INVMC">
    SELECT CMSMC.MC002 AS NAME,INVMC.MC007	 AS MC007    
    FROM INVMC
	JOIN CMSMC ON INVMC.MC002=CMSMC.MC001
	WHERE 1=1 
    AND  INVMC.MC001 like '#URL.MB001#' 
</cfquery>


<cfquery datasource="#SESSION.COMPANY#" name="INVMF">
	SELECT MF001,MF002,MC002,ME003,ME009,ME010,SUM(MF008*MF010) AS NUM
	FROM INVMF
	JOIN INVME ON ME001=MF001 AND ME002=MF002
	JOIN CMSMC ON MC001=MF007
	WHERE 1=1 
    AND  ME001 like '#URL.MB001#' 
	AND ME007 ='N'
	GROUP BY MF001,MC002,MF002,ME003,ME009,ME010
	HAVING SUM(MF008*MF010) > 0
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="INVLA">
    SELECT  TOP 20 *	    
    FROM INVLA
	JOIN CMSMC ON MC001=LA009
	WHERE 1=1 
    AND  LA001 like '#URL.MB001#' 
	ORDER BY LA004 DESC
</cfquery>


<table border="1" align="center">

<TR bgcolor="666666" style="color:FFF" align="center">
	<TD>品號</TD>
	<TD>品名</TD>
	<TD>規格</TD>
	<TD>單位</TD>
	<TD>屬性</TD>
	<TD>前置天數</TD>
	<TD>MOQ</TD>
	<TD>庫存數量</TD>
</TR>

<cfoutput query="INVMB">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>

	<tr bgcolor="#bgcolor#">
		<TD align="center">#MB001#</TD> 
		<TD>#MB002#</TD> 
		<TD align="center">#MB003#</TD> 
		<TD align="center">#MB004#</TD> 
		<TD align="center"  >#MB025#</TD> 
		<TD align="center">#MB036#</TD> 
		<TD align="right"><cfif #MB039# NEQ 0>#NUMBERFORMAT(MB039,"9,999,999")#</cfif></TD>
		<TD align="right">#NUMBERFORMAT(MB064,"9,999,999.99")#</TD>
	</tr>
</cfoutput>
</table>

<P>
 
 <table border="1" align="center">

 <TR bgcolor="666666" style="color:FFF" align="center">
	<TD>庫別</TD>
	<TD>庫存數量</TD>
</TR>

<cfoutput query="INVMC">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>

	<tr bgcolor="#bgcolor#">
		<TD align="center">#NAME#</TD> 
		<TD align="right">#NUMBERFORMAT(MC007,"9,999,999.99")#</TD>
	</tr>
</cfoutput>
</table>

<P>


<table border="1" align="center">

<TR bgcolor="666666" style="color:FFF"  align="center">
	<TD>批號</TD>
	<TD>最高入庫日</TD>
	<TD>有效日期</TD>
	<TD>複檢日期</TD>
	<TD>庫別</TD>
	<TD>數量</TD>
</TR>

<cfoutput query="INVMF">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<tr bgcolor="#bgcolor#">
		<TD>#MF002#</TD> 
		<TD>#MID(ME003,1,4)#-#MID(ME003,5,2)#-#MID(ME003,7,2)#</TD> 
		<TD>#MID(ME009,1,4)#-#MID(ME009,5,2)#-#MID(ME009,7,2)#</TD> 
		<TD>#MID(ME010,1,4)#-#MID(ME010,5,2)#-#MID(ME010,7,2)#</TD> 
		<TD>#MC002#</TD> 
		<TD align="right">#NUMBERFORMAT(NUM,"9,999,999.99")#</TD>
	</tr>
</cfoutput>
</table>

<P>
 
<table border="1" align="center">

<TR >
	<TD colspan="10">最近入出記錄</TD>
</TR>

<TR bgcolor="666666" style="color:FFF" align="center">
	<TD>日期</TD>
	<TD>單據</TD>
	<TD>異動別</TD>
	<TD>庫別</TD>
	<TD>數量</TD>
	<TD>備註</TD>
</TR>

<cfoutput query="INVLA">
   
    <cfif #LA014# EQ "1"><cfset class="入庫">
    <cfelseif #LA014# EQ "2"><cfset class="銷貨">
    <cfelseif  #LA014# EQ "3"><cfset class="領用">
    <cfelseif  #LA014# EQ "4"><cfset class="轉撥">
    <cfelseif  #LA014# EQ "5"><cfset class="調整">
	</cfif>
	
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<tr bgcolor="#bgcolor#">
		<TD>#MID(LA004,1,4)#-#MID(LA004,5,2)#-#MID(LA004,7,2)#</TD> 
		<TD>#LA006#-#LA007#-#LA008#</TD> 
		<TD align="center">#class#</TD> 
		<TD>#MC002#</TD> 
		<TD align="right" width="80">#NUMBERFORMAT(LA011,"9,999,999.999")#</TD>
		<TD>#LA010#</TD> 
	</tr>
</cfoutput>
</table>

<cfinclude template="/EMG/footer.cfm">
<cfinclude template="/EMG/close_window.cfm">
