class Movie
  attr_reader :name, :extension
  @@REGEX_OVERFLOW = /[.|\ ][0-9]{4}[.|\ ]+.*/
  @@REGEX_BRACKETS = /\[(.*?)\]/
  
  def initialize(name, extension)
    @name = name
    @extension = extension
  end

  def rename_movie
    format_name + @extension
  end
  
  private def format_name
    @name.chomp(@name[@@REGEX_OVERFLOW])
         .sub(@@REGEX_BRACKETS, "")
         .tr(".", " ")
         .lstrip
         .rstrip
         .upcase
  end
end