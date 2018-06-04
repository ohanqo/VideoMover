require "./lib/Movie.rb"
require "./lib/TVShow.rb"

require "./config/regex.rb"
require "./config/folders.rb"
require "./config/extensions.rb"

require 'fileutils'

Dir.glob(PATH_DOWNLOAD + "/**/*") do |absolute_path|

  extension = File.extname(absolute_path)
  file = File.basename(absolute_path, extension)

  if EXT_FILES.include? extension
    if REG_TVSHOW.match(absolute_path) != nil
      show = TVShow.new(file, extension)

      show_name = show.formatted_name
      show_season = show.season

      destination_path = PATH_TVSHOW + "/" + show_name + "/" + show_season
      system 'mkdir', '-p', destination_path if !File.directory? destination_path

      destination_path_with_file = destination_path + "/" + show.rename_episode 
      FileUtils.mv absolute_path, destination_path_with_file if !File.exist? destination_path_with_file 

    elsif REG_MOVIE.match(absolute_path) != nil
      movie = Movie.new(file, extension)
      
      destination_path_with_file = PATH_MOVIE + "/" + movie.rename_movie 
      FileUtils.mv absolute_path, destination_path_with_file if !File.exist? destination_path_with_file 
    end
  end
end