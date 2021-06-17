Asteroid = {}
Asteroid.img = love.graphics.newImage("img/Asteroid Brown.png")
Asteroid.asteroids = {}
function Asteroid:Create()
    local rand = math.random(100)
    local asteroid = {}
        asteroid.w = Asteroid.img:getWidth()
        asteroid.h = Asteroid.img:getHeight()
        if rand < 20 then
            asteroid.x = 0
            asteroid.y = math.random(Height)
        elseif rand > 20 and rand < 50 then
            asteroid.x = Width
            asteroid.y = math.random(Height)
        elseif rand > 50 and rand < 75 then
            asteroid.x = math.random(Width)
            asteroid.y = 0
        else
            asteroid.x = math.random(Width)
            asteroid.y = Height
        end
end
