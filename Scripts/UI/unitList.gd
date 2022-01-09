extends Panel

var portraitScene = preload("res://Scenes/UI/Portrait.tscn")

var inList : Dictionary = {}
var error

func _ready() -> void:
	error = SignalBus.connect("objectSelected", self, "somethingSelected")
	error = SignalBus.connect("objectDeselected", self, "somethingDeselected")

func addPortrait(object) -> void:
	var objectID = object.get_instance_id()
	if !inList.has(objectID):
		var newPortrait = portraitScene.instance()
		# This is where I would pass in any variables I need to
		$GridContainer.call_deferred("add_child", newPortrait)
		newPortrait.get_node("portraitImage").texture = object.portrait
		inList[objectID] = newPortrait


func removePortrait(object) -> void:
	var objectID = object.get_instance_id()
	if inList.has(objectID):
		var portrait = inList[objectID] 
		portrait.queue_free()
		error = inList.erase(objectID)


func somethingSelected(object) -> void:
	addPortrait(object)

func somethingDeselected(object) -> void:
	removePortrait(object)
