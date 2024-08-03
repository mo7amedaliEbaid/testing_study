import 'package:flutter_test/flutter_test.dart';
import 'package:testing_study/article.dart';
import 'package:testing_study/news_change_notifier.dart';
import 'package:testing_study/news_service.dart';
import 'package:mocktail/mocktail.dart';

/*class MockNewsService implements NewsService {
  @override
  Future<List<Article>> getArticles() {
    return [
      Article(title: "title1", content: "content1"),
      Article(title: "title2", content: "content2"),
      Article(title: "title3", content: "content3"),
    ] as Future<List<Article>>;
  }
}*/
class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test("Initial values are correct", () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });
}
