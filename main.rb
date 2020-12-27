require 'dxopal'
include DXOpal

Window.load_resources do

  Window.loop do
    Window.draw_box_fill(0, 0, Window.width, 50, [128, 128, 128] )
    Window.draw_box_fill(0, 50, Window.width, Window.height, [C_BLACK])
  end
end
