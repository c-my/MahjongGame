extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var texture
var hide_texture
var pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = ImageTexture.new()
	texture = load("res://Asset/Tile/DropTileRight.png")
	hide_texture = ImageTexture.new()
	hide_texture = load("res://Asset/Tile/HideTileRight.png")
	position = Vector2(Constants.Screen.WIDTH-Constants.Tile.SIDE_DROP_WIDTH-Constants.Table.SIDE_SHOWN_MARGIN_X,
	Constants.Screen.HEIGHT-Constants.Table.SIDE_SHOWN_MARGIN_Y-3*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK)-Constants.Tile.SIDE_DROP_THICK)

	
func show_tiles(tiles):
	clear_tiles()
	for suit in tiles:
		if(suit["shown_type"]==Message.player_action.CHOW or
		suit["shown_type"]==Message.player_action.PONG):
			for i in range(3):
				var tmp = suit["tiles"][2-i]
				var t = get_tile_instance(tmp["suit"], tmp["number"])
				add_child(t)
				t.position = Vector2(0, pos+i*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK))
		elif(suit["shown_type"]==Message.player_action.EXPOSED_KONG):
			for i in range(3):
				var tmp = suit["tiles"][i]
				var t = get_tile_instance(tmp["suit"], tmp["number"])
				add_child(t)
				t.position = Vector2(0, pos+i*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK))
			var t = get_tile_instance(suit["tiles"][3]["suit"], suit["tiles"][3]["number"])
			add_child(t)
			t.position = Vector2(0, pos+Constants.Tile.SIDE_DROP_HEIGHT-2*Constants.Tile.SIDE_DROP_THICK)			

		elif(suit["shown_type"]==Message.player_action.CONCEALED_KONG):
			for i in range(3):
				var t = get_hide_tile_instance()
				add_child(t)
				t.position = Vector2(0, pos+i*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK))
			var t = get_hide_tile_instance()
			add_child(t)
			t.position = Vector2(0, pos+Constants.Tile.SIDE_DROP_HEIGHT-2*Constants.Tile.SIDE_DROP_THICK)
		elif(suit["shown_type"]==Message.player_action.ADDED_KONG):
			for i in range(3):
				var tmp = suit["tiles"][i]
				var t = get_tile_instance(tmp["suit"], tmp["number"])
				add_child(t)
				t.position = Vector2(0, pos+i*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK))
			var hide_t = get_hide_tile_instance()
			add_child(hide_t)
			hide_t.position = Vector2(0, pos+Constants.Tile.SIDE_DROP_HEIGHT-2*Constants.Tile.SIDE_DROP_THICK)		
		
		pos -= Constants.Tile.SIDE_SHOWN_SEP + 3*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK)
		
func clear_tiles():
	pos = 0
	for tile in get_children():
		remove_child(tile)
		tile.queue_free()


func get_tile_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	tile.scale = Vector2(Constants.Tile.SIDE_SCALE, Constants.Tile.SIDE_SCALE)
	return tile

func get_hide_tile_instance():
	var tile = Sprite.new()
	tile.texture = hide_texture
	tile.centered = false
	tile.scale = Vector2(Constants.Tile.SIDE_SCALE, Constants.Tile.SIDE_SCALE)	
	return tile
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
