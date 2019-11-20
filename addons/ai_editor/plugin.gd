tool
extends EditorPlugin

var ai_editor_scene_data : PackedScene = preload("res://addons/ai_editor/AIEditorScene.tscn") as PackedScene

var main_scene : Control
var bottom_panel_button : ToolButton

var edited_ai_action : AIAction

func _enter_tree():
	main_scene = ai_editor_scene_data.instance() as Control
	bottom_panel_button = add_control_to_bottom_panel(main_scene, "AI Editor")
	
func _exit_tree():
	remove_control_from_bottom_panel(main_scene)
	main_scene.queue_free()
#	bottom_panel_button.queue_free()
#	bottom_panel_button.hide()

#
#func edit(object : Object) -> void:
#	edited_ai_action = object as AIAction
#	main_scene.set_target(edited_ai_action)
#
#	bottom_panel_button.show()
#
#
#func handles(object : Object) -> bool:
#	return object is AIAction

