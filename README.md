rubyiot_mobile
==============

このソフトウェアはIoTのmobile部をrubyで実装したものです。
主な機能は以下の通りです。

* 定期間隔（現状は５秒）毎にサーバからセンサー情報を取得し、一覧表示します。
* 機器(ファン)のON/OFF操作を行い、サーバを介してcontrollerへの制御を依頼します。
* サーバからセンサーの計測値を取得しグラフ表示します。
* センサーの監視値（上限、下限）を設定しサーバへ登録します。

使用方法
--------
## 動作環境

OS X 10.9.5
Xcode 6.2
RubyMotion 3.14

## ビルド/実行方法
Xcode, RubyMotionはすでにインストールされていることを想定しています。
ここではiPhoneシミュレータでの実行方法を記します。
    $ git clone https://github.com/ossforumjp-app-IoT/rubyiot_mobile.git
    $ cd rubyiot_mobile/
    $ bundle install --path vendor/bundle
    $ bundle exec rake simulator

## ライセンス

個々のファイルについて、個別にライセンス・著作権表記があるものはそのライセンスに従います。  
ライセンス表記がないものに関しては以下のライセンスを適用します。

Copyright 2015 Japan OSS Promotion Forum

Licensed under the Apache License, Version 2.0 (the "License");  
you may not use this file except in compliance with the License.  
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software  
distributed under the License is distributed on an "AS IS" BASIS,  
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  
See the License for the specific language governing permissions and  
limitations under the License.
