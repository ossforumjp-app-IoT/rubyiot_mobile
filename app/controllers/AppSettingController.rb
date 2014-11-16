class AppSettingController < UITableViewController

  CONNECTION_SECTION = 0
  SERVER_ROW_NUMBER = 0
=begin
  ACCOUNT_ROW_NUMBER = 1
  PASSWORDROW_NUMBER = 2
  NUMBER_OF_ROWS_IN_CONNECTION_SECTION = 3
=end
  NUMBER_OF_ROWS_IN_CONNECTION_SECTION = 1

  APP_VERSION_SECTION = 1
  APP_VERSION_ROW_NUMBER = 0
  NUMBER_OF_ROWS_IN_APP_VERSION_SECTION = 1

  SERVER_TEXT = "サーバ"
  VERSION_TEXT = "バージョン"
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

  def numberOfSectionsInTableView tableView
    2
  end

  def tableView(tableView, numberOfRowsInSection: indexPath)
    if indexPath == 0
      NUMBER_OF_ROWS_IN_CONNECTION_SECTION
    else
      NUMBER_OF_ROWS_IN_APP_VERSION_SECTION
    end
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CellID)
    cell.userInteractionEnabled = true

    case indexPath.section
    when CONNECTION_SECTION
      display_connection_section indexPath, cell
    when APP_VERSION_SECTION
      display_version_section indexPath, cell
    end
    cell
  end

  def tableView(tableView, titleForHeaderInSection: section)
    section == 0 ? "接続情報" : "バージョン情報"
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    selectedCell = tableView.cellForRowAtIndexPath(indexPath)
    text = selectedCell.textLabel.text

    case text
    when SERVER_TEXT
      AppSettingDetailController.new.tap do |c|
        c.item = { name: SERVER_TEXT, value: $settings.server_address}
        navigationController.pushViewController(c, animated:true)    
      end
      #self.navigationController.pushViewController(AppSettingDetailController.alloc.initAndSetCode, animated: true)
    else 
      alert = UIAlertView.alloc.init
      alert.message = "Error: #{text} was not captured above"
      alert.addButtonWithTitle "OK"
      alert.show
    end
  end

  private

  def display_connection_section indexPath, cell
    case indexPath.row
    when SERVER_ROW_NUMBER
      cell.textLabel.text = SERVER_TEXT
      cell.detailTextLabel.text = $settings.server_address
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    when ACCOUNT_ROW_NUMBER
      cell.textLabel.text = ACCOUNT_TEXT
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    when PASSWORDROW_NUMBER
      cell.textLabel.text = PASSWORD_TEXT
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    end
  end

  def display_version_section indexPath, cell
    case indexPath.row
    when APP_VERSION_ROW_NUMBER
      cell.textLabel.text = VERSION_TEXT
      cell.userInteractionEnabled = false
      cell.detailTextLabel.text = APP_VERSION
    end
  end
end
