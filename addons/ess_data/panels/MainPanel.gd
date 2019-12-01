tool
extends Control

signal inspect_data

export(PackedScene) var resource_scene : PackedScene
export(PackedScene) var folder_entry_button_scene : PackedScene
export(String) var base_folder : String = "res://data/"
export(NodePath) var main_container : NodePath
export(NodePath) var folder_entry_container_path : NodePath


var _main_container : Node
var _resource_scene : Node
var _folder_entry_container : Node


var _folders : Array = [
	{
		"folder": base_folder + "entity_resources/",
		"type": "EntityResourceData",
		"name": "Entity Resources"
	},
	{
		"folder": base_folder + "entity_skills/",
		"type": "EntitySkillData",
		"name": "Entity Skills"
	},
	{
		"folder": base_folder + "spells/",
		"type": "Spell",
		"name": "Spells"
	},
	{
		"folder": base_folder + "auras/",
		"type": "Aura",
		"name": "Auras"
	},
	{
		"folder": base_folder + "aura_groups/",
		"type": "AuraGroup",
		"name": "Aura Groups"
	},
	{
		"folder": base_folder + "item_templates/",
		"type": "ItemTemplate",
		"name": "Items"
	},
	{
		"folder": base_folder + "crafting/",
		"type": "CraftRecipe",
		"name": "Craft Recipes"
	},
	{
		"folder": base_folder + "item_visuals/",
		"type": "ItemVisual",
		"name": "ItemVisuals"
	},
	{
		"folder": base_folder + "character_models/",
		"type": "MeshDataResource",
		"name": "Character Models"
	},
	{
		"folder": base_folder + "character_specs/",
		"type": "CharacterSpec",
		"name": "Character Specs"
	},
	{
		"folder": base_folder + "character_textures/",
		"type": "Texture",
		"name": "Character Textures"
	},
	{
		"folder": base_folder + "effect_data/",
		"type": "SpellEffectVisual",
		"name": "Effect Datas"
	},
	{
		"folder": base_folder + "entities/",
		"type": "EntityData",
		"name": "Entities"
	},
	{
		"folder": base_folder + "player_character_data/",
		"type": "EntityData",
		"name": "Player Characters"
	},
	{
		"folder": base_folder + "entity_classes/",
		"type": "EntityClassData",
		"name": "Entity Classes"
	},
	{
		"folder": base_folder + "ai/",
		"type": "AIAction",
		"name": "AI"
	},
	{
		"folder": base_folder + "planets/",
		"type": "PropDataEntry",
		"name": "Planets"
	},
	{
		"folder": base_folder + "biomes/",
		"type": "BiomeData",
		"name": "Biomes"
	},
	{
		"folder": base_folder + "dungeons/",
		"type": "DungeonData",
		"name": "Dungeons"
	},
	{
		"folder": base_folder + "dungeon_rooms/",
		"type": "DungeonRoomData",
		"name": "Dungeon Rooms"
	},
	{
		"folder": base_folder + "basic_models/",
		"type": "MeshDataResource",
		"name": "Basic Models"
	},
	{
		"folder": base_folder + "model_blocks/",
		"type": "PropData",
		"name": "Model Blocks"
	},
	{
		"folder": base_folder + "ships/",
		"type": "PropData",
		"name": "Ships"
	},
	{
		"folder": base_folder + "ship_parts/",
		"type": "PropData",
		"name": "Ship Parts"
	},
	{
		"folder": base_folder + "props/",
		"type": "PropData",
		"name": "Props"
	},
	{
		"folder": base_folder + "prop_models/",
		"type": "PackedScene",
		"name": "Prop Models"
	},
	{
		"folder": base_folder + "spell_effects/enchanter/",
		"type": "Spatial",
		"name": "Spell Effects -> Enchanter"
	},
	{
		"folder": base_folder + "spell_effects/nature/",
		"type": "Spatial",
		"name": "Spell Effects -> Nature"
	},
	{
		"folder": base_folder + "spell_effects/textures/",
		"type": "Texture",
		"name": "Spell Effects -> Textures"
	},
	{
		"folder": base_folder + "icons/",
		"type": "Texture",
		"name": "Icons"
	},
	{
		"folder": base_folder + "icons/items/",
		"type": "Texture",
		"name": "Icons -> Items"
	},
	{
		"folder": base_folder + "icons/naturalist/",
		"type": "Texture",
		"name": "Icons -> Naturalist"
	},
	{
		"folder": base_folder + "environments/",
		"type": "Environment",
		"name": "Environments"
	},
	{
		"folder": base_folder + "materials/",
		"type": "Material",
		"name": "Materials"
	},
	{
		"folder": base_folder + "models/",
		"type": "CharacterSkeleton",
		"name": "CharacterModels"
	},
	{
		"folder": base_folder + "fonts/",
		"type": "Font",
		"name": "Fonts"
	},
	{
		"folder": base_folder + "shaders/",
		"type": "Shader",
		"name": "Shaders"
	},
	{
		"folder": base_folder + "voxel_libraries/",
		"type": "VoxelmanLibrary",
		"name": "Voxel Libraries"
	},
	{
		"folder": base_folder + "voxel_surfaces/",
		"type": "VoxelSurface",
		"name": "Voxel Surfaces"
	},
	{
		"folder": base_folder + "voxel_textures/",
		"type": "Texture",
		"name": "Voxel Textures"
	},
	{
		"folder": base_folder + "xp/",
		"type": "XPData",
		"name": "XP Data"
	},
	{
		"folder": base_folder + "cursors/",
		"type": "Texture",
		"name": "Cursors"
	},
]

func _ready():
	_main_container = get_node(main_container)
	
	_resource_scene = resource_scene.instance()
	_main_container.add_child(_resource_scene)
	_resource_scene.owner = _main_container
	_resource_scene.connect("inspect_data", self, "inspect_data")
	
	_folder_entry_container = get_node(folder_entry_container_path)
	
	for ch in _folder_entry_container.get_children():
		ch.queue_free()
	
	var index = 0
	for f in _folders:
		var fe : Node = folder_entry_button_scene.instance()
		
		_folder_entry_container.add_child(fe)
		fe.owner = _folder_entry_container
		
		fe.text = f["name"]
		fe.tab = index
		
		fe.set_main_panel(self)
		
		index += 1
	
	set_tab(0)
#	set_tab("test")

func set_tab(tab_index : int) -> void:
	hide_all()
	
	_resource_scene.show()
	_resource_scene.set_resource_type(_folders[tab_index]["folder"], _folders[tab_index]["type"])
	
func hide_all() -> void:
	_resource_scene.hide()

func inspect_data(var data : Resource) -> void:
	emit_signal("inspect_data", data)
