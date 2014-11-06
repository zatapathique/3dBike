module Constants
  DATABASE_PATH = './database.yml'
  
  RESOLUTION = 1280, 720

  APP_TITLE = 'Project Lubuskie'
  STEREOSCOPIC_PLAYER_TITLE = 'Stereoscopic Player'
  DEFAULT_VOLUME = 0.8
  
  SPEED_TRESHOLD = 2 # lowest bike speed to consider it moving
  PAUSE_TRESHOLD = 1 # [s] 
  BACK_TO_MENU_TRESHOLD = 10 # [s]

  OUTRO_HOLD_TIME = 15
  
  # COM STUFF ----------
  APP_COM = 0 # COM1

  READ_RETIRES = 4
  READ_TIMEOUT = 10

  BAUD = 9600
  DATA_BITS = 8
  PARITY = 0
  STOP_BITS = 1

  BIKE_LEFT_BUTTON = 128
  BIKE_RIGHT_BUTTON = 64
end