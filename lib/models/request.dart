import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  Request(String ref, bool approved, bool open, String approvedBy,
      String hydrant, String requestedBy) {
    this._reference = ref;
    this._approved = approved;
    this._approvedBy = approvedBy;
    this._hydrant = hydrant;
    this._requestedBy = requestedBy;
    this._open = open;
  }
  String _reference;
  bool _approved;
  bool _open;
  String _approvedBy;
  String _hydrant;
  String _requestedBy;

  bool getApproved() {
    return _approved;
  }

  String getApprovedBy() {
    return _approvedBy;
  }

  String getHydrant() {
    return _hydrant;
  }

  String getRequestedBy() {
    return _requestedBy;
  }

  String getDBReference() {
    return _reference;
  }

  bool getOpen() {
    return _open;
  }
}
