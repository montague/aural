module Aural
  class Encoder

  end
end

if __FILE__ == $0
  filename = "_t2TzJ.flv"
  file = File.expand_path("../../../#{filename}", __FILE__)

  `ffmpeg -i #{file} -acodec libmp3lame -ac 2 -ab 128K _t2TzJ.mp3`

end