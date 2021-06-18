Player = {}

function Player:Load()
   self.img =  love.graphics.newImage("img/player.png")
   self.w = self.img:getWidth()
   self.h = self.img:getHeight()
   self.x = Width / 2
   self.y = Height / 2
   self.r = 0
   self.ox = self.w / 2
   self.oy = self.h / 2
   self.sx = 0.1
   self.sy = 0.1
   self.Speed = 300
   self.velx = self.Speed * math.cos(math.pi / 4)
   self.vely = self.Speed * math.sin(math.pi / 4)
   self.bullets = {}
   self.cd = 0.9
   self.canFire = 0
   self.body = love.physics.newBody(World, self.x, self.y, "dynamic")
   self.shape = love.physics.newCircleShape(0.1*(self.w/2))
   self.fixture = love.physics.newFixture(self.body, self.shape, 1)
   self.fixture:setRestitution(0.9)
   self.fixture:setFriction(1)
   self.fixture:setUserData("player")
   self.numBullets = 0
   self.bulletSound = love.audio.newSource( "Audio/Laser Gun Sound Effect.mp3", "stream")
end

function Player:Update(dt)
   self.r = self.r + dt*2

   if love.keyboard.isDown("w") then
      self.body:applyForce(0, -300)
   elseif love.keyboard.isDown("a") then
      self.body:applyForce(-300, 0)
   elseif love.keyboard.isDown("s") then
      self.body:applyForce(0, 300)
   elseif love.keyboard.isDown("d") then
      self.body:applyForce(300, 0)
   end

   if self.body:getY() < 0 then
      self.body:setY(Height)
   end
   if self.body:getY() > Height then
      self.body:setY(0)
   end
   if self.body:getX() < 0 then
      self.body:setX(Width)
   end
   if self.body:getX() > Width then
      self.body:setX(0)
   end

   self.canFire = self.canFire - dt
   if love.mouse.isDown(1) and self.canFire <= 0 then
      love.audio.play(self.bulletSound)
      self:Fire()
      self.canFire = self.cd
   end
end

function Player:Draw()
   love.graphics.draw(self.img, self.body:getX(), self.body:getY(), self.r, self.sx,self.sy, self.ox, self.oy)
end

function Player:Fire()
   table.insert(Player.bullets, Bullet:Create(self.numBullets))
   self.numBullets = self.numBullets + 1
end