# coding: utf-8
class AppDelegate
  #attr_accessor :notice_list

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    # 設定情報のインスタンス
    $settings = Settings.instance
    if $settings.server_address == nil
       $settings.server_address = ""
    end

    # サーバへのログインセッション
    $loginSession = nil

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    ## Sensor List
    #sensor_list_controller = SensorListController.alloc.initWithNibName(nil, bundle: nil)
    #sensor_nav_controller = UINavigationController.alloc.initWithRootViewController(sensor_list_controller)

    # Gateway List
    gateway_list_controller = GatewayListController.alloc.initWithNibName(nil, bundle: nil)
    gateway_nav_controller = UINavigationController.alloc.initWithRootViewController(gateway_list_controller)

    app_setting_controller = AppSettingController.alloc.init
    app_setting_controller.title = "設定"
    app_setting_nav_controller = UINavigationController.alloc.initWithRootViewController(app_setting_controller)

    #notice_controller = NoticeDataController.alloc.initWithNibName(nil, bundle: nil)
    #notice_nav_controller = UINavigationController.alloc.initWithRootViewController(notice_controller)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    #tab_controller.viewControllers = [sensor_nav_controller, app_setting_nav_controller]
    tab_controller.viewControllers = [gateway_nav_controller, app_setting_nav_controller]

    @window.rootViewController = tab_controller
    @window.makeKeyAndVisible

    control_appearance

    true
  end

  def control_appearance
    UINavigationBar.appearance.setBackgroundImage(UIImage.alloc.init,
      forBarMetrics: UIBarMetricsDefault)
    color = UIColor.colorWithRed(0.557, green:0.722, blue:1.0, alpha:1.0)
    UINavigationBar.appearance.setBackgroundColor(color)
    #UINavigationBar.appearance.setShadowImage(UIImage.alloc.init)
    #UINavigationBar.appearance.barTintColor = color
    UINavigationBar.appearance.tintColor = UIColor.blueColor
    UINavigationBar.appearance.setTitleTextAttributes({
      UITextAttributeTextColor => UIColor.blueColor,
      UITextAttributeTextShadowColor => UIColor.blueColor,
      UITextAttributeTextShadowOffset =>  NSValue.valueWithUIOffset(UIOffsetMake(0,0)),
      UITextAttributeFont => UIFont.fontWithName("HiraKakuProN-W6", size: 16)
    })

    UITabBar.appearance.barTintColor = color
    UITabBar.appearance.TintColor = UIColor.blueColor

    UIToolbar.appearance.barTintColor = color
    UIToolbar.appearance.TintColor = UIColor.blueColor

    UIBarButtonItem.appearance.setTitleTextAttributes({
      UITextAttributeFont => UIFont.fontWithName("HiraKakuProN-W3", size: 14)
    }, forState:UIControlStateNormal)
  end
end
