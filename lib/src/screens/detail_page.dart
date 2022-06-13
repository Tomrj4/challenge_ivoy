import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments;
    final String getDetailAnime = """
    query{
    Media(id: $id) {
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
		  description
      status
      episodes
    }
  }
""";
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail #$id"),
        ),
        body: Query(
          options: QueryOptions(document: gql(getDetailAnime)),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            Map data = result.data?["Media"];
            return ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(data["title"]["romaji"],
                            style: const TextStyle(fontSize: 30)),
                      )),
                      Image.network(
                        data["coverImage"]["large"],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Text(
                                  "Status:",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  data["status"],
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Row(children: <Widget>[
                              const Text(
                                "Episodes:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                data["episodes"].toString(),
                                style: const TextStyle(fontSize: 16),
                              )
                            ]),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child:
                            Text("Descripcion", style: TextStyle(fontSize: 30)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            data["description"]
                                .replaceAll("<br>", "")
                                .replaceAll("<b>", "")
                                .replaceAll("</b>", ""),
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ],
                  );
                });
          },
        ));
  }
}
