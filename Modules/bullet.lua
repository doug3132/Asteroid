Bullet = {
    img = love.graphics.newImage("img/bullet.png")
}

function Bullet:Create(num)
    local bullet = {}
        bullet.w = Bullet.img:getWidth()
        bullet.h = Bullet.img:getHeight()
        if Player.body:getX() > love.mouse.getX() then
            bullet.x = Player.body:getX() - (0.1*Player.w)
        else
            bullet.x = Player.body:getX()
        end
        bullet.y = Player.body:getY()
        bullet.r = 0
        bullet.ox = bullet.w / 2
        bullet.oy = bullet.h / 2
        bullet.sx = 0.5
        bullet.sy = 0.5
        bullet.Speed = 19000
        bullet.life = 3
        bullet.body = love.physics.newBody(World, bullet.x, bullet.y, "dynamic")
        bullet.shape = love.physics.newCircleShape(0.5*(bullet.w/2))
        bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape, 1)
        bullet.fixture:setRestitution(0.9)
        bullet.fixture:setFriction(1)
        bullet.fixture:setUserData("bullet"..num)
        bullet.dir = { x = love.mouse.getX() - bullet.x, y = love.mouse.getY() - bullet.y}
        local normal = (bullet.dir.x ^ 2 + bullet.dir.y^2) ^ 0.5
        bullet.dir.x = bullet.dir.x / normal
        bullet.dir.y = bullet.dir.y / normal
    return bullet
end

function Bullet:Update(dt)
    for i, b in ipairs(Player.bullets) do
        b.body:setLinearVelocity(b.Speed * b.dir.x * dt, b.Speed * b.dir.y * dt)
        b.life = b.life - dt
        if b.life <= 0  then
            table.remove(Player.bullets, i)
        end
    end
end

function Bullet:Draw()
    for i, b in ipairs(Player.bullets) do
        love.graphics.draw(Bullet.img, b.body:getX(), b.body:getY(), b.r, b.sx,b.sy, b.ox, b.oy)
    end
end

function Bullet:BeginContact(a, b, coll)
    if string.match(b:getUserData(), "bullet") and a:getUserData() ~= "player" then
        for i, bu in ipairs(Player.bullets) do
            if bu.fixture:getUserData() == b:getUserData() then
                table.remove(Player.bullets, i)
            end
        end
    end
end