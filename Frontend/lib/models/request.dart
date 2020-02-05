class Request {
  Request.complete(String ref, bool approved, bool open,
      String approvedByUserId, String hydrantId, String requestedByUserId) {
    this._id = ref;
    this._approved = approved;
    this._approvedByUserId = approvedByUserId;
    this._hydrantId = hydrantId;
    this._requestedByUserId = requestedByUserId;
    this._open = open;
  }
  String _id;
  bool _approved;
  bool _open;
  String _approvedByUserId;
  String _hydrantId;
  String _requestedByUserId;

  Request(
      bool approved, bool open, String hydrantId, String requestedByUserId) {
    this._id = null;
    this._approved = approved;
    this._approvedByUserId = null;
    this._hydrantId = hydrantId;
    this._requestedByUserId = requestedByUserId;
    this._open = open;
  }
  bool getApproved() {
    return _approved;
  }

  String getApprovedByUserId() {
    return _approvedByUserId;
  }

  void setApprovedByUserId(String id) {
    this._approvedByUserId = id;
  }

  String getHydrantId() {
    return _hydrantId;
  }

  String getRequestedByUserId() {
    return _requestedByUserId;
  }

  String getId() {
    return _id;
  }

  bool isOpen() {
    return _open;
  }

  void setApproved(bool approved) {
    this._approved = approved;
  }

  void setOpen(bool open) {
    this._open = open;
  }
}
