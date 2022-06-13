import 'package:challenge_ivoy/src/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  final String getAnimes = """
    query{
      Page(
       page:2
        perPage:10
     ){
        media {
         id
          coverImage {
            extraLarge
           large
           medium
            color
         }
         title {
           romaji
            english
            native
           userPreferred
      }
    }
  }
}
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Query(
            options: QueryOptions(document: gql(getAnimes)),
            builder: (QueryResult result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              List media = result.data?["Page"]["media"];

              return Center(
                child: ListView.builder(
                  itemCount: media.length,
                  itemBuilder: (context, index) {
                    final name = media[index]["title"]["romaji"];
                    final image = media[index]["coverImage"]["large"];
                    final id = media[index]["id"];
                    // print(name);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          subtitle: Text(id.toString()),
                          title: Text(name),
                          leading: Image.network(
                            image,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/detail",
                                arguments: id);
                          }),
                    );
                  },
                ),
              );
            }));
  }
}
