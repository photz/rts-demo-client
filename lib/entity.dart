
import 'dart:html';

class Entity {
  var _id;
  var _x;
  var _y;
  Element _element;
  String _class;

  String get classes => _element.classes;
  String get id => _id;

  Entity (this._id, parent) {
    _element = new DivElement();
    _element.classes.add('entity');
    _element.setAttribute('data-id', this._id);
    _class = "";
    parent.append(_element);
  }

  void updatePosition(position) {
    this._x = position["x"] * 10;
    this._y = position["y"] * 10;
    _element.style.left = this._x.toString() + "px";
    _element.style.bottom = this._y.toString() + "px";
  }

  void addClass(cls) {
    _element.classes.add(cls);
  }
}