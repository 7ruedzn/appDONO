import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  Future<QuerySnapshot> getDocumentsByCategory(String _category) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("produtos")
        .document(_category)
        .collection("produtos")
        .getDocuments();
    return querySnapshot;
  }
}
