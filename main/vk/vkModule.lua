-- self.vk = require("main/vk/vkModule")

local M = {}

local appValue = "https://vk.com/app7767948";

M.VKRun = function (jscode)
	if jstodef then
		html5.run( jscode );
	end
end

M.Init = function ()
	M.VKRun("vkBridge.send('VKWebAppInit')");
end

M.ShowInterstitial = function ()
	M.VKRun('vkBridge.send("VKWebAppShowNativeAds", {ad_format:"interstitial"}).then(data => console.log(data.result)).catch(error => console.log(error))');
end

M.Share = function ()
	M.VKRun('vkBridge.send("VKWebAppShowWallPostBox", {"message": "Крутая игра для телефона! #vkgames #directgames","attachments": "'..appValue..'"})');
end

M.ShareWall = function ()
	M.VKRun('vkBridge.send("VKWebAppShare", {"link": "'..appValue..'"})');
end

M.AddFriend = function ()
	M.VKRun('vkBridge.send("VKWebAppShowInviteBox", {}).then(data => console.log(data.success)).catch(error => console.log(error))');
end

return M