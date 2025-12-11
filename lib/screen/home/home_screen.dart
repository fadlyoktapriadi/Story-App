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

  const HomeScreen({
    super.key,
    required this.onTap,
    required this.onLogout,
    required this.onAddStory,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(
      () => context.read<HomeProvider>().getStories(refresh: true),
    );
  }

  void _onScroll() {
    final provider = context.read<HomeProvider>();
    if (!provider.hasMorePages) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.getStories();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
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
                child: Padding(padding: const EdgeInsets.all(12.0),
                  child: Text("Story data could not be loaded. Please try again."),
                ),
              );
            } else if (provider.state is StoryStoriesSuccessState) {
              final stories = provider.stories;
              return RefreshIndicator(
                onRefresh:
                    () =>
                        context.read<HomeProvider>().getStories(refresh: true),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: stories.length + (provider.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == stories.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final story = stories[index];
                    return ItemCardStory(
                      story: story,
                      onTap: () => widget.onTap(story.id),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
