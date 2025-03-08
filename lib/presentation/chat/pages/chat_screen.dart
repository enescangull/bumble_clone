import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumble_clone/presentation/chat/bloc/match_bloc.dart';
import 'package:bumble_clone/presentation/chat/bloc/match_event.dart';
import 'package:bumble_clone/presentation/chat/bloc/match_state.dart';
import 'package:bumble_clone/core/services/match_service.dart';
import 'package:bumble_clone/common/components/match_circle_avatar.dart';

import '../../../common/components/chat_list_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchBloc(MatchService())..add(LoadMatches()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Chats",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Matches",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BlocBuilder<MatchBloc, MatchState>(
                builder: (context, state) {
                  if (state is MatchesLoaded) {
                    if (state.unmessagedMatches.isEmpty) {
                      return Container(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            const Text(
                                'Spotlight is the easiest way to up your odds of a match'),
                            const SizedBox(height: 8),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Learn More",
                                ))
                          ],
                        ),
                      );
                    }
                    return Wrap(
                      spacing: 8,
                      children: state.unmessagedMatches
                          .map((match) => MatchCircleAvatar(match: match))
                          .toList(),
                    );
                  } else if (state is MatchError) {
                    return const Text('Error: You have no new match');
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 8),
              Text("Your chats",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BlocBuilder<MatchBloc, MatchState>(builder: (context, state) {
                if (state is MatchesLoaded) {
                  return Column(
                    children: state.messagedMatches
                        .map((match) => ChatListTile(match: match))
                        .toList(),
                  );
                } else {
                  return const Text('You have no messaged matches');
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
