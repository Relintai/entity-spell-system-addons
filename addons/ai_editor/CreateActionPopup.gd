tool
extends AcceptDialog

signal action_selected

export(NodePath) var tree_path : NodePath
export(NodePath) var search_le_path : NodePath

var _search_le : LineEdit
var _tree : Tree

var _group : ButtonGroup

func _ready():
	_search_le = get_node(search_le_path) as LineEdit
	_tree = get_node(tree_path) as Tree
	_tree.connect("item_activated", self, "item_activated")

	connect("about_to_show", self, "about_to_show")

func about_to_show():
	_tree.clear()
	
	var arr : PoolStringArray = PoolStringArray()
	arr.append("AIAction")
	arr.append_array(ClassDB.get_inheriters_from_class("AIAction"))

	var gsc : Array = ProjectSettings.get("_global_script_classes")
	
	var l : int = arr.size() - 1
	
	while (arr.size() != l):
		l = arr.size()
		
		for i in range(gsc.size()):
			var d : Dictionary = gsc[i] as Dictionary
			
			var found = false
			for j in range(arr.size()):
				if arr[j] == d["class"]:
					found = true
					break
				
			if found:
				continue
				
			for j in range(arr.size()):
				if arr[j] == d["base"]:
					arr.append(d["class"])

	_tree.create_item()
	for a in arr:
		var ti : TreeItem = _tree.create_item()
		ti.set_text(0, a)


func item_activated() -> void:
	emit_signal("action_selected", _tree.get_selected().get_text(0))
	hide()
