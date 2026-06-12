<!--- This template defines the PassUrlVars() and PassFormVars() functions --->
<!--- These functions are user defined and can be adapted as needed --->
<cfinclude template="VarPassingFunctions.cfm">
<cfinclude template="header.cfm">

<cfif NOT IsDefined("SESSION.login_msn")><cfset #SESSION.login_msn#=""></cfif> 
		
<html>

<cfoutput>
<cfset #FORM.COMPANY# ="">
 <!--- 將使用者輸入的帳號密碼，跟資料庫DSCSYS.DSCMA做比對---> 
<cfquery name="DSCMB" datasource="PKOOL">
	 SELECT *
	 FROM DSCMB
    
	 WHERE 1=1
</cfquery>

<!--- 該滑鼠游標停在帳號輸入上--->
<body onLoad="document.loginForm.userLogin.focus();">

<cfform action="#CGI.script_name#?#PassUrlVars()#" name="loginForm" 
  method="post" preservedata="yes">
  
  <cfoutput>#passFormVars("UserLogin,UserPassword")#</cfoutput>
  
  <!--- Make the UserLogin and UserPassword fields required --->
  <input type="hidden" name="userLogin_required">
  <input type="hidden" name="userPassword_required">

<h4 align="center">歡迎使用上岳科技資訊系統</h4>
  <!--- Use an HTML table for simple formatting --->
  <table border="0" align="center" style="font-size:24px">
    <tr><td colspan="2" bgcolor="silver" align="center">系統登入</td></tr>
    <tr height="50">
      <td>帳號：</td>
      <td>
	  <cftooltip tooltip="輸入你的員工工號"> 
      <cfinput type="text" name="userLogin" size="10" value=""  maxlength="10" required="yes" message="請輸入帳號。"  style="font-size:24px">
      </cftooltip>
      </td>
    </tr>
	
	<tr height="50">
      <td>密碼：</td>
      <td>
		  <cftooltip tooltip="輸入你的密碼"> 
			  <cfinput type="password" name="userPassword" size="10" value=""  maxlength="10" required="yes"  message="請輸入密碼。"  style="font-size:24px">
		  </cftooltip>
      </td>
    </tr>
	
	<tr height="50">
	   <td>公司別：</td>
	   <td>
	         <select name="COMPANY"  style="font-size:24px">
		         <cfloop query="DSCMB">
				  <option value="#TRIM(MB001)#">#MB002#</option>
				  </cfloop>	 
			 </select>
	    </td>
	</tr>
	
	<tr>
	  <td colspan="2" align="center">
		  <!--- Submit Button that reads "Enter" --->
		  <cftooltip tooltip="按此進入">  
		  <input type="submit" value="登入" class="btn btn-primary  btn-block"  style="font-size:24px">
			</cftooltip>
	  </td>
	</tr>
  </table>
  
</cfform>

<cfif #SESSION.login_msn# gt "">
      <h4 align="center" class="alert alert-warning">#SESSION.login_msn#</h4>
</cfif>

 <cfset #SESSION.login_msn#= "">

</body>
</html>
</cfoutput>
<cfinclude template="footer.cfm">
