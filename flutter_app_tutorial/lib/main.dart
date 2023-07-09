import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Fluterr App Tutorial',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  //Adicionando a funcionalidade
  var favorites = <WordPair>[];

  /* que remove o par de palavras atual da lista de favoritos (se já estiver lá) ou o adiciona 
  (se ainda não estiver)
  */
  void toggleFacorite() {
    if (favorites.contains((current))) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //acessadno os métodos do MyappState pela var appState
    var appState = context.watch<MyAppState>();
    //
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            //criar "lacuna" visuais
            SizedBox(
              height: 18,
            ),
            Row(
              //colcoando os botoes um do lado do outro
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFacorite();
                  },
                  icon: Icon(icon),
                  label: Text('like'),
                ),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    //Ao usar theme.textTheme,, você acessa o tema da fonte do app.
    //Teoricamente, a propriedade displayMedium do tema pode ser null ! operador p avisar que pode ser null
    //copyWith() retorna uma cópia do estilo de texto com as mudanças definidas
    //o padding Ñ é atributo de Text e SIM um Widget
    return Card(
      elevation: 10.0,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          //semanticsLabel substituir o conteúdo visual do widget de texto por um conteúdo semântico mais apropriado para leitores de tela:
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
