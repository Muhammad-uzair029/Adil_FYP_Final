
class ShopKeeperProductsModel {

  String _id;
  String _image;
  String _name;
  String _price;
  String _description;
  String _user;
  int _active;


  ShopKeeperProductsModel(this._id, this._image, this._name, this._price,
      this._description, this._user);


  String get user => _user;

  set user(String value) {
    _user = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get image => _image;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  set image(String value) {
    _image = value;
  }
}