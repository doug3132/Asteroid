require("Modules.Player")
require("Modules.bullet")
require("Modules.asteroids")

Width = love.graphics.getWidth()
Height = love.graphics.getHeight()

function love.load()
    love.physics.setMeter(64)
    World = love.physics.newWorld(0.1*64, 0.1*64, true)
    World:setCallbacks(beginContact, endContact, preSolve, postSolve)
    love.graphics.setBackgroundColor(100/255,100/255,130/255)

    Player:Load()

    Asteroid:Create()
    static = {
        b = love.physics.newBody(World, 400,400, "static"),
        s = love.physics.newRectangleShape(200,50),
    }
    static.f = love.physics.newFixture(static.b, static.s) :setUserData("Block")

    persisting = 0
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
end

function love.update(dt)
    Player:Update(dt)
    Bullet:Update(dt)
    World:update(dt)
end

function love.draw()
    Bullet:Draw()
    Player:Draw()
    love.graphics.polygon("line", static.b:getWorldPoints(static.s:getPoints()))
    love.graphics.print("Bullets: "..#Player.bullets)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function beginContact(a, b, coll)
    x,y = coll:getNormal()
    Bullet:BeginContact(a, b, coll)
end

function endContact()
    persisting = 0
end

function preSolve()
    if persisting == 0 then
    elseif persisting < 20 then
    end
    persisting = persisting + 1
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end