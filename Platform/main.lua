function love.load()
	love.physics.setMeter (64)
	world = love.physics.newWorld(0,9.81 * 64, true)

	objects = {}
	objects.floor = {}
	objects.floor.body  = love.physics.newBody(world, 900/2,650 -50 /2)
	objects.floor.shape = love.physics.newRectangleShape(900,50)
	objects.floor.fixture = love.physics.newFixture(objects.floor.body, objects.floor.shape)
	
	objects.wall = {}
	objects.wall.body  = love.physics.newBody(world, 900 - 50/2,650/2)
	objects.wall.shape = love.physics.newRectangleShape(50,650)
	objects.wall.fixture = love.physics.newFixture(objects.wall.body, objects.wall.shape)
	
	objects.ball = {}
	objects.ball.body  = love.physics.newBody(world, 650/2,650/2, "dynamic")
	objects.ball.body:setFixedRotation(true)
	objects.ball.shape = love.physics.newRectangleShape(20, 20)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape,1)
	objects.ball.fixture:setFriction(0)
	
	objects.block1 = {}
	objects.block1.body  = love.physics.newBody(world, 200,550, "dynamic")
	objects.block1.shape = love.physics.newRectangleShape(0,0,50,100)
	objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5)
	
	objects.block2 = {}
	objects.block2.body  = love.physics.newBody(world, 200,400, "dynamic")
	objects.block2.shape = love.physics.newRectangleShape(0,0,100,50)
	objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 2)

	love.graphics.setBackgroundColor(104/255,136/255,248/255)
	love.window.setMode(900,650)
end

local force = 0
local isMoving = false

function inGround(yVelocity)
	return math.abs(yVelocity) <= 0.01
end

function love.update (dt)
	world:update(dt)
	local xVelocity, yVelocity = objects.ball.body:getLinearVelocity();

	if love.keyboard.isDown("right") then
    isMoving = true
		force = 400
		objects.ball.body:applyForce(force,0)

	elseif love.keyboard.isDown("left") then
    isMoving = true
		force = -400
		objects.ball.body:applyForce(force,0)
	else
    isMoving = false
    force = 0
  end

  if isMoving or inGround(yVelocity) then
    local resistency = xVelocity
    objects.ball.body:applyForce(-resistency, 0)
  else 
    local resistency = xVelocity / 5
    objects.ball.body:applyForce(-resistency, 0)
  end

	if love.keyboard.isDown("up") and inGround(yVelocity) then
		objects.ball.body:setLinearVelocity(xVelocity,-400)
	end

	if love.keyboard.isDown("return") then
		objects.ball.body:setPosition(650/2,650/2)
		objects.ball.body:setLinearVelocity(0,0)
	end
end

function love.draw()
	love.graphics.setColor(72/255,160/255,14/255)
	love.graphics.polygon("fill", objects.floor.body:getWorldPoints(objects.floor.shape:getPoints()))
	love.graphics.polygon("fill", objects.wall.body:getWorldPoints(objects.wall.shape:getPoints()))

	love.graphics.setColor(193/255,47/255,14/255)
	love.graphics.polygon("fill", objects.ball.body:getWorldPoints(objects.ball.shape:getPoints()))
	
	love.graphics.setColor(50/255,50/255,50/255)
	love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
	love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
end
