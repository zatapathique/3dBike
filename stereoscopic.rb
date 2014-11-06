require 'win32ole'

class Stereoscopic
  attr_reader :player

  PLAYBACK_STATE = {
    -1 => :not_running,
    0 => :play,
    1 => :pause,
    2 => :stop,
    3 => :fast_forward,
    4 => :fast_backward
  }

  def initialize
    @player = WIN32OLE.new('StereoPlayer.Automation')
  end

  def prepare
    player.wait_till_ready
    player.disable_input
    player.hide_menu
    player.enter_fullscreen
  end

  def ready?
    player.GetReady false
    return WIN32OLE::ARGV[0]
  end

  def when_ready(&block)
    until ready? ; end # loop till player ready
    block.call if block_given?
  end
  alias_method :wait_till_ready, :when_ready

  def open(item)
    case item
    when Album then player.OpenFile item.path
    when Movie then player.OpenLeftRightFiles(item.left, item.right, item.audio, 1)
    end
  rescue WIN32OLERuntimeError => e
    # do nothing
  end

  def close
    player.ClosePlayer
  end

  # PLAYBACK STUFF ---------------------------------
  def playback_position
    player.GetPosition -1
    WIN32OLE::ARGV[0]
  end
  def playback_duration
    player.GetDuration -1
    WIN32OLE::ARGV[0]
  end
  
  def set_volume(volume)
    player.SetVolume volume
  end

  def stop_playback
    player.SetPlaybackState PLAYBACK_STATE.key(:stop)
  end
  def pause_playback
    player.SetPlaybackState PLAYBACK_STATE.key(:pause)
  end
  def start_playback
    player.SetPlaybackState PLAYBACK_STATE.key(:play)
  end
  alias_method :resume_playback, :start_playback

  def playback_completed?
    player.GetPlaybackCompleted false
    WIN32OLE::ARGV[0]
  end

  def next_file_in_folder
    player.NextFileInFolder
  end
  def previous_file_in_folder
    player.PreviousFileInFolder
  end
  # -------------------------------------------------

private
  def enter_fullscreen
    player.EnterFullscreenMode true
  end
  def leave_fullscreen
    player.LeaveFullscreenMode
  end
  def disable_input
    player.SetHIDEventsEnabled false
  end
  def hide_menu
    player.SetMenuVisible false
  end

  def self.supported_image_formats
    %w[ .jpg .jpeg .jps .mpo .tif .tiff .gif .png .pns .bmp ]
  end
end