Asteroid = {}
Asteroid.img = love.graphics.newImage("img/Asteroid_Brown.png")
Asteroid.asteroids = {}
Asteroid.cd = 5
Asteroid.canSpawn = 0

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

    asteroid.body = love.physics.newBody(World, asteroid.x, asteroid.y, "dynamic")
    asteroid.shape = love.physics.newCircleShape(0.1*(asteroid.w/2))
    asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, 1)
    asteroid.fixture:setRestitution(0.9)
    asteroid.fixture:setFriction(1)
    return asteroid
end

function Asteroid:Update(dt)
    self.canSpawn = self.canSpawn - dt
    if self.canSpawn < 0 then
        table.insert(Asteroid.asteroids, Asteroid:Create())
    end 
end

function Asteroid:Draw()
    
end