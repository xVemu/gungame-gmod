GM.Name = "Gun Game"
GM.Author = "Vemu"
GM.Email = "kamilox26@gmail.com"

DeriveGamemode( "sandbox" )

local weapons = {"weapon_lightsaber","weapon_nyangun","mw3_barrett","mw3_dragunov","bo2r_svu","wf_wpn_sr43","wf_wpn_sr02","wf_wpn_sr34","mw3_l86_lsw","mw3_m60","bo2r_hamr","mw3_fad","mw3_m4a1","bo2r_m27","bo2r_peacekeeper","mw3_p90","mw3_fmg","mw3_ump45","bo2r_mp7","mw3_skorpion","cw_l115","wf_wpn_ar02","wf_wpn_ar29","wf_wpn_ar27","wf_wpn_ar04","wf_wpn_ar23","wf_wpn_ar31","wf_wpn_smg31","wf_wpn_smg38","wf_wpn_smg44","wf_wpn_smg04","wf_wpn_smg02","cw_g3a3","cw_l85a2","cw_g36c","cw_scarh","cw_ar15","cw_ak74","cw_vss","cw_m14","cw_m249_official","cw_ump45","cw_mac11","cw_mp5","cw_vz61_kry","doi_atow_g43","doi_atow_m1carbine","doi_atow_m1a1carbine","doi_atow_m1garand","doi_atow_k98k","doi_atow_enfield","doi_atow_m1903a3","doi_atow_stg44","doi_atow_mp40","doi_atow_m1918a2","doi_atow_fg42","doi_atow_sten","doi_atow_m1928a1","doi_atow_m1a1","doi_atow_owen","doi_ws_atow_mp34","doi_ws_atow_kp31","doi_atow_m3greasegun","doi_atow_bren","doi_atow_lewis","doi_atow_mg42","doi_atow_mg34","doi_atow_m1919a6","doi_atow_vickers","weapon_ar2","weapon_smg1","wf_wpn_shg07","cw_m3super90","bo2r_870mcs","mw3_usas","mw3_spas12","wf_wpn_shg01","wf_wpn_shg44","doi_atow_ithaca37","doi_atow_m1912","cw_shorty","weapon_shotgun","bo2r_b23r","mw3_usp","mw3_p99","doi_atow_c96carbine","cw_mr96","weapon_357","cw_deagle","doi_atow_browninghp","doi_atow_m1911a1","cw_m1911","wf_wpn_pt05","doi_atow_c96","doi_atow_p38","wf_wpn_pt41","doi_atow_p08","cw_makarov","doi_atow_ppk","cw_p99","wf_wpn_pt14","weapon_pistol","doi_atow_webley","doi_atow_sw1917","doi_atow_welrod","tfa_nmrih_fubar","csgo_cssource"}
local done = false

function GM:PlayerDeath( victim, inflictor, ply )
	self.BaseClass:PlayerDeath(victim, inflictor, ply)
    if ply:IsPlayer() and IsValid(ply) and ply ~= victim then
    	local actualItem = ply:GetNWInt("actualItem", 1)
        if actualItem >= table.Count(weapons) then
            PrintMessage(HUD_PRINTTALK, ply:Name().." wygrał!")
        else
        	ply:SetNWInt("actualItem", actualItem + 1)
        	PrintMessage(HUD_PRINTTALK, ply:Name().." - "..actualItem.."/"..table.Count(weapons))
  			actualItem = ply:GetNWInt("actualItem", 1)
            ply:RemoveAllItems()
            local weapon = ply:Give(weapons[actualItem])
            ply:GiveAmmo( 999,  weapon:GetPrimaryAmmoType())
        end
    end
end

function GM:PlayerLoadout( ply )
    local weapon = ply:Give(weapons[ply:GetNWInt("actualItem", 1)])
    ply:GiveAmmo( 999,  weapon:GetPrimaryAmmoType())
	return true
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply, false)
    ply:GodEnable()
    local visibility = true
    timer.Create("spawnInvisible", (1/4), 9, function()
    	ULib.invisible(ply, not visibility)
    	visibility = not visibility
    end)
    timer.Simple((9/4), function()
    	ply:GodDisable()
    end)
end

function GM:PlayerInitialSpawn(ply)
	if (not done) then
		done = true
		for _, each in ipairs(weapons) do
			ply:Give(each)
			ply:SelectWeapon(each)
		end
		ply:Kill()
	end
end

concommand.Add("gg_restart", function()
	for _, ply in ipairs( player.GetAll() ) do
		ply:SetNWInt("actualItem", 1)
		ply:Kill()
	end
end)