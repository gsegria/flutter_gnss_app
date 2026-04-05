

# Flutter GNSS App

跨平台 Flutter GNSS 應用，支援即時定位、航跡記錄、日誌匯出及高精度模組接入。


## run
flutter devices
adb devices



---

## 專案結構

```text
/flutter_gnss_app
│
├─ lib/
│   ├─ ui/                  # App 的畫面界面 (View)
│   │    ├─ map_screen.dart     # 地圖導航、航跡繪製
│   │    ├─ track_screen.dart   # 航跡列表顯示
│   │    └─ log_screen.dart     # 日誌列表及 CSV 匯出功能
│   │
│   ├─ services/            # 服務層 (Logic / Data Handling)
│   │    └─ gnss_service.dart   # GNSS 資料流管理，LocationModel 實時更新
│   │
│   ├─ models/              # 資料模型 (Model)
│   │    └─ location_model.dart  # 定位資料結構
│   │
│   ├─ utils/               # 工具函數 (Utilities)
│   │    └─ gpx_kml_utils.dart   # GPX / KML 匯出, 日期時間格式化
│   │
│   └─ main.dart            # App 主入口，TabBar 控制三個頁面
│
├─ android/                 # Android 原生模板
├─ ios/                     # iOS 原生模板
├─ assets/                  # 圖標、地圖資源
└─ pubspec.yaml             # 套件定義、資源聲明



核心檔案說明
| 檔案                             | 功能                             |
| ------------------------------ | ------------------------------ |
| lib/main.dart                  | App 主入口，TabBar 控制三個頁面          |
| lib/ui/map_screen.dart         | 地圖導航、航跡繪製                      |
| lib/ui/track_screen.dart       | 航跡列表                           |
| lib/ui/log_screen.dart         | 日誌列表與 CSV 匯出                   |
| lib/services/gnss_service.dart | GNSS 資料流管理，實時 LocationModel    |
| lib/models/location_model.dart | 定位資料模型                         |
| pubspec.yaml                   | 已定義 Flutter、地圖、地理定位、CSV、文件儲存套件 |
| assets/                        | 可放圖標或自訂資源                      |
| android/ / ios/                | Flutter 自動生成原生模板               |


=============================================================
todo:

1️⃣ 地圖 API Key

使用 google_maps_flutter，必須有 Google Maps API Key：

Android

到 Google Cloud Console
 建立專案
啟用 Maps SDK for Android
生成 API Key
編輯 android/app/src/main/AndroidManifest.xml，加入：
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
2️⃣ 權限設定

GNSS App 需要讀取位置，可能需要背景定位：

Android

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>

==================
android app 運行

明白，你想在 Rock 5B+ 上開發和運行 Android App。因為 Rock 5B+ 是 ARM64 Linux，所以這裡有幾個關鍵點需要注意：

1️⃣ 安裝 Android SDK / Build Tools

Flutter 需要：

Android SDK 36
Build Tools 28.0.3
Platform Tools（adb、fastboot 等



=============================================================


+-------------------------------+
|        Flutter App UI          |
|-------------------------------|
| - 地圖導航 Map Screen          |
| - 航跡紀錄 Track Screen       |
| - 衛星資訊/狀態 Status Screen |
| - 日誌管理 Log Screen          |
| - 設定 Settings Screen         |
+-------------------------------+
            |
            v
+-------------------------------+
|      Flutter GNSS Service      |
|-------------------------------|
| - GPS/位置更新 (geolocator)    |
| - 航跡紀錄管理 (GPX/KML/SQLite)|
| - 日誌匯出 CSV/JSON/KML        |
| - Platform Channel NMEA/Native |
+-------------------------------+
            |
            v
+-------------------------------+
|  Native / Platform Layer       |
|-------------------------------|
| - Android: GnssStatus / NMEA  |
| - iOS: CoreLocation / NMEA    |
| - USB/Serial GNSS Module      |
| - 高精度外部模組接口 (RTK/PPP)|
+-------------------------------+
            |
            v
+-------------------------------+
| Optional Backend / Radxa       |
|-------------------------------|
| - RTK/PPP 計算                |
| - 多頻 GNSS 處理               |
| - 雲端日誌分析                 |
+-------------------------------+


2️⃣ 模組化設計
A. UI 層 (Flutter)
地圖導航
套件: google_maps_flutter / flutter_map (OpenStreetMap)
功能: 即時位置、航跡顯示、路線規劃、標記、路線偏差警示
航跡紀錄
功能: 實時收集座標 → 儲存 SQLite/本地文件 (GPX/KML)
支援回放功能
日誌匯出
支援 CSV/JSON/KML 匯出
可上傳雲端或生成報告
衛星狀態
顯示 SNR、衛星數量、HDOP/VDOP/PDOP
可即時更新圖表或列表

B. GNSS Service 層 (Flutter)
定位更新
套件: geolocator 或 location
支援背景更新
航跡管理
儲存/讀取本地 SQLite 或文件
GPX/KML 生成
日誌管理
收集定位、速度、方向、時間戳
可自動匯出
Platform Channel
用於接收原始 NMEA 或外部高精度模組資料


C. Native / Platform 層
Android
GnssStatus / GnssMeasurements
LocationManager.addNmeaListener
iOS
CoreLocation
NMEA 解析
外接模組
USB / UART / Bluetooth GNSS 模組
高精度 RTK / PPP 計算可在 Radxa / 後端完成