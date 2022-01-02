import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learn/app/home/account/account_page.dart';
import 'package:flutter_learn/app/home/community/post_detail_page.dart';
import 'package:flutter_learn/app/home/community/posts_page.dart';
import 'package:flutter_learn/app/home/desktop/community_screen.dart';
import 'package:flutter_learn/app/home/desktop/widgets/side_menu.dart';
import 'package:flutter_learn/app/home/fcm_view_model.dart';
import 'package:flutter_learn/app/home/tab_item.dart';
import 'package:flutter_learn/constants/keys.dart';
import 'package:flutter_learn/constants/responsive.dart';
import 'package:flutter_learn/controllers/menu_controller.dart';
import 'package:flutter_learn/models/post.dart';
//import 'package:flutter_learn/secret_keys.dart';
import 'package:flutter_learn/services/fcm_service.dart';
import 'package:flutter_learn/services/firebase_auth_service.dart';
import 'package:flutter_learn/services/firestore_database.dart';
import 'package:flutter_learn/translations/locale_keys.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmModelProvider =
    StateNotifierProvider<FcmViewModel, String?>((ref) => FcmViewModel());

class HomePage extends StatefulHookWidget {
  const HomePage({required this.analytics, required this.observer});
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _screens = [
    PostsPage(),
    //PlaylistPage(),
    AccountPage(),
  ];
  int _selectedIndex = 0;

  Future<void> _sendAnalyticsEvent(String eventName) async {
    await widget.analytics.logEvent(
      name: eventName,
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    print('logEvent succeeded');
  }

  Future<void> setPostsBatch(List<Post> posts) async {
    final database = context.read(databaseProvider);
    for (final post in posts) {
      await Future.delayed(Duration(milliseconds: 100));
      await database.setPost(post);
    }
  }

  void _submitMockPosts() {
    final posts = List.generate(10, (_) => Post.random());
    setPostsBatch(posts);
    _sendAnalyticsEvent('_submitMockPosts');
  }

  @override
  void initState() {
    super.initState();
    final fcm = context.read(fcmServiceProvider);
    fcm.setupInteractedPost();
  }

  @override
  Widget build(BuildContext context) {
    final appUser = useProvider(appUserStreamProvider).data?.value;
    final fcmModel = useProvider(fcmModelProvider);

    useEffect(() {
      print('fcmModel: $fcmModel');
      if (fcmModel != null) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          PostDetailPage.show(context, postId: fcmModel);
          context.read(fcmModelProvider.notifier).setPageOpenPostId(null);
        });
      }
    });
    print('HomePage appUser: $appUser');

    return Scaffold(
      floatingActionButton:
          appUser?.id == 'sPGSy6SVI1UYCH1F9C0b0JPrDMk2' || appUser?.id == 'sPGSy6SVI1UYCH1F9C0b0JPrDMk2'
              ? FloatingActionButton(
                  mini: true,
                  onPressed: _submitMockPosts,
                  child: Text(
                    LocaleKeys.test.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                )
              : null,
      key: context.read(menuControllerProvider).scaffoldKey,
      drawer: Responsive.isDesktop(context) ? const SideMenu() : null,
      body: Responsive.isDesktop(context)
          ? CommunityScreen()
          : _screens[_selectedIndex],
      // IndexedStack(
      //     index: _selectedIndex,
      //     children: _screens,
      //   ),
      bottomNavigationBar: Responsive.isDesktop(context)
          ? const SizedBox()
          : BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              elevation: 1.0,
              key: const Key(Keys.bottomNavigationBar),
              items: [
                _buildItem(TabItem.community),
                //_buildItem(TabItem.youTube),
                _buildItem(TabItem.more),
              ],
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;
    return BottomNavigationBarItem(
        icon: Icon(itemData.icon), label: itemData.label);
  }
}
