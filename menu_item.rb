class MenuItem
  attr_reader :id, :title, :pixmap, :menu_sound, :view_sound

  def initialize(id, title)
    @id = id
    @title = title
    @pixmap = Qt::Pixmap.new "#{IMAGES_ROOT}/#{title}_#{RESOLUTION.join('_')}.png"
  end

  def self.all
    db_yml = YAML.load(File.open(DATABASE_PATH))

    movies = db_yml['movies'].map do |attributes|
      params = attributes.values_at('id', 'title', 'folder_path', 'intro', 'outro')
      Movie.new(*params)
    end

    photos = db_yml['photos'].map do |attributes|
      params = attributes.values_at('id', 'title', 'folder_path', 'initial_photo')
      Album.new(*params)
    end

    (movies + photos).sort_by(&:id)
  end
end