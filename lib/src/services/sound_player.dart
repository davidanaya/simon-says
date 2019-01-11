import 'dart:io';

import 'package:flutter/material.dart';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simon_says/src/models/constants.dart';

class SoundPlayer {
  AssetBundle _bundle;
  AudioPlayer _audioPlayer = AudioPlayer();

  Map<GameColor, String> _sounds = {};

  Stream<AudioPlayerState> get state$ => _audioPlayer.onPlayerStateChanged;

  Future<void> loadSounds(BuildContext context) async {
    _bundle = DefaultAssetBundle.of(context);
    Directory tempDir = await getApplicationDocumentsDirectory();
    return Future.wait(
        GameColor.values.map((color) => _loadSound(color, tempDir)));
  }

  Future<void> play(GameColor color) {
    var uri = _sounds[color];
    print('play sound $color $uri 🎵🎵🎵');
    return uri != null
        ? _audioPlayer.play(_sounds[color], isLocal: true)
        : null;
  }

  Future<void> stop() {
    return _audioPlayer.stop();
  }

  Future<void> _loadSound(GameColor color, Directory tempDir) async {
    String name = gameColors[color].soundFileName;
    ByteData data = await _bundle.load('assets/sounds/$name.mp3');
    File tempFile = File('${tempDir.path}/$name.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    _sounds[color] = tempFile.path;
  }
}
