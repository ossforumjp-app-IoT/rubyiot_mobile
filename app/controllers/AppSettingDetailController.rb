# coding: utf-8
class AppSettingDetailController < UIViewController

  attr_accessor :item

  def viewDidLoad
    super
    #color = UIColor.colorWithRed(0.60, green:0.20, blue:0.20, alpha:1.0)
    #self.view.backgroundColor = color
    self.view.backgroundColor = UIColor.whiteColor
=begin
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = self.item[:value]
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2,
    	self.view.frame.size.height / 2)
    self.view.addSubview @label
=end
    self.title = self.item[:name]

    @text_field = UITextField.alloc.initWithFrame [[0,0], [280, 26]]
    #@text_field.placeholder = "#abcabc"
    @text_field.textAlignment = UITextAlignmentLeft
    @text_field.autocapitalizationType = UITextAutocapitalizationTypeNone
    @text_field.borderStyle = UITextBorderStyleRoundedRect
    @text_field.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 100)
    @text_field.text = self.item[:value]
    @text_field.delegate = self

    self.view.addSubview @text_field

    @save = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @save.setTitle("保存", forState:UIControlStateNormal)
    #@save.setTitle("Loading", forState:UIControlStateDisabled)
    @save.setTitleColor(UIColor.lightGrayColor, forState:UIControlStateDisabled)
    @save.sizeToFit
    @save.center = CGPointMake(self.view.frame.size.width / 2, @text_field.center.y + 40)

    # TODO:
    #@save.addTarget(self.navigationController,
    #             action: 'popViewControllerAnimated:',
    #             forControlEvents: UIControlEventTouchUpInside)
    #@save.addTarget(self,
    #              action: "pop:",
    #              forControlEvents: UIControlEventTouchUpInside)

    @save.when(UIControlEventTouchUpInside) do
      @save.enabled = false
      @text_field.enabled = false
      # TODO: 設定の更新(値チェック)
      self.item[:set].call(@text_field.text)
      self.navigationController.popViewControllerAnimated(true)
    end


    #@save.when(UIControlEventTouchUpInside) do
    #  @save.enabled = false
      #@text_field.enabled = false
=begin
      hex = @text_field.text
      # chop off any leading #s
      hex = hex[1..-1] if hex[0] == "#"

      Color.find(hex) do |color|
        if color.nil?
          @save.setTitle("None :(", forState: UIControlStateNormal)
        else
          @save.setTitle("Search", forState: UIControlStateNormal)
          self.open_color(color)
        end

        @save.enabled = true
        @text_field.enabled = true
      end
=end
    #  self.navigationController.popViewController(animated:true)
    #end
    self.view.addSubview @save
  end
=begin
  def push
 	new_controller = TapController.alloc.initWithNibName(nil, bundle: nil)
  	self.navigationController.pushViewController(new_controller, animated: true)
  end

  def initWithNibName(name, bundle: bundle)
  	super
  	self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
  	self
  end
=end
 def textFieldShouldReturn(textField)
    # if we're moving from email field to password, activate the password field for editing
    # otherwise, shift the container back down
    #  container_frame = @container.frame
    #  container_frame.origin.y += 70
=begin
      UIView.animateWithDuration(0.3,
        animations: lambda {
          @container.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = false
        }
      )
=end
      textField.resignFirstResponder
    false
  end


  def pop
    # TODO: 設定の更新(値チェック)
    #$settings.server_address = text_field.text
    p "---------------pop"
    self.navigationController.popViewControllerAnimated(true)
  end
end
