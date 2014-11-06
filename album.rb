class Album < MenuItem
  attr_reader :initial_photo

  def initialize(id, title, folder_path, initial_photo)
    super(id, title)
    
    @initial_photo = "#{folder_path}/#{initial_photo}"
  end
end