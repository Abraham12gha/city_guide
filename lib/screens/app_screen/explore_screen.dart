import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../map/provider/attraction_provider.dart';
import '../../map/screens/direction_screen.dart';
import '../../map/services/location_service.dart';
import '../../map/widget/attraction_bottom_sheet.dart';
import '../../map/widget/attraction_marker.dart';
import 'attraction_detail.dart';


class ExploreMapScreen extends ConsumerStatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  ConsumerState<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends ConsumerState<ExploreMapScreen> {
  LatLng? userLocation;


  final locationService = LocationService();

final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final attractionsAsync =
    ref.watch(attractionsProvider);

    const cityCenter = LatLng(
      24.8607,
      67.0011,
    );




    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton:
      FloatingActionButton(
        backgroundColor: Colors.white,

        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),

        onPressed: () async {
          final position = await locationService.getLocationIfAvailable();
          if (position == null) {

            if (!mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Location unavailable',
                ),
              ),
            );

            return;
          }

          setState(() {
            userLocation = LatLng(
              position.latitude,
              position.longitude,
            );
          });


          mapController.move(
            LatLng(
              position.latitude,
              position.longitude,
            ),
            15,
          );
        },
      ),

      body: attractionsAsync.when(
        data: (attractions) {
            print(
              'Attractions Count: ${attractions.length}',
            );

            for (final attraction in attractions) {
              print(
                '${attraction.name} '
                    '${attraction.latitude}, '
                    '${attraction.longitude}',
              );
            }

          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: cityCenter,
              initialZoom: 6,
            ),

            children: [

              TileLayer(
                urlTemplate:
                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const [
                  'a',
                  'b',
                  'c',
                  'd',
                ],
              ),

              MarkerLayer(
                markers: attractions.map((attraction) {

                  return Marker(
                    point: LatLng(
                      attraction.latitude,
                      attraction.longitude,
                    ),

                    width: 50,
                    height: 50,


                    child: AttractionMarker(
                      attraction: attraction,

                      onTap: () {

                        showModalBottomSheet(
                          context: context,

                          builder: (_) {
                            return AttractionBottomSheet(
                              attraction: attraction,

                              onDetails: () {

                              },

                              onDirections: () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DirectionScreen(
                                      destinationName:
                                      attraction.name,

                                      destinationLatitude:
                                      attraction.latitude,

                                      destinationLongitude:
                                      attraction.longitude,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );

                }).toList(),

              ),

              if (userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLocation!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.location_history,
                        color: Colors.blue,
                        size: 35,
                      ),
                    ),
                  ],
                ),
            ],
          );
        },

        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (error, stack) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
      ),


    );
  }
}