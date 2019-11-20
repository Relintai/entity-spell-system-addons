extends "AIActionEditor.gd"

var _add_button : Button
var _remove_button : Button
var _hbox : HBoxContainer
var _labels : Array

func _ready():
	title = "AIActionContainer"
	
func setup() -> void:
	.setup()
	
	_hbox = HBoxContainer.new()
	_hbox.size_flags_vertical = SIZE_EXPAND_FILL
	add_child(_hbox)
	_hbox.owner = self
	
	_add_button = Button.new()
	_add_button.rect_min_size = Vector2(0, 30)
	_add_button.size_flags_horizontal = SIZE_EXPAND_FILL
	_add_button.text = "Add"
	_add_button.connect("pressed", self, "add_pressed")
	_hbox.add_child(_add_button)
	_add_button.owner = _hbox
	
	_remove_button = Button.new()
	_remove_button.rect_min_size = Vector2(0, 30)
	_remove_button.size_flags_horizontal = SIZE_EXPAND_FILL
	_remove_button.text = "Remove"
	_remove_button.connect("pressed", self, "remove_pressed")
	_hbox.add_child(_remove_button)
	_remove_button.owner = _hbox

	
func add_pressed() -> void:
	_action.set_num_ai_actions(_action.get_num_ai_actions() + 1)
	
	var button : Label = Label.new()
	button.rect_min_size = Vector2(0, 30)
	button.text = "Entry " + str(_labels.size())
	
	if _labels.size() > 0:
		add_child_below_node(_labels.back(), button)
	else:
		add_child(button)
		
	set_slot(get_child_count() - 1, false, 0, Color(1, 0, 0), true, 0, Color(1, 0, 0))
		
	button.owner = self
	
	_labels.append(button)

func remove_pressed() -> void:
	pass

func connected_to(from_slot, to_node) -> bool:
	if from_slot > _labels.size():
		return false
	
	if (_action.get_ai_action(from_slot) != null):
			return false
	
	var action : AIAction = to_node._action
	
	for i in range(_action.get_num_ai_actions()):
		if (_action.get_ai_action(i) == action):
			return false
		
	_action.set_ai_action(from_slot, action)
	return true

func disconnected_from(from_slot) -> bool:
	if from_slot > _labels.size():
		return false
		
	_action.set_ai_action(from_slot, null)
	
	return true
