-- self.vk = require("main/vk/vkModule")

local M = {}

local appValue = "https://vk.com/app7767948"

local function js_listener(self, message_id, message)
	if message_id == "VKUserIdEvent" then
		print('Callback: VKUserIdEvent')
		if message.id then
			print('user id: ' .. message.id)
			M.user_id = message.id
			print('M.user_id' .. M.user_id)
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

M.VkIntegrationApiSetScore = function(vk_int_api_host, vk_int_api_port, vk_int_api_secret_path, user_id, score, activity_id, handle_response)
	local headers = {
		["Content-Type"] = "application/json"
	}
	local body = '{"user_id": "' .. user_id .. '", "value": ' .. score .. ', "activity_id": "' .. activity_id ..'"}'
	print(body)
	http.request(vk_int_api_host .. ':' .. vk_int_api_port .. '/restapi/v1.0/game/integrations/vk/' .. vk_int_api_secret_path .. '/set_score' , "POST", handle_response, headers, body)
end


return M
