# coding: utf-8
class AppSettingController < UITableViewController

  SETTING_ITEMS = [
    [
      { :text => "サーバ", :value => proc{$settings.server_address}, :set => proc{|v| $settings.server_address = v} },
      { :text => "ユーザ名", :value => proc{$settings.username}, :set => proc{|v| $settings.username = v} },
      { :text => "パスワード", :value => proc{$settings.password}, :set => proc{|v| $settings.password = v} },
    ],
    [
      { :text => "バージョン", :value => nil }
    ]
  ]

  SERVER_TEXT = "サーバ"
  APP_VERSION = "1.0.0"

  def init
    super
    initWithStyle(UITableViewStyleGrouped)
    #self.tabBarItem = UITabBarItem.alloc.initWithTitle('設定', image: nil, tag: 0)
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('HOME', image:UIImage.imageNamed('settings.png'), tag: 1)
    self
  end
=begin
  def initWithNibName(name, bundle: bundle)
    super
    #self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemMostRecent, tag: 1)
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('HOME', image:UIImage.imageNamed('settings.png'), tag: 1)

    self
  end
=end
  def viewDidLoad
    super
    #color = UIColor.colorWithRed(0.60, green:0.20, blue:0.20, alpha:1.0)
    #self.view.backgroundColor = color
  end

  def viewDidAppear animated
    self.tableView.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    SETTING_ITEMS.count
  end

  def tableView(tableView, numberOfRowsInSection: section)
    SETTING_ITEMS[section].count
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CellID)
    cell.userInteractionEnabled = true

    cell.textLabel.text = SETTING_ITEMS[indexPath.section][indexPath.row][:text]
    if SETTING_ITEMS[indexPath.section][indexPath.row][:value] == nil
      cell.detailTextLabel.text = APP_VERSION
    else
      cell.detailTextLabel.text = SETTING_ITEMS[indexPath.section][indexPath.row][:value].call
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end
    
    cell
  end

  def tableView(tableView, titleForHeaderInSection: section)
    section == 0 ? "接続情報" : "バージョン情報"
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    AppSettingDetailController.new.tap do |c|
      c.item = { name: SETTING_ITEMS[indexPath.section][indexPath.row][:text],
                 value: SETTING_ITEMS[indexPath.section][indexPath.row][:value].call,
                 set: SETTING_ITEMS[indexPath.section][indexPath.row][:set]
               }
      navigationController.pushViewController(c, animated:true)
    end
  end
end
