extends Node

@export var tracks: Array[AudioStreamOggVorbis] = []
@export var tracknames: Array[String] = []

@export var startingTrack: String

@onready var stream1 = $Stream1
@onready var stream2 = $Stream2

func _getTrackByName(name: String) -> AudioStreamOggVorbis :
  for i in range(len(tracknames)) :
    if tracknames[i] == name :
      return tracks[i]
  
  return tracks[0]

func playTrack(name: String) :
  var track = _getTrackByName(name)
  
  stream2.stream = track
  stream2.playing = true
  
  # Fade out the track playing in stream 1 and fade in the other
  $AnimationPlayer.play("fadeout")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
  # Switch the streams and set volume back to +0
  stream1.stream = stream2.stream
  stream1.playing = true
  stream1.volume_db = 0
  
  # Stop the second stream
  stream2.playing = false

func _ready() -> void:
  stream1.stream = _getTrackByName(startingTrack)
  stream1.playing = true
  stream1.volume_db = 0
