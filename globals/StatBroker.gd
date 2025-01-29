extends Node

var allUpgradeCards: Array[UpgradeCard] = []
var playerUpgradeCards: Array[UpgradeCard] = []
var leftArmUpgradeCards: Array[UpgradeCard] = []
var rightArmUpgradeCards: Array[UpgradeCard] = []
var backpackUpgradeCards: Array[UpgradeCard] = []

var debugLog: bool = true

func transformWeaponProperty(statID: Enums.WeaponPropertyStatID, weaponSlot: Enums.WeaponSlot, startingStat):
	var mutatedStat = startingStat
	var modifiers = _extractModifiersFromCards(_filterCardsByStatID(_getCardsForWepSlot(weaponSlot), statID))
	for modifier: BaseWeaponPropertyModifier in modifiers:
		mutatedStat = modifier.value #for now the only propertyModifier just sets a value
	return mutatedStat
	
func transformWeaponNumeric(statID: Enums.WeaponNumericStatID, weaponSlot: Enums.WeaponSlot, startingStat):
	return _transformNumeric(statID, startingStat, _getCardsForWepSlot(weaponSlot))
	
func transformPlayerNumeric(statID: Enums.PlayerNumericStatID, startingStat):
	return _transformNumeric(statID, startingStat, playerUpgradeCards)
	
func _transformNumeric(statID, startingStat, cards: Array[UpgradeCard]):
	var modifierRarityDicts: Array[Dictionary] = _extractModifierAndRarityPairsFromCards(_filterCardsByStatID(cards, statID))
	var mutatedStat = startingStat + _sumCompoundingAddModifiers(modifierRarityDicts) 
	
	for multiplier in _getMultiplicativeMultipliers(modifierRarityDicts):
		mutatedStat *= multiplier
		
	mutatedStat *= _sumAddativeMultipliers(modifierRarityDicts)
	
	mutatedStat += _sumFlatAddModifiers(modifierRarityDicts)
	
	if debugLog:
		print("BrokerNumericTransform: statID:" + str(statID) + " inValue: " + str(startingStat) + " outValue: " + str(mutatedStat))
	return mutatedStat

func _sumAddativeMultipliers(modifierRarityDicts:Array[Dictionary]) -> float:
	return 1 + _sumFromDictArray(modifierRarityDicts, Enums.NumericOperation.MULTIPLY_ADDITIVE)

func _sumFlatAddModifiers(modifierRarityDicts:Array[Dictionary]) -> float:
	return _sumFromDictArray(modifierRarityDicts, Enums.NumericOperation.ADD_FLAT)

func _sumCompoundingAddModifiers(modifierRarityDicts:Array[Dictionary]) -> float:
	return _sumFromDictArray(modifierRarityDicts, Enums.NumericOperation.ADD_COMPOUNDING)

# returns an array of the raw values for the given rarity for multiplicative operations
func _getMultiplicativeMultipliers(modifierRarityDicts:Array[Dictionary]) -> Array[float]:
	# workaround for array functions not returning typed arrays
	# See https://github.com/godotengine/godot/issues/72566
	var value: Array[float]
	value.assign(modifierRarityDicts.filter(func(dic): return dic.modifier.operation == Enums.NumericOperation.MULTIPLY_MULTIPLICATIVE).map(func(dic): return dic.modifier.value.getValueForRarity(dic.rarity)))
	return value
	
func _sumFromDictArray(modifierRarityDicts:Array[Dictionary], operationType: Enums.NumericOperation) -> float:
	var _sum = func(accum, dic):
		var value = dic.modifier.value.getValueForRarity(dic.rarity)
		return accum + value
		
	return modifierRarityDicts.filter(func(dic): return dic.modifier.operation == operationType).reduce(_sum, 0)
	
func _getCardsForWepSlot(weaponSlot: Enums.WeaponSlot) -> Array[UpgradeCard]:
	match weaponSlot:
			Enums.WeaponSlot.RIGHT_ARM:
				return rightArmUpgradeCards
			Enums.WeaponSlot.LEFT_ARM:
				return leftArmUpgradeCards
			Enums.WeaponSlot.BACKPACK:
				return backpackUpgradeCards
	return []

# takes an UpgradeCard array and returns all modifiers that the cards contain
func _extractModifiersFromCards(cards: Array[UpgradeCard]) -> Array:
	return cards.map(func(card): return card.upgrade.modifier)

func _extractModifierAndRarityPairsFromCards(cards: Array[UpgradeCard]) -> Array[Dictionary]:
	# workaround for array functions not returning typed arrays
	# See https://github.com/godotengine/godot/issues/72566
	var result:Array[Dictionary]
	result.assign(cards.map(func(card) -> Dictionary: return { "rarity":card.rarity, "modifier": card.upgrade.modifier}))
	return result
	
func _filterCardsByStatID(cards: Array[UpgradeCard], statID) -> Array[UpgradeCard]:
	# workaround for array functions not returning typed arrays
	# See https://github.com/godotengine/godot/issues/72566
	var result:Array[UpgradeCard]
	result.assign(cards.filter(func(card): return card.upgrade.modifier.statID == statID))
	return result
	
func registerUpgrade(card:UpgradeCard) -> void:
	if card.upgrade is PlayerUpgrade:
		allUpgradeCards.append(card)
		playerUpgradeCards.append(card)
		SignalBus.playerUpgradesChanged.emit(card)
		print("StatBroker: registered playerUpgrade", card)
		return
	
	if card.upgrade is WeaponUpgrade:
		match card.upgrade.weaponSlot:
			Enums.WeaponSlot.RIGHT_ARM:
				allUpgradeCards.append(card)
				rightArmUpgradeCards.append(card)
				SignalBus.weaponUpgradesChanged.emit(Enums.WeaponSlot.RIGHT_ARM, card)
				print("StatBroker: registered rightArmUpgrade", card)
				return
			Enums.WeaponSlot.LEFT_ARM:
				allUpgradeCards.append(card)
				leftArmUpgradeCards.append(card)
				SignalBus.weaponUpgradesChanged.emit(Enums.WeaponSlot.LEFT_ARM, card)
				print("StatBroker: registered leftArmUpgrade", card)
				return
			Enums.WeaponSlot.BACKPACK:
				allUpgradeCards.append(card)
				backpackUpgradeCards.append(card)
				SignalBus.weaponUpgradesChanged.emit(Enums.WeaponSlot.BACKPACK, card)
				print("StatBroker: registered backpackUpgrade", card)
				return
	
