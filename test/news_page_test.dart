import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:testing_study/article.dart';
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

  void arrangeNewsServiceReturnsArticlesAfter2Seconds() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articlesFromService;
    });
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

  testWidgets("title is displayed", (widgetTester) async {
    arrangeNewsServiceReturnsArticles();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    expect(find.text("News"), findsOneWidget);
  });
  testWidgets("loading indicator is displayed while waiting for articles",
      (widgetTester) async {
    arrangeNewsServiceReturnsArticlesAfter2Seconds();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await widgetTester.pumpAndSettle();
  });
}
