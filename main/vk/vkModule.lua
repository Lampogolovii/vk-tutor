-- self.vk = require("main/vk/vkModule")

local M = {}

local appValue = "https://vk.com/app7783928"

local function js_listener(self, message_id, message)
	if message_id == "VKUserIdEvent" then
		print('Callback: VKUserIdEvent')
		if message.id then
			print('user id: ' .. message.id)
			M.user_id = message.id
			print('M.user_id' .. M.user_id)
		end
	elseif message_id == "VKUserAccessTokenEvent" then
		if message.user_access_token then
			M.user_access_token = message.user_access_token
		end
	end
end

M.VKRun = function (jscode)
	if jstodef then
		html5.run( jscode )
	end
end

M.Init = function ()
	if jstodef then
		jstodef.add_listener(js_listener)
	end
	M.VKRun("vkBridge.send('VKWebAppInit')")

	M.VKRun('var user_access_token = (new URL(document.location)).searchParams.get("access_token"); JsToDef.send("VKUserAccessTokenEvent", {user_access_token: user_access_token});')
end

M.ShowInterstitial = function ()
	M.VKRun('vkBridge.send("VKWebAppShowNativeAds", {ad_format:"interstitial"}).then(data => console.log(data.result)).catch(error => console.log(error))')
end

M.Share = function ()
	M.VKRun('vkBridge.send("VKWebAppShowWallPostBox", {"message": "Крутая игра для телефона! #vkgames #directgames","attachments": "'..appValue..'"})')
end

M.ShareWall = function ()
	M.VKRun('vkBridge.send("VKWebAppShare", {"link": "'..appValue..'"})')
end

M.AddFriend = function ()
	M.VKRun('vkBridge.send("VKWebAppShowInviteBox", {}).then(data => console.log(data.success)).catch(error => console.log(error))')
end

M.GetUserInfo = function()
	M.VKRun('console.log("VK_UserInfo"); vkBridge.send("VKWebAppGetUserInfo", {}).then(data => { console.log(data); JsToDef.send("VKUserIdEvent", {id: data.id});} ).catch(error => console.log(error))')
end

M.ShowLeaderboards = function( value )
	M.VKRun('console.log("VK_Leaderboards"); vkBridge.send("VKWebAppShowLeaderBoardBox", {"user_result":'..value..', "global":1}).then(data => { console.log(data); } ).catch(error => console.log(error))')
end

M.VkIntegrationApiGetLeaderBoards = function(global, type)
	local glob_val = 0
	if global == true then
		glob_val = 1
	end

	M.VKRun('vkBridge.send("VKWebAppCallAPIMethod", {"method": "apps.getLeaderboard", "params": {"v":"5.124", "access_token": "' .. M.user_access_token .. '", "global": "' .. glob_val .. '", "extended": "1", "type": "' .. type .. '"}}).then(data => {console.log(data); JsToDef.send("VKGetLeaderBoardsEvent", {data: data.response})}).catch(error => console.log(error))')
end

M.VkIntegrationApiGetUsers = function(vk_int_api_host, vk_int_api_port, vk_int_api_secret_path, api_id, user_ids, handle_response)
	local headers = {
		["Content-Type"] = "application/json"
	}
	local ids = ''
	for i, v in ipairs(user_ids) do
		ids = ids .. ',' .. v
	end
	ids = string.sub(ids, 2)
	local body = '{"api_id": "' .. api_id .. '", "user_ids":[' .. ids ..']}'
	print(body)
	http.request(vk_int_api_host .. ':' .. vk_int_api_port .. '/restapi/v1.0/game/integrations/vk/' .. vk_int_api_secret_path .. '/get_users' , "POST", handle_response, headers, body)
end

M.VkIntegrationApiSetScore = function(vk_int_api_host, vk_int_api_port, vk_int_api_secret_path, api_id, user_id, score, activity_id, handle_response)
	local headers = {
		["Content-Type"] = "application/json"
	}
	local body = '{"api_id": "' .. api_id .. '", "user_id": "' .. user_id .. '", "value": ' .. score .. ', "activity_id": "' .. activity_id ..'"}'
	print(body)
	http.request(vk_int_api_host .. ':' .. vk_int_api_port .. '/restapi/v1.0/game/integrations/vk/' .. vk_int_api_secret_path .. '/set_score' , "POST", handle_response, headers, body)
end


return M
