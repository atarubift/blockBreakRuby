require 'dxopal'
include DXOpal

GAME_INFO = {
  scene: :title,
  score: 0,
  life: 5,
}

X_WIDTH = Window.width
Y_HEIGHT = Window.height

Sound.register(:hit_racket, 'sounds/hitracket.wav')
Sound.register(:hit_block, 'sounds/banishbl.wav')
Sound.register(:all_miss, 'sounds/allmiss.wav')
Sound.register(:down_life, 'sounds/downlife.wav')
Sound.register(:button, 'sounds/button.wav')
Sound.register(:sucess, 'sounds/clear.wav')
# Sound.register(:bgm, 'sounds/bgm.wav')

class Bar < Sprite
  
  def initialize
    x = X_WIDTH / 2
    y = Y_HEIGHT - 30
    bar = Image.new(50, 10, [255, 255, 255])
    super(x, y, bar)
  end

  def update
    if Input.key_down?(K_LEFT) && self.x > 0
      self.x -= 5
    elsif Input.key_down?(K_RIGHT) && self.x < (Window.width - 50)
      self.x += 5
    end
  end
end

class Walls < Array
  def initialize
    self << Wall.new(0, 50, 1, Y_HEIGHT - 50)
    self << Wall.new(0, 50, X_WIDTH, 1)
    self << Wall.new(X_WIDTH - 1, 50, 1, Y_HEIGHT - 50)
  end

  def draw
    Sprite.draw(self)
  end
end

class Wall < Sprite
  def initialize(x, y, dx, dy)
    self.x = x
    self.y = y
    self.image = Image.new(dx, dy, C_BLACK)
    super(x, y, image)
  end
end

class Blocks < Array
  def initialize
    7.times do |y|
      10.times do |x|
        self << Block.new(21 + 60 * x, 55 + 20 * y, C_WHITE) 
      end
    end
  end

  def draw
    Sprite.draw(self)
  end
end

class Block < Sprite
  def initialize(x, y, c)
    self.x = x
    self.y = y
    self.image = Image.new(58, 18, c)
    super(self.x, self.y, self.image)
  end
end

class Ball < Sprite
  def initialize
    x = X_WIDTH / 2
    y = Y_HEIGHT - 55 
    ball = Image.new(10, 10).circle_fill(5, 5, 5, C_WHITE)
    super(x, y, ball)
    @dx = rand(1..5)
    y_rand = rand(3..6)
    @dy = -1 * y_rand
  end

  def update(walls, bar, blocks)
    self.x += @dx

    if self === walls or self === bar
      self.x -= @dx
      @dx = -1 * @dx
      Sound[:hit_racket].play
    end

    hit = self.check(blocks).first
    if hit != nil
      hit.vanish
      Sound[:hit_block].play
      self.x -= @dx
      @dx *= -1
      GAME_INFO[:score] += 100
    end

    self.y += @dy

    if self === walls or self === bar
      self.y -= @dy
      @dy *= -1
      Sound[:hit_racket].play
    end

    hit = self.check(blocks).first
    if hit != nil
      hit.vanish
      Sound[:hit_block].play
      self.y -= @dy
      @dy *= -1
      GAME_INFO[:score] += 100
    end

    if self.y > Y_HEIGHT
      GAME_INFO[:life] -= 1
      if GAME_INFO[:life] > 0 
        self.y = Y_HEIGHT - 40
        Sound[:down_life].play
        @dx = rand(1..5)
        @dy *= -1
        GAME_INFO[:scene] = :title
      else
        GAME_INFO[:scene] = :gameover
        Sound[:all_miss].play
      end
    end
  end
end

class Game
  def initialize
    reset
  end

  def reset
    @walls = Walls.new
    @blocks = Blocks.new
    resetPlace
    GAME_INFO[:scene] = :title
    GAME_INFO[:score] = 0
    GAME_INFO[:life] = 5
  end

  def resetPlace
    @bar = Bar.new
    @ball = Ball.new
  end

  def run
    # Sound[:bgm].play
    Window.loop do
      Window.draw_box_fill(0, 0, X_WIDTH, 50, [128, 128, 128] )
      Window.draw_font(0, 25, "SCOER: #{GAME_INFO[:score]} LIFE: #{"●" * GAME_INFO[:life]}", Font.default)
      Window.draw_box_fill(0, 50, X_WIDTH, Y_HEIGHT, [0, 0, 0])

      case GAME_INFO[:scene]
      when :title
        resetPlace
        Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 2, "PRESS SPACE", Font.default)
        if Input.key_push?(K_SPACE)
          GAME_INFO[:scene] = :playing
          Sound[:button].play
        end
      when :playing
        @walls.draw
        @bar.update
        @bar.draw
        @ball.update(@walls, @bar, @blocks)
        @ball.draw
        @blocks.draw
        if GAME_INFO[:score] == 7000
          GAME_INFO[:scene] = :clear
          Sound[:sucess].play
        end
      when :gameover
        Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 3, " GAME OVER ", Font.default)
        Window.draw_font((X_WIDTH / 5)  * 2, (Y_HEIGHT - 50) / 2, "RETRY:SPACE", Font.default)
        if Input.key_push?(K_SPACE)
          Sound[:button].play
          reset
        end
      when :clear
        Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 2, "Congratulation!", Font.default)
        if Input.key_push?(K_SPACE)
          Sound[:button].play
          reset
        end
      end
    end
  end
end

Window.load_resources do
  game = Game.new
  game.run
end 
