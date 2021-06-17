require("Modules.Player")
require("Modules.bullet")
require("Modules.asteroids")
Width = love.graphics.getWidth()
Height = love.graphics.getHeight()
Red = 100/255
Green = 100/255
Blue = 130/255

function love.load()
    love.physics.setMeter(64) --the height of a meter our Worlds will be 64px
    World = love.physics.newWorld(0.1*64, 0.1*64, true)
      World:setCallbacks(beginContact, endContact, preSolve, postSolve)
    --Define background color
    love.graphics.setBackgroundColor(Red,Green,Blue)

    -- New Player
    Player:Load()

    static = {}
        static.b = love.physics.newBody(World, 400,400, "static")
        static.s = love.physics.newRectangleShape(200,50)
        static.f = love.physics.newFixture(static.b, static.s)
        static.f:setUserData("Block")

    text       = ""   -- we'll use this to put info text on the screen later
    persisting = 0    -- we'll use this to store the state of repeated callback calls
  -- initial graphics setup
  -- set the background color to a nice blue
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

end

function love.update(dt)
    --Player update
    Player:Update(dt)
    --Bullet update
    Bullet:Update(dt)

    World:update(dt) -- this puts the World into motion
end

function love.draw()
    --Bullet Draw
    Bullet:Draw()
    --Player Draw
    Player:Draw()
    love.graphics.polygon("line", static.b:getWorldPoints(static.s:getPoints()))

    love.graphics.print("Bullets: "..#Player.bullets)
    love.graphics.print(text, 10, 10)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
    love.event.quit("apertou esc")
    end
end

function beginContact(a, b, coll)
  x,y = coll:getNormal()
  text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "
  --Bullet Collision
  Bullet:BeginContact(a, b, coll)
end

function endContact(a, b, coll)
  persisting = 0
  --text = #text.."\n"..#a:getUserData().." uncolliding with "..#b:getUserData()
end

function preSolve(a, b, coll)
  if persisting == 0 then    -- only say when they first start touching
      --text = #text.."\n"..#a:getUserData().." touching "..#b:getUserData()
  elseif persisting < 20 then    -- then just start counting
      --text = #text.." "..#persisting
  end
  persisting = persisting + 1    -- keep track of how many updates they've been touching for
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end