class TextCanvasTest < Picotest::Test
  def blocks(canvas)
    out = []
    while (block = canvas.next_block)
      out << block
    end
    out
  end

  def test_one_block_per_line_by_default
    list = blocks(TextCanvas.new(["A", "B", "C"]))
    assert_equal 3, list.size
    assert_equal 16, list[0][0]
    assert_equal 48 * 16, list[0][1].bytesize
  end

  def test_band_lines_group_lines_and_the_last_band_is_short
    list = blocks(TextCanvas.new(["A", "B", "C"], band_lines: 2))
    assert_equal [32, 16], [list[0][0], list[1][0]]
    assert_equal 48 * 16, list[1][1].bytesize
  end

  def test_empty_line_has_no_ink
    block = TextCanvas.new([""]).next_block
    assert_equal "\x00" * (48 * 16), block[1]
  end

  def test_text_leaves_ink
    block = TextCanvas.new(["HI"]).next_block
    assert block[1] != "\x00" * (48 * 16)
  end

  def test_each_band_is_drawn_fresh
    list = blocks(TextCanvas.new(["HI", ""]))
    assert list[0][1] != "\x00" * (48 * 16)
    assert_equal "\x00" * (48 * 16), list[1][1]
  end

  def test_same_text_gives_the_same_bytes
    list = blocks(TextCanvas.new(["HEAP FREE 1", "HEAP FREE 1"]))
    assert_equal list[0][1], list[1][1]
  end

  def test_returns_nil_after_the_last_block
    canvas = TextCanvas.new(["A"])
    canvas.next_block
    assert canvas.next_block.nil?
  end

  def test_blocks_feed_the_phomemo_job
    job = PhomemoThermalPrinter::Job.new(TextCanvas.new(["A", "B"]), density: 4, feed: 3)
    segments = 0
    while job.next_segment
      segments += 1
    end
    assert_equal 32, job.rows
    assert_equal 2, job.blocks
    assert_equal 4, segments
  end
end
