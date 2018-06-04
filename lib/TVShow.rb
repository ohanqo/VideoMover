class TVShow
  attr_reader :name, :extension, :season_and_episode, :season
  @@REGEX_SEASON_AND_EPISODE = /S[0-9]{2}E[0-9]{2}/  
  @@REGEX_OVERFLOW = /[.|\ ]S[0-9]{2}E[0-9]{2}[.|\ ]+.*/
  @@REGEX_BRACKETS = /\[(.*?)\]/
  
  def initialize(name, extension)
    @name = name
    @extension = extension
    @season_and_episode = @@REGEX_SEASON_AND_EPISODE.match(@name).to_s
    @season = @season_and_episode[0...-3].to_s
  end
  
  def rename_episode
    shorten(format_name) + " " + @season_and_episode + @extension
  end

  def formatted_name
    format_name
  end  

  private

  def format_name
    @name.chomp(@name[@@REGEX_OVERFLOW])
         .sub(@@REGEX_BRACKETS, "")
         .tr(".", " ")
         .lstrip
         .rstrip
         .upcase
  end
  
  def shorten(long_name)
    if(long_name.count(" ") > 2)
        long_name.split.map(&:chr).join
    else
        long_name
    end
  end
end