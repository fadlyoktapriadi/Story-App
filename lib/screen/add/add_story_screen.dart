import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common.dart';
import 'package:story_app/provider/add/add_provider.dart';
import 'package:story_app/provider/home/home_provider.dart';
import 'package:story_app/result/story_add_story_result_state.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() onBack;

  const AddStoryScreen({super.key, required this.onBack});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    final addProvider = Provider.of<AddProvider>(context, listen: false);
    addProvider.addListener(() {
      if (addProvider.state is StoryAddStoryResultStateSuccess) {
        context.read<HomeProvider>().getStories();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Story Uploaded Successfully")),
        );
        widget.onBack();

      } else if (addProvider.state is StoryAddStoryResultStateError) {
        final errorMessage = (addProvider.state as StoryAddStoryResultStateError).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.titleAddStory)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child:
                  context.watch<AddProvider>().imagePath == null
                      ? const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.image, size: 100),
                      )
                      : _showImage(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // minimumSize: const Size.fromHeight(50), // Full-width button
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiary, // Primary color
                    foregroundColor:
                        Theme.of(
                          context,
                        ).colorScheme.onTertiary, // Text color on primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    _onGalleryView();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_library),
                      const SizedBox(width: 8),
                      Text(
                        "Gallery",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // minimumSize: const Size.fromHeight(50), // Full-width button
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiary, // Primary color
                    foregroundColor:
                        Theme.of(
                          context,
                        ).colorScheme.onTertiary, // Text color on primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    _onCameraView();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt),
                      const SizedBox(width: 8),
                      Text(
                        "Camera",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.placeholderDescription,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Full-width button
                  backgroundColor:
                      Theme.of(context).colorScheme.primary, // Primary color
                  foregroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.onPrimary, // Text color on primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                onPressed: () {
                  _uploadStory();
                },
                child: Consumer<AddProvider>(
                  builder: (context, value, child) {
                    return switch (value.state) {
                      StoryAddStoryResultStateLoading() => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      StoryAddStoryResultStateSuccess() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.uploadStory,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      _ => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.uploadStory,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onGalleryView() async {
    final provider = context.read<AddProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<AddProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _showImage() {
    final imagePath = context.read<AddProvider>().imagePath;
    return kIsWeb
        ? Image.network(imagePath.toString(), fit: BoxFit.contain)
        : Image.file(File(imagePath.toString()), fit: BoxFit.contain);
  }

  _uploadStory() async {
    final addProvider = context.read<AddProvider>();
    final imagePath = addProvider.imagePath;
    final imageFile = addProvider.imageFile;

    final ScaffoldMessengerState scaffoldMessengerState = ScaffoldMessenger.of(
      context,
    );

    if (imagePath == null || imageFile == null) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please enter a description")),
      );
      return;
    }

    try {
      final fileName = imageFile.name;
      final bytes = await imageFile.readAsBytes();
      final newBytes = await addProvider.compressImage(bytes);

      await addProvider.uploadStory(
        newBytes,
        fileName,
        _descriptionController.text,
      );
    } catch (e) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text("Failed to upload story: $e")),
      );
    } finally {
      addProvider.clearImage();
    }
  }
}
