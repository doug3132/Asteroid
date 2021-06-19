Asteroid = {
    img = love.graphics.newImage("img/Asteroid_Brown.png"),
    asteroids = {},
    cd = 2,
    canSpawn = 1,
    asteroidNum = 0
}

function Asteroid:Create(num)
    local rand = math.random(100)
    local asteroid = {
        w = Asteroid.img:getWidth(),
        h = Asteroid.img:getHeight(),
        sx = 0.5,
        sy = 0.5,
        Speed = 1700,
        ox = Asteroid.img:getWidth()/ 2,
        oy = Asteroid.img:getWidth() / 2,
        life = 50,
        health = 2
    }

    if rand < 20 then
        asteroid.x = 0
        asteroid.y = math.random(Height)
    elseif rand > 20 and rand < 50 then
        asteroid.x = Width
        asteroid.y = math.random(Height)
        
    elseif rand > 50 and rand < 75 then
        asteroid.x = math.random(Width)
        asteroid.y = 0
        asteroid.dir = { x =asteroid.x, y =asteroid.y}
    else
        asteroid.x = math.random(Width)
        asteroid.y = Height
    end
    asteroid.body = love.physics.newBody(World, asteroid.x, asteroid.y, "dynamic")
    asteroid.shape = love.physics.newCircleShape(0.5*(asteroid.w/2))
    asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, 1)
    asteroid.fixture:setRestitution(0.9)
    asteroid.fixture:setFriction(1)
    asteroid.fixture:setUserData("asteroid"..num)
    asteroid.dir = { x = love.mouse.getX() -asteroid.x, y = love.mouse.getY()-asteroid.y}
    local normal = (asteroid.dir.x ^ 2 + asteroid.dir.y^2) ^ 0.5
    asteroid.dir.x = asteroid.dir.x / normal
    asteroid.dir.y = asteroid.dir.y / normal
    return asteroid
end

function Asteroid:Update(dt)
    self.canSpawn = self.canSpawn - dt
    if self.canSpawn <= 0 then
        table.insert(self.asteroids, self:Create(self.asteroidNum))
        self.canSpawn = self.cd
        self.asteroidNum = self.asteroidNum + 1
    end 
    for i, b in ipairs(Asteroid.asteroids) do
        b.body:setLinearVelocity(b.Speed * b.dir.x * dt, b.Speed * b.dir.y * dt)
        b.life = b.life - dt
        if b.life <= 0  then
            table.remove(Asteroid.asteroids, i)
        end
    end
end

function Asteroid:Draw()
    for i, b in ipairs(self.asteroids) do
        love.graphics.draw(self.img, b.body:getX(), b.body:getY(), b.r, b.sx,b.sy, b.ox, b.oy)
    end
end

function Asteroid:BeginContact(a, b, coll)
    if string.match(a:getUserData(), "asteroid") then
        for i, as in ipairs(Asteroid.asteroids) do
            if as.fixture:getUserData() == a:getUserData() then
                if as.health <= 0 then
                    table.remove(Asteroid.asteroids, i)
                    Destroy_queue[a] = true
                else
                    as.health = as.health -1
                end
            end
        end
    elseif string.match(b:getUserData(), "asteroid") and string.match(a:getUserData(), "asteroid") and a:getUserData() ~= "player" then
        for i, as in ipairs(Asteroid.asteroids) do
            if as.fixture:getUserData() == b:getUserData() then
                table.remove(Asteroid.asteroids, i)
                Destroy_queue[b] = true
            end
        end
    end
end