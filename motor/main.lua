--camera
width = love.graphics.getWidth()
height = love.graphics.getHeight()
camera = {}
camera._x = 0
camera._y = 0

function camera:set()
  love.graphics.push()
  love.graphics.translate(-self._x, -self._y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self._x = self._x + (dx or 0)
  self._y = self._y + (dy or 0)
end


function camera:setX(value)
  if self._bounds then
    self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self._x = value
  end
end

function camera:setY(value)
  if self._bounds then
    self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self._y = value
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end

end

function camera:getBounds()
  return unpack(self._bounds)
end

function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end
 
function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

map = {
{
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1}
},
{
{0,0,0,0,0,0,0},
{0,0,0,2,2,2,0},
{0,0,0,2,2,2,0},
{0,0,0,2,0,2,0},
{0,0,0,0,0,0,0},
{1,1,1,1,1,1,1},
{1,1,1,1,1,1,1}
},
{
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{1,0,0,0,0,0,0},
},
{
{0,0,0,0,0,0,1},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{0,0,0,0,0,0,0},
{1,0,0,0,0,0,0},
}
}


function boundcamera()

	local div =32
	local x = #map[1][1]*div-width+div*2
	if x < 0 then x = 0 end
	local y = #map[1]*div-height+div*2
	if y < 0 then y = 0 end
	camera:setBounds(-div*2, -div*2, x, y)
end
boundcamera()

function love.update(dt)
	if love.keyboard.isDown('left') then
		angle = angle-0.01
	end
	if love.keyboard.isDown('right') then
		angle = angle+0.01
	end
end


function love.load()

grnd = love.graphics.newImage('img/grnd.png')--
--grnd = make3d('img/grnd.png')--love.graphics.newImage('img/grnd.png')
grass =love.graphics.newImage('img/grass.png') -- 
--grass =make3d('img/grass.png')--
--tile:setFilter('nearest','nearest')
--wall:setFilter('nearest','nearest')
angle = -math.pi/2
acc = 0
love.graphics.setBackgroundColor(100,100,255)
imglst = {grnd,grass}


tX=32
tY=32
end


function love.draw()
	local width, height = love.graphics.getDimensions()

	local centerX =  width/2
	local centerY = height/2
	sin = math.sin(angle)
	cos = math.cos(angle)
	tZ=-16--*(sin+cos)

	camera:set()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.push()
	love.graphics.scale(1,0.3)
	love.graphics.translate(centerX,centerY)
	love.graphics.rotate(angle)
	love.graphics.translate(-centerX,-centerY)
	local cx =centerX/2+tX
	local cy= centerY/2+tY
		
			
	zi=1
	for z=1,4,1 do			

		yi=5
		for y=1,7,1 do

			xi = 7
			for x = 1,7,1 do
	
				if map[z][y][x] > 0 then
			
					love.graphics.draw( imglst[map[z][y][x]], cx+xi*tX+zi*tZ*sin, cy+yi*tY+zi*tZ*cos, 0, 1, 1, 0, 0, 0, 0)

				end
				
--[[					if angle >= math.pi/2 and angle <= 3*math.pi/2 then
						love.graphics.draw(grass,400*(sin+cos) ,500+0.5*(sin-cos) ,0, 1, 1, 0, 0, 0, 0)
					end

					if angle >= 0 and angle <= math.pi then
						love.graphics.draw(grass,400*(sin+cos) ,500+0.5*(sin-cos) ,0, 1, 1, 0, 0, 0, 0)
					end

					if angle <= math.pi/2 or angle >= 3*math.pi/2 then
						love.graphics.draw(grass,400*(sin+cos) ,500-0.5*(sin-cos) ,0, 1, 1, 0, 0, 0, 0)
					end

					if angle >= math.pi then
						love.graphics.draw(grass,400*(sin+cos) ,500-0.5*(sin-cos) ,0, 1, 1, 0, 0, 0, 0)
					end]]--
			xi=xi-1 				

			end


			yi=yi-1
		end
		zi=zi+1			

	end
	
	camera:unset()
	love.graphics.pop()
end

function love.keypressed(key)   
	if key == "escape" then
		love.event.push("quit")   
	end
	if key == "space" then
		acc = 0
	end
end


function make3d(file)
	local imageData = love.image.newImageData( file )
	local newimagedata = love.image.newImageData(imageData:getWidth()*3/2,  imageData:getHeight()*3/2)
	--topo
	for i=imageData:getWidth()-1,0,-1 do
		for j=imageData:getHeight()-1,0,-1 do
			local r,g,b,a = imageData:getPixel(i,j)
			if i+j/2 < newimagedata:getWidth() then
				newimagedata:setPixel(math.floor(i+j/2),math.floor(j/2),r/2,g/2,b/2,a)
			end
		end
	end
	for i=imageData:getWidth()-1,0,-1 do
		for j=imageData:getHeight()-1,0,-1 do
			local r,g,b,a = imageData:getPixel(j,i)
			if i/2+2 < newimagedata:getWidth() then
				newimagedata:setPixel(math.floor(j/2),math.floor(j/2+i),r*0.75,g*0.75,b*0.75,a)
			end
		end
	end
	for i=imageData:getWidth()-1,0,-1 do
		for j=imageData:getHeight()-1,0,-1 do
			local r,g,b,a = imageData:getPixel(i,j)
			newimagedata:setPixel(i-(2)+imageData:getWidth()/2,j+imageData:getHeight()/2,r,g,b,a)
		end
	end
	return love.graphics.newImage(newimagedata)
end