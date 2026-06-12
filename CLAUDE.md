# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> 個人通用偏好（語言、Shell、回應風格、安全紅線）見 `D:\claude\CLAUDE.md`，此處只列本專案特有規則。

---

## 系統定位

- **產品名稱**：CIS — 上岳科技資訊系統（ERP）
- **客戶**：上岳科技股份有限公司（`APPLICATION.companyName = "LY"`）
- **架構**：Adobe ColdFusion (.cfm/.cfc) + Microsoft SQL Server，Bootstrap 4 / jQuery 3.5 前端
- **部署**：CF Server 掛在內網，URL 前綴 `/EMG/`；檔案上傳走 UNC `\\192.168.0.9\AGP\CF_files\...`
- **沒有 build / test / lint**：開發流程是「改 .cfm → 瀏覽器 reload」。不要建議加 Node toolchain、CI、單元測試框架，除非業主主動要求

## 多公司資料源模型（**最重要**）

兩種 datasource 共存，弄錯會撈錯公司的資料：

| Datasource | 用途 | 引用方式 |
|---|---|---|
| `PKOOL` | **系統表**：使用者 `BIMPB`、部門 `BIMPC`、選單 `BIMPD/PE`、權限 `BIMPF/PG`、使用者-公司對應 `BIMPH`、登入記錄 `BIMKA`、公司清單 `DSCMB`、系統參數 `BIMPA` | 寫死 `datasource="PKOOL"` |
| `#SESSION.COMPANY#` | **業務表**：COPMA 客戶、PURMA 廠商、INVMB 品號、PURTC 採購單…等 | `datasource="#SESSION.COMPANY#"` |

`SESSION.COMPANY` 是 DSN 名稱（不是公司代碼），在 `ForceUserLogin.cfm` 登入時由 `DSCMB.MB003` 寫入，可透過 `change.cfm` 動態切換。**新增任何業務查詢一律用 `#SESSION.COMPANY#`**，寫死 `PKOOL` 會在切公司時讀到錯誤資料。

## Application 生命週期（Application.cfc）

| 事件 | 行為 |
|---|---|
| `onApplicationStart` | 設定 `APPLICATION.datasource="PKOOL"`、`APPLICATION.companyName="LY"` |
| `onRequestStart` | **每個 request** 自動 `<cfinclude template="ForceUserLogin.cfm">`（驗證登入） |
| `onRequestEnd` | **每個 request** 自動 `<cfinclude template="footer.cfm">`（頁尾） |

因此所有 `.cfm` 頁面不需要手動處理登入檢查，也不需要在新頁面底部加 `footer.cfm`（舊頁面有加但屬冗餘）。

## SESSION 變數參考

登入成功後由 `ForceUserLogin.cfm` 寫入，全站可用：

| 變數 | 來源 | 說明 |
|---|---|---|
| `SESSION.code` | `BIMPB.PB001` | 使用者帳號（主鍵） |
| `SESSION.Cnname` | `BIMPB.PB002` | 中文姓名 |
| `SESSION.Enname` | `BIMPB.PB003` | 英文姓名 |
| `SESSION.DepCode` | `BIMPC.PC001` | 部門代碼 |
| `SESSION.Dep` | `BIMPC.PC002` | 部門名稱 |
| `SESSION.PB009` | `BIMPB.PB009` | 用途依業務邏輯而定 |
| `SESSION.company` | `DSCMB.MB003` | **DSN 名稱**（決定業務資料源） |
| `SESSION.company_NAME` | `DSCMB.MB002` | 公司顯示名稱 |

`change.cfm` 切公司時只更新 `SESSION.company` 與 `SESSION.company_NAME`，其他 SESSION 變數不變。

## 根目錄檔案地圖

| 檔案 | 用途 |
|---|---|
| `Application.cfc` | CF 應用程式生命週期（見上方） |
| `ForceUserLogin.cfm` | 登入驗證閘道（每 request 自動執行） |
| `UserLoginForm.cfm` | 登入表單 UI |
| `menu.cfm` | 導覽列（查 BIMPD/PE/PF/PG 產生選單） |
| `header.cfm` | Logo + CSS/JS 引入（Bootstrap 4、jQuery 3.5） |
| `footer.cfm` | 頁尾版權宣告 |
| `permission.cfm` | 權限檢查（設定中文權限變數） |
| `change.cfm` | 切換公司（更新 SESSION.company） |
| `Logout.cfm` | 登出（清 SESSION + `<cflogout>`） |
| `VarPassingFunctions.cfm` | 工具函式：`passURLVars()` / `passFormVars()` 跨頁傳遞參數 |

## 前端資源（header.cfm 載入）

每頁透過 `menu.cfm` → `header.cfm` 自動載入：
- CSS：`/css/bootstrap.min.css`、`/css/defaultTheme.css`、`/css/myTheme.css`
- JS：`jquery-3.5.1.slim.js`、`popper.min.js`、`bootstrap.min.js`、`jquery-3.5.1.min.js`、`jquery.fixedheadertable.js`

## 標準頁面樣板

每支業務頁照下列順序，缺一不可（特別是 `permission.cfm`）：

```cfm
<title>畫面標題</title>
<cfinclude template="/EMG/menu.cfm">

<cfset program_id   = "COP101">       <!--- 程式代號，對應 BIMPE.PE001 --->
<cfset program_name = "客戶查詢">
<cfset program_type = "Q">            <!--- Q=查詢, M=維護 等 --->

<cfinclude template="/EMG/permission.cfm">

<!--- FORM 變數防呆預設 --->
<cfif NOT IsDefined("FORM.MA002")><cfset FORM.MA002=""></cfif>

<cfquery datasource="#SESSION.COMPANY#" name="...">...</cfquery>

<!--- render --->

<cfinclude template="/EMG/footer.cfm">
```

`Application.cfc` 的 `onRequestEnd` 已自動 include `footer.cfm`，所以頁尾那行其實是多餘的（舊頁面慣例如此，改舊頁時別動，新頁可省）。

## 權限機制

- `permission.cfm` 依 `program_id` 查 `BIMPF`（個人權限）UNION `BIMPG`（部門權限），把 5 個權限旗標寫入**中文變數名稱**：`查詢權限 / 修改權限 / 新增權限 / 刪除權限 / 列印權限`（值為 `Y` / `N`）
- 沒查到任何權限直接 `<cfabort>` 顯示「你沒有此程式的權限！」
- 擴充權限檢查時請沿用中文變數名稱，與既有頁面一致

## 模組與命名規則

```
BIM*   系統基礎、權限維護、生產排程參數（BIM101 基本參數、BIM2/3xx 權限維護）
COP*   客戶（Customer）— COP101 查詢、COP201 維護…
PUR*   採購（Purchase）— PURMA 廠商、PURTC 採購單
INV*   品號 / 庫存（Inventory）— INVMB 品號主檔
```

程式資料夾固定 3 碼字母 + 3 碼數字（`COP101`）。資料夾內檔案命名：

| 檔名樣式 | 用途 |
|---|---|
| `index.cfm` | 只放 `<cflocation url="<主檔>.cfm">` |
| `<TABLE>.cfm` | 列表 / 查詢主頁 |
| `<TABLE>_detail.cfm` | 明細檢視 |
| `<TABLE>_UPDATE_FORM.cfm` | 編輯表單 |
| `<TABLE>_UPDATE_SQL.cfm` | 寫 DB 後 `<cflocation>` 回主頁 |
| `<TABLE>_excel.cfm` / `_PDF.cfm` | 匯出 |
| `<功能中文名>.txt`（0 bytes） | 人工標籤，無功能。**不要刪、也不要載入** |

資料表命名：`<模組><表>` 共 5 碼，欄位 `<表>001, <表>002, ...`（例：`COPMA.MA001`, `INVMB.MB064`）。新增欄位請接續編號，別跳號。

## 編碼地雷（容易踩）

**檔案編碼不統一**：

- **根目錄檔案是 Big5**：`menu.cfm`、`header.cfm`、`footer.cfm`、`UserLoginForm.cfm`、`ForceUserLogin.cfm`、`permission.cfm`、`change.cfm` 等
- **模組目錄底下的檔案是 UTF-8**：BIM/COP/PUR/INV/* 下的 `.cfm`

編輯時務必保留原檔編碼，否則中文全變亂碼。用 `Edit` 工具一般安全（只動 diff），但用 `Write` 整檔覆寫前一定要先確認編碼。新建檔案跟隨**所在資料夾**的習慣：放模組底下→ UTF-8。

## 安全現況（必須先講清楚）

這套系統的安全設計已過時，**改之前要先跟使用者確認**，不要自作主張全面重構：

1. **SQL Injection 大量存在**：所有 query 用 `#FORM.xxx#` / `#SESSION.xxx#` / `#URL.xxx#` 直接內插，沒有 `<cfqueryparam>`。輸入字串裡的單引號 `'` 會炸 SQL
2. **密碼明文**：`BIMPB.PB004` 直接比對（`WHERE PB004='#FORM.userPassword#'`）
3. **CSRF / XSS**：`<cfoutput>` 直出未做 `htmlEditFormat`
4. **檔案上傳**：`<cffile action="upload" nameconflict="overwrite">` 用 FORM 來的檔名作為路徑，無副檔名白名單

新功能在不破壞既有風格的前提下，**至少**：新 query 用 `<cfqueryparam>`、輸出敏感資料前 `htmlEditFormat()`。

## 不要碰的目錄（備份廢碼）

下列是歷次手動備份的廢墟，不要列入搜尋、不要改、不要當作參考實作：

```
COP\COP201_20240717BACKUP\
COP\COP202_20240923\
COP\COP202_20241014\
COP\COP201\新增資料夾\
COP\COP202\備份\        COP\COP202\新增資料夾\        COP\COP202\沒用到\
COP\COP202_20241014\備份\  COP\COP202_20241014\新增資料夾\  COP\COP202_20241014\沒用到\
COP\COP304\BACKUP\      COP\COP304\新增資料夾\
```

`menu_test.cfm` 也是棄置實驗，正式入口是 `menu.cfm`。

## 既有慣例（沿用就好，別 refactor）

- 表格分隔色：`<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>`
- 表格 ID `myTable01` 是固定的，會被 `jquery.fixedheadertable.js` 接管產生 fixed header
- `<cftooltip>` 雖然 CF 已 deprecated，舊頁仍在用，沿用即可
- 表單按鈕 class 偏好 `btn btn-primary` / `btn-warning` / `btn-outline-warning`
- 數字格式化用 `NUMBERFORMAT(x, "9,999,999")` 或 `"9,999,999.99"`
- 日期 `DateFormat(now(),"yyyy-mm-dd")`、時間 `TimeFormat(now(),"HH:MM:SS")`
- 寫入 BIMKA 登入記錄時，`casper` 帳號跳過（內建排除）

## CRUD 三段式慣例

業務頁面的新增／修改／刪除遵循固定拆檔模式：

1. **列表頁** `<TABLE>.cfm` — 查詢＋顯示清單，連結到編輯頁
2. **編輯表單** `<TABLE>_UPDATE_FORM.cfm` — 查單筆、預填欄位、POST 到 SQL 頁
3. **SQL 頁** `<TABLE>_UPDATE_SQL.cfm` — 執行 INSERT/UPDATE/DELETE 後 `<cflocation>` 回列表頁

不要把寫入邏輯放在表單頁，也不要把顯示邏輯放在 SQL 頁。

## 開發工作流

- 編輯後直接到 CF Server 對應 URL 重新整理頁面驗證
- DB 變更請對 `PKOOL`（系統）或對應公司 DSN（業務）下 SQL；改 schema 前先備份對應表
- 版控使用 git（`.gitignore` 已排除備份目錄與上傳檔案）
- 沒有 CI / build / test / lint — 驗證方式就是開瀏覽器看結果
