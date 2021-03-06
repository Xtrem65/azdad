--require "resources/essentialmode/lib/MySQL"
--MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "18020603")

-- nouvelle config globale ! 
require "resources/gconfig/gconfig"

-- PARAMS
local malusfood = 10
local bonusfood = 100 -- MAX FOOD
local maluswater = 20
local bonuswater = 100 -- MAX WATER
local malusneeds = 100 -- MAX NEEDS
local bonusneeds = 10

-- GLOBAL TIMER
local globaltimer = true
local globaltime = 600000

-- INDIVIDUAL TIMERS (globaltimer = false)
local foodtimer = 90000
local watertimer = 60000
local needstimer = 120000

-- CHECK NEEDS
function checkneeds(player)
  local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = player})
  local result = MySQL:getResults(executed_query, {'food', 'water', 'needs'}, "identifier")
  return tonumber(result[1].food),tonumber(result[1].water),tonumber(result[1].needs)
end

-- UPDATE NEEDS
function updateneeds(player, calories, waterdrops, wc)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_food = food - calories
  local new_water = water - waterdrops
  local new_needs = needs + wc
  MySQL:executeQuery("UPDATE users SET `food`='@foodvalue', `water`='@watervalue', `needs`='@needsvalue' WHERE identifier = '@identifier'", {['@foodvalue'] = new_food, ['@watervalue'] = new_water, ['@needsvalue'] = new_needs, ['@identifier'] = player})
end

-- CUSTOM UPDATE NEEDS
function customupdateneeds(player, calories, waterdrops, wc)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_food = food + calories
  if(tonumber(new_food) >= tonumber(bonusfood)) then
	new_food = bonusfood
  elseif(tonumber(new_food) <= 0) then
    new_food = 0
  end
  local new_water = water + waterdrops
  if(tonumber(new_water) >= tonumber(bonuswater)) then
	new_water = bonuswater
  elseif(tonumber(new_water) <= 0) then
    new_water = 0
  end
  local new_needs = needs - wc
  if(tonumber(new_needs) >= tonumber(malusneeds)) then
	new_needs = malusneeds
  elseif(tonumber(new_needs) <= 0) then
    new_needs = 0
  end
  MySQL:executeQuery("UPDATE users SET `food`='@foodvalue', `water`='@watervalue', `needs`='@needsvalue' WHERE identifier = '@identifier'", {['@foodvalue'] = new_food, ['@watervalue'] = new_water, ['@needsvalue'] = new_needs, ['@identifier'] = player})
end
-- SET NEEDS
function setneeds(player, food, water, needs)
  MySQL:executeQuery("UPDATE users SET `food`='@foodvalue', `water`='@watervalue', `needs`='@needsvalue' WHERE identifier = '@identifier'", {['@foodvalue'] = food, ['@watervalue'] = water, ['@needsvalue'] = needs, ['@identifier'] = player})
end
-- FOOD
function addcalories(player, calories)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_food = food + calories
  if(tonumber(new_food) >= tonumber(bonusfood)) then
	new_food = bonusfood
  elseif(tonumber(new_food) <= 0) then
    new_food = 0
  end
  MySQL:executeQuery("UPDATE users SET `food`='@value' WHERE identifier = '@identifier'", {['@value'] = new_food, ['@identifier'] = player})
end

function removecalories(player, calories)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_food = food - calories
  if(tonumber(new_food) >= tonumber(bonusfood)) then
	new_food = bonusfood
  elseif(tonumber(new_food) <= 0) then
    new_food = 0
  end
  MySQL:executeQuery("UPDATE users SET `food`='@value' WHERE identifier = '@identifier'", {['@value'] = new_food, ['@identifier'] = player})
end

RegisterServerEvent('gabs:removecalories')
AddEventHandler('gabs:removecalories', function(source, calories)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      if(tonumber(food) > 1) then
        removecalories(player, calories)
        local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
        TriggerClientEvent("gabs:setfood", source, new_food)
--        TriggerClientEvent("gabs:remove_calories", source, calories)
        CancelEvent()
		if(tonumber(new_food) <= 0) then
			TriggerClientEvent('gabs:needskill', source)
			CancelEvent()
		end
      else
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Mort de faim")
        CancelEvent()
      end
  end)
end)

RegisterServerEvent('gabs:addcalories')
AddEventHandler('gabs:addcalories', function(source, calories)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      if(tonumber(food) < tonumber(bonusfood)) then
        addcalories(player, calories)
        local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
        TriggerClientEvent("gabs:setfood", source, new_food)
--        TriggerClientEvent("gabs:add_calories", source, calories)
--		TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Miam")
		TriggerClientEvent("gabs:eat", source)
        CancelEvent()
		if(tonumber(new_food) <= 0) then
			TriggerClientEvent('gabs:needskill', source)
			CancelEvent()
		end
      else
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Pas faim")
        CancelEvent()
      end
  end)
end)
-- WATER
function addwater(player, waterdrops)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_water = water + waterdrops
  if(tonumber(new_water) >= tonumber(bonuswater)) then
	new_water = bonuswater
  elseif(tonumber(new_water) <= 0) then
    new_water = 0
  end
  MySQL:executeQuery("UPDATE users SET `water`='@value' WHERE identifier = '@identifier'", {['@value'] = new_water, ['@identifier'] = player})
end

function removewater(player, waterdrops)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_water = water - waterdrops
  if(tonumber(new_water) >= tonumber(bonuswater)) then
	new_water = bonuswater
  elseif(tonumber(new_water) <= 0) then
    new_water = 0
  end
  MySQL:executeQuery("UPDATE users SET `water`='@value' WHERE identifier = '@identifier'", {['@value'] = new_water, ['@identifier'] = player})
end

RegisterServerEvent('gabs:removewater')
AddEventHandler('gabs:removewater', function(source, waterdrops)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      if(tonumber(maluswater) <= tonumber(water)) then
        removewater(player, waterdrops)
        local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
        TriggerClientEvent("gabs:setwater", source, new_water)
--        TriggerClientEvent("gabs:remove_water", source, waterdrops)
        CancelEvent()
		if(tonumber(new_water) <= 0) then
			TriggerClientEvent('gabs:needskill', source)
			CancelEvent()
		end
      else
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Mort de soif")
        CancelEvent()
      end
  end)
end)

RegisterServerEvent('gabs:addwater')
AddEventHandler('gabs:addwater', function(source, waterdrops)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      if(tonumber(water) <= tonumber(bonuswater)) then
        addwater(player, waterdrops)
        local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
        TriggerClientEvent("gabs:setwater", source, new_water)
--        TriggerClientEvent("gabs:add_water", source, waterdrops)
--		TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Vous avez bu")
		TriggerClientEvent("gabs:drink", source)
        CancelEvent()
		if(tonumber(new_water) <= 0) then
			TriggerClientEvent('gabs:needskill', source)
			CancelEvent()
		end
      else
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Vous n'avez pas soif")
        CancelEvent()
      end
  end)
end)
-- NEEDS
function addneeds(player, wc)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_needs = needs + wc
  if(tonumber(new_needs) >= tonumber(malusneeds)) then
	new_needs = malusneeds
  elseif(tonumber(new_needs) <= 0) then
    new_needs = 0
  end
  MySQL:executeQuery("UPDATE users SET `needs`='@value' WHERE identifier = '@identifier'", {['@value'] = new_needs, ['@identifier'] = player})
end

function removeneeds(player, wc)
  local food, water, needs = table.unpack{checkneeds(player)}
  local new_needs = needs - wc
  if(tonumber(new_needs) >= tonumber(malusneeds)) then
	new_needs = malusneeds
  elseif(tonumber(new_needs) <= 0) then
    new_needs = 0
  end
  MySQL:executeQuery("UPDATE users SET `needs`='@value' WHERE identifier = '@identifier'", {['@value'] = new_needs, ['@identifier'] = player})
end

RegisterServerEvent('gabs:removeneeds')
AddEventHandler('gabs:removeneeds', function(source, wc)
--AddEventHandler('gabs:removeneeds', function(wc)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      if(tonumber(needs) >= 1) then
        removeneeds(player, wc)
        local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
        TriggerClientEvent("gabs:setneeds", source, new_needs)
--        TriggerClientEvent("gabs:remove_needs", source, wc)
--		TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Pipi caca")
		TriggerClientEvent("gabs:pee", source)
        CancelEvent()
		if(tonumber(new_needs) >= tonumber(malusneeds)) then
			TriggerClientEvent('gabs:needskill', source)
			CancelEvent()
		end
      else
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Vous n'avez aucun besoin")
        CancelEvent()
      end
  end)
end)

RegisterServerEvent('gabs:addneeds')
AddEventHandler('gabs:addneeds', function(source, wc)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      if(tonumber(needs) <= tonumber(malusneeds)) then
        addneeds(player, wc)
        local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
        TriggerClientEvent("gabs:setneeds", source, new_needs)
--        TriggerClientEvent("gabs:add_needs", source, wc)
        CancelEvent()
		if(tonumber(new_needs) >= tonumber(malusneeds)) then
			TriggerClientEvent('gabs:needskill', source)
			CancelEvent()
		end
      else
--        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Mort")
		TriggerClientEvent('gabs:needskill', source)
        CancelEvent()
      end
  end)
end)

--SET DEFAULT NEEDS
RegisterServerEvent('gabs:setdefaultneeds')
AddEventHandler('gabs:setdefaultneeds', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
	local player = user.identifier
	setneeds(player, tonumber(bonusfood), tonumber(bonuswater), 0)
	TriggerClientEvent("gabs:setfood", source, tonumber(bonusfood))
	TriggerClientEvent("gabs:setwater", source, tonumber(bonuswater))
	TriggerClientEvent("gabs:setneeds", source, 0)
	CancelEvent()
  end)
end)

--ADD CUSTOM NEEDS
RegisterServerEvent('gabs:addcustomneeds')
AddEventHandler('gabs:addcustomneeds', function(source, calories, waterdrops, wc)
  TriggerEvent('es:getPlayerFromId', source, function(user)
	local player = user.identifier
	customupdateneeds(player, calories, waterdrops, wc)
	local food, water, needs = table.unpack{checkneeds(player)}
	TriggerClientEvent("gabs:setfood", source, food)
	TriggerClientEvent("gabs:setwater", source, water)
	TriggerClientEvent("gabs:setneeds", source, needs)
	CancelEvent()
  end)
end)

-- START NEEDS
AddEventHandler('es:playerLoaded', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local food, water, needs = table.unpack{checkneeds(player)}
      TriggerClientEvent("gabs:setfood", source, food)
	  TriggerClientEvent("gabs:setwater", source, water)
	  TriggerClientEvent("gabs:setneeds", source, needs)
    end)
end)

-- GLOBAL SAVE
local function saveneeds()
	if globaltimer then
		SetTimeout(globaltime, function()
			TriggerEvent("es:getPlayers", function(users)
				for k,v in pairs(users)do
					local player = v.identifier
					local food, water, needs = table.unpack{checkneeds(player)}
					if(tonumber(food) >= 1) and (tonumber(water) >= 1) and (tonumber(needs) < tonumber(malusneeds)) then
						updateneeds(player, malusfood, maluswater, bonusneeds)
						local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
						TriggerClientEvent("gabs:setfood", k, new_food)
--						TriggerClientEvent("gabs:remove_calories", k, malusfood)
						TriggerClientEvent("gabs:setwater", k, new_water)
--						TriggerClientEvent("gabs:remove_water", k, maluswater)
						TriggerClientEvent("gabs:setneeds", k, new_needs)
--						TriggerClientEvent("gabs:add_needs", k, bonusneeds)
						CancelEvent()
						if(tonumber(new_food) <= 0) or (tonumber(new_water) <= 0) or (tonumber(new_needs) >= tonumber(malusneeds)) then
							TriggerClientEvent('gabs:needskill', k)
							CancelEvent()
						end
					else
						TriggerClientEvent('gabs:needskill', k)
						CancelEvent()
					end
				end
			end)
			saveneeds()
		end)
	end
end
saveneeds()

-- INDIVIDUAL SAVES
local function foodsave()
	if (globaltimer == false) then
		SetTimeout(foodtimer, function()
			TriggerEvent("es:getPlayers", function(users)
				for k,v in pairs(users)do
					local player = v.identifier
					local food, water, needs = table.unpack{checkneeds(player)}
					if (tonumber(food) >= 1) then
						updateneeds(player, malusfood, 0, 0)
						local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
						TriggerClientEvent("gabs:setfood", k, new_food)
--						TriggerClientEvent("gabs:remove_calories", k, malusfood)
						CancelEvent()
						if (tonumber(new_food) <= 0) then
							TriggerClientEvent('gabs:needskill', k)
							CancelEvent()
						end
					else
						TriggerClientEvent('gabs:needskill', k)
						CancelEvent()
					end
				end
			end)
			foodsave()
		end)
	end
end
foodsave()

local function watersave()
	if (globaltimer == false) then
		SetTimeout(watertimer, function()
			TriggerEvent("es:getPlayers", function(users)
				for k,v in pairs(users)do
					local player = v.identifier
					local food, water, needs = table.unpack{checkneeds(player)}
					if (tonumber(water) >= 1) then
						updateneeds(player, 0, maluswater, 0)
						local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
						TriggerClientEvent("gabs:setwater", k, new_water)
--						TriggerClientEvent("gabs:remove_water", k, maluswater)
						CancelEvent()
						if (tonumber(new_water) <= 0) then
							TriggerClientEvent('gabs:needskill', k)
							CancelEvent()
						end
					else
						TriggerClientEvent('gabs:needskill', k)
						CancelEvent()
					end
				end
			end)
			watersave()
		end)
	end
end
watersave()

local function needssave()
	if (globaltimer == false) then
		SetTimeout(needstimer, function()
			TriggerEvent("es:getPlayers", function(users)
				for k,v in pairs(users)do
					local player = v.identifier
					local food, water, needs = table.unpack{checkneeds(player)}
					if (tonumber(needs) < tonumber(malusneeds)) then
						updateneeds(player, 0, 0, bonusneeds)
						local new_food, new_water, new_needs = table.unpack{checkneeds(player)}
						TriggerClientEvent("gabs:setneeds", k, new_needs)
--						TriggerClientEvent("gabs:add_needs", k, bonusneeds)
						CancelEvent()
						if (tonumber(new_needs) >= tonumber(malusneeds)) then
							TriggerClientEvent('gabs:needskill', k)
							CancelEvent()
						end
					else
						TriggerClientEvent('gabs:needskill', k)
						CancelEvent()
					end
				end
			end)
			needssave()
		end)
	end
end
needssave()
