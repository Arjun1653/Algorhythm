abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const roadmap = '/roadmap';
  static const log = '/log';
  static const analytics = '/analytics';
  static const review = '/review';
  static const problemDetail = '/problem/:id';
  static const topicDetail = '/topic/:topicId';
  static const settings = '/settings';

  static String problemDetailPath(int id) => '/problem/$id';
  static String topicDetailPath(String topicId) => '/topic/$topicId';
}
