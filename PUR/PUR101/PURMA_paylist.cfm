<cfinclude template="/univision/menu.cfm">

<cfquery datasource="#APPLICATION.dataSource#" name="PURMA">
    SELECT  *
    FROM PURMA
    LEFT JOIN DSCSYS..CMSMO ON MO001=MA027
	WHERE 1=1
</cfquery>

<h4><center>供應商匯款帳戶明細</center></h4>

<cfoutput>

<table border="1" align="center">

<TR  bgcolor="666666" style="color:FFF">
   <TD>廠商代號</TD>
   <TD>簡稱</TD>
   <TD>公司全名</TD>
   <TD>統一編號</TD>
   <TD>聯絡人</TD>
   <TD>聯絡地址</TD>
   <TD>付款方式</TD>
   <TD>匯款銀行代號</TD>
   <TD>銀行名稱</TD>
   <TD>帳號</TD>
</TR>

<cfloop query="PURMA">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
	<cfif MA024 EQ "1"><cfset 付款方式 =" 1.現金"></cfif>
	<cfif MA024 EQ "2"><cfset 付款方式 =" 2.電匯"></cfif>
	<cfif MA024 EQ "3"><cfset 付款方式 =" 3.支票"></cfif>
	<cfif MA024 EQ "4"><cfset 付款方式 =" 4.其他"></cfif>
	<TR bgcolor="#bgcolor#" >
		<TD>#MA001#</TD> 
		<TD>#MA002#</TD>
		<TD>#MA003#</TD>
		<TD>#MA005#</TD>
		<TD>#MA013#</TD>
		<TD>#MA014#</TD>
		<TD>#付款方式#</TD>
		<TD>#MA027#</TD>
		<TD>#MO006#</TD>
		<TD>#MA028#</TD>
	</TR>
</cfloop>

</table>


</cfoutput>

