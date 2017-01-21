NPC = {
	imgfile = "";
	img1 = "";
	img2 = "";
	img = nil;
	interacting = false;
	x = 0;
	y = 0;
	label = "";
	fake_label = nil;
	profile = "";
	isMan = true;
	area = nil;
	timeWaitAnimation = 10;
	lastAnimation = love.timer.getTime();
	
}

function NPC:new (o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

-- Create an Image object for the NPC
function NPC:setImage()
	self.img = love.graphics.newImage(self.imgfile)
end

-- Create an area for the NPC
function NPC:setArea()
	self.area = Area:new{
		height = self.img:getHeight();
		width = self.img:getWidth();
		x = self.x;
		y = self.y;
	}
end

function NPC:getCompletion()
	if not self.quest then 
		return 1
	end
	local nbrQuest = 0
	local nbrCompleted = 0
	for _,quest in ipairs(self.quest) do
		if quest.resolved then
			nbrCompleted = nbrCompleted + 1
		end
		nbrQuest = nbrQuest + 1
	end
	if nbrQuest == 0 then return 1 end -- Inutile
	return nbrCompleted/nbrQuest
end

function NPC:getPatience()
	if self.profile == NPC_PROFILE_SHY then 
		return math.random(0, 25)/100
	elseif self.profile == NPC_PROFILE_CHARMER then
		return math.random(25, 50)/100
	elseif self.profile == NPC_PROFILE_ARROGANT then
		return math.random(50, 75)/100
	else
		return math.random(75, 100)/100
	end
end


function NPC.updateAnimation()
	for index, npc in ipairs(NPC_group) do

		npc.timeWaitAnimation = 1 - FL_animNPC_group[index]:makeDecision(_, _)
		local time = love.timer.getTime()
		local diff = time - npc.lastAnimation
		-- print(diff)

		if diff > npc.timeWaitAnimation then 
			-- Changer d'image
			if (npc.imgfile == npc.img1) then
				npc.imgfile = npc.img2
			else
				npc.imgfile = npc.img1
			end
			npc.img = love.graphics.newImage(npc.imgfile)
			npc.lastAnimation = time
		end
	
	end

end

-- Permet de positionner les NPC sur la carte sans collision avec les autres éléments déjà placés
function NPC.randomePositionNew()
	for i,npc in ipairs(NPC_group) do
		local areaLetter = Object_group[1]
		npc.x = math.random(0, ROOM_INNER_WIDTH-npc.area.width)
		npc.y = math.random(0, ROOM_INNER_HEIGHT-npc.area.height)
		npc.area.x = npc.x
		npc.area.y = npc.y

		while npc.area:IsAreaTouched(areaLetter.img:getHeight(), areaLetter.img:getWidth(), areaLetter.x, areaLetter.y) or NPC.collides(npc, i) do
			npc.x = math.random(0, ROOM_INNER_WIDTH-npc.area.width)
			npc.y = math.random(0, ROOM_INNER_HEIGHT-npc.area.height)
			npc.area.x = npc.x
			npc.area.y = npc.y

		end	

	end

end

-- Vérifie si le NPC npc entre en collision avec le npc à l'index i
function NPC.collides(npc, i)
	local compteur = 1
	while compteur ~= i do
		local othernpc = NPC_group[compteur]
		if npc.area:IsAreaTouched(othernpc.img:getHeight(), othernpc.img:getWidth(), othernpc.x, othernpc.y) then
			return true
		end
		compteur = compteur + 1
	end
	if npc.area:IsAreaTouched(Gus.img:getHeight(), Gus.img:getWidth(), Gus.x, Gus.y) then
			return true
		end
	return false
end	

-- Is the NPC willing to give personal information, such as its name?
-- Out: bool
-- Selon le nombre d'insistance, on va savoir si le NPC donne son nom ou pas
function NPC:isWillingToProvidePersonalData(nbr_insiste)
	if(nbr_insiste == 0) then
	-- Shy, arrogant et agressive ne donne pas leur nom tout de suite
		if self.profile == NPC_PROFILE_SHY or self.profile == NPC_PROFILE_ARROGANT or self.profile == NPC_PROFILE_AGGRESSIVE then
			return false
		else
			return true
		end
	elseif (nbr_insiste == 1) then
		-- shy donne son nom
		if(self.profile == NPC_PROFILE_SHY) or (self.profile == NPC_PROFILE_ARROGANT) or (self.profile == NPC_PROFILE_AGGRESSIVE) then
			return true
		else
			return false
		end
	else
		-- Pour l'instant, l'arrogant et l'agressif ne donne jamais leur nom
		return false
	end
end

-- Retourne le nom supposé du pnj 
function NPC:getLabel() 
	if self.fake_label then
		return self.fake_label
	end
	
	return self.label
end


-- This function is not part of the class NPC. It's simply used
-- during the load process to create the NPC instances according to their names.
function createNPC(name)
	local index = nil
	for i, v in ipairs(NPC_NAMES) do
		if v == name then index = i; break;	end
	end
	if index then
		v = NPC_LIST[index]
		o = NPC:new{
			imgfile = "assets//img//"..v.imgfile;
			img1 = "assets//img//"..v.img1;
			img2 = "assets//img//"..v.img2;
			x = v.x;
			y = v.y;
			label = name;
			profile = v.profile;
			fake_label = v.fake_label;
		}
	else
		print (string.format("Error, PNJ called %s does not exist in the database.", name))
		return
	end
	if not o then print (string.format("Error in the creation of the NPC %s", name)) end
	return o
end