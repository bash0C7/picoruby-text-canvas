# picoruby-text-canvas

PicoRuby の mrbgem です。テキストの行を `picoruby-vram` に 1 行ずつ描き、横 8 ピクセルを 1 バイトとする 1bpp の行ブロックとして返します。プリンターやディスプレイは知りません。

## 使い方

```ruby
require 'text_canvas'

canvas = TextCanvas.new(["HEAP FREE 102000", "UP MS 2474"])
while (block = canvas.next_block)
  rows = block[0]
  bytes = block[1]
end
```

| 項目 | 内容 |
|---|---|
| `TextCanvas.new(lines, width: 384, font: "8x16", line_height: 16, band_lines: 1)` | `lines` は文字列の配列です。`font` は `picoruby-terminus` のサイズで、`6x12`、`8x16`、`12x24`、`16x32` です。 |
| `next_block` | `band_lines` 行ぶんを描いて、`[rows, bytes]` を返します。最後のあとは `nil` です。`bytes` は `rows * width / 8` バイトで、最上位ビットが左端、1 が黒です。 |

ASCII（0x20 から 0x7e）だけを描けます。`next_block` は、描いたあとに `GC.start` を呼びます。

## Phomemo T02 に印字する

`next_block` を持つオブジェクトは、[picoruby-phomemo-thermal-printer](https://github.com/bash0C7/picoruby-phomemo-thermal-printer) の `Job` にそのまま渡せます。

```ruby
job = PhomemoThermalPrinter::Job.new(TextCanvas.new(lines), density: 4, feed: 3)
```

## ビルドに加える

```ruby
conf.gem core: "picoruby-vram"
conf.gem core: "picoruby-bdffont"
conf.gem core: "picoruby-terminus"
conf.gem gemdir: "/path/to/picoruby-text-canvas"
```

## テスト

picoruby の host VM（`picoruby-vram`、`picoruby-bdffont`、`picoruby-terminus` を含む）と `picoruby-picotest` で `test/` を実行します。

## ライセンス

MIT。`LICENSE` を参照してください。
