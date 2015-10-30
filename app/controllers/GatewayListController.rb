# coding: utf-8
# カスタムセル
class GatewayLabelCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier: reuseIdentifier)
    super(UITableViewCellStyleValue1, reuseIdentifier)
    addLabelsToSubview
    self
  end

  def addLabelsToSubview
    Motion::Layout.new do |layout|
      layout.view self.contentView
      layout.subviews "headingLabel" => headingLabel
      layout.vertical "|-[headingLabel]|"
      layout.horizontal "|-[headingLabel]"
    end
  end

  def headingLabel
    @headingLabel ||= UILabel.alloc.init.tap do |label|
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    end
  end
end

# ゲートウェイリスト画面
class GatewayListController < UIViewController

  def viewDidLoad
    super

    self.title = "ゲートウェイ一覧"

    @gateways = nil

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table
    @table.dataSource = self
    @table.delegate = self

    # データ取得と描画
    retrieve_data
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      GatewayLabelCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end

    cell.headingLabel.text = @gateways[indexPath.row][:name]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @gateways.nil? ? 0 : @gateways.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    # ゲートウェイ選択後のセンサー一覧画面へ遷移
    SensorListController.new.tap do |c|
      c.gateway = @gateways[indexPath.row]
      back_button = UIBarButtonItem.alloc.initWithTitle("戻る", style:UIBarButtonItemStylePlain, target:nil, action:nil)
      self.navigationItem.setBackBarButtonItem(back_button, animated:true)
      navigationController.pushViewController(c, animated:true)
    end
  end

  def initWithNibName(name, bundle: bundle)
    super
    # TODO アイコン画像の差し替え
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('HOME', image:UIImage.imageNamed('temperature.png'), tag: 1)

    self
  end

  # ゲートウェリストの取得
  def retrieve_data
    loaded_data_func = lambda { |data|
      if data != nil
        @gateways = data
        @table.reloadData
      else
        App.alert("ゲートウェイ情報の取得に失敗しました")
      end
    }
    Gateway.retrieve_data(loaded_data_func)
  end
end
