module Paperclip
  class ParseImage < Processor
    attr_accessor :engine

    def initialize(file, options = {}, attachment = nil)
      super

      @file   = file
      @engine = Tesseract::Engine.new do |e|
        e.language  = :eng
        e.whitelist = ':.0123456789'
      end
    end

    def make
      MiniMagick.processor = :gm
      i = MiniMagick::Image.read(@file)

      info = i.verbose.match(/([\d]+)x([\d]+)\+[\d]+\+[\d]+/)
      if info[1] == '1920' && info[2] == '1080'
        i.crop('1415x315+205+435') # 1080p
      elsif info[1] == '1440' && info[2] == '810'
        i.crop('1065x235+150+325') # 810p
      elsif info[1] == '1280' && info[2] == '720'
        i.crop('945x210+135+290') # 720p
      end

      i.resize('150%')
      i.edge(1)
      i.negate
      i.normalize
      i.colorspace('gray')
      i.blur('0x.5')
      i.contrast

      attachment.instance.parsed = @engine.text_for(i)

      @file
    end

    def fromfile
      "\"#{ File.expand_path(@file.path) }[0]\""
    end
  end
end
