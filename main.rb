require 'dxopal'
include DXOpal

GAME_INFO = {
  scene: :title,
  score: 0,
  life: 5,
}

X_WIDTH = Window.width
Y_HEIGHT = Window.height

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
    self.image = Image.new(dx, dy, C_WHITE)
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
    y = Y_HEIGHT - 50 
    ball = Image.new(10, 10).circle_fill(5, 5, 5, C_WHITE)
    super(x, y, ball)
    @dx = rand(1..5)
    @dy = rand(3..6)
  end

  def update(walls, bar, blocks)
    self.x += @dx

    if self === walls or self === bar
      self.x -= @dx
      @dx = -1 * @dx
    end

    hit = self.check(blocks).first
    if hit != nil
      hit.vanish
      self.x -= @dx
      @dx *= -1
      GAME_INFO[:score] += 100
    end

    self.y += @dy

    if self === walls or self === bar
      self.y -= @dy
      @dy *= -1
    end

    hit = self.check(blocks).first
    if hit != nil
      hit.vanish
      self.y -= @dy
      @dy *= -1
      GAME_INFO[:score] += 100
    end

    if self.y > Y_HEIGHT
      GAME_INFO[:life] -= 1
      if GAME_INFO[:life] > 0 
        self.y = Y_HEIGHT - 40
        @dx = rand(1..5)
        @dy *= -1
        GAME_INFO[:scene] = :title
      else
        GAME_INFO[:scene] = :gameover
      end
    end
  end
end

Window.load_resources do

  walls = Walls.new
  bar = Bar.new
  walls = Walls.new
  ball = Ball.new
  blocks = Blocks.new
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
      walls.draw
      bar.update
      bar.draw
      ball.update(walls, bar, blocks)
      ball.draw
      blocks.draw
    when :gameover
      Window.draw_font((X_WIDTH / 5) * 2, (Y_HEIGHT - 50) / 3, " GAME OVER ", Font.default)
      Window.draw_font((X_WIDTH / 5)  * 2, (Y_HEIGHT - 50) / 2, "RETRY:SPACE", Font.default)
      if Input.key_push?(K_SPACE)
        GAME_INFO[:score] = 0
        GAME_INFO[:life] = 5
        GAME_INFO[:scene] = :title
        Ball.new
        Bar.new
        Blocks.new
      end
    end
  end
end 
