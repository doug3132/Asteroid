require("Modules.Player")
require("Modules.bullet")
require("Modules.asteroids")

Width = love.graphics.getWidth()
Height = love.graphics.getHeight()
Destroy_queue = {}
Timer = 0
Live = true

function love.load()
    love.physics.setMeter(64)
    World = love.physics.newWorld(0.1*64, 0.1*64, true)
    World:setCallbacks(beginContact, endContact, preSolve)
    love.graphics.setBackgroundColor(100/255,100/255,130/255)

    Player:Load()

    static = {
        b = love.physics.newBody(World, 400,400, "static"),
        s = love.physics.newRectangleShape(200,50),
    }
    static.f = love.physics.newFixture(static.b, static.s) :setUserData("Block")

    persisting = 0
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
end

function love.update(dt)
    if Live then
        Timer = Timer + dt
        Asteroid:Update(dt)
        Player:Update(dt)
        Bullet:Update(dt)
        if table.getn(Destroy_queue) > 0 then
            for b in pairs(Destroy_queue) do
                World:DestroyBody(b)
                Destroy_queue[b] = nil
            end
        end
        World:update(dt)
    end
end

function love.draw()
    if Live then
        Asteroid:Draw()
        Bullet:Draw()
        Player:Draw()
        love.graphics.polygon("line", static.b:getWorldPoints(static.s:getPoints()))
        love.graphics.print("Bullets: "..#Player.bullets)
        love.graphics.print("Score: "..math.floor(Timer), 0, 15)
    else
        alignCenter = (Width/2)-70
        love.graphics.print("Game Over", alignCenter, (Height/2)-100, 0, 1.5, 1.5)
        love.graphics.print("Final Score: "..math.floor(Timer), alignCenter, (Height/2)-50)
        love.graphics.print("'ESC' to quit", alignCenter, (Height/2)-30, 0, 0.8)
        love.graphics.print("or 'R' to play again", alignCenter, (Height/2)-15, 0, 0.8)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "r" then
        love.event.quit("restart")
    end
end

function beginContact(a, b, coll)
    x,y = coll:getNormal()
    Bullet:BeginContact(a, b, coll)
    Asteroid:BeginContact(a, b, coll)
    Player:BeginContact(a, b, coll)
end

function endContact()
    persisting = 0
end

function preSolve()
    persisting = persisting + 1
end