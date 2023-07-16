class_name Hotbar_Slot_Node extends Inventory_Slot_Node

export ( NodePath ) onready var lbl_key = get_node( lbl_key ) as Label
export ( NodePath ) onready var highlight = get_node( highlight ) as TextureRect

func set_slot( value ):
	.set_slot( value )
	set_key()
	slot.connect( "slot_select_changed", self, "_on_slot_select_changed" )

# If you press this slot's key, activate the item if possible.
func _input( event ):
	if event.is_action_pressed( "hotbar_" + slot.key ):
		slot.selected = true

# Set the key to be pressed to activate this slot.
func set_key():
	if lbl_key is Label:
		lbl_key.text = slot.key

func _on_slot_select_changed():
	highlight.visible = slot.selected
