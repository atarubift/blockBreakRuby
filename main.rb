require 'dxopal'
include DXOpal

GAME_INFO = {
  scene: :title,
  score: 0,
  life: 5,
}

X_WIDTH = Window.width
Y_HEIGHT = Window.height

bar = Sprite.new(X_WIDTH / 2, Y_HEIGHT - 30, Image.new(50, 10, [255, 255, 255]))
walls = [Sprite.new(0, 50, Image.new(1, Y_HEIGHT - 50, C_BLACK)),
         Sprite.new(0, 50, Image.new(X_WIDTH, 1, C_BLACK)),
         Sprite.new(X_WIDTH - 1, 50, Image.new(1, Y_HEIGHT - 50, C_BLACK)),
         bar]
ball = Sprite.new(X_WIDTH / 2, Y_HEIGHT - 40, Image.new(10, 10).circle_fill(5, 5, 5, C_WHITE))
dx = rand(1..5)
dy = -1 * rand(3..6)
image = Image.new(58, 18, C_WHITE)
blocks = []
7.times do |y|
  10.times do |x|
    blocks << Sprite.new(21 + 60 * x, 55 + 20 * y, image) 
  end
end


Window.load_resources do

  Window.loop do
    Window.draw_box_fill(0, 0, X_WIDTH, 50, [128, 128, 128] )
    Window.draw_font(0, 25, "SCOER: #{GAME_INFO[:score]} LIFE: #{"●" * GAME_INFO[:life]}", Font.default)
    Window.draw_box_fill(0, 50, X_WIDTH, Y_HEIGHT, [0, 0, 0])

    case GAME_INFO[:scene]
    when :title
      Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 2, "PRESS SPACE", Font.default)
      if Input.key_push?(K_SPACE)
        GAME_INFO[:scene] = :playing
      end
    when :playing
      if Input.key_down?(K_LEFT) && bar.x > 0
        bar.x -= 5 
      elsif Input.key_down?(K_RIGHT) && bar.x < (Window.width - 50)
        bar.x += 5
      end
      
      Sprite.draw(walls)

      ball.x += dx
      if ball === walls
        ball.x -= dx
        dx = -dx
      end

      x_block = ball.check(blocks).first
      if x_block
        x_block.vanish
        GAME_INFO[:score] += 100
        ball.x -= dx
        dx = -dx
      end

      ball.y += dy
      if ball === walls
        ball.y -= dy
        dy = -dy
      end

      y_block = ball.check(blocks).first
      if y_block
        y_block.vanish
        GAME_INFO[:score] += 100
        ball.y -= dy
        dy = -dy
      end

      if ball.y > Y_HEIGHT
        if GAME_INFO[:life] > 0
          GAME_INFO[:life] -= 1
          ball.y = Y_HEIGHT - 40
          dx = rand(1..5)
          dy = -dy
          GAME_INFO[:scene] = :title
        else GAME_INFO[:life] == 0
          GAME_INFO[:scene] = :gameover
        end
      end

      ball.draw
      Sprite.draw(blocks)
    when :gameover 
      Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 3, "GAME OVER", Font.default)
      Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 2, "RETRY:SPACE", Font.default)
      if Input.key_push?(K_SPACE)
        GAME_INFO[:score] = 0
        GAME_INFO[:life] = 5
        GAME_INFO[:scene] = :title
        ball.x = X_WIDTH / 2
        ball.y = Y_HEIGHT - 40
        dx = 3
        dy = -3
        block = []
        7.times do |y|
          10.times do |x|
            blocks << Sprite.new(21 + 60 * x, 55 + 20 * y, image) 
          end
        end
      end
    end
  end
end
