-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------COPS MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local menupolice = {
	opened = false,
	title = "Menu police",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Animations", description = ""},
				{name = "Citoyen", description = ""},
				{name = "Vehicule", description = ""},
				{name = "Appeler renfort(prochainement)", description = ""},
				{name = "Radar (prochainement)", description = ""},
				{name = "Fermer le menu", description = ""},
			}
		},
		["Animations"] = {
			title = "ANIMATIONS",
			name = "Animations",
			buttons = {
				{name = "Faire la circulation", description = ''},
				{name = "Prendre des notes", description = ''},
				{name = "Stand By", description = ''},
				{name = "Stand By 2", description = ''},
			}
		},
		["Citoyen"] = {
			title = "CITIZEN INTERACTIONS",
			name = "Citoyen",
			buttons = {
				{name = "Identité(prochainement)", description = ''},
				{name = "Fouiller", description = ''},
				{name = "Menottage", description = ''},
				{name = "Mettre dans le véhicule", description = ''},
				{name = "Sortir du véhicule", description = ''},
				{name = "Amendes", description = ''},
			}
		},
		["Amendes"] = {
			title = "Amendes",
			name = "Amendes",
			buttons = {
				{name = "Rappel à la loi (50€)", description = ''},
				{name = "Infraction mineur (100€)", description = ''},
				{name = "Refus d'optempérer (200€)", description = ''},
				{name = "Infraction + DDF (250€)", description = ''},
				{name = "Infraction Majeur (500€)", description = ''},
				{name = "Possesion de Drogue (500€)", description = ''},
				{name = "Agression (1000€)", description = ''},
				{name = "Vol de vehicule (1500€)", description = ''},
				{name = "Braquage Superette (2500€)", description = ''},
				{name = "Braquage Banque (5000€)", description = ''},
				{name = "Meurtre (4000€)", description = ''},
				{name = "Meurtre sur agent (10000€)", description = ''},
				{name = "Deal de weed (9000€)", description = ''},
				{name = "Deal de crack (10000€)", description = ''},
				{name = "Deal de coke (11000€)", description = ''},
				{name = "Deal de Meth (12000€)", description = ''},
			}
		},
		["Vehicule"] = {
			title = "VEHICULE INTERACTIONS",
			name = "Vehicule",
			buttons = {
				{name = "Vérifier la plaque", description = ''},
				{name = "Crochet", description = ''},
			}
		},
	}
}
-------------------------------------------------
----------------CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedPolice(button)
	local ped = GetPlayerPed(-1)
	local this = menupolice.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Animations" then
			OpenMenuPolice('Animations')
		elseif btn == "Citoyen" then
			OpenMenuPolice('Citoyen')
		elseif btn == "Vehicule" then
			OpenMenuPolice('Vehicule')
		elseif btn == "Fermer le menu" then
			CloseMenuPolice()
		end
	elseif this == "Animations" then
		if btn == "Faire la circulation" then
			Circulation()
		elseif btn == "Prendre des notes" then
			Note()
		elseif btn == "Stand By" then
			StandBy()
		elseif btn == "Stand By 2" then
			StandBy2()
		end
	elseif this == "Citoyen" then
		if btn == "Amendes" then
			OpenMenuPolice('Amendes')
		elseif btn == "Fouiller" then
			Check()
		elseif btn == "Menottage" then
			Cuffed()
		elseif btn == "Mettre dans le véhicule" then
			PutInVehicle()
		elseif btn == "Sortir du véhicule" then
			UnseatVehicle()
		end
	elseif this == "Vehicule" then
		if btn == "Crochet"then
			Crocheter()
		elseif btn == "Vérifier la plaque" then
			CheckPlate()
		end
	elseif this == "Amendes" then
		if btn == "Rappel à la loi (50€)"then
			Fines(50)
		elseif btn == "Infraction mineur (100€)"then
			Fines(100)
		elseif btn == "Refus d'optempérer (200€)"then
			Fines(200)
		elseif btn == "Infraction + DDF (250€)"then
			Fines(250)
		elseif btn == "Infraction Majeur (500€)"then
			Fines(500)
		elseif btn == "Possesion de Drogue (500€)" then
			Fines(500)
		elseif btn == "Agression (1000€)" then
			Fines(1000)
		elseif btn == "Vol de vehicule (1500€)" then
			Fines(1500)
		elseif btn == "Braquage Superette (2500€)" then
			Fines(2500)
		elseif btn == "Braquage Banque (5000€)" then
			Fines(5000)
		elseif btn == "Meurtre (4000€)" then
			Fines(4000)
		elseif btn == "Meurtre sur agent (10000€)" then
			Fines(10000)
		elseif btn == "Deal de weed (9000€)" then
			Fines(9000)
		elseif btn == "Deal de crack (10000€)" then
			Fines(10000)
		elseif btn == "Deal de coke (11000€)" then
			Fines(11000)
		elseif btn == "Deal de Meth (12000€)" then
			Fines(12000)
		end
	end
end
-------------------------------------------------
----------------FONCTION ANIMATIONS---------------
-------------------------------------------------
function Circulation()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu fais la circulation.")
end

function Note()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end) 
	drawNotification("~g~Tu prends taking notes.")
end

function StandBy()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu es en Stand By.")
end

function StandBy2()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GUARD_STAND", 0, 1)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu es en Stand By.")
end

-------------------------------------------------
------------FONCTION INTERACTION Citizen---------
-------------------------------------------------
function Check()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "Il n'y a Personne pres de vous !")
	end
end

function Cuffed()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "Il n'y a Personne pres de vous (Approchez-vous) !")
	end
end

function PutInVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Il n'y a Personne pres de vous (Approchez-vous) !")
	end
end

function UnseatVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Il n'y a Personne pres de vous (Approchez-vous) !")
	end
end

function Fines(amount)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Il n'y a Personne pres de vous (Approchez-vous) !")
	end
end

-------------------------------------------------
------------FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function Crocheter()
	Citizen.CreateThread(function()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	--GetClosestVehicle(x,y,z,distance dectection, 0 = tous les vehicules, Flag 70 = tous les veicules sauf police a tester https://pastebin.com/kghNFkRi)
	veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
	Citizen.Wait(20000)
    SetVehicleDoorsLocked(veh, 1)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	drawNotification("Le vehicule est maintenant ~g~ouvert~w~.")
	end)
end

function CheckPlate()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "pas de vehicule pres de vous (Approchez-vous) !")
	end
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuPolice(menu)
	menupolice.lastmenu = menupolice.currentmenu
	if menu == "Animations" then
		menupolice.lastmenu = "main"
	elseif menu == "Citoyen" then
		menupolice.lastmenu = "main"
	elseif menu == "Vehicule" then
		menupolice.lastmenu = "main"
	elseif menu == "Amendes" then
		menupolice.lastmenu = "main"
	end
	menupolice.menu.from = 1
	menupolice.menu.to = 10
	menupolice.selectedbutton = 0
	menupolice.currentmenu = menu
end
-------------------------------------------------
------------------DRAW NOTIFY--------------------
-------------------------------------------------
function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
--------------------------------------
-------------DISPLAY HELP TEXT--------
--------------------------------------
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
-------------------------------------------------
------------------DRAW TITLE MENU----------------
-------------------------------------------------
function drawMenuTitle(txt,x,y)
local menu = menupolice.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
------------------DRAW MENU BOUTON---------------
-------------------------------------------------
function drawMenuButton(button,x,y,selected)
	local menu = menupolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
------------------DRAW MENU INFO-----------------
-------------------------------------------------
function drawMenuInfo(text)
	local menu = menupolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end
-------------------------------------------------
----------------DRAW MENU DROIT------------------
-------------------------------------------------
function drawMenuRight(txt,x,y,selected)
	local menu = menupolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
-------------------DRAW TEXT---------------------
-------------------------------------------------
function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end
-------------------------------------------------
----------------CONFIG BACK MENU-----------------
-------------------------------------------------
function BackMenuPolice()
	if backlock then
		return
	end
	backlock = true
	if menupolice.currentmenu == "main" then
		CloseMenuPolice()
	elseif menupolice.currentmenu == "Animations" or menupolice.currentmenu == "Citoyen" or menupolice.currentmenu == "Vehicule" or menupolice.currentmenu == "Amendes" then
		OpenMenuPolice(menupolice.lastmenu)
	else
		OpenMenuPolice(menupolice.lastmenu)
	end
end
-------------------------------------------------
---------------------FONCTION--------------------
-------------------------------------------------
function f(n)
return n + 0.0001
end

function LocalPed()
return GetPlayerPed(-1)
end

function try(f, catch_f)
local status, exception = pcall(f)
if not status then
catch_f(exception)
end
end
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
-------------------------------------------------
----------------FONCTION OPEN--------------------
-------------------------------------------------
function OpenPoliceMenu()
	menupolice.currentmenu = "main"
	menupolice.opened = true
	menupolice.selectedbutton = 0
end
-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuPolice()
		menupolice.opened = false
		menupolice.menu.from = 1
		menupolice.menu.to = 10
end
-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,166) and menupolice.opened == true then
				CloseMenuPolice()
		end
		if menupolice.opened then
			local ped = LocalPed()
			local menu = menupolice.menu[menupolice.currentmenu]
			drawTxt(menupolice.title,1,1,menupolice.menu.x,menupolice.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, menupolice.menu.x,menupolice.menu.y + 0.08)
			drawTxt(menupolice.selectedbutton.."/"..tablelength(menu.buttons),0,0,menupolice.menu.x + menupolice.menu.width/2 - 0.0385,menupolice.menu.y + 0.067,0.4, 255,255,255,255)
			local y = menupolice.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= menupolice.menu.from and i <= menupolice.menu.to then

					if i == menupolice.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,menupolice.menu.x,y,selected)
					if button.distance ~= nil then
						drawMenuRight(button.distance.."m",menupolice.menu.x,y,selected)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedPolice(button)
					end
				end
			end
		end
		if menupolice.opened then
			if IsControlJustPressed(1,202) then
				BackMenuPolice()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if menupolice.selectedbutton > 1 then
					menupolice.selectedbutton = menupolice.selectedbutton -1
					if buttoncount > 10 and menupolice.selectedbutton < menupolice.menu.from then
						menupolice.menu.from = menupolice.menu.from -1
						menupolice.menu.to = menupolice.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if menupolice.selectedbutton < buttoncount then
					menupolice.selectedbutton = menupolice.selectedbutton +1
					if buttoncount > 10 and menupolice.selectedbutton > menupolice.menu.to then
						menupolice.menu.to = menupolice.menu.to + 1
						menupolice.menu.from = menupolice.menu.from + 1
					end
				end
			end
		end

	end
end)