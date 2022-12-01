import 'package:cloud_firestore/cloud_firestore.dart';

extension DocumentSnapshotExtension on DocumentSnapshot {
  get dataAsMap => this.data() as Map<String,dynamic>;
}

