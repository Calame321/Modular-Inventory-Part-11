class_name Hotbar extends Inventory

signal selected_item_changed( item )

var selected_slot : Hotbar_Slot

func get_new_slot( s ):
	var slot = Hotbar_Slot.new( s, self )
	slot.connect( "slot_selected", self, "_on_slot_selected" )
	return slot

func use_selected_item():
	if selected_slot and selected_slot.item and selected_slot.item.components.has( "usable" ):
		print( "Used hotbar slot: ", selected_slot.key )
		selected_slot.item.components.usable.use()

func select_next():
	print("select next")
	for s in range( slots.size() ):
		if slots[ s ].selected:
			var total = slots.size()
			var next = ( s + 1 ) % slots.size()
			slots[ next ].selected = true
			break

func select_previous():
	for s in range( slots.size() ):
		if slots[ s ].selected:
			slots[ ( s + slots.size() - 1 ) % slots.size() ].selected = true
			break

func _on_slot_selected( slot ):
	selected_slot = slot
	emit_signal( "selected_item_changed", slot.item )
	
	for s in slots:
		if s != slot:
			s.selected = false

# Pack the data of the referenced item so the link is preserved on load.
# If the original item is lost, save the item itself.
func get_data() -> Dictionary:
	var data = {}
	for s in slots.size():
		if slots[ s ].item:
			# The slot where the original item is.
			var slot = slots[ s ].item.slot
			if slot and slot.groups.find( "player" ) > -1:
				data[ s ] = {
					is_reference = true,
					inventory_name = slot.inventory.name,
					slot_index = slot.index
				}
			else:
				data[ s ] = {
					is_reference = false,
					item = slots[ s ].item.get_data()
				}
	return data

# Set the data of each slots from the Dictionary.
func set_data( data : Dictionary ) -> void:
	for s in slots.size():
		slots[ s ].put_item( null )
		if data.has( s ):
			var item
			if data[ s ].is_reference:
				var inv = InventoryManager.get_inventory_by_name( data[ s ].inventory_name )
				item = inv.slots[ data[ s ].slot_index ].item
			else:
				item = ItemManager.get_item_from_data( data[ s ].item )
			slots[ s ].put_item( item )
