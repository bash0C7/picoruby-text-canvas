MRuby::Gem::Specification.new('picoruby-text-canvas') do |spec|
  spec.license = 'MIT'
  spec.author  = 'bash0C7'
  spec.summary = 'Draws text lines on picoruby-vram and yields them as 1bpp row blocks'
  spec.require_name = 'text_canvas'
  spec.add_dependency 'picoruby-vram'
  spec.add_dependency 'picoruby-bdffont'
  spec.add_dependency 'picoruby-terminus'
end
