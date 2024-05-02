class ApiConstant {
  ApiConstant._();

  static const String apiBaseUrl = 'https://space.venturo.id/';
  static const String apiBaseUrlStaging = 'https://space.venturo.pro/';
  // static const String apiBaseUrlDev = 'https://space.venturo.pro/';

  static String login() {
    return 'api/v1/auth/login';
  }

  static String home({required int authId}) {
    return 'api/v1/mobile/timebox-home?user_auth_id=$authId';
  }

  static String issue() {
    return 'api/v1/timebox-issues';
  }

  static String getIssue({
    required int authId,
    required int projectId,
    required String position,
  }) {
    return 'api/v1/timebox-issues?user_auth_id=$authId&m_project_id=$projectId&position=$position';
  }

  static String getIssueBacklog({
    required int authId,
    required int projectId,
    required String position,
    required String section,
  }) {
    return 'api/v1/timebox-issues?user_auth_id=$authId&m_project_id=$projectId&position=$position&section=$section';
  }

  static String deleteIssue({
    required int id,
  }) {
    return 'api/v1/timebox-issues/$id';
  }

  static String undoDeleteIssue({
    required int id,
  }) {
    return 'api/v1/timebox-issues-restore/$id';
  }

  static String squad() {
    return 'api/v2/timebox-position';
  }

  static String getAllIssueFromTimebox() {
    return 'api/v2/timebox';
  }

  static String getAllIssueTimeBoxSquad({
    required String userAuthId,
    required String status,
    String? fillter,
  }) {
    if (fillter == "project") {
      return '/api/v2/timebox-per-user-per-project/$userAuthId?status=$status';
    } else {
      return '/api/v2/timebox-per-user-per-date/$userAuthId?status=$status';
    }
  }

  static String getAllIssueTimeBoxInstruction({
    required String userAuthId,
    required String status,
    String? fillter,
  }) {
    if (fillter == "project") {
      return '/api/v2/timebox-instruction-per-project/$userAuthId?status=$status';
    } else {
      return '/api/v2/timebox-instruction-per-date/$userAuthId?status=$status';
    }
  }

  static String acceptance() {
    return '/api/v1/timebox-acceptance';
  }

  static String getMySquadTimebox({
    required int userAuthId,
  }) {
    return '/api/v2/timebox-junior-issues/$userAuthId';
  }

  static String putMySquadTimebox() {
    return '/api/v2/timebox-junior-issues';
  }
}
