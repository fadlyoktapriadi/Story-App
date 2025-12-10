import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common.dart';
import 'package:story_app/provider/add/add_provider.dart';
import 'package:story_app/provider/home/home_provider.dart';
import 'package:story_app/result/story_add_story_result_state.dart';

import '../components/placemark_comp.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() onBack;

  const AddStoryScreen({super.key, required this.onBack});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool isUsingMaps = false;
  final Location location = Location();
  late GoogleMapController mapController;
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  LatLng? _currentLatLng;
  geo.Placemark? placemark;
  late final Set<Marker> markers = {};
  double lat = 0.0;
  double lon = 0.0;

  Future<void> serviceLocationGps() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }
  }

  Future<void> _initLocation() async {
    await serviceLocationGps();
    final data = await location.getLocation();
    setState(() {
      _currentLatLng = LatLng(data.latitude ?? 0, data.longitude ?? 0);
      lat = data.latitude ?? 0;
      lon = data.longitude ?? 0;
    });
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(title: street, snippet: address),
    );
    setState(() {
      lat = latLng.latitude;
      lon = latLng.longitude;
      markers.clear();
      markers.add(marker);
    });
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

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
        final errorMessage =
            (addProvider.state as StoryAddStoryResultStateError).error;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.placeholderDescription,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lokasi Story",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: isUsingMaps,
                    onChanged: (value) {
                      setState(() {
                        isUsingMaps = value;
                      });
                      if (value) {
                        _initLocation();
                      }
                    },
                  ),
                ],
              ),
            ),

            if (isUsingMaps)
              _currentLatLng == null
                  ? const SizedBox(
                    height: 270,
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 270,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentLatLng!,
                              zoom: 18,
                            ),
                            markers: markers,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            onMapCreated: (controller) {
                              controller.animateCamera(
                                CameraUpdate.newLatLng(_currentLatLng!),
                              );
                              setState(() {
                                mapController = controller;
                              });
                            },
                            onLongPress: (LatLng latLng) {
                              onLongPressGoogleMap(latLng);
                            },
                          ),
                          if (placemark == null)
                            const SizedBox()
                          else
                            Positioned(
                              bottom: 16,
                              right: 16,
                              left: 16,
                              child: PlacemarkWidget(placemark: placemark!),
                            ),
                        ],
                      ),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
        lat: lat,
        lon: lon,
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