import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'github_data.dart';

Future<List<GitHubData>> fetchGitHubData(http.Client client) async {
  final response = await client.get(
      'https://github-trending-api.now.sh/developers?language=java&since=daily');
  return compute(parseGithubData, response.body);
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CircleAvatar(
          backgroundImage: NetworkImage(
            "https://camo.githubusercontent.com/7710b43d0476b6f6d4b4b2865e35c108f69991f3/68747470733a2f2f7777772e69636f6e66696e6465722e636f6d2f646174612f69636f6e732f6f637469636f6e732f313032342f6d61726b2d6769746875622d3235362e706e67",
          ),
          backgroundColor: Colors.white,
        ),
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<List<GitHubData>>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          return snapshot.hasData
              ? TrendingDataList(
                  trendingData: snapshot.data,
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
        future: fetchGitHubData(http.Client()),
      ),
    );
  }
}

class TrendingDataList extends StatelessWidget {
  final List<GitHubData> trendingData;

  const TrendingDataList({Key key, this.trendingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: Material(
            child: InkWell(
              child: new Padding(
                padding: EdgeInsets.only(
                    top: 12.0, bottom: 12.0, left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        trendingData[index].avatar,
                      ),
                      radius: 24.0,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${trendingData[index].username}',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            '${trendingData[index].repo.name}',
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.grey[700]),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text('${trendingData[index].repo.description}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => _dialog(context,
                        trendingData[index].url, trendingData[index].repo.url));
              },
            ),
          ),
        );
      },
      itemCount: trendingData.length,
    );
  }

  Widget _dialog(BuildContext context, String profileUrl, String repoUrl) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("Open Profile"),
          onTap: () {
            Navigator.pop(context);
            _launchURL(profileUrl);
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("Open Repository"),
          onTap: () {
            Navigator.pop(context);
            _launchURL(repoUrl);
          },
        ),
      ],
    );
  }

  Future<Null> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
