require 'Win32API'

module WinApi
  $keypress = Win32API.new("User32", "GetAsyncKeyState", [], 'I')
  $find_window = Win32API.new("User32", "FindWindow", 'PP', 'I')
  $bring_to_front = Win32API.new("User32", "BringWindowToTop", [], 'I')
  $set_foreground_window = Win32API.new("User32", "SetForegroundWindow", [], 'I')
  $get_foreground_window = Win32API.new("User32", "GetForegroundWindow", [], 'I')
  $lock_set_foreground_window = Win32API.new("User32", "LockSetForegroundWindow", 'I', 'I')
  $show_window = Win32API.new("User32", "ShowWindow", [], 'I')
  $block_input = Win32API.new("User32", "BlockInput", 'I', 'I')
  $show_cursor = Win32API.new("User32", "ShowCursor", 'I', 'I')

  def keypressed?(vkey)
    lb = $keypress.call(vkey)
    !lb.zero?
  end
  def block_input(int)
    $block_input.call int
  end
  def find_window(name)
    $find_window.call nil, name
  end
  def find_window_by_class(klas)
    $find_window.call klas, nil
  end
  def bring_to_front(hwnd)
    $bring_to_front.call hwnd
  end
  def set_foreground_window(hwnd)
    $set_foreground_window.call hwnd
  end
  def get_foreground_window
    $get_foreground_window.call
  end
  def lock_set_foreground_window
    $lock_set_foreground_window.call 1
  end
  def unlock_set_foreground_window
    $lock_set_foreground_window.call 0
  end

  def show_window(hwnd, func = 1)
    $show_window.call hwnd, func
  end
  
  def hide_cursor
	  $show_cursor.call 0
  end

  def app_hwnd
    find_window APP_TITLE
  end
  def player_hwnd
    find_window STEREOSCOPIC_PLAYER_TITLE
  end
end