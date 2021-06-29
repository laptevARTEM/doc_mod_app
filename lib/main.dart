import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _sugg = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggF = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSugg(),
    );
  }
  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // ignore: missing_return
        builder: (BuildContext context){
          final tiles = _saved.map(
              (WordPair pair){
                return ListTile(
                  title :Text(
                    pair.asPascalCase,
                    style: _biggF,
                  // ignore: missing_return
                  )
                );
              },
          );
          final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              :<Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Names'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }
  Widget _buildSugg(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context,i){
        if(i.isOdd) return const Divider();
        final index = i~/2;
        if(index>=_sugg.length){
          _sugg.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_sugg[index]);
      }
    );
  }
  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggF,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.green : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }
          else{
            _saved.add(pair);
          }
        });
      },
    );
  }
}
