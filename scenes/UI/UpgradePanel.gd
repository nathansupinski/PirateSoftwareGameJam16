class_name UpgradePanel extends MarginContainer
##Temporary export for testing
@export var upgrade : Upgrade :
	set(value):
		upgrade = value
		updatePanel()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#upgrade = load("res://asssets/UpgradeTest.tres") as Upgrade
	updatePanel()
	pass # Replace with function body.


func updatePanel()-> void:
	
	if not upgrade or not is_node_ready():
		return
	var name : String = "[center]%s" % upgrade.name
	%UpgradeName.text = name
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
