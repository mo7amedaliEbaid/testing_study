import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:testing_study/article.dart';
import 'package:testing_study/article_page.dart';
import 'package:testing_study/news_change_notifier.dart';
import 'package:testing_study/news_page.dart';
import 'package:testing_study/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: "title1", content: "content1"),
    Article(title: "title2", content: "content2"),
    Article(title: "title3", content: "content3"),
  ];
  void arrangeNewsServiceReturnsArticles() {
    when(() => mockNewsService.getArticles())
        .thenAnswer((_) async => articlesFromService);
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets("tapping on the first article opens the article page",
      (widgetTester) async {
    arrangeNewsServiceReturnsArticles();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump();
    await widgetTester.tap(find.text("content1"));
    await widgetTester.pumpAndSettle();
    expect(find.byType(NewsPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
    expect(find.text("title1"), findsOneWidget);
    expect(find.text("content1"), findsOneWidget);
  });
}
