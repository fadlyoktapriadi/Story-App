import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/detail/detail_provider.dart';
import 'package:story_app/result/story_detail_result_state.dart';
import 'package:story_app/screen/components/placemark_comp.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final Function() onBack;

  const DetailScreen({super.key, required this.id, required this.onBack});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Set<Marker> markers = {};

  void _defineMarker(LatLng latLng, String address) {
    final marker = Marker(
      markerId: const MarkerId("story_location"),
      position: latLng,
      infoWindow: InfoWindow(title: address),
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  void initState() {
    Future.microtask(() {
      context.read<DetailProvider>().getDetailStory(widget.id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Story",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Consumer<DetailProvider>(
          builder: (context, provider, child) {
            if (provider.state is StoryDetailLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state is StoryDetailErrorState) {
              return Center(
                child: Text((provider.state as StoryDetailErrorState).error),
              );
            } else if (provider.state is StoryDetailSuccessState) {
              final story =
                  (provider.state as StoryDetailSuccessState).story.story;
              return Stack(
                children: [
                  Hero(
                    tag: story.id,
                    child: Image.network(
                      story.photoUrl,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      height: 320,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image),
                        );
                      }
                    ),
                  ),
                  ListView(
                    children: [
                      const SizedBox(height: 300),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.account_circle),
                                          const SizedBox(width: 4),
                                          Text(
                                            story.name,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        DateFormat(
                                          'yyyy-MM-dd HH:mm',
                                        ).format(story.createdAt),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    story.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            if (story.lat != null && story.lon != null) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 300,
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(story.lat!, story.lon!),
                                        zoom: 15,
                                      ),
                                      markers: markers,
                                      mapToolbarEnabled: true,
                                      myLocationButtonEnabled: false,
                                      onMapCreated: (controller) async {
                                        final info = await geo
                                            .placemarkFromCoordinates(
                                              story.lat!,
                                              story.lon!,
                                            );
                                        final place = info[0];
                                        _defineMarker(
                                          LatLng(story.lat!, story.lon!),
                                          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
