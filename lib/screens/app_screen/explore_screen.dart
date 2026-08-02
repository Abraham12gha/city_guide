import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../map/provider/attraction_provider.dart';
import '../../map/screens/direction_screen.dart';
import '../../map/services/location_service.dart';
import '../../map/widget/attraction_bottom_sheet.dart';
import '../../map/widget/attraction_marker.dart';
import '../../services/home_firestore.dart';
import 'attraction_detail.dart';


class ExploreMapScreen extends ConsumerStatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  ConsumerState<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends ConsumerState<ExploreMapScreen> {
  static const primaryColor = Color(0xFF14B8A6);
  final HomeFirestore homeFirestore = HomeFirestore();
  Set<String> favoriteIds = {};

  LatLng? userLocation;

  final locationService = LocationService();

  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = await homeFirestore.loadFavorites();

    setState(() {
      favoriteIds = favorites;
    });
  }
  Widget build(BuildContext context) {
    final attractionsAsync = ref.watch(attractionsProvider);

    const cityCenter = LatLng(
      24.8607,
      67.0011,
    );

    return Scaffold(
      backgroundColor: Colors.white,


      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        elevation: 3,

        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),

        onPressed: () async {
          final position = await locationService.getLocationIfAvailable();
          if (position == null) {

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Location unavailable',
                ),
                backgroundColor: Colors.grey.shade800,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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

          return FlutterMap(
            mapController: mapController,
            options: const MapOptions(
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
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,

                          builder: (_) {
                            return AttractionBottomSheet(
                              attraction: attraction,

                              onDetails: () async {

                                final doc = await homeFirestore.getAttractionById(
                                  attraction.id,
                                );

                                if (doc == null) return;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AttractionDetail(
                                      attraction: doc,
                                      isFavorite: favoriteIds.contains(attraction.id),
                                    ),
                                  ),
                                );
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
                      width: 28,
                      height: 28,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        },

        error: (error, stack) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey.shade400,
                    size: 46,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}