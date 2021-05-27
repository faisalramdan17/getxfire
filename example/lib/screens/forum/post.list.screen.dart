import 'package:getxfire/getxfire.dart';
import 'package:getxfire_example/global_variables.dart';
import 'package:getxfire_example/screens/forum/comment.dart';
import 'package:getxfire_example/screens/forum/comment.form.dart';
import 'package:getxfire_example/screens/forum/display_photos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumListScreen extends StatefulWidget {
  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  String category;

  ForumData forum;
  ScrollController scrollController = ScrollController();

  /// Check if the scroll is at the bottom of the page
  bool get atBottom =>
      scrollController.offset >
      (scrollController.position.maxScrollExtent - 200);

  @override
  void initState() {
    super.initState();
    category = Get.arguments['category'];
    forum = ForumData(
      category: category,
      render: (RenderType x) {
        if (mounted) setState(() {});
      },
    );

    ff.fetchPosts(forum);
    scrollController.addListener(onScrollToBottom);
  }

  ///
  onScrollToBottom() {
    if (!atBottom) return;
    ff.fetchPosts(forum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (ff.notLoggedIn) {
                  Get.snackbar('로그인', '로그인을 먼저 해 주세요.');
                  return;
                }
                if (ff.user.phoneNumber.isBlank &&
                    ff.appSetting('block-non-verified-users-to-create') ==
                        true) {
                  Get.defaultDialog(
                    middleText: 'Please verify your phone number first!',
                    textConfirm: 'Ok',
                    confirmTextColor: Colors.white,
                    onConfirm: () => Get.back(),
                  );
                } else {
                  Get.toNamed('forum-edit', arguments: {'category': category});
                }
              }),
          if (ff.loggedIn)
            StreamBuilder(
                stream: ff.publicDoc.snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) return Container();
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  print('data: ${snapshot.data.data()}');
                  Map<String, dynamic> data = snapshot.data.data();
                  bool postEnabled =
                      data[NotificationOptions.post(category)] ?? false;
                  bool commentEnabled =
                      data[NotificationOptions.comment(category)] ?? false;
                  return Row(children: [
                    IconButton(
                      icon: FaIcon(
                        postEnabled
                            ? FontAwesomeIcons.solidBell
                            : FontAwesomeIcons.solidBellSlash,
                        size: 18,
                      ),
                      onPressed: () async {
                        final String topic = NotificationOptions.post(category);
                        try {
                          if (postEnabled) {
                            // await ff.unsubscribeTopic(topic);
                          } else {
                            // await ff.subscribeTopic(topic);
                          }
                          await ff.updateUserPublic(topic, !postEnabled);
                        } catch (e) {
                          Get.snackbar('Error', e.toString());
                        }
                      },
                    ),
                    IconButton(
                      icon: FaIcon(
                        commentEnabled
                            ? FontAwesomeIcons.solidComment
                            : FontAwesomeIcons.commentSlash,
                        size: 18,
                      ),
                      onPressed: () async {
                        final String topic =
                            NotificationOptions.comment(category);
                        try {
                          if (commentEnabled) {
                            // await ff.unsubscribeTopic(topic);
                          } else {
                            // await ff.subscribeTopic(topic);
                          }
                          await ff.updateUserPublic(topic, !commentEnabled);
                        } catch (e) {
                          Get.snackbar('Error', e.toString());
                        }
                      },
                    ),
                  ]);
                }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: forum.posts.length,
                itemBuilder: (context, i) {
                  Map<String, dynamic> post = forum.posts[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostSubject(post: post),
                      PostContent(post: post),
                      DisplayPhotos(files: post['files']),
                      PostButtons(post: post),
                      Divider(),
                      CommentForm(post: post),
                      if (post['comments'] != null)
                        for (int j = 0; j < post['comments'].length; j++)
                          Comment(post: post, index: j),
                    ],
                  );
                },
              ),
              if (forum.inLoading) CircularProgressIndicator(),
              if (forum.status == ForumStatus.noPosts)
                Text('No post exists in this forum.'),
              if (forum.status == ForumStatus.noMorePosts)
                Text('There is no more post.'),
            ],
          ),
        ),
      ),
    );
  }
}

class PostButtons extends StatelessWidget {
  const PostButtons({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PostEditButton(post: post),
        ElevatedButton(
          onPressed: () async {
            try {
              await ff.deletePost(post['id']);
            } catch (e) {
              Get.snackbar('Error', e.toString());
            }
          },
          child: Text('Delete'),
        ),
        if (ff.voteSetting(post['category'], 'like'))
          ElevatedButton(
            onPressed: () async {
              try {
                await ff.vote(
                  post: post['id'],
                  choice: true,
                );
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            child: Text('Like ${post['likes'] ?? ''}'),
          ),
        if (ff.voteSetting(post['category'], 'dislike'))
          TextButton(
            onPressed: () async {
              try {
                await ff.vote(
                  post: post['id'],
                  choice: false,
                );
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            child: Text('Dislike ${post['dislikes'] ?? ''}'),
          ),
      ],
    );
  }
}

class PostEditButton extends StatelessWidget {
  const PostEditButton({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.toNamed(
        'forum-edit',
        arguments: {'post': post},
      ),
      child: Text('Edit'),
    );
  }
}

class PostContent extends StatelessWidget {
  const PostContent({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(post['content']),
      color: Colors.grey[200],
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      width: double.infinity,
    );
  }
}

class PostSubject extends StatelessWidget {
  const PostSubject({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post['title'],
          style: TextStyle(fontSize: 22),
        ),
        Text(
          post['id'],
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
