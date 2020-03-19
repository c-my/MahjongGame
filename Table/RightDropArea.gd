extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var texture
var tiles = []


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = ImageTexture.new()
	texture = load("res://Asset/Tile/DropTileRight.png")
	
func add_tile(suit, number):
	var tile = get_tile_instance(suit, number)
	tiles.append(tile)
	add_child(tile)
	move_child(tile, 0)
	show_tiles()

func get_tile_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	return tile

func show_tiles():
	for i in range(tiles.size()):
		tiles[i].position = Vector2(-i*Constants.Tile.SIDE_DROP_DIFF, 
				-i*(Constants.Tile.SIDE_DROP_HEIGHT-Constants.Tile.SIDE_DROP_THICK))
				
	
func clear_tiles():
	for tile in get_children():
		remove_child(tile)
		tile.queue_free()
	tiles = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
