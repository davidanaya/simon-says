import 'dart:io';

import 'package:flutter/material.dart';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SimonSoundsPlayer {
  AssetBundle _bundle;
  AudioPlayer _audioPlayer = AudioPlayer();

  List<String> _soundsNames = ['blue', 'green', 'red', 'yellow'];
  Map<String, String> _sounds = {};

  Future<void> loadSounds(BuildContext context) async {
    _bundle = DefaultAssetBundle.of(context);
    Directory tempDir = await getApplicationDocumentsDirectory();
    return Future.wait(_soundsNames.map((name) => _loadSound(name, tempDir)));
  }

  Future<void> _loadSound(String name, Directory tempDir) async {
    ByteData data = await _bundle.load('assets/sounds/$name.mp3');
    File tempFile = File('${tempDir.path}/$name.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    _sounds[name] = tempFile.path;
  }

  Future<void> playGreen() {
    return _play('green');
  }

  Future<void> playRed() {
    return _play('red');
  }

  Future<void> playYellow() {
    return _play('yellow');
  }

  Future<void> playBlue() {
    return _play('blue');
  }

  Future<void> _play(String color) {
    var uri = _sounds[color];
    return uri != null
        ? _audioPlayer.play(_sounds[color], isLocal: true)
        : null;
  }
}
