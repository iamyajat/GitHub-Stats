import 'package:flutter/material.dart';
import 'package:githubstats/data/models/github_response.dart';
import 'package:githubstats/utils/strings.dart' as strings;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StatsPage extends StatefulWidget {
  final String username;

  const StatsPage({Key? key, required this.username}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<GithubResponse> githubStats;

  Future<GithubResponse> _getStats() async {
    Uri endpointUri = Uri.parse(strings.endpoint + widget.username);
    var data = await http.get(endpointUri);
    var jsonData = json.decode(data.body);
    GithubResponse user = GithubResponse.fromJson(jsonData);
    return user;
  }

  @override
  void initState() {
    super.initState();
    githubStats = _getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GithubResponse>(
          future: githubStats,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: StatsWidget(
                  user: snapshot.requireData,
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white60,
              ));
            }
          }),
    );
  }
}

class StatsWidget extends StatefulWidget {
  final GithubResponse user;

  const StatsWidget({Key? key, required this.user}) : super(key: key);

  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(((widget.user.name != null
                    ? widget.user.name.toString()
                    : widget.user.login.toString()) +
                "'s GitHub")
            .toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: CircleAvatar(
                              radius: 42,
                              backgroundImage: NetworkImage(
                                  widget.user.avatarUrl.toString())),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text(
                                  widget.user.name != null
                                      ? widget.user.name.toString()
                                      : widget.user.login.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                              ),
                              Text(
                                widget.user.bio != null
                                    ? widget.user.bio
                                        .toString()
                                        .replaceAll("\n", " ")
                                        .replaceAll("\r", "")
                                    : "Bio Unavailable",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontStyle: widget.user.bio != null
                                      ? FontStyle.normal
                                      : FontStyle.italic,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                child: Text(
                                  widget.user.location != null
                                      ? widget.user.location.toString()
                                      : "Location Unavailable",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: widget.user.location != null
                                        ? FontStyle.normal
                                        : FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: Column(
                              children: [
                                Text(
                                  widget.user.followers.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      height: 1.2,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("Followers"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: Column(
                              children: [
                                Text(
                                  widget.user.following.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      height: 1.2,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("Following"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Email: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              String website = widget.user.email.toString();
                              if (website != "") {
                                if (!website.startsWith("http")) {
                                  website = "http://" + website;
                                }
                                launch(website);
                              }
                            },
                            child: Text(
                              widget.user.email != null
                                  ? widget.user.email.toString()
                                  : "Unavailable",
                              style: TextStyle(
                                height: 1.5,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                decoration: widget.user.email != null
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                fontStyle: widget.user.email != null
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Company: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          Text(
                            widget.user.company != null
                                ? widget.user.company.toString()
                                : "Unavailable",
                            style: TextStyle(
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                              fontStyle: widget.user.company != null
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Website: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              String website = widget.user.blog.toString().trim();
                              if (website != "") {
                                if (!website.startsWith("http")) {
                                  website = "http://" + website;
                                }
                                launch(website);
                              }
                            },
                            child: Text(
                              widget.user.blog.toString().trim() != ""
                                  ? widget.user.blog.toString()
                                  : "No Link",
                              style: TextStyle(
                                height: 1.5,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                decoration: widget.user.blog.toString().trim() != ""
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                fontStyle: widget.user.blog.toString().trim() != ""
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Available for hire: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          Text(
                            widget.user.hireable != null ? "Yes" : "No",
                            style: const TextStyle(
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Twitter: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              String website =
                                  widget.user.twitterUsername.toString();
                              if (website != "") {
                                website = "https://twitter.com/" + website;
                                launch(website);
                              }
                            },
                            child: Text(
                              widget.user.twitterUsername != null
                                  ? "@" + widget.user.twitterUsername.toString()
                                  : "Unavailable",
                              style: TextStyle(
                                height: 1.5,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                decoration: widget.user.twitterUsername != null
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                fontStyle: widget.user.twitterUsername != null
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                          child: Column(
                            children: [
                              Text(
                                widget.user.publicRepos.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 30,
                                    height: 1.2,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text("Public Repositories"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                          child: Column(
                            children: [
                              Text(
                                widget.user.publicGists.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 30,
                                    height: 1.2,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text("Public Gists"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => launch(widget.user.htmlUrl.toString()),
                child: const Text("Open in GitHub"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
