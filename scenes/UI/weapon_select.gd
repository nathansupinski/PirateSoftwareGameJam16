extends MarginContainer

const weaponsPreviews : Dictionary = {
	"40mmGrenadelauncher":{
		"left": preload("res://scenes/weapons/40mmGrenadelauncherLeft/40mmGrenadelauncherL0001.png"),
		"right" : preload("res://scenes/weapons/40mmGrenadelauncherRight/40mmGrenadelauncherR0001.png")
	},
	"teslaGun":{
		"left": preload("res://scenes/weapons/teslaGunLeft/teslaGunL0001.png"),
		"right" : preload("res://scenes/weapons/teslaGunRight/teslaGunR0001.png")
	},
	"120mmCannon":{
		"left": preload("res://scenes/weapons/120mmCannonLeft/120mmCannonL0001.png"),
		"right" : preload("res://scenes/weapons/120mmCannonRight/120mmCannonR0001.png")
	}
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nothing_selected : bool = not (%LeftWeaponChoice.selected>=0 and %RightWeaponChoice.selected >=0)
	%Confirm.disabled = nothing_selected
	if nothing_selected:
		%Confirm.modulate = Color(0.3,0.2,0.2,0.7)
	else:
		%Confirm.modulate = Color.WHITE
	
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	
	##TODO maybe disable if they select same one


func _on_confirm_pressed() -> void:
	print("confirmed") # Replace with function body.
	Global.selectedWeapon1 = _indexToWeapon(%LeftWeaponChoice.selected)
	Global.selectedWeapon2 = _indexToWeapon(%RightWeaponChoice.selected)
	get_tree().change_scene_to_file("res://scenes/main/main_scene.tscn")

	#print(Global.sele)

func _indexToWeapon(index : int) -> Weapon:
	match index:
		0:
			return load("res://scenes/weapons/teslaGun.tscn").instantiate(1)
		1:
			return  load("res://scenes/weapons/120mmCannon.tscn").instantiate(1)
		2:
			return load("res://scenes/weapons/40mmGrenadelauncher.tscn").instantiate(1)
		_:
			return Weapon.new()

func _indexToWeaponString(index : int) -> String :
	match index:
		0:
			return "teslaGun"
		1:
			return  "120mmCannon"
		2:
			return "40mmGrenadelauncher"
		_:
			return ""
			
func _on_right_weapon_choice_item_selected(index: int) -> void:
	var selected : String = _indexToWeaponString(index)
	%RightWeaponPreview.texture = weaponsPreviews[selected]["right"]
	
	


func _on_left_weapon_choice_item_selected(index: int) -> void:
	var selected : String = _indexToWeaponString(index)
	%LeftWeaponPreview.texture = weaponsPreviews[selected]["left"]
