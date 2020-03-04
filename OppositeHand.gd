extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tiles = []
var texture

func show_tiles(count):
	if count < 0 or count == tiles.size():
		return
	if count > tiles.size():
		var diff = count - tiles.size()
		for i in range(diff):
			var tile = get_tile_instance()
			tiles.append(tile)
			add_child(tile)
	else:
		var diff = tiles.size() - count
		for i in range(diff):
			remove_child(tiles[0])
			tiles.remove(0)
	rearrange_tiles()
	
	
func rearrange_tiles():
	print_debug("tiles_count:", tiles.size())
	print_debug("hand loc:", self.position)
	for i in range(tiles.size()):
		tiles[i].position = Vector2(i*Constants.Tile.OPPOSITE_HAND_WIDTH, 0)
	var x = (Constants.Screen.WIDTH - get_children().size()*Constants.Tile.OPPOSITE_HAND_WIDTH)/2.0
	var y = Constants.Table.OPPO_HAND_MARGIN_Y
	self.position = Vector2(x, y)
	
func get_tile_instance():
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	return tile
	
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = ImageTexture.new()
	texture.load("res://Asset/Tile/OppositeHand.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
