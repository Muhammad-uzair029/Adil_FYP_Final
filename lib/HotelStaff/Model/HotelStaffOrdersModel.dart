class HotelStaffOrdersModel {
  String _orderID;
  String _userID;
  String _userName;
  String _userEmail;
  String _userPhone;
  String _userAddress;
  String _productID;
  String _productName;
  String _productPrice;
  String _HotelStaffID;
  String _status;
  String _shippingstatus;

  HotelStaffOrdersModel(
    this._orderID,
    this._userID,
    this._userName,
    this._userEmail,
    this._userPhone,
    this._userAddress,
    this._productID,
    this._productName,
    this._productPrice,
    this._HotelStaffID,
    this._status,
    this._shippingstatus,
  );

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  setStatus(String status) {
    this.status = status;
  }

  String get shippingstatus => _shippingstatus;

  set shippingstatus(String value) {
    _shippingstatus = value;
  }

  setshippingstatus(String status) {
    this.shippingstatus = status;
  }

  String get HotelStaffID => _HotelStaffID;

  set HotelStaffID(String value) {
    _HotelStaffID = value;
  }

  String get productPrice => _productPrice;

  set productPrice(String value) {
    _productPrice = value;
  }

  String get productName => _productName;

  set productName(String value) {
    _productName = value;
  }

  String get productID => _productID;

  set productID(String value) {
    _productID = value;
  }

  String get userAddress => _userAddress;

  set userAddress(String value) {
    _userAddress = value;
  }

  String get userPhone => _userPhone;

  set userPhone(String value) {
    _userPhone = value;
  }

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  String get orderID => _orderID;

  set orderID(String value) {
    _orderID = value;
  }
}
