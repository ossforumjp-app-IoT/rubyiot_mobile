class ChartController < UIViewController
  attr_accessor :item

  HTTP = "http://"
  CHART_URL = "/chart?"
  START = "&start="
  SPAN = "&span="

  def viewDidLoad
    super
    self.title = "チャート"
    self.view.backgroundColor = UIColor.whiteColor
    @webview = UIWebView.new.tap do |v|
      v.frame = self.view.bounds
      self.view.addSubview(v)
    end

    @segment = UISegmentedControl.alloc.initWithItems(["時", "日", "週", "月", "年"])
    @segment.frame = CGRectMake(0, 440, 290, 30);
    @segment.segmentedControlStyle = UISegmentedControlStyleBar
    @segment.selectedSegmentIndex = 0
    @segment.addTarget(self, action: "segmentChange", forControlEvents: UIControlEventValueChanged)
    @segment.tintColor = UIColor.blueColor

    @toolbar = UIToolbar.alloc.initWithFrame(CGRectMake(0,self.view.bounds.size.height - self.tabBarController.rotatingFooterView.frame.size.height - 44,320,44))
    button_item = UIBarButtonItem.alloc.initWithCustomView(@segment)

    @toolbar.items = [button_item]
    self.view.addSubview(@toolbar)
    @sensor_id = self.item[:id]

    segmentChange

  end

  def segmentChange
    index = @segment.selectedSegmentIndex
    #curDate = NSDate.date
    calendar = NSCalendar.alloc.initWithCalendarIdentifier(NSGregorianCalendar)
    comps = calendar.components(
      NSYearCalendarUnit|
      NSMonthCalendarUnit|
      NSDayCalendarUnit|
      NSHourCalendarUnit| 
      NSMinuteCalendarUnit|
      NSSecondCalendarUnit,
      fromDate:NSDate.date)
    case index
    when 0
      span = "hourly"
      comps.hour -= 1
    when 1
      span = "daily"
      comps.day -= 1
    when 2
      span = "weekly"
      comps.day -= 6
    when 3
      span = "monthly"
      comps.month -= 1
    when 4
      span = "yearly"
      comps.year -= 1
    end

    date = calendar.dateFromComponents(comps)
    #p "date = #{date}"
    p start_date = date.strftime("%Y-%m-%d+%H:%M:%S") #=> "2009-03-01+00:31:21"

    url_str = HTTP + $settings.server_address + CHART_URL + "sensor_id=" + @sensor_id + START + start_date + SPAN + span
    url = NSURL.URLWithString(url_str)
    #p "url=#{url_str}"
    request = NSURLRequest.requestWithURL(url)
    @webview.loadRequest(request)
  end
end