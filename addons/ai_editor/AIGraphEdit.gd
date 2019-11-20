tool
extends GraphEdit

export(NodePath) var create_action_popup : NodePath

var _create_action_popup : PopupMenu
var _actions : Array

func _ready() -> void:
	_create_action_popup = get_node(create_action_popup)
	_create_action_popup.connect("action_selected", self, "create_action")
	
	connect("popup_request", self, "popup_request")
	connect("connection_request", self, "connection_request")
	connect("disconnection_request", self, "disconnection_request")
	

func popup_request(position: Vector2) -> void:
	_create_action_popup.rect_position = position
	_create_action_popup.popup()

func create_action(action) -> void:
	var cls : Script
	
	var pclass = action
	while cls == null and pclass != "":
		var file_name : String = "res://addons/ai_editor/editors/" + pclass + "Editor.gd"

		var d : Directory = Directory.new()
		
		if d.file_exists(file_name):
			cls = load(file_name)
		else:
			pclass = get_parent_class(pclass)
			
	if cls == null:
		print("AiGraphEdit cls==null! (create_action)")
	
	var n : GraphNode = cls.new() as GraphNode
	add_child(n)
	n.owner = self
	n.rect_position = _create_action_popup.rect_position
	
	if ClassDB.class_exists(action):
		n.set_action(ClassDB.instance(action))
	else:
		var gsc : Array = ProjectSettings.get("_global_script_classes")
		
		for i in range(gsc.size()):
			var d : Dictionary = gsc[i] as Dictionary

			if action == d["class"]:
				var scls : Script = load(d["path"])
				n.set_action(scls.new())
	
func connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var node = get_node(from)
	var to_node = get_node(to)
	if node.connected_to(from_slot, to_node):
		connect_node(from, from_slot, to, to_slot)
		save()
	
func disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var node = get_node(from)
	if node.disconnected_from(from_slot):
		disconnect_node(from, from_slot, to, to_slot)
		save()

func save():
	for action in _actions:
		ResourceSaver.save(action.resource_path, action)

func close_request(graph_node : Node) -> void:
	remove_node(graph_node)
	
#	{ from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }.

func remove_node(graph_node : Node) -> void:
	var connections : Array = get_connection_list()
	
	for conn in connections:
		if conn["from"] == graph_node.name:
			remove_node(get_node(conn["to"]))
			disconnect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])
			
	graph_node.queue_free()

func add_action(ai_action : AIAction, position: Vector2) -> void:
	_actions.append(ai_action)
	
	var n : GraphNode = get_graph_node_for(ai_action)

	n.rect_position = position
#	n.rect_position = _create_action_popup.rect_position
	n.set_action(ai_action)

func get_parent_class(cls_name: String) -> String:
	if ClassDB.class_exists(cls_name):
		return ClassDB.get_parent_class(cls_name)

	var gsc : Array = ProjectSettings.get("_global_script_classes")

	for i in range(gsc.size()):
		var d : Dictionary = gsc[i] as Dictionary

		if cls_name == d["class"]:
			return d["base"]
			
	return ""

func get_graph_node_for(action : AIAction) -> GraphNode:
	var cls : Script
	
	var pclass : String = action.get_class()

#	if action.get_script() != null:
#		var gsc : Array = ProjectSettings.get("_global_script_classes")
#
#		for i in range(gsc.size()):
#			var d : Dictionary = gsc[i] as Dictionary
#
#			print(d)
#			if cls_name == d["path"]:
#				d["base"]
	
	while cls == null and pclass != "":
		var file_name : String = "res://addons/ai_editor/editors/" + pclass + "Editor.gd"

		var d : Directory = Directory.new()
		
		if d.file_exists(file_name):
			cls = load(file_name)
		else:
			pclass = get_parent_class(pclass)
			
	if cls == null:
		print("AiGraphEdit cls==null! (get_graph_node_for)")
		return null
	
	var n : GraphNode = cls.new() as GraphNode
	add_child(n)
	n.owner = self

	return n

func can_drop_data(position, data):
	if data is AIAction:
		return true
		
	if data is Dictionary:
		if data.has("type") and data["type"] == "files" and data.has("files"):
			for file in data["files"]:
				if ResourceLoader.exists(file):
					var res : Resource = ResourceLoader.load(file)
				
					if res is AIAction:
						return true

	return false

func drop_data(position, data):
	if data is AIAction:
		return true
		
	if data is Dictionary:
		if data.has("type") and data["type"] == "files" and data.has("files"):
			for file in data["files"]:
				if ResourceLoader.exists(file):
					var res : Resource = ResourceLoader.load(file)
				
					if res is AIAction:
						add_action(res, position)
