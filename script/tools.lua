-----------------------------------
-- TOOLS
-- Several common useful functions
-- Edit at your will!
----------------------------------

-- Safely opens a file
-- In: filename (str), opening mode (str)
-- Out: handle or nil
function safeopen(filename, mode)
	if DEBUG_MODE then print (filename, mode) end
	if pcall(io.open(filename, mode)) then
		return (io.open(filename, mode))
	end
	print ("Couldn't open file named "..tostring(filename))
	return nil
end

-- Checks whether the table is a hash (list of pairs key->value) or a table indexed with integers
-- In: table
-- Out: true if it's a hash, false otherwise
function isAssociativeArray(t)
	local i = 0
	for _ in pairs(t) do
		i = i + 1
		if t[i] == nil then return false end
	end
	return true
end

-- Prints correctly the data contained in a variable, whatever its type
-- In: any printable variable
-- Out: no return value. Prints the variable content (or variable type if the type isn't listed)
function tprint (item)
	if type(item) == "string" or type(item) == "number" or type(item) == "boolean" or type(item) == "nil" then
		print (item)
	elseif type(item) == "table" then
		if isAssociativeArray(item) then
			for i, v in ipairs(item) do
				print (i, v)
			end
		else
			for i, v in pairs(item) do
				print (i, v)
			end
		end
	else
		print (item, ": type is "..type(item))
	end
end

-- Printing for debugging mode
-- In: any printable item
-- Out: no return value. Only a print.
function dprint (s)
	if DEBUG_MODE then tprint (s) end
end

-- Constrain a value between a min and a max
-- In: (numbers) value to constrain, minimum value, maximum value
-- Out: value constrained between min and max
function keepBetweenMinMax(x, mini, maxi)
	if x<mini then
		return mini
	elseif x >maxi then
		return maxi
	else
		return x
	end
end

-- Round to x decimals
-- Int: number[, number of decimals]
-- Out: rounded number
function round(num, nb_decimals)
	local mult = 10^(nb_decimals or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Checks whether a table contains an element or not
-- In: table, element to look for
-- Out: true if table contains this element, false otherwise
function table.contains(t, item)
	for _, v in pairs(t) do
		if v == item then
			return true
		end
	end
	return false
end

-- Get a normalized value
-- In: original value (number), minimum of the origin interval, maximum of the origin interval, minimum of the target interval, maximum of the target interval
-- Out: normalized value (number)
function norm(origin_val, origin_min, origin_max, target_min, target_max)
	norm_value = (origin_val - origin_min) * (target_max - target_min) / (origin_max - origin_min) + target_min 
	return norm_value
end

-- Iterator through ordered keys
-- (http://www.lua.org/pil/19.3.html)
function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

-- Splits a string into an array
-- In: sentence to split (string)
-- Out: array containing each string
function split(s)
	local l = {}
	--for i in string.gmatch(s, "%S+") do
	for i in string.gmatch(s, "[^ ]+") do
		table.insert(l, i)
	end
	return l
end

-- Parse une phrase et renvoie un tableau des mots prononcés
-- On ne reutilise pas split car elle n'est pas assez complete
-- Pour ce dont on a besoin
function parseSentence(message)
	local indice = 1 -- indice dans le mot special en cours, 1 si aucun mot special
	local tab = {}
	local specialWord = nil
	for i in string.gmatch(message, "([aA-zZÀÂÄÇÉÈÊËÎÏÔÖÙÛÜŸÆŒàâäçéèêëîïôöùûüÿæœ]+)") do -- séparé en mot, sans ponctuation
		i = string.lower(i)
		if not specialWord then --on verifie si on a un mot special
			specialWord = matchWithSpecialLex(indice, i) 
		else
			-- on est deja en train de regarder un mot special, on verifie si on a la suite
			-- print ("compare ", specialWord[indice], " avec ", i)
			if(specialWord[indice] ~= i) then --on est finalement pas en présence d'un mot special
				for j =1,indice-1 do --on va ajouter tout ce qu'on pensait special avant
					table.insert(tab, specialWord[j])
				end
				specialWord = nil
				indice = 1
			end
		end
		if(specialWord) then -- si c'est un mot special, on regarde si on est arrivé au bout
			indice = indice +1
			-- on cherche la taille de la liste
			local taille = 0
			for index, v in pairs(specialWord) do 
				taille = taille +1 
			end
			if(indice==taille) then -- on a atteint la fin du mot special
				table.insert(tab, specialWord[taille])
				specialWord = nil
				indice = 1
			end				
		else
			table.insert(tab, i) --on ajoute le mot
		end
	end
	return tab
end

-- Récupère la ponctuation des messages
function parsePonctuation(message)
	local tab = {}
	for i in string.gmatch(message, "([?,.;:!*]+)") do -- séparé en mot, sans ponctuation
		i = string.lower(i)
		table.insert(tab, i) --on ajoute le mot
	end
	return tab
end


-- Contient un des elements du lexique special
-- i est l'indice de la chaine a verifier: 1 pour la 1ere, 2 pour la 2e etc
-- renvoie la liste du mot special
function matchWithSpecialLex(i, item)
	for _, v in pairs(LEX_SPECIAL_WORDS) do
		if v[i] == item then
			return v
		end
	end
	return nil
end
