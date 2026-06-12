<cfinclude template="/EAGLE/menu_all.cfm">

<cfif  NOT IsDefined("FORM.TA001")> <cfset #FORM.TA001#="">	</cfif>
<cfif  NOT IsDefined("FORM.TA003_1")> <cfset #FORM.TA003_1#="">	</cfif>
<cfif  NOT IsDefined("FORM.TA003_2")> <cfset #FORM.TA003_2#="">	</cfif>
<cfif  NOT IsDefined("FORM.TA055")> <cfset #FORM.TA055#="">	</cfif>
<cfif  NOT IsDefined("FORM.TA011")> <cfset #FORM.TA011#="">	</cfif>
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<h4><center>製令明細表</center></h4>

<!---資料查詢介面--->
<cfform action="MOCTA_LIST.cfm">
	<table align="center" bgcolor="9999CC">
	 <tr>
      <td>單別：</td> <td><cfinput type="Text" name="TA001" size="4" maxlength="4" ></td>
	  <td>日期：</td> 
     
          <td><cfinput type="Text" name="TA003_1" size="10" maxlength="10" required="yes" >~</td>
          <td><cfinput type="Text" name="TA003_2" size="10" maxlength="10" required="yes" ></td>
<td>生管人員：</td> <td><cfinput type="Text" name="TA055" size="10" maxlength="10" ></td>
          <td><cfselect name="TA011">
           
           <option value="1">未完工</option>
           <option value="Y">已完工</option>
           <option value="y">指定完工</option>
           <option value="">全部</option>
          </cfselect></td>
	  <td><input type="submit" name="submit" value="查詢"></td>
     </tr>
	</table>
</cfform>


<cfif #FORM.submit# EQ "查詢">

<cfquery name="MOCTA" datasource="EAGLE" result="result1">
    SELECT *
    FROM MOCTA
    LEFT JOIN CMSMV ON MV001=TA055
    WHERE TA003 >= '#FORM.TA003_1#' AND TA003 <='#FORM.TA003_2#' AND TA013='Y'
    <cfif FORM.TA055 IS NOT "">AND MV002 LIKE '%#FORM.TA055#%'</cfif>
    <cfif FORM.TA011 IS "1">AND TA011 IN ('1','2','3')
    <cfelseif FORM.TA011 IS "Y">AND TA011 IN ('Y')
    <cfelseif FORM.TA011 IS "y">AND TA011 IN ('y')
    </cfif>
    <cfif FORM.TA001 IS NOT "">AND TA001 = '#FORM.TA001#'</cfif>
</cfquery>

<cfoutput>
 
<table border="1" align="center">
	<TR bgcolor="666666" style="color:FFF">
	    <td>開立日期</td>
	    <td>單別-單號</td>
	 
            <td>品號</td>
	    <td>品名</br>規格</td>
        
	    <td>製令狀態</td>
		<td>預計產量</td>
		<td>生管人員</td>
	</tr>

    <cfloop query="MOCTA">
    
<cfif #TA011# eq "1"><cfset status = "未生產"></cfif>
<cfif #TA011# eq "2"><cfset status = "已發料"></cfif>
<cfif #TA011# eq "3"><cfset status = "生產中"></cfif>
<cfif #TA011# eq "Y"><cfset status = "已完工"></cfif>
<cfif #TA011# eq "y"><cfset status = "指定完工"></cfif>


    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TA003,1,4)#-#MID(TA003,5,2)#-#MID(TA003,7,2)#</td>
	    <td>#TA001#-#TA002#</td>
	  
		<td>#TA006#</td>
		<td>#TA034#</br>#TA035#</td>
                
<td>#status#</td>
		<td align="right">#NUMBERFORMAT(TA015,"9999999")#</td>
<td>#MV002#</td>
		
	</tr>
    </cfloop>
</table>

</cfoutput>


</cfif>

