require 'dxopal'
include DXOpal

GAME_INFO = {
  scene: :title,
  score: 0,
  life: 5,
}

font = Font.new(10)

Window.load_resources do

  Window.loop do
    Window.draw_box_fill(0, 0, Window.width, 50, [128, 128, 128] )
    Window.draw_font(0, 0, "SCOER: #{GAME_INFO[:score]} LIFE: #{"●" * GAME_INFO[:life].to_i}", Font.default)
    Window.draw_box_fill(0, 50, Window.width, Window.height, [C_BLACK])
  end
end
