TOWER_BASIC = 0
TOWER_ELEMENTS = 1
TOWER_FIRE = 2
TOWER_ICE = 3
TOWER_DEATH = 4

function UpgradeDeath (event)
	local caster = event.caster
	local ability = event.ability

	local tower_level = ability:GetLevel()

	UpdateModel(caster, GetModelNameForTower(TOWER_DEATH), 0.58 + (tower_level/30))

	caster:RemoveAbility("petri_upgrade_ice_tower")
	caster:RemoveAbility("petri_upgrade_fire_tower")

	UpdateAttributes(TOWER_DEATH, ability)
end

function UpgradeIce (event)
	local caster = event.caster
	local ability = event.ability

	local tower_level = ability:GetLevel()

	UpdateModel(caster, GetModelNameForTower(TOWER_ICE), 0.58 + (tower_level/30))

	caster:RemoveAbility("petri_upgrade_death_tower")
	caster:RemoveAbility("petri_upgrade_fire_tower")

	UpdateAttributes(TOWER_ICE, ability)
end

function UpgradeFire (event)
	local caster = event.caster
	local ability = event.ability

	local tower_level = ability:GetLevel()

	UpdateModel(caster, GetModelNameForTower(TOWER_FIRE), 0.58 + (tower_level/30))

	caster:RemoveAbility("petri_upgrade_death_tower")
	caster:RemoveAbility("petri_upgrade_ice_tower")

	UpdateAttributes(TOWER_FIRE, ability)
end

function UpgradeElements (event)
	local caster = event.caster
	local ability = event.ability

	local tower_level = ability:GetLevel()

	UpdateModel(caster, GetModelNameForTower(TOWER_ELEMENTS), 0.58)

	caster:RemoveAbility("petri_upgrade_basic_tower")

	caster:AddAbility("petri_upgrade_fire_tower")
	caster:AddAbility("petri_upgrade_death_tower")
	caster:AddAbility("petri_upgrade_ice_tower")

	caster:SwapAbilities("petri_upgrade_fire_tower", "petri_empty1", true, false)
	caster:SwapAbilities("petri_upgrade_death_tower", "petri_empty2", true, false)
	caster:SwapAbilities("petri_upgrade_ice_tower", "petri_empty3", true, false)

	InitAbilities(caster)

	UpdateAttributes(TOWER_ELEMENTS, ability)
end

function UpgradeBasic (event)
	local caster = event.caster
	local ability = event.ability

	local tower_level = ability:GetLevel()

	caster:SetModelScale(0.35 + (tower_level/30))

	caster:RemoveAbility("petri_upgrade_elements_tower")

	UpdateAttributes(TOWER_BASIC, ability)
end

function GetModelNameForTower(tower)
	if tower == TOWER_ELEMENTS then 
		return "models/props_structures/tower_good3_dest_lvl1.vmdl"
	elseif tower == TOWER_FIRE then 
		return "models/items/invoker/forge_spirit/infernus/infernus.vmdl"
	elseif tower == TOWER_ICE then 
		return "models/heroes/ancient_apparition/ancient_apparition.vmdl"
	elseif tower == TOWER_DEATH then 
		return "models/heroes/undying/undying_tower.vmdl"
	end
end

function UpdateAttributes(tower, ability)
	local tower_level = ability:GetLevel() - 1

	local attack = ability:GetLevelSpecialValueFor("attack", tower_level)
	local attack_rate = ability:GetLevelSpecialValueFor("attack_rate", tower_level)

	local caster = ability:GetCaster()

	caster:SetBaseDamageMax(attack)
	caster:SetBaseDamageMin(attack)

	if tower == TOWER_BASIC then
	elseif tower == TOWER_ELEMENTS then 
	elseif tower == TOWER_FIRE then
		caster:RemoveModifierByName("modifier_attack_speed")
		ability:ApplyDataDrivenModifier(ability:GetCaster(), caster, "modifier_crits", {})
		StartAnimation(caster, {duration=-1, activity=ACT_DOTA_IDLE , rate=1.4})
	elseif tower == TOWER_ICE then
		caster:RemoveModifierByName("modifier_attack_speed")
		ability:ApplyDataDrivenModifier(ability:GetCaster(), caster, "modifier_skadi", {})
		StartAnimation(caster, {duration=-1, activity=ACT_DOTA_IDLE , rate=1.4})
	elseif tower == TOWER_DEATH then 
		caster:RemoveModifierByName("modifier_attack_speed")
		ability:ApplyDataDrivenModifier(ability:GetCaster(), caster, "modifier_death_tower", {})
		StartAnimation(caster, {duration=-1, activity=ACT_DOTA_IDLE , rate=1.4})
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_attack_speed", {})
end

-- Misc
function IceTowerOnOrbImpact(keys)
	if not keys.target:IsMagicImmune() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_skadi_cold_attack", {duration = keys.ColdDuration})
	end
end

function DeathTowerOnOrbImpact(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if not target:IsMagicImmune() then
		local modifierName = "modifier_death_tower_corruption"
		local maxStacks = ability:GetLevelSpecialValueFor("armor_reduction_stacks", ability:GetLevel()-2)

		AddStackableModifierWithDuration(target, target, ability, modifierName, 10, maxStacks)
	end
end