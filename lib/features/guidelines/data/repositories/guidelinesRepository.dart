import 'package:avetol/features/guidelines/data/dataSources/guidelinesDataSource.dart';
import 'package:avetol/features/guidelines/data/models/appInfo.dart';
import 'package:avetol/features/guidelines/data/models/feedback.dart';
import 'package:avetol/features/guidelines/data/models/feedbackTypes.dart';

class GuidelinesRepository {
  GuidelinesRemoteDataSource guidelinesRemoteDataSource;
  GuidelinesRepository(this.guidelinesRemoteDataSource);
  Future<Guidelines> getAppInfo() async {
    try {
      final appInfo = await guidelinesRemoteDataSource.getGuidelines();
      return appInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<List<FeedbackTypes>> getFeedbackTypes() async {
    try {
      final feedbackTypes = await guidelinesRemoteDataSource.getFeedbackTypes();
      return feedbackTypes;
    } catch (e) {
      throw e;
    }
  }

  Future giveFeedback(FeedbackModel feedback) async {
    try {
      await guidelinesRemoteDataSource.giveFeedback(feedback);
    } catch (e) {
      throw e;
    }
  }
}
