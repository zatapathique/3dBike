require 'singleton'
require 'serialport'

class Communication
  include Singleton
  include Constants

  def initialize
    @app_com = SerialPort.new APP_COM

    @app_com.baud = BAUD
    @app_com.data_bits = DATA_BITS
    @app_com.parity = PARITY
    @app_com.stop_bits = STOP_BITS

    @app_com.read_timeout = READ_TIMEOUT
  end

  def state?(question = 1)
    @app_com.write_byte question

    response = nil
    READ_RETIRES.times do
      response = @app_com.read_last_byte
      break unless response.nil?
    end

    if response
      left = bike_left_pressed?(response)
      right = bike_right_pressed?(response)

      response -= BIKE_LEFT_BUTTON if left
      response -= BIKE_RIGHT_BUTTON if right

      speed = response
    else
      left = right = false
      speed = 63
    end

    return [left, right, speed]
  end

private
  def bike_left_pressed?(response)
    (response & BIKE_LEFT_BUTTON) == BIKE_LEFT_BUTTON
  end
  def bike_right_pressed?(response)
    (response & BIKE_RIGHT_BUTTON) == BIKE_RIGHT_BUTTON
  end
end