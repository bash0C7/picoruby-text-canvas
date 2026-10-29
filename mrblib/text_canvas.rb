require "vram"
require "bdffont"
require "terminus"

class TextCanvas
  include VRAM::Delegatable
  include Terminus::Drawable

  attr_reader :width, :line_height

  def initialize(lines, width: 384, font: "8x16", line_height: 16, band_lines: 1)
    @lines = lines
    @width = width
    @font = font
    @line_height = line_height
    @band_lines = band_lines
    @row_bytes = width / 8
    @next = 0
    @height = band_lines * line_height
    @vram = VRAM.new(w: width, h: @height, cols: 1, rows: 1, layout: :horizontal)
  end

  def next_block
    lines = @lines
    return nil if @next >= lines.size
    count = lines.size - @next
    count = @band_lines if count > @band_lines
    @vram.fill(0)
    i = 0
    while i < count
      draw_terminus(@font, 0, i * @line_height, lines[@next + i])
      i += 1
    end
    @next += count
    GC.start
    rows = count * @line_height
    [rows, "" + @vram.pages[0][2].byteslice(0, rows * @row_bytes)]
  end
end
