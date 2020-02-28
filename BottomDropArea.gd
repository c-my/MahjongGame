extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tiles = []
var texture


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = ImageTexture.new()
	texture.load("res://Asset/Tile/DropTileBottom.png")
	
func add_tile(suit, number):
	var tile = get_tile_instance(suit, number)
	tiles.append(tile)
	add_child(tile)
	show_tiles()

func get_tile_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	tile.vframes = 7
	tile.hframes = 9
	tile.frame_coords = Vector2(suit, number)
	return tile

func show_tiles():
	for i in range(tiles.size()):
		tiles[i].position = Vector2(i*Constants.Tile.BOTTOM_DROP_WIDTH, 0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
