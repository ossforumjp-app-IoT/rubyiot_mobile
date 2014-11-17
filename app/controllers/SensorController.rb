#class SensorController < BaseDetailController
class SensorController < UIViewController

  attr_accessor :item

  def show_no_controller
    alert = UIAlertView.alloc.init
    alert.message = "コントローラがありません"
    alert.addButtonWithTitle "OK"
    alert.show  
  end

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor

    @label_name = UILabel.alloc.initWithFrame(CGRectZero)
    @label_name.text = self.item[:name]
    @label_name.font = UIFont.fontWithName("HiraKakuProN-W3",size:20)
    @label_name.sizeToFit
    @label_name.center = CGPointMake(self.view.frame.size.width / 2,
      self.view.frame.size.height / 4)
    self.view.addSubview @label_name

    @label_value = UILabel.alloc.initWithFrame(CGRectZero)
    @label_value.text = self.item[:value] + get_unit(self.item[:unit])
    @label_value.font = UIFont.fontWithName("HiraKakuProN-W3",size:45)
    @label_value.sizeToFit
    @label_value.center = CGPointMake(self.view.frame.size.width / 2,
      self.view.frame.size.height / 2)
    self.view.addSubview @label_value

    self.title = "センサー"

    @toolbar = UIToolbar.alloc.initWithFrame(CGRectMake(0,self.view.bounds.size.height - self.tabBarController.rotatingFooterView.frame.size.height - 44,320,44))
    chart_btn = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('line_chart.png'), style:UIBarButtonItemStylePlain, target:self, action:'chart_action')
    operate_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('remote_control.png'), style:UIBarButtonItemStylePlain, target:self, action:'operate_action')
    monitor_button = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('settings_wrench.png'), style:UIBarButtonItemStylePlain, target:self, action:'monitor_action')
    gap = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    @toolbar.items = [gap, chart_btn, gap, operate_button, gap, monitor_button, gap]
    self.view.addSubview(@toolbar)

  end

  # リモコン操作画面を表示
  def operate_action
    # retrieving data
    loaded_data_func = lambda { |data|
      found = false
      data.each do |d|
        #p "device_id = #{d[:device_id]} controller_id=#{d[:id]}"
        # device_idをキーにしてリモコンを検索
        if d[:device_id] == item[:device_id] then
          remote_controller = RemoteController.alloc.initWithController(d)
          self.navigationController.pushViewController(remote_controller, animated: true)
          found = true
          break
        end
      end
      if found == false
        show_no_controller
      end
    }
    # デバイスのコントローラ（リモコン）を取得
    Controller.retrieve_data(loaded_data_func)
  end

  # 監視値設定画面を表示
  def monitor_action
    loaded_data_func = lambda { |data|
      data.each do |d|
        monitor_controller = MonitorController.alloc.initWithMonitor(d)
        self.navigationController.pushViewController(monitor_controller, animated: true)    
      end
    }
    # 監視値を取得する
    Monitor.retrieve_data(loaded_data_func, item[:id])
  end

  # チャート画面を表示
  def chart_action

    ChartController.new.tap do |c|
      c.item = self.item
      navigationController.pushViewController(c, animated:true)
    end
  end

  # 単位を取得
  def get_unit(str)
    ret = ""
    case str
    when "degree Celsius"
      ret = "°"
    end
    return ret
  end
end