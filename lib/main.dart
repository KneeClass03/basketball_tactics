import 'package:flutter/material.dart';

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

/// This class manages everything concerning the attacking team.
/// TODO: implement interface TEAM because DefendingTeam needs to be implemented as well
class AttackingTeam extends StatelessWidget {
  AttackingTeam({super.key}) {
    // lock the size of the team to 5 players
    players = List<Attacker>.generate(
      5,
      (index) => Attacker(
        team: this,
        id: index,
      ),
      growable: false,
    );
  }

  late final List<Attacker> players;
  // a list of each player's mutable state; needed for calculations (probably bad design)
  final List<AttackerState> playerStates = <AttackerState>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: players,
    );
  }

  /// Iterates through each player and checks if any of them are selected
  bool otherPlayerSelected(int id) {
    for (int i = 0; i < players.length; i++) {
      if (playerStates[i].selected) {
        return true;
      }
    }
    return false;
  }

  void addState(AttackerState state) {
    playerStates.add(state);
  }
}

/// This class represents a offensive player and offers functionality like
/// selection, movement (TODO), passing (TODO)
/// TODO: implement interface Player that both Attacker and Defender derive from
class Attacker extends StatefulWidget {
  const Attacker({required this.team, required this.id, Key? key})
      : super(key: key);
  // unique id (for the team)
  final int id;
  // the team the player is playing for
  final AttackingTeam team;

  @override
  State<Attacker> createState() => AttackerState();
}

/// This class manages the mutable state of an attacker, so far only concerning
/// selection.
/// IDEA: So far the concept was to select the player with a tap, then send him
/// to a location with the second tap. Tapping might be a better fit for passing the ball,
/// while movement can be initiated with a drag gesture.
class AttackerState extends State<Attacker> {
  bool _selected = false;
  bool get selected => _selected;

  @override
  Widget build(BuildContext context) {
    Stack stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        // this bigger circle only shows up when the player is selected
        Container(
          height: 50.0,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: _selected ? Colors.black26 : Colors.transparent,
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
      ],
    );

    return GestureDetector(
      onTap: _toggleSelect,
      child: stack,
    );
  }

  /// Adds the state to the teams list for processing reasons (probably bad design)
  @override
  void initState() {
    super.initState();
    widget.team.addState(this);
  }

  /// Toggles the _selected variable depending on if other players are already selected.
  void _toggleSelect() {
    setState(() {
      _selected = !widget.team.otherPlayerSelected(widget.id);
    });
  }
}
