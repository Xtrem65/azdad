

--
-- THIS IS AN EXAMPLE FILE. CHANGES HERE WON'T AFFECT ANYTHING AT ALL!
--
--                YOU SHOULD EDIT THE 'ACLConfig.lua'!
--


-- Check the ping of the client attempting to connect. Set to 0 to disable this check
ACL.maxPing = 120

-- Set to false to disable whitelisting
ACL.enableWhitelist = true

-- Set to true to enable the /kick and /playerlist commands
ACL.enablePlayerManagement = false

-- The whitelist can handle IP's, Steam ID's and words
ACL.whitelist = {
	--"[CLANTAG]",				-- Allow everyone with this tag in their name to connect
	--"MsQuerade",				-- Allow everyone with this name to connect
	--"ip:1.1.1.1",				-- Allow this IP to connect
	--"ip:2.2.2.2",				-- Allow this IP to connect
	--"ip:3.3.3.3",				-- Allow this IP to connect
	--"steam:1100001baadface",	-- Allow this Steam ID to connect
	--"steam:11000011337babe",	-- Allow this Steam ID to connect
	"steam:110000104615927"		-- Allow this Steam ID to connect
}

-- Handles only IP's and Steam ID's
-- Mods don't need to be whitelisted, they will always have access unless banned
-- Mods are currently indistinguishable from admins
ACL.mods = {
	--"ip:4.4.4.4",				-- Appoint this IP as moderator
	--"steam:1100001deadbeef"		-- Appoint this Steam ID as moderator
}

-- Handles only IP's and Steam ID's
-- Admins don't need to be whitelisted, they will always have access unless banned
-- Admins don't need to be added to mods list
ACL.admins = {
	--"ip:5.5.5.5",				-- Appoint this IP as administrator
	--"steam:11000011badbabe"		-- Appoint this Steam ID as administrator
}

-- The banlist supersedes allow rules. Handles IP's, Steam ID's and words
ACL.banlist = {
	--"ip:6.6.6.6",				-- Disallow this IP to connect
	--"steam:1100001deadc0de",	-- Disallow this Steam ID to connect
	--"bannedword"				-- Disallow this word in someone's name
}