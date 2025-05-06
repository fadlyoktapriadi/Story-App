import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/home/home_provider.dart';
import 'package:story_app/result/story_stories_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
                  final stories = (provider.state as StoryStoriesSuccessState).stories.listStory;
                  return ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return InkWell(
                        child: Card(
                          child: Column(
                            children: [
                              Image.network(
                                story.photoUrl,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                              Text(
                                story.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Expanded(
                              //   child: Image.network(
                              //     stories.elementAt(index).photoUrl,
                              //     fit: BoxFit.cover,
                              //     height: 200,
                              //   ),
                              // ),
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         story.name,
                              //         style: const TextStyle(
                              //           fontSize: 20,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       Text(
                              //         story.description,
                              //         style: const TextStyle(fontSize: 16),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
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
