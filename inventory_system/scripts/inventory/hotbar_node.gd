class_name Hotbar_Node extends Scale_Control

export ( NodePath ) onready var slot_container = get_node( slot_container ) as Control

export ( Resource ) var player_data

var slots : Array = []

# The mouse wheel input is triggering twice? added this to prevent it.
var prevent_double_input = true

# Draw the hotbar slot from the player data.
func _ready():
	for slot in player_data.hotbar.slots:
		var slot_node = ResourceManager.get_instance( "hotbar_slot_node" )
		slot_container.add_child( slot_node )
		slot_node.slot = slot
		slots.append( slot )

func _process( delta ):
	prevent_double_input = true

func _input( event ):
	if prevent_double_input and not event.is_echo() and event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			player_data.hotbar.select_next()
		elif event.button_index == BUTTON_WHEEL_DOWN:
			player_data.hotbar.select_previous()
		prevent_double_input = false
