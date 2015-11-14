# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-layout'
#require 'rubygems'
#require 'bubble-wrap'
#require 'motion-plot'

#require 'bundler'
#Bundler.require :default

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'rubyIotMobile2'
  app.identifier = 'com.htk-jp.he.rubyIotMobile2'

  # iOS9ではデフォルトでhttpsしか使えない。httpを使えるようにするには以下の設定が必要
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  
  # Developerのプロビジョニングでrake deviceするとき、get-task-allowはtrueにすること
  app.entitlements['get-task-allow'] = true
  
  # プロビジョニングプロファイルの設定
  # プロジェクトのトップディレクトリに配置したプロビジョニングファイル名を指定する
  app.provisioning_profile = 'rubyIotMobile2_dev.mobileprovision'

  # CodeSignに使う証明書の名前の設定
  #app.codesign_certificate = 'iPhone Developer: xxxx (xxxx)'
end
