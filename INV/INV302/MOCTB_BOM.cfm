<cfinclude template="/EAGLE/menu_all.cfm">

<cfif  NOT IsDefined("FORM.TA001")> <cfset #FORM.TA001#="">	</cfif>
<cfif  NOT IsDefined("FORM.TA002_1")> <cfset #FORM.TA002_1#="">	</cfif>
<cfif  NOT IsDefined("FORM.TA002_2")> <cfset #FORM.TA002_2#="">	</cfif>

<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif>

<title>製令狀況查詢作業</title>

<h4><center>製令狀況查詢作業</center></h4>

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

<!---資料查詢介面--->
<cfform action="MOCTB_BOM.cfm">
	<table align="center" bgcolor="9999CC">
	 <tr>
	      <td>製令單別：</td> <td><cfinput type="Text" name="TA001" size="4" maxlength="4" required="yes" ></td>
          <td>單號：</td> <td><cfinput type="Text" name="TA002_1" size="15" maxlength="15" required="yes" >~</td>
          <td><cfinput type="Text" name="TA002_2" size="15" maxlength="15" required="yes" ></td>
	      <td><input type="submit" name="submit" value="查詢"></td>
     </tr>
	</table>
</cfform>

<cfif #FORM.submit# EQ "查詢">

<!---查詢BOM表資料--->

<cfquery datasource="EAGLE" name="MOCTA">
    SELECT *
    FROM MOCTA
    WHERE 0=0 AND TA001='#FORM.TA001#' AND TA002 >='#FORM.TA002_1#' AND TA002 <='#FORM.TA002_2#'
</cfquery>
        
<cfform action="MOCTB_BOM_material.cfm"  method='post' name='myform' target="_blank">       
<table border="1" align="center">
    <tr bgcolor="CCCCCC" >
	 <TD>全選<cfinput type='checkbox' name='Check_ctr' value='yes' onClick="Check(document.myform.check_list)"></TD>
     <td>製令</td>
     <td>產品品名</td>
     <td>規格</td>
     <td>預計產量 </td>
    </tr>
          
<cfoutput>
 
  <cfloop query="MOCTA">

  <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
      
  <tr bgcolor="#bgcolor#">
	 <TD align="center"><cfinput type="checkbox" name='check1' id='check_list' checked="yes"  value="'#Trim(TA001)##Trim(TA002)#'"/></TD>
     <td>#TA001#-#TA002#</td>
     <td>#TA034#</td>
     <td>#TA035#</td>
     <td>#TA011#</td>
  </tr>

  </cfloop>
 </cfoutput>	
   

</table>

<P>
<center><cfinput type="submit" width="20"  style="font-size:22px;background-color:F0F0F0" name="submit" value="產生材料庫存狀況"></center>

</cfform>
	  
</cfif>


