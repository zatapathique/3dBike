class Movie < MenuItem
  attr_reader :left, :right, :audio, :resistances, :intro, :outro

  def initialize(id, title, folder_path, intro, outro)
    super(id, title)

    path = "#{folder_path}\\#{title}"

    @left = "#{path}_left.mp4"
    @right = "#{path}_right.mp4"
    @audio = "#{path}_audio.wav"

    @intro = intro.to_sec
    @outro = outro.to_sec

    initialize_resistances "#{path}_resistances.txt"
  end

  def resistance_for(position)
    timestamp = @resistances_timestamps.find{|time| time < position} || 0
    @resistances[timestamp]
  end

private
  def initialize_resistances(path)
    file = File.open path

    @resistances = Hash.new
    @resistances[0] = 0

    file.each_line do |line|
      timestamp, resistance = line.chomp.split(' ')
      @resistances[timestamp.to_sec] = resistance.to_i
    end

    @resistances_timestamps = @resistances.keys.sort.reverse
  end
end