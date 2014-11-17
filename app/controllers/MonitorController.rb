# Pickerの値(-10.0から50.0までしか対応していない)
MonitorValues = []
-10.upto(50) do |i|
  MonitorValues << i.to_s + ".0"
end
MonitorValues << ""

class MonitorController < UIViewController
  attr_accessor :monitor

  def initWithMonitor(monitor)
    initWithNibName(nil, bundle:nil)
    self.monitor = monitor
    self
  end

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.title = "監視値"

    self.tap {
      @upper = MonitorValues.find_index self.monitor[:max]
      @lower = MonitorValues.find_index self.monitor[:min]
    }
    @table_view = UITableView.grouped
    @table_view.dataSource = self
    @table_view.delegate = self

    self.view << @table_view

    @modal_view = UIControl.alloc.initWithFrame(self.view.bounds)
    @modal_view.backgroundColor = :white.uicolor(0.5)
    @modal_view.alpha = 0.0

    @modal_view.on :touch do
      cancel
    end

    self.view << @modal_view

    @keyboard_view = UIView.alloc.initWithFrame(
      [[0, UIScreen.mainScreen.bounds.size.height], [UIScreen.mainScreen.bounds.size.width, 260]])

    self.view << @keyboard_view

    item = UINavigationItem.new
    item.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemCancel,
        target: self,
        action: :cancel)

    item.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemDone,
        target: self,
        action: :done)

    nav_bar = UINavigationBar.alloc.initWithFrame([[0, 0], [UIScreen.mainScreen.bounds.size.width, 44]])
    nav_bar.items = [item]
    @keyboard_view << nav_bar

    @picker_delegate = MonitorPickerDelegate.new
    @picker_view = UIPickerView.alloc.initWithFrame([[0, 44], [UIScreen.mainScreen.bounds.size.width, 216]])
    @picker_view.showsSelectionIndicator = true
    @picker_view.delegate = @picker_view.dataSource = @picker_delegate
    #@picker_view.selectRow(@upper, inComponent:0, animated:false)
    @keyboard_view << @picker_view

    right_button = UIBarButtonItem.alloc.initWithTitle("保存", style: UIBarButtonItemStyleBordered, target:self, action:'pop')
    self.navigationItem.rightBarButtonItem = right_button

  end

  CellID = 'CellIdentifier'
  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell = table_view.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CellID)
    cell.userInteractionEnabled = true
    case index_path.section
    when 0 #監視値
      display_monitor_section(index_path, cell)
    end
    cell.textLabel.font = UIFont.fontWithName("HiraKakuProN-W3",size:14)
    cell
  end

  def tableView(table_view, titleForHeaderInSection:section)
    return "監視値"
  end

  def tableView(table_view, numberOfRowsInSection:section)
    return 2
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    table_view.deselectRowAtIndexPath(index_path, animated:true)
    #TODO
    cell = table_view.cellForRowAtIndexPath(index_path)
    @selectedRowText = cell.textLabel.text

    case @selectedRowText
    when "上限"
      idx = @upper
    when "下限"
      idx = @lower
    end
    @picker_view.selectRow(idx, inComponent:0, animated:false)
    @modal_view.fade_in
    @keyboard_view.slide :up
  end

  def pop
    loaded_data_func = lambda {
      self.navigationController.popViewControllerAnimated(true)
    }
    Monitor.post_data(loaded_data_func, self.monitor[:id], MonitorValues[@lower], MonitorValues[@upper])
  end

  def done
    case @selectedRowText
    when "上限"
      @upper = @picker_view.selectedRowInComponent(0)
    when "下限"
      @lower = @picker_view.selectedRowInComponent(0)
    end
    @table_view.reloadData
    cancel
  end

  def cancel
    @modal_view.fade_out
    @keyboard_view.slide :down
  end

  private
  def display_monitor_section indexPath, cell
    case indexPath.row
    when 0
      cell.textLabel.text = "上限"
      cell.detailTextLabel.text = MonitorValues[@upper]
    when 1
      cell.textLabel.text = "下限"
      cell.detailTextLabel.text = MonitorValues[@lower]    
    end
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
  end
end

class MonitorPickerDelegate

  def numberOfComponentsInPickerView(picker_view)
    return 1
  end

  def pickerView(picker_view, numberOfRowsInComponent:section)
    return MonitorValues.length
  end

  def pickerView(picker_view, titleForRow:row, forComponent:section)
    return MonitorValues[row].to_s
  end
end
