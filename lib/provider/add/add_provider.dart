import 'package:image_picker/image_picker.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:story_app/result/story_add_story_result_state.dart';

class AddProvider extends ChangeNotifier {

  final StoryRepository storyRepository;

  AddProvider(this.storyRepository);

  String? imagePath;
  XFile? imageFile;

  StoryAddStoryResultState _state = StoryAddStoryNoneState();

  StoryAddStoryResultState get state => _state;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<void> uploadStory(
    List<int> bytes,
    String fileName,
    String description, {
    double? lat,
    double? lon,
  }) async {
    _state = StoryAddStoryResultStateLoading();
    notifyListeners();

    try {
      final response = await storyRepository.uploadStory(
        bytes,
        fileName,
        description,
        lat,
        lon,
      );
      _state = StoryAddStoryResultStateSuccess(response);
    } catch (e) {
      _state = StoryAddStoryResultStateError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      newByte = img.encodeJpg(image, quality: compressQuality);

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  void clearImage() {
    imagePath = null;
    imageFile = null;
    _state = StoryAddStoryNoneState();
    notifyListeners();
  }
}
