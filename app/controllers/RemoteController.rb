OPERATION_POLLING_INTERVAL = 1

class RemoteController < UIViewController
  attr_accessor :controller

  def initWithController(controller)
    initWithNibName(nil, bundle:nil)
    self.controller = controller
    self
  end

  def viewDidLoad
    super

    self.title = "リモコン"
    self.view.backgroundColor = UIColor.whiteColor

    @label_name = UILabel.alloc.initWithFrame(CGRectZero)
    @label_name.text = self.controller[:name]
    @label_name.font = UIFont.fontWithName("HiraKakuProN-W3",size:20)
    @label_name.sizeToFit
    @label_name.center = CGPointMake(self.view.frame.size.width / 2,
      self.view.frame.size.height / 4)
    self.view.addSubview @label_name

    @label_value = UILabel.alloc.initWithFrame(CGRectZero)
    case self.controller[:value]
    when "0"
      @label_value.text = "停止中"
    when "1"
      @label_value.text = "運転中"
    end
    @label_value.font = UIFont.fontWithName("HiraKakuProN-W3",size:20)
    @label_value.sizeToFit
    @label_value.center = CGPointMake(self.view.frame.size.width / 2,
    self.view.frame.size.height / 2)
    self.view.addSubview @label_value

    margin = 50
    @on_button = UIButton.rounded_rect.tap do |b|
      b.setTitle("ON", forState:UIControlStateNormal)
      b.accessibilityLabel = "Hello Button"
      b.frame = [[margin, 400], [view.frame.size.width - margin * 2, 42]]
      b.backgroundColor = getButtonColor
      b.on(:touch) do |event|
        push("1")
      end
    end
    self.view << @on_button

    @off_button = UIButton.rounded_rect.tap do |b|
      b.setTitle("OFF", forState:UIControlStateNormal)
      b.frame = [[margin, 450], [view.frame.size.width - margin * 2, 42]]
      b.backgroundColor = getButtonColor
      b.on(:touch) do |event|
        push("0")
      end
    end
    self.view << @off_button    
    setControlStatus
  end

  def push(value)
    # retrieving data
    loaded_data_func = lambda { |data|
      if data != nil
        data.each do |d|
          p "operation_id = #{d[:operation_id]} controller_id=#{d[:controller_id]}"
          @operation_id = d[:operation_id]
          polling
        end
      else
        App.alert("操作に失敗しました")
        setControlStatus
      end
    }
    if value == "0"
      @off_button.enabled = false
    else
      @on_button.enabled = false
    end
    # リモコン操作の実行
    Operation.post_data(loaded_data_func, self.controller[:id], value)
  end

  def polling
    loaded_data_func = lambda { |data|
      if data == nil
        App.alert("操作状態の取得に失敗しました")
        setControlStatus
        return
      end
      data.each do |d|
        p "operation_id = #{d[:operation_id]} value=#{d[:value]} status=#{d[:status]}"
        self.controller[:status] = d[:status]
        case d[:status]
        when ""
          startTimer
        when "0" # 未実行
          startTimer
        when "1" # 実施中
          startTimer
        when "2" # 完了
          self.controller[:value] = d[:value]
          setControlStatus
          App.alert("操作が完了しました")
        when "9" # 異常
          setControlStatus
          App.alert("操作に失敗しました")
        else
          setControlStatus
　　　　　　App.alert("操作に失敗しました")
        end
      end
    }
    Operation.retrieve_data(loaded_data_func, @operation_id)
  end

  # タイマー開始
  def startTimer
    if @timer == nil
      #@time  = 0.0
      @timer = NSTimer
        .scheduledTimerWithTimeInterval(
          OPERATION_POLLING_INTERVAL,
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
    polling
  end

  def setControlStatus
    case self.controller[:value]
    when "0"
      @label_value.text = "停止中"
      @on_button.enabled = true
      @on_button.backgroundColor = getButtonColor
      @off_button.enabled = false
      @off_button.backgroundColor = UIColor.grayColor
    when "1"
      @label_value.text = "運転中"
      @on_button.enabled = false
      @on_button.backgroundColor = UIColor.grayColor
      @off_button.enabled = true
      @off_button.backgroundColor = getButtonColor
    end
  end

  def getButtonColor
    UIColor.colorWithRed(0.557, green:0.722, blue:1.0, alpha:1.0)
  end

  def viewWillDisappear(animated)
    stopTimer
  end

  def viewWillAppear(animated)
    setControlStatus
  end
end