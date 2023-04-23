class TContact {
  //These are private properties and all 3 are nullable
  int? _id;
  String? _number;
  String? _name;

  //These are two constructors
  TContact(this._number, this._name); //Doesnt assign value to _id property
  TContact.withID(this._id, this._number, this._name); //Assigns value to prprty

  //getters used to get the value. When id is called, getter setter is called
  String get number => _number!;
  String get name => _name!;
  int get id => _id!;

  @override // ASk GPT
  // this function converts and saves id, number, name to string
  String toString() {
    return 'Contact: { id: $_id, name: $_name, number: $_number}';
  }

  //setters set new values for two properties
  set number(String newNumber) => this._number = newNumber;
  set name(String newName) => this._name = newName;

  // Convert a 'contact' object to ;map' object
  // Function is used whenever we try to put data into database
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = this._id;
    map['number'] = this._number;
    map['name'] = this._name;

    return map;
  }

  //Extract a 'contact' object from a 'Map' object
  TContact.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._number = map['number'];
    this._name = map['name'];
  }
}
// This is contacts map page
