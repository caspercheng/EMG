
<!--- Force the user to log in --->
<!--- *** This code only executes if the user has not logged in yet! *** --->
<!--- Once the user is logged in via <cfloginuser>, this code is skipped --->
<cflogin>
 
 <!--- 檢查是否有登入，未登入則跳到登入畫面---> 
 <cfif not (isDefined("FORM.userLogin") and isDefined("FORM.userPassword"))>
    <cfinclude template="UserLoginForm.cfm">
    <cfabort> 
 
 <cfelse> 
 
 <!--- 將使用者輸入的帳號密碼，跟資料庫DSCSYS.DSCMA做比對---> 
<cfquery name="getUser" datasource="PKOOL">
	 SELECT *
	 FROM BIMPB
     LEFT JOIN BIMPC ON PB005=PC001
	 WHERE PB001 = '#FORM.UserLogin#'
	      AND PB004='#FORM.userPassword#'
		  AND PB007='N'
</cfquery>
 
 <cfquery name="checkcompany" datasource="PKOOL">
	 SELECT TOP 1 *
	 FROM BIMPH
	 WHERE PH001 = '#FORM.UserLogin#'
</cfquery>

 <cfquery name="DSCMB" datasource="PKOOL">
<!---	 SELECT *
	 FROM DSCMB
	 WHERE MB003 = '#FORM.COMPANY#'--->
	  SELECT TOP 1 DSCMB.*
	 FROM BIMPH
	 LEFT JOIN DSCMB ON MB001=PH003
	 WHERE PH001 = '#FORM.UserLogin#'
	  AND MB003 = '#FORM.COMPANY#'
</cfquery>



<!--- If the username and password are correct... --->
<cfif getUser.recordCount GT 0>
     <!--- Tell ColdFusion to consider the user "logged in" --->
     <!--- For the NAME attribute, we will provide the user's --->
     <!--- ContactID number and first name, separated by commas --->
     <!--- Later, we can access the NAME value via GetAuthUser() --->
     <cfloginuser
     name="#getUser.PB001#"
     password="#FORM.userPassword#"
     roles=""> 

	<cfoutput query="DSCMB">
		<cfset SESSION.company= #trim(MB003)#>
		<cfset SESSION.company_NAME= #MB002#>
	</cfoutput>

	<!---設定登入session變數--->
	<cfoutput query="getUser">
	   <cfset SESSION.code= #PB001#>
	   <cfset SESSION.Cnname= #PB002#>
	   <cfset SESSION.Enname= #PB003#>
	   <cfset SESSION.DepCode= #PC001#>   
	   <cfset SESSION.Dep= #PC002#>
	   <cfset SESSION.PB009= #PB009#>
	</cfoutput>

    <!--- 新增登入資料---> 
    <cfquery name="BIMKA" datasource="PKOOL">
		SELECT *
		FROM BIMKA 
		WHERE KA001='#Dateformat(now(),"yyyy-mm-dd")#'
			 AND KA002 LIKE '#timeformat(now(),"HH:MM")#%'
			 AND KA003='#SESSION.code#'
    </cfquery>

    <!--- 新增登入資料---> 
	<cfif #BIMKA.recordcount# eq 0 AND #SESSION.code# NEQ "casper">
		<cfquery name="BIMKA_INSERT" datasource="PKOOL">
		  INSERT INTO BIMKA(KA001,KA002,KA003,KA004,KA005,KA006)
		  VALUES('#Dateformat(now(),"yyyy-mm-dd")#','#timeformat(now(),"HH:MM:SS")#','#SESSION.code#',N'#SESSION.Cnname#','#CGI.Remote_Addr#','')
		</cfquery>
	</cfif>

   <!--- Otherwise, re-prompt for a valid username and password --->
   <cfelse> 
		   <cfset SESSION.code= "">
		   <cfset SESSION.Cnname= "">
		   <cfset SESSION.Enname= "">
		   <cfset SESSION.DepCode= "">
		   <cfset SESSION.Dep= "">
		   <cfset SESSION.company= "">
		   <cfset SESSION.PB009= "">

   	 <cflogout>
	 <cfset SESSION.login_msn ="輸入的帳號、密碼有誤或該使用者沒有權限。請重新輸入！">
	 <cfinclude template="UserLoginForm.cfm">
     <cfabort>
   </cfif>
 
 </cfif> 

</cflogin>
