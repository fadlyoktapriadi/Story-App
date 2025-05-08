import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/data/api/response/story_detail_response.dart';

class ItemCardStory extends StatelessWidget {
  final Function onTap;
  final Story story;

  const ItemCardStory({super.key, required this.onTap, required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: story.id,
                    child: Image.network(
                      story.photoUrl,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          const Icon(Icons.account_circle),
                          const SizedBox(width: 4),
                          Text(
                            story.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(story.createdAt),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  story.description,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
