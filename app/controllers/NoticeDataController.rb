#class CurrentDataController < UIViewController
class NoticeDataController < UITableViewController

  def viewDidLoad
    super

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table

    @table.dataSource = self
    @table.delegate = self

    @data = UIApplication.sharedApplication.delegate.notice_list
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end

    item = @data[indexPath.row]
    # put your data in the cell
    cell.textLabel.text = item[:disc]
    cell.textLabel.font = UIFont.fontWithName("HiraKakuProN-W3",size:14)
    cell.detailTextLabel.text = item[:datetime]
    cell.detailTextLabel.font = UIFont.fontWithName("HiraKakuProN-W3",size:10)
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    # return the number of rows
    @data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    #NoticeDetailController.new.tap do |c|
    #c.item = "#{@data[indexPath.row]} "
    #navigationController.pushViewController(c, animated:true)
    #end
=begin
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    alert = UIAlertView.alloc.init
    alert.message = "#{@data[indexPath.row]} tapped!"
    alert.addButtonWithTitle "OK"
    alert.show
=end
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemMostViewed, tag: 1)
    self.title = "お知らせ一覧"
    #self.tabBarItem.badgeValue = "1"
    
    self
  end

  def viewWillAppear(animated)
    self.tabBarItem.badgeValue = nil
    p "test #{Sensor.getdata}"
  end
end
