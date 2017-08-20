import 'dart:html';
import 'dart:convert';
import 'package:rts_demo_client/entity.dart';

class GameMap {
  Map _entities;
  Element _element;
  var _playerId;

  GameMap() {
    _entities = new Map<int, Entity>();
    _element = new DivElement();
    _element.classes.add("map");
    document.body.append(_element);
    _element.onMouseDown.listen(this._onMouseDown);
  }

  void _onMouseDown(MouseEvent e) {
    var id = e.target.getAttribute('data-id');
    print(id);
    if (id == null)
    {
      return;
    }

    Entity ent = _getEntityById(id);
    print(ent.classes);
  }

  Entity _getEntityById(id) {
    if (!_entities.containsKey(id))
    {
      _entities[id] = new Entity(id, this._element);
    }
    return _entities[id];
  }

  void setPlayerId(playerId) {
    _playerId = playerId;
  }

  void setPointMasses(pointMasses) {
    pointMasses.forEach((entityId, pointMass) {
      Entity ent = _getEntityById(entityId);
      ent.updatePosition(pointMass["position"]);
    });
  }

  void setResources(resources) {
    resources.forEach((entityId, resource) {
      Entity ent = _getEntityById(entityId);
      ent.addClass("entity-resource");
    });
  }

  void setOwnership(ownerships) {
    ownerships.forEach((entityId, playerId) {
      if (playerId.toString() == _playerId.toString()) {
        Entity ent = _getEntityById(entityId);
        ent.addClass("entity-allied");
      }
    });
  }

  void setUnitFactories(factories) {
    factories.forEach((entityId, fctry) {
      Entity ent = _getEntityById(entityId);
      ent.addClass("entity-factory");
    });
  }
}