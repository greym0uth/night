extends Resource
class_name Photo

@export var file_name: String
@export var distance_score: float = 0.0
@export var zoom_score: float = 0.0
@export var image_texture: ImageTexture

func _init(file_name: String, image_texture: ImageTexture):
  self.file_name = file_name
  self.image_texture = image_texture
