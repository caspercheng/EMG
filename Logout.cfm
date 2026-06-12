<!---系統登出作業，請自動跳到登入網頁--->

   <cfset SESSION.code= "">
   <cfset SESSION.Cnname= "">
   <cfset SESSION.Enname= "">
   <cfset SESSION.DepCode= "">
   <cfset SESSION.Dep= "">
   <cfset SESSION.company= "">

<cflogout>

<cflocation url="/EMG/menu.cfm">


