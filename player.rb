class Player
  include Constants

  attr_reader :bike, :stereoscopic

  def initialize
    @stereoscopic = Stereoscopic.new
    @bike = Communication.instance
  end

  def try_close_stereoscopic
    stereoscopic.close rescue nil
  end

  def play(item)
    case item
    when Movie then play_movie(item)
    when Album then view_images(item)
    end
  end

private
  def play_movie(movie)
    stereoscopic.prepare 
    stereoscopic.open movie
    
    set_foreground_window player_hwnd

    last_movement = Time.now
    bike_stopped = false
    
    loop do
      # get bike's resistance for given movie position
      movie_position = stereoscopic.playback_position
      resistance = movie.resistance_for movie_position

      # send resistance to the bike and read its state
      left_pressed, right_pressed, speed = @bike.state? resistance

      # if actual ride started check if user is pedaling
      if movie_position.between?(movie.intro, movie.outro)
        if speed >= SPEED_TRESHOLD
          last_movement = Time.now
          stereoscopic.resume_playback
        end

        time_passed = Time.now - last_movement
        
        stereoscopic.pause_playback if time_passed > PAUSE_TRESHOLD
        bike_stopped = time_passed > BACK_TO_MENU_TRESHOLD
      end
    
      if bike_stopped || left_pressed || right_pressed || stereoscopic.playback_completed?
        stereoscopic.stop_playback
        set_foreground_window app_hwnd
        return true
      end

      sleep 0.05
    end
  end

  def view_images(album)
    stereoscopic.prepare
    stereoscopic.open album
    
    bring_to_front player_hwnd
    loop do
      left_pressed, right_pressed = @bike.state?

      if left_pressed
        bring_to_front app_hwnd
        return true
      elsif right_pressed
        stereoscopic.next_file_in_folder
      end

      sleep 0.05
    end
  end
end