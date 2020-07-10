import 'package:drag_and_drop_lists/drag_and_drop_list_expansion.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ExpansionTileExample extends StatefulWidget {
  ExpansionTileExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListTileExample createState() => _ListTileExample();
}

class InnerList {
  final String name;
  List<String> children;
  InnerList({this.name, this.children});
}

class _ListTileExample extends State<ExpansionTileExample> {
  List<InnerList> _lists;

  @override
  void initState() {
    super.initState();

    _lists = List.generate(4, (outerIndex) {
      return InnerList(
        name: outerIndex.toString(),
        children: List.generate(6, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expansion Tiles'),
      ),
      drawer: NavigationDrawer(),
      body: DragAndDropLists(
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        // listGhost is mandatory when using expansion tiles to prevent multiple widgets using the same globalkey
        listGhost: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 100.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Icon(Icons.add_box),
            ),
          ),
        ),
      ),
    );
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    return DragAndDropListExpansion(
      title: Text('List ${innerList.name}'),
      subtitle: Text('Subtitle ${innerList.name}'),
      leading: Icon(Icons.ac_unit),
      children: List.generate(innerList.children.length, (index) => _buildItem(innerList.children[index])),
      key: PageStorageKey<InnerList>(innerList),
    );
  }

  _buildItem(String item) {
    return DragAndDropItem(
      child: ListTile(
        title: Text(item),
      ),
    );
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}