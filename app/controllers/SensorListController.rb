# coding: utf-8
# センサーリストの更新間隔
SENSOR_LIST_UPDATE_INTERVAL = 5 # ポーリング間隔

# カスタムセル
class ThreeLabelCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier: reuseIdentifier)
    super(UITableViewCellStyleValue1, reuseIdentifier)
    addLabelsToSubview
    self
  end
  
  def addLabelsToSubview
    Motion::Layout.new do |layout|
      layout.view self.contentView
      layout.subviews "headingLabel" => headingLabel, "subLabel" => subLabel, "sideLabel" => sideLabel
      layout.vertical "|[headingLabel][subLabel]|"
      layout.vertical "|[sideLabel]|"
      layout.horizontal "|-[headingLabel]"
      layout.horizontal "|-[subLabel]"
      layout.horizontal "[sideLabel]-|"
    end
  end
  
  def headingLabel
    @headingLabel ||= UILabel.alloc.init.tap do |label|
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    end
  end
 
  def subLabel
    @subLabel ||= UILabel.alloc.init.tap do |label|
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    end
  end
 
  def sideLabel
    @sideLabel ||= UILabel.alloc.init.tap do |label|
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    end
  end
end

# センサーリスト画面
class SensorListController < UIViewController

  attr_accessor :gateway

  def viewDidLoad
    super

    self.title = "センサー一覧"

    @notice_table_data = []

    @alerts = []
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table
    @table.dataSource = self
    @table.delegate = self

    @sensors = nil
    retrieve_data
    @pending = false
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      ThreeLabelCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end

    item = @sensors[indexPath.row]
    # put your data in the cell
    cell.headingLabel.text = item[:name]
    cell.subLabel.text = item[:datetime]
    if item[:value] != ""
      cell.sideLabel.text = item[:value] + get_unit(item[:unit])
    end
    if item[:alert] == "1" then
      cell.sideLabel.textColor = UIColor.redColor
    else
      cell.sideLabel.textColor = UIColor.blackColor
    end

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @sensors.nil? ? 0 : @sensors.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    SensorController.new.tap do |c|
      c.item = @sensors[indexPath.row]
      back_button = UIBarButtonItem.alloc.initWithTitle("戻る", style:UIBarButtonItemStylePlain, target:nil, action:nil)
      self.navigationItem.setBackBarButtonItem(back_button, animated:true)
      navigationController.pushViewController(c, animated:true)
    end
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('HOME', image:UIImage.imageNamed('temperature.png'), tag: 1)

    self
  end

  # タイマー開始
  def startTimer
    stopTimer
    if @timer == nil
      #@time  = 0.0
      @timer = NSTimer
        .scheduledTimerWithTimeInterval(
          SENSOR_LIST_UPDATE_INTERVAL,
          target: self,
          selector: "timerHandler:",
          userInfo: nil,
          repeats: true)
    end
  end

  # タイマー停止
  def stopTimer
    if @timer
      @timer.invalidate
      @timer = nil
    end
  end

  # タイマーのハンドラ
  def timerHandler(userInfo)
    stopTimer
    retrieve_data
  end

  # センサーリストの取得
  def retrieve_data
    loaded_data_func = lambda { |data|
      if data != nil
        @sensors = data
        updatebadge
        @table.reloadData
        startTimer
      else
        @pending = true # viewを再表示するまで通信やめとく
        App.alert("センサー情報の取得に失敗しました")
      end
    }
    Sensor.retrieve_data(self.gateway[:id], loaded_data_func)
  end


  def viewWillDisappear(animated)
    self.tabBarItem.badgeValue = nil
  end

  def viewWillAppear(animated)
    if @pending == true
      stopTimer
      startTimer
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

  def updatebadge
    alert = [] #アラート発生センサー
    @sensors.each{|var|
      if var[:alert] == "1"
        alert << var[:id]
      end
    }
    new_alert = alert - @alerts #新たにアラート発生したセンサー
    #p "new_alert = #{new_alert}"
    #new_alert.each{|var|
    #  #addNoticeInfo(var)
    #}
    if new_alert.length > 0
      self.tabBarItem.badgeValue = new_alert.length.to_s
    end
    #UIApplication.sharedApplication.delegate.notice_list = @notice_table_data
    @alerts = alert #アラート発生センサー情報を保存しておく
  end
=begin
  def addNoticeInfo(sensor_id)
    @sensors.each{|var|
      if var[:id] == sensor_id
        @notice_table_data.unshift({
          :datetime => var[:datetime],
          :disc => "監視値を超えました（#{var[:name]}）"})
        p @notice_table_data
      end
    }
  end
=end
end
