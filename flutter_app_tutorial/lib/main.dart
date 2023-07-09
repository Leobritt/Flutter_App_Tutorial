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
  void toggleFavorite() {
    if (favorites.contains((current))) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
/*O ambiente de desenvolvimento integrado cria uma nova classe para você, _MyHomePageState. 
Essa classe estende State e, portanto, pode gerenciar os próprios valores. Ela pode mudar a si mesma*/

/*classe privado indicada pelo _*/
class _MyHomePageState extends State<MyHomePage> {
  //O novo widget com estado só precisa rastrear uma variável: selectedIndex. Faça as três mudanças abaixo em _MyHomePageState:
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //usando o selectedIndex para determina qual tela mostrar

    /*var page do tipo Widget
    uma instrução switch atribui uma tela a page, de acordo com o valor atual em selectedIndex
    Como ainda não há uma FavoritesPage, use um Placeholder, um widget útil que desenha um retângulo cruzado onde quer que você o coloque,
    marcando essa parte da interface como incompleta
    */
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            /*A SafeArea garante que os filhos não sejam ocultos por um entalhe de 
              hardware ou uma barra de status*/
            SafeArea(
              /*o widget une a NavigationRail para evitar que os botões de navegação sejam ocultos 
                por uma barra de status móvel */
              child: NavigationRail(
                //extend mostra os rótulos ao lado dos ícones se o tamanho de tela for mair >= 600px.
                extended: constraints.maxWidth >= 600,
                //destinos de navegação
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                //O índice zero selecionado indica o primeiro destino
                selectedIndex: selectedIndex,
                /*A coluna de navegação também define o que acontece quando o usuário seleciona um dos destinos 
                  com onDestinationSelected.*/
                onDestinationSelected: (value) {
                  //setState(). Essa chamada é semelhante ao método notifyListeners() usado antes. Ela garante a atualização da interface.
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),

            //Os widgets expandidos são extremamente úteis em linhas e colunas.
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                //alterando a page
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
