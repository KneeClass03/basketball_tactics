import 'package:flutter/material.dart';

typedef PlayerSelectedCallback = Function(int id, bool hasBall);

abstract class TwoPlayersSelectedNotification extends Notification {
  const TwoPlayersSelectedNotification({
    required this.initiatorId,
    required this.receiverId,
  });

  final int initiatorId;
  final int receiverId;
}

class PassNotification extends TwoPlayersSelectedNotification {
  PassNotification({required super.initiatorId, required super.receiverId});
}

class ScreenNotification extends TwoPlayersSelectedNotification {
  ScreenNotification({required super.initiatorId, required super.receiverId});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Tactics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: AttackingTeam(),
      ),
    );
  }
}

class AttackingTeam extends StatefulWidget {
  AttackingTeam({super.key});

  final List<Attacker> players = <Attacker>[];
  // a list of each player's mutable state; needed for calculations (probably bad design)
  // final List<AttackerState> playerStates = <AttackerState>[];

  @override
  State<AttackingTeam> createState() => _AttackingTeamState();
}

class _AttackingTeamState extends State<AttackingTeam> {
  List<int> playersInActionInvolved = <int>[];
  bool ballInActionInvolved = false;

  @override
  void initState() {
    super.initState();
    widget.players.addAll(List<Attacker>.generate(
      5,
      (index) => Attacker(
        team: widget,
        id: index,
        onPlayerSelected: registerSelectedPlayer,
        startsWithBall: index == 2,
      ),
      growable: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.players,
    );
  }

  void registerSelectedPlayer(int id, bool hasBall) {
    ballInActionInvolved = !(ballInActionInvolved || hasBall);
    playersInActionInvolved.add(id);

    if (playersInActionInvolved.length >= 2) {
      if (ballInActionInvolved) {
        print('pass');
        /* PassNotification(
          initiatorId: playersInActionInvolved[0],
          receiverId: playersInActionInvolved[1],
        ).dispatch(context); */
      } else {
        print('screen');
        /* ScreenNotification(
          initiatorId: playersInActionInvolved[0],
          receiverId: playersInActionInvolved[1],
        ).dispatch(context); */
      }
      playersInActionInvolved.clear();
      ballInActionInvolved = false;
    }
  }
}

/// This class represents a offensive player and offers functionality like
/// selection, movement (TODO), passing (TODO)
/// TODO: implement interface Player that both Attacker and Defender derive from
class Attacker extends StatefulWidget {
  const Attacker({
    required this.team,
    required this.id,
    required this.onPlayerSelected,
    required this.startsWithBall,
    Key? key,
  }) : super(key: key);
  // unique id (for the team)
  final int id;
  // the team the player is playing for
  final AttackingTeam team;
  final PlayerSelectedCallback onPlayerSelected;
  final bool startsWithBall;

  @override
  State<Attacker> createState() => AttackerState();
}

/// This class manages the mutable state of an attacker, so far only concerning
/// selection.
/// IDEA: So far the concept was to select the player with a tap, then send him
/// to a location with the second tap. Tapping might be a better fit for passing the ball,
/// while movement can be initiated with a drag gesture.
class AttackerState extends State<Attacker> {
  // bool _selected = false;
  // bool get selected => _selected;
  bool isBallHandler = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleOnTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: buildChildren(),
      ),
    );
  }

  void handleOnTap() {
    setState(() {
      widget.onPlayerSelected(widget.id, isBallHandler);
    });
  }

  /// Adds the state to the teams list for processing reasons (probably bad design)
  @override
  void initState() {
    super.initState();
    isBallHandler = widget.startsWithBall;
  }

  List<Widget> buildChildren() {
    var builder = <Widget>[
      Container(
        height: 50.0,
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.transparent,
        ),
      ),
      Container(
        height: 25.0,
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Color.fromARGB(255, 75, 75, 75),
        ),
      ),
      Container(
        height: 15.0,
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.black87,
        ),
      ),
    ];

    if (isBallHandler) builder.add(const Basketball());

    return builder;
  }

  /// Toggles the _selected variable depending on if other players are already selected.
  /* void _toggleSelect() {
    setState(() {
      _selected = !_selected;
    });
  } */
}

class Basketball extends StatelessWidget {
  const Basketball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      width: 15.0,
      height: 15.0,
      image: AssetImage('images/basketball.png'),
    );
  }
}
