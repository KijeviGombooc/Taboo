import 'package:flutter/material.dart';
import 'package:taboo/models/Team.dart';
import 'package:taboo/models/DBHelper.dart';
import 'package:taboo/screens/GameScreen.dart';

class TeamsScreen extends StatefulWidget {
  final gameID;

  const TeamsScreen({required this.gameID});

  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<Team>? teamsData;
  int? currentTeam;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taboo"),
        centerTitle: true,
      ),
      body: teamsData == null || currentTeam == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: teamsData!.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => onTeamTapped(teamsData![i]),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${teamsData![i].getName}"),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (teamsData as List<Team>)[i].score.toString(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => _onGoTeamPressed(context),
                    child: FittedBox(
                        child: Text(
                            "Go ${teamsData![currentTeam as int].getName}!")),
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              fixedSize: MaterialStateProperty.all(
                                Size(350, 100),
                              ),
                              textStyle: MaterialStateProperty.all(
                                Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 60),
                              ),
                            ),
                  ),
                ),
              ],
            ),
    );
  }

  void _loadData() {
    DBHelper.getTeamsData(widget.gameID).then((value) {
      setState(() {
        teamsData = value;
      });
    }).then((value) {
      DBHelper.getCurrentTeam(widget.gameID).then((value) {
        setState(() {
          currentTeam = value;
        });
      });
    });
  }

  void _onGoTeamPressed(ctx) {
    if (teamsData != null && currentTeam != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return GameScreen(
              gameID: widget.gameID,
              teamID: currentTeam as int,
            );
          },
        ),
      ).then(
        (_) {
          _loadData();
          teamsData = null;
          currentTeam = null;
        },
      );
    }
  }

  onTeamTapped(Team team) {
    TextEditingController controller =
        TextEditingController(text: team.getName);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: controller,
              ),
              ElevatedButton(
                onPressed: () {
                  DBHelper.setTeamName(
                    widget.gameID,
                    team.id,
                    controller.text.trim(),
                  ).then((value) {
                    print("adadad");
                    setState(
                      () {
                        team.name = controller.text.trim();
                      },
                    );
                  });
                },
                child: Text("Rename"),
              ),
            ],
          ),
        );
      },
    );
  }
}
