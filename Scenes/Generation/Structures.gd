extends Node

onready var ball:PlayerBall = Global.get_world_node("PlayerBall")

var PRELOAD_NAME_BLACKLIST = [
	"LevelStructure4-4"
]

var CURRENT_CHECKPOINT = 1
onready var STRUCTURES_LEFT_IN_CHECKPOINT = CHECKPOINT_LENGTH[CURRENT_CHECKPOINT]
var STRUCTURE_PRELOADS = {}

# minimum of 2 or checkpoint display will break - not even gonna bother to fix this edge case
var CHECKPOINT_LENGTH = {
	1: 4,
	2: 7,
	3: 7,
	4: -1,
	5: 7,
	6: 7,
	7: 7,
	8: 7,
	9: -1
}

var CHECKPOINT_COLOR = {
	1: Color("#b4ff8f"),
	2: Color("#fbff87"),
	3: Color("#8291ff"),
	4: Color("#ff8787"),
}

func get_current_checkpoint_color():
	return CHECKPOINT_COLOR[CURRENT_CHECKPOINT]

var CURRENT_COLOR = Color("#ffffff")

func change_color() -> void:
	CURRENT_COLOR = get_current_checkpoint_color()

# loads and saves all structures
func dir_contents_load_all_scenes(path:String, parent_folder_name_for_saving="uncategorized"):
	STRUCTURE_PRELOADS[parent_folder_name_for_saving] = {}
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." && file_name != "..":
				if dir.current_is_dir():
#					var fullpath = path + "/" + file_name
#					print("[Loading structures] Found directory: " + fullpath)
					dir_contents_load_all_scenes(path + "/" + file_name, file_name)
				else:
					if file_name.ends_with(".tscn"):
						var fullpath = path + "/" + file_name
						var object_name = file_name.trim_suffix(".tscn")
						
						if PRELOAD_NAME_BLACKLIST.has(object_name):
							# print("Blacklisted object found: " + fullpath + " (not saved)")
							pass
						else:
							# print("Found file: " + fullpath + " (saved as " + parent_folder_name_for_saving + "." + object_name + ")")
							STRUCTURE_PRELOADS[parent_folder_name_for_saving][object_name] = load(fullpath)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _ready() -> void:
	Global.connect("announce_checkpoint", self, "change_color")
	dir_contents_load_all_scenes("res://Scenes/Checkpoints")

func get_first_child():
	return get_children()[0]

func get_last_child():
	return get_children()[-1]

func get_structure_preload_random(preload_group_key):
	var preload_group = STRUCTURE_PRELOADS[preload_group_key]
	var values = preload_group.values()
	return values[Global.randint_range(0, values.size()-1)]

func get_structure_preload_extratime(checkpoint: int):
	return STRUCTURE_PRELOADS["ExtraTime"]["LevelStructureExtraTime" + str(checkpoint)]

func get_structure_preload_transition():
	return STRUCTURE_PRELOADS["X"]["LevelStructureTransition"]

func add_structure_instance(structure_preload, ypos:float, trans=false):
	var structure = structure_preload.instance()
	structure.init(ypos)
	add_child(structure)
	return structure

func generate_new_structure(mode="") -> void:
	if mode == "end_checkpoint":
		add_structure_instance(get_structure_preload_extratime(CURRENT_CHECKPOINT), get_last_child().get_global_y_bottom())
		add_structure_instance(get_structure_preload_transition(), get_last_child().get_global_y_bottom(), true)
	else:
		add_structure_instance(get_structure_preload_random(str(CURRENT_CHECKPOINT)), get_last_child().get_global_y_bottom())
		# add_structure_instance(STRUCTURE_PRELOADS["4"]["LevelStructure4-2"], get_last_child().get_global_y_bottom())
		STRUCTURES_LEFT_IN_CHECKPOINT -= 1

func delete_structure() -> void:
	if get_child_count() >= 8:
		get_child(0).queue_free()

func update_checkpoint() -> bool:
	if STRUCTURES_LEFT_IN_CHECKPOINT == 0:
		generate_new_structure("end_checkpoint")
		CURRENT_CHECKPOINT += 1
		STRUCTURES_LEFT_IN_CHECKPOINT = CHECKPOINT_LENGTH[CURRENT_CHECKPOINT]
		return true
	return false

func update_barrier() -> void:
	Global.get_world_node("UnloadedStructureBarrierEnd").global_position = Vector2(0, get_last_child().get_global_y_bottom())

func renew_structures():
	if !update_checkpoint():
		delete_structure()
		generate_new_structure()

	update_barrier()

var peak_y = 0

func _process(delta: float) -> void:
	peak_y = get_first_child().get_global_y_top()
	if ball.global_position.y > get_last_child().get_global_y_top():
		renew_structures()
