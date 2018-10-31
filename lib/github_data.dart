import 'dart:convert';

List<GitHubData> parseGithubData(String response) {
  final trendingData = json.decode(response)..cast<Map<String, dynamic>>();

  return trendingData
      .map<GitHubData>((json) => GitHubData.fromJson(json))
      .toList();
}

class GitHubData {
  String username;
  String name;
  String url;
  String avatar;
  Repo repo;

  GitHubData({this.username, this.name, this.url, this.avatar, this.repo});

  GitHubData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    url = json['url'];
    avatar = json['avatar'];
    repo = Repo.fromJson(json['repo']);
  }
}

class Repo {
  String name;
  String description;
  String url;

  Repo({this.name, this.description, this.url});

  Repo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    url = json['url'];
  }
}
