module Paperclip
  class ParseImage < Processor
    attr_accessor :engine

    def initialize(file, options = {}, attachment = nil)
      super

      @file           = file
      @whiny          = options[:whiny].nil? ? true : options[:whiny]
      @format         = options[:format]
      @current_format = File.extname(@file.path)
      @basename       = File.basename(@file.path, @current_format)

      @engine = Tesseract::Engine.new do |e|
        e.language  = :eng
        e.whitelist = ':.0123456789'
      end
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

      command = "identify"
      params  = "#{fromfile}"
      success = Paperclip.run(command, params)
      info    = success.match(/([\d]+)x([\d]+)\+[\d]+\+[\d]+/)

      if info[1] == '1920' && info[2] == '1080'
        crop_geom = '1415x315+205+435' # 1080p
      elsif info[1] == '1920' && info[2] == '1018'
        crop_geom = '1420x315+200+400' # Xephyr
      elsif info[1] == '1440' && info[2] == '810'
        crop_geom = '1065x235+150+325' # 810p
      elsif info[1] == '1280' && info[2] == '720'
        crop_geom = '945x210+135+290' # 720p
      end

      command = "convert"
      params = "-crop #{crop_geom} -resize 300% -blur 0x1 -contrast -normalize -type grayscale -sharpen 1 -posterize 3 -negate -gamma 25 #{fromfile} #{tofile(dst)}"

      begin
        success = Paperclip.run(command, params)
      rescue Paperclip::Errors::PaperclipCommandLineError
        raise Paperclip::Errors::PaperclipError, "There was an error processing the file #{@basename}" if @whiny
      end

      attachment.instance.parsed = @engine.text_for(tofile(dst))

      @file
    end

    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      File.expand_path(destination.path)
    end
  end
end
