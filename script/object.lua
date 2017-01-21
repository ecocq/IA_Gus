Object = {
	imgfile = "";
	img = nil;
	interacting = false;
	grabbed = false;
	x = 0;
	y = 0;
	label = "";
	area = nil;
}

function Object:new (o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

-- Create an Image object for the Object
function Object:setImage()
	self.img = love.graphics.newImage(self.imgfile)
end

-- Create an area for the Object
function Object:setArea()
	self.area = Area:new{
		height = self.img:getHeight();
		width = self.img:getWidth();
		x = self.x;
		y = self.y;
	}
end

-- This function is not part of the class NPC. It's simply used
-- during the load process to create the NPC instances according to their names.
function createObject(name)
	local index = nil
	for i, v in ipairs(OBJECT_NAMES) do
		if v == name then index = i; break;	end
	end
	if index then
		v = OBJECT_LIST[index]
		o = Object:new{
			imgfile = "assets//img//"..v.imgfile;
			x = v.x;
			y = v.y;
			label = name;
		}
	else
		print (string.format("Error, Object called %s does not exist in the database.", name))
		return
	end
	if not o then print (string.format("Error in the creation of the Object %s", name)) end
	return o
end