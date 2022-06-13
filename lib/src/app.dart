import 'package:challenge_ivoy/src/screens/detail_page.dart';
import 'package:challenge_ivoy/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyApp extends StatelessWidget {
  final HttpLink httplink = HttpLink('https://graphql.anilist.co/');
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(cache: GraphQLCache(), link: httplink));
    return GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'Material App',
          initialRoute: "/",
          routes: {
            "/": (context) => const HomePage(),
            "/detail": (context) => DetailPage()
          },
        ));
  }
}
