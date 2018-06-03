require 'fileutils'

EXT__FILES = [".avi", ".mkv", ".mp4"]
PATH__MOVIE = "/volume1/MOVIES"
PATH__TVSHOW = "/volume1/TVSHOWS"
DIR__DOWNLOAD = "/volume1/FILES/DOWNLOAD"

REG__TVSHOW = /\.S[0-9]{2}E[0-9]{2}\./
REG__MOVIE = /[0-9]{4}\./
REG__FILENAME = /^(.+\/)*(.+)$/
REG__SQUAREBRACKETS = /\[(.*?)\]/
LOGFILE__NAME = "LOGFILE"

# LOGFILE
logfile = File.open(LOGFILE__NAME, "a")
logfile.puts("****************")
logfile.puts("Début du script")
logfile.puts(Time.now.strftime("%d/%m/%Y %H:%M"))
logfile.puts("****************")

Dir.glob(DIR__DOWNLOAD + "/**/*") do |absolutePath|

  fileName = absolutePath.scan(/^(.+\/)*(.+)$/).last.last
  fileExtension = File.extname(absolutePath)
  
  regTVShow = REG__TVSHOW.match(absolutePath)  
  regMovie = REG__MOVIE.match(absolutePath)

  if EXT__FILES.include? fileExtension

    logfile.puts fileName

    if regTVShow != nil
      
      regOtherThanShowName = Regexp.new (regTVShow.to_s + "+.*")
      formattedFileName = fileName.sub(regOtherThanShowName, "").tr(".", " ").upcase

      seasonWithEpisode = regTVShow.to_s.delete('.')
      season = seasonWithEpisode[0...-3]

      destinationPath = PATH__TVSHOW + "/" + formattedFileName + "/" + season
      
      logfile.puts "Nom du fichier formatté ->" + formattedFileName          
      logfile.puts "Type  -> Série"

      if !File.directory?(destinationPath)

        logfile.puts "Le dossier n'existe pas -> Création de celui-ci" 
        system 'mkdir', '-p', destinationPath

      end

      if formattedFileName.count(" ") > 2

        logfile.puts "Renommage de la série"
        episodeName = formattedFileName.split.map(&:chr).join + " " + seasonWithEpisode + fileExtension
        logfile.puts episodeName

      else

        episodeName = formattedFileName + " " + seasonWithEpisode + fileExtension

      end

      if episodeName.include? "["
        episodeName = episodeName.sub(REG__SQUAREBRACKETS, "").lstrip
      end

      destinationPathWithFormattedFileName = destinationPath + "/" + episodeName

      FileUtils.mv absolutePath, destinationPathWithFormattedFileName
      logfile.puts "Déplacement du fichier  ->  " + absolutePath + " vers " + destinationPathWithFormattedFileName

    elsif regMovie != nil

      logfile.puts "Type -> Film"

      delimiter = absolutePath.scan(REG__MOVIE).last
      regOtherThanMovieName = Regexp.new (delimiter.to_s + "*")
      formattedFileName = fileName.sub(regOtherThanMovieName, "").tr(".", " ").upcase.rstrip

      destinationPath = PATH__MOVIE + "/" + formattedFileName + fileExtension

      if !File.directory?(PATH__MOVIE)
        Dir.mkdir PATH__MOVIE
        logfile.puts "Le dossier contenant tous les films n'existe pas  ->  Création de celui-ci (" + PATH__MOVIE + ")"          
      end

      if !File.exist?(destinationPath)
        FileUtils.mv absolutePath, destinationPath
        logfile.puts "Déplacement du fichier  ->  " + absolutePath + " vers " + destinationPath
      end

    else

      logfile.puts("Type -> Inconnu")

    end

    logfile.puts("-----------")
    logfile.puts("")

  end
end

logfile.puts("$$$$$$$$$$$$$$$$")
logfile.puts("Fin du script")
logfile.puts(Time.now.strftime("%d/%m/%Y %H:%M"))
logfile.puts("$$$$$$$$$$$$$$$$")
logfile.puts("")
logfile.close