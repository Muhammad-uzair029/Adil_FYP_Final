

class UserListModel{

  String _key;
  String _address;
  String _phone;
  String _name;
  int _active;
  String _email;


  UserListModel(this._key, this._address, this._phone, this._name,
      this._active, this._email);


  String get key => _key;

  set key(String value) {
    _key = value;
  }

  int getActive(){
    return _active;
  }

  void setActive(int active){
    this._active = active;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}