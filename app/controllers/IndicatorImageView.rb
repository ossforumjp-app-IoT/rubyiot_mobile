class IndicatorImageView < UIImageView
  attr_accessor :loading, :loading_view

  def initWithFrame(rect)
    super
    puts "initWithFrame: #{rect}"
    @loading = false
    @loading_view = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge).tap do |lv|
      lv.color = UIColor.blackColor
    end
    self
  end

  def loading=(loading)
    puts "loading: #{loading}"
    if loading
      self.image = nil
      addSubview(@loading_view)
      @loading_view.hidesWhenStopped = true
      @loading_view.startAnimating
    else
      @loading_view.stopAnimating
    end
  end

  def layoutSubviews
    super
    puts "layoutSubviews: #{self.frame.size}"
    w = 30
    h = 30
    x = (self.frame.size.width/2.0 - w/2)
    y = (self.frame.size.height/2.0 - h/2)
    @loading_view.frame = [[x, y], [w, h]]
  end
end
