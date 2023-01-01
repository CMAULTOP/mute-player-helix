
local PLUGIN = PLUGIN

PLUGIN.name = "Mute players"
PLUGIN.author = "cmaul github.com/CMAULTOP"
PLUGIN.description = "A plugin that allows you to hook up a player through a scoreboard or all at once."

--[[

ВСТАВИТЬ В helix\gamemode\core\derma\cl_scoreboard.lua в 129 строку с заменой
INSERT INTO helix\gamemode\core\derma\cl_scoreboard.lua in line 129 with replacement

self.icon.DoRightClick = function()
	local client = self.player

	if (!IsValid(client)) then
		return
	end

	local menu = DermaMenu()

	menu:AddOption(L("viewProfile"), function()
		client:ShowProfile()
	end):SetImage("icon16/user_suit.png")


	menu:AddOption(L("copySteamID"), function()
		SetClipboardText(client:IsBot() and client:EntIndex() or client:SteamID())
	end):SetImage("icon16/link.png")

	if !(self.player == LocalPlayer()) then
		menu:AddOption(client:IsMuted() and "Размутить" or "Замутить", function()
			if client:IsMuted() then
					client:SetMuted( false )
				else
					client:SetMuted( true )
				end
		end):SetImage(client:IsMuted() and "icon16/sound_mute.png" or "icon16/sound.png")
	end

	hook.Run("PopulateScoreboardPlayerMenu", client, menu)
	menu:Open()
end


]]--


ix.option.Add("VoiceEnable", ix.type.bool, false, {
	category = "chat",
	OnChanged = function()
		if (ix.option.Get("VoiceEnable", true)) then
			for i, ply in ipairs( player.GetAll() ) do
				ply:SetMuted( true )
			end
		else
			for i, ply in ipairs( player.GetAll() ) do
				ply:SetMuted( false )
			end
		end
	end
})

ix.lang.AddTable("russian", {
	optVoiceEnable = "Выключить голосовой чат",
	optdVoiceEnable = "Включает или выключает голосовой чат. Мутит всех игроков на сервере."
})

function Schema:PlayerLoadedCharacter()
	if (ix.option.Get("VoiceEnable", true)) then
		for i, ply in ipairs( player.GetAll() ) do
			ply:SetMuted( true )
		end
	end
end