require 'rubygems'
require 'Qt4'

require 'pry'
require 'yaml'

require './winapi'
require './constants'
require './extensions'

require './stereoscopic'
require './player'
require './communication'
require './menu_item'
require './movie'
require './album'
require './qt_app'

# since this script loads automaticaly after PC starts
# we have to let it load all the stuff it needs
sleep 10 

app = Qt::Application.new(ARGV)
QtApp.new
app.exec