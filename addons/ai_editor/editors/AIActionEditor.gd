extends GraphNode

var _action : AIAction

func _ready():
	title = "AIAction"
	show_close = true
	resizable = true
	rect_min_size = Vector2(200, 40)
	
	connect("close_request", self, "close_request")
	connect("resize_request", self, "resize_request")
	
	setup()

func set_action(action) -> void:
	_action = action
	
	if _action:
		title = _action.get_class()
		
		if _action.has_method("get_title"):
			title = _action.get_title()
	
	setup()

func setup() -> void:
	for ch in get_children():
		ch.queue_free()
		remove_child(ch)
	
	var le : LineEdit = LineEdit.new()
	le.rect_min_size = Vector2(0, 30)
	le.placeholder_text = "Description"
	add_child(le)
	le.owner = self
	
	set_slot(0, true, 0, Color(1, 0, 0), false, 0, Color(1, 0, 0))
	

func close_request() -> void:
	get_node("..").close_request(self)
#	queue_free()
	
func resize_request(new_min_size: Vector2) -> void:
	rect_min_size = new_min_size

func connected_to(from_slot, to_node) -> bool:
	return false
	
func disconnected_from(from_slot) -> bool:
	return false
