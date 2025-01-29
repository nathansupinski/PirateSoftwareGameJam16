class_name WeaponNumericModifier extends BaseWeaponModifier

@export var statID: Enums.WeaponNumericStatID
## [b]Multiply Additive:[/b] all operations of this type are summed before being multiplied to the target stat.
## 1 is added to the sum of all values to prevent division and make math easy. To set a 30% increase use a value of .3
## [br][br][b]Multiply Multiplicative:[/b] target stat is multiplied directly by this value after any [b]Add Compounding[/b] opperations are applied
## [br][br][b]Add Compounding:[/b] the value is added directly to the target stat [b]before[/b] any multipliers.
## [br][br][b]Add Flat:[/b] the value is added directly to the target stat [b]after[/b] all other operations.
@export var operation: Enums.NumericOperation
@export var value: NumericModifierValue
