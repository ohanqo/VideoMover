class TVShow
  attr_reader :name, :extension, :season_and_episode, :season
  @@REGEX_SEASON_AND_EPISODE = /S[0-9]{2}E[0-9]{2}/  
  @@REGEX_OVERFLOW = /[.|\ ]S[0-9]{2}E[0-9]{2}[.|\ ]+.*/
  @@REGEX_BRACKETS = /\[(.*?)\]/
  
  def initialize(name, extension)
    @name = name
    @extension = extension
    @season_and_episode = @@REGEX_SEASON_AND_EPISODE.match(@name)
    @season = @season_and_episode[0...-3]
    shorten if @name.count(" ") > 2 || @name.count(".") > 3
  end

  def shorten
    @name = format_name.split.map(&:chr).join
  end
  
  def format_name
    @name.chomp(@name[@@REGEX_OVERFLOW])
         .sub(@@REGEX_BRACKETS, "")
         .tr(".", " ")
         .lstrip
         .rstrip
         .upcase
  end
end