
<cfquery datasource="#SESSION.COMPANY#"  name="PURMA">
    SELECT  *
    FROM PURMA
	WHERE MA001 ='#URL.PURMA001#'
</cfquery>



<h4><center>供應商資料</center></h4>

<cfoutput>
<cfloop query="PURMA">
<table border="1" align="center">

<TR><TD  bgcolor="666666" style="color:FFF">廠商代號</TD><TD>#MA001#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">簡稱</TD><TD>#MA002#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">公司全名</TD><TD>#MA003#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">統一編號</TD><TD>#MA005#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">TEL</TD><TD>#MA008#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">FAXNO.</TD><TD>#MA010#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">聯絡人</TD><TD>#MA013#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">聯絡地址</TD><TD>#MA014#</TD></TR>
<TR><TD  bgcolor="666666" style="color:FFF">E-MAIL</TD><TD>#MA011#</TD></TR>
</TR>

</table>

</cfloop>
</cfoutput>

