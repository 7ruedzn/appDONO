import 'package:cloud_firestore/cloud_firestore.dart';

class ExceptionManager {
  static catchUpdateError(dynamic e) {
    Map<String, dynamic> error = {};
    error["$e"] = e;
    Firestore.instance.collection("errors").add(error);
  }
}
