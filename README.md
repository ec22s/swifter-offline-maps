# SwifterOfflineMaps

2025年12月12日 福岡Tech LT大忘年会 モバイル枠でデモしたアプリのソースです

- LTタイトル「WebサーバをiOSアプリに内蔵して完全オフライン地図」

- イベント詳細 https://moneyforward.connpass.com/event/375276/

- スライド動画

  - 1ページあたり5秒で遷移
 
  - 当日流したデモ動画は次項に切り出し

  https://github.com/user-attachments/assets/c5fc2abc-f7c9-49d7-bcfa-a79cec40f94d

<br>

- 当日流したデモ動画

  - 九州北部のズームレベル14までの地図データをアプリに内蔵した例 (ファイルサイズ 約190MB)

  - iPad第10世代実機での動作を録画

  - 左がアプリ内蔵地図、右が通常のオンライン地図
 
  - 左側でズーム・移動すると右側の地図も連動
 
  - ネット接続状態で徐々にズームイン → 途中でネットから切断 → 左のオフライン地図だけ精細に表示

  https://github.com/user-attachments/assets/e0a54d83-248c-4cf5-a2e5-da5e1f7277fe

<br>

- 当日準備したけど割愛したデモ動画

  - 地図データと端末は前項と同じ、モバイル回線がつながりにくい地域で録画
 
  - ネット切断状態で徐々に熊本市付近にズームイン → 左のオフライン地図は精細に表示 → 途中でネットに接続 → 右側の通常地図はデータ読み込みまで一定の時間がかかる

  https://github.com/user-attachments/assets/ea87e168-af2f-4cf5-91f2-0249b49d6cde

<br>

## アプリの情報

- ビルド環境

  - macOS 15.6 (24G84)
  
  - Xcode 26.2 (17C52)

- 動作確認環境

  - iOS Simulator : iPad (A16), iPad OS 26.2
  
  - 実機 : iPad (10th), iPad OS 18.7.1

- 利用ライブラリ

  - [Swifter](https://github.com/httpswift/swifter) 1.5.0
 
  - [MapLibre GL JS](https://github.com/maplibre/maplibre-gl-js) 5.6.2

- 利用データ

  - フォント : Noto Sans Regular
  
    - [mapbox-gl-js-offline-example](https://github.com/klokantech/mapbox-gl-js-offline-example) のグリフセットを利用

  - スプライト : [tile.openstreetmap.jp](https://tile.openstreetmap.jp/) > STYLES > maptiler-basic-ja

  - 地図スタイル : 上記スタイル (デモ用に一部修正して利用)

<br>

## デモの再現手順

- (1) 本リポジトリのソースをクローン

- (2) 地図データの準備

  - [maptiler > North Kyushu](https://www.maptiler.com/on-prem-datasets/asia/japan/north-kyushu/) から OpenStreetMap vector tiles をダウンロード (利用形態によっては有償になる等の制約があります)

    <img width=640 src="https://github.com/user-attachments/assets/72cc59b2-8642-4571-94ce-e9c616a8c971" />

  - ダウンロードした `.mbtiles` を `MVT` 形式に変換
 
    - 使えるツールは多数ありますが Node.js 環境なら [mbtiles2pbf](https://github.com/ec22s/mbtiles2pbf) が便利です。というか今回のデモに使うため Fork and update しました

  - 変換後は `0` `1` ... `14` のフォルダになっているはず → 本リポジトリのソースの `SwifterOfflineMaps/www.bundle.mvt` の下に `tiles` フォルダを作り、その中に置く
 
    <img width=320 src="https://github.com/user-attachments/assets/f630ae28-8115-4d61-bfa4-9a2ff21853e8" />

- (3) Xcodeでプロジェクトを開き、ビルド

  - ターゲットの `Team` や `Bundle Identifier` 等は各自で設定
 
  - ライブラリは Swift Package Manager で自動的に読み込まれる

- (4) ビルドと起動に成功すれば、下記の画面が表示されるはず

  <img width=640 src="https://github.com/user-attachments/assets/d3cd3eb5-5379-42c1-a526-cd95047a5f80" />

  - LTや前掲のデモ動画では左右の違いを目立たせるため左側 (アプリ内蔵地図) でデータのない部分を非表示にしていましたが、現在のソースではしていません

  - 従ってネットに接続した状態では、アプリ起動時の左右の表示がほぼ同じです

- 不具合等の連絡・問合せは[プロフィール](https://github.com/ec22s)のe-mailへお願いします

<br>

## 参考にしたもの

- (1) [swifter-protomaps-example](https://github.com/sfomuseum/swifter-protomaps-example)

  - これが無ければ出来なかった

  - `PMTiles` を使うWeb地図を `Swifter` でアプリに内蔵したもの
 
  - ただしフォント・スプライトは未対応
 
  - 地図だけでなく `Swifter` の細かい利用方法 (CORS対応等) も貴重な情報

- (2) [mapbox-gl-js-offline-example](https://github.com/klokantech/mapbox-gl-js-offline-example)

  - Webベースの、localhostで完結する意味でのオフライン地図

  - これをiOSアプリに内蔵すればいいのでは？ という着想につながった

<br>

## 今後のTODO

  - `MVT` 形式の代わりに `PMTiles` を使えるように

  - オフライン地図の不具合調査・改修 (ズームインしても精細なタイルが表示されない場合がある等)

  - [maplibre-native-offline-demo](https://github.com/ec22s/maplibre-native-offline-demo) との統合

    - 上記でローカル化できなかったフォント・スプライトのみ `Swifter` などアプリ内蔵Webサーバが送出するようにし、WKWebViewベースでなく `MapLibre Native` の地図として完全オフラインを実現したい🔥

<br>

以上
