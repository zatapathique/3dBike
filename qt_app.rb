class QtApp < Qt::Widget
  include WinApi
  include Constants

  INITIAL_SELECTION = 0

  slots 'react_to_bike()'

  def initialize
    super

    @player = Player.new
    @bike = Communication.instance
    @menu_items = MenuItem.all
    @selection = INITIAL_SELECTION

    setWindowTitle APP_TITLE
    showFullScreen

    @label = Qt::Label.new(self)
    update_background
    @label.show

    hide_cursor
    show
    set_foreground_window app_hwnd

    # start gathering input from bike
    @timer = Qt::Timer.new(self)
    connect(@timer, SIGNAL('timeout()'), SLOT('react_to_bike()'))
    @timer.start(10)
  end

  def change_selection(dir)
    @selection += dir.eql?(:down) ? 1 : -1
    @selection %= @menu_items.count
    update_background
  end

  def play_selected_item
    @player.play selected_item
  rescue StandardError => e
    @player.try_close_stereoscopic
    @player.initialize_stereoscopic
  end

private 
  def update_background
    @label.setPixmap selected_item.pixmap
  end

  def selected_item
    @menu_items[@selection]
  end

  def react_to_bike
    left_last = @left_pressed
    right_last = @right_pressed
    @left_pressed, @right_pressed, speed = @bike.state?

    if right_last == false && @right_pressed
      play_selected_item
    elsif left_last == false && @left_pressed
      change_selection :down
    end
  end
end