import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/home/home_provider.dart';
import 'package:story_app/provider/login/auth_provider.dart';
import 'package:story_app/result/story_stories_result_state.dart';
import 'package:story_app/screen/components/item_card_story.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onTap;
  final Function() onLogout;
  final Function() onAddStory;

  const HomeScreen({super.key, required this.onTap, required this.onLogout, required this.onAddStory});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<HomeProvider>().getStories();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Storyfy",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Handle logout action
              await context.read<AuthProvider>().logout();
              widget.onLogout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          widget.onAddStory();
        },
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.state is StoryStoriesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state is StoryStoriesErrorState) {
              return Center(
                child: Text((provider.state as StoryStoriesErrorState).error),
              );
            } else if (provider.state is StoryStoriesSuccessState) {
              final stories =
                  (provider.state as StoryStoriesSuccessState)
                      .stories
                      .listStory;
              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return ItemCardStory(
                    onTap: () {
                      widget.onTap(
                        story.id,
                      );
                    },
                    story: story,
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
