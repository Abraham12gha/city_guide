import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_app/models/attraction_model.dart';
import '../../services/attraction_firestore.dart';


final attractionsProvider =
StreamProvider<List<AttractionModel>>((ref) {

  final service = AttractionService();

  return service.getAttractions();
});