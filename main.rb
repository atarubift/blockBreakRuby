require 'dxopal'
include DXOpal

GAME_INFO = {
  scene: :title,
  score: 0,
  life: 5,
}

X_WIDTH = Window.width
Y_HEIGHT = Window.height

Window.load_resources do

  Window.loop do
    Window.draw_box_fill(0, 0, X_WIDTH, 50, [128, 128, 128] )
    Window.draw_font(0, 25, "SCOER: #{GAME_INFO[:score]} LIFE: #{"●" * GAME_INFO[:life].to_i}", Font.default)
    Window.draw_box_fill(0, 50, X_WIDTH, Y_HEIGHT, [0, 0, 0])

    case GAME_INFO[:scene]
    when :title
      Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 2, "PRESS SPACE", Font.default)
      if Input.key_push?(K_SPACE)
        GAME_INFO[:scene] = :playing
      end
    when :playing
      Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 2, "Playing Now!", Font.default)
    end
  end
end
