#!ruby

require 'optparse'
require 'rexml/document'



class TmxFile
  include REXML
  VERSION = 0
  def initialize

  end
  def read(filename)
    @doc = REXML::Document.new(File.open(filename, 'r'))
    read_map
  end
  def read_map
    elem = @doc.elements['map']
    @map_width = elem.attributes['width'].to_i
    @map_height = elem.attributes['height'].to_i
    @tile_width = elem.attributes['tilewidth'].to_i
    @tile_height = elem.attributes['tileheight'].to_i
    elem.each_element do |e|
      case e.name
      when 'tileset'
        read_tileset(e)
      when 'layer'
        read_layer(e)
      end
    end
  end
  def read_tileset(elem)
    @tile_properties = {}
    elem.each_element do |e|
      case e.name
      when 'image'
        read_image(e)
      when 'tile'
        @tile_properties[e.attributes['id'].to_i] = read_tile_property(e)
      end
    end
  end
  def read_image(elem)
    @image = File.basename(elem.attributes['source'], '.*')
  end
  # 各タイルのプロパティをHashで保存しておく
  def read_tile_property(elem)
    list = {}
    elem.elements['properties'].each_element do |e|
      list[e.attributes['name']] = e.attributes['value']
    end
    list
  end
  def read_layer(elem)
    # width, heightはmapの値と同じなはずじゃないのか？
    # 異なるケースがあるのかも知れないが今回は無視
    @tiles = [];
    row = [];
    elem.elements['data'].each_element do |e|
      if e.name =~ /^tile/
        row << e.attributes['gid'].to_i - 1
        if row.size == @map_width
          @tiles << row
          row = [];
        end
      end
    end
    raise 'error' unless row.empty? # データが正しければ、必ず空になっているはず
    @tiles.reverse! # SpriteKitの座標系と合わせるために反転しておく
  end

  def to_bin
    bin = ''
    bin += gen_header
    bin += gen_tiles
    bin
  end
  def gen_header
    bin = ['TMX0', VERSION, @map_width, @map_height, @tile_width, @tile_height].pack('Z4ISSSS')
    bin += [@image[0, 15], 0].pack('Z15c')
    bin
  end
  def gen_tiles
    bin = ''
    @tiles.each do |row|
      row.each do |id|
        if @tile_properties.has_key?(id)
          bin += [id, gen_userdata(id)].pack('sS')
        else
          bin += [id, 0].pack('sS')
        end
      end
    end
    bin
  end
  def gen_userdata(id)
    props = @tile_properties[id]
    0x01 | ((props['type'].to_i & 0xff) << 8)
  end



  def dump
    @tiles.each do |row|
      row.each do |c|
        printf "%3d ", c
      end
      print "\n"
    end
  end
end

options = {
  :o => '',
}
OptionParser.new do |opts|
  opts.on('-o OUTFILENAME') { |f| options[:o] = f }
  opts.parse! ARGV
end
if ARGV.size > 0
  tmx = TmxFile.new
  tmx.read(ARGV.shift)
  # tmx.dump
  unless options[:o].empty?
    File.open(options[:o], 'w+') do |f|
      f.write tmx.to_bin
    end
  end
end





