import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Observable variables
  final RxBool isEnabled = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnalytics();
  }

  // Initialize analytics
  Future<void> _initializeAnalytics() async {
    try {
      // Enable analytics collection
      await _analytics.setAnalyticsCollectionEnabled(true);

      // Set user properties
      await _analytics.setUserProperty(name: 'app_version', value: '1.0.0');
      await _analytics.setUserProperty(name: 'platform', value: 'mobile');
    } catch (e) {
      errorMessage.value = 'Error initializing analytics: ${e.toString()}';
      isEnabled.value = false;
    }
  }

  // Track registration step
  Future<void> trackRegistrationStep(String stepName) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'registration_step',
        parameters: {
          'step_name': stepName,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking registration step: ${e.toString()}';
    }
  }

  // Track form field interaction
  Future<void> trackFormFieldInteraction(
    String fieldName,
    String action,
  ) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'form_field_interaction',
        parameters: {
          'field_name': fieldName,
          'action': action, // 'focus', 'blur', 'validation_error', 'success'
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking form interaction: ${e.toString()}';
    }
  }

  // Track image upload
  Future<void> trackImageUpload(
    String imageType,
    bool success, {
    String? error,
  }) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'image_upload',
        parameters: {
          'image_type': imageType, // 'id_card', 'profile_picture'
          'success': success,
          'error': error,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking image upload: ${e.toString()}';
    }
  }

  // Track location detection
  Future<void> trackLocationDetection(
    bool success, {
    String? method,
    String? error,
  }) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'location_detection',
        parameters: {
          'success': success,
          'method': method, // 'gps', 'manual'
          'error': error,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking location detection: ${e.toString()}';
    }
  }

  // Track college selection
  Future<void> trackCollegeSelection(
    String collegeName,
    String selectionMethod,
  ) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'college_selection',
        parameters: {
          'college_name': collegeName,
          'selection_method':
              selectionMethod, // 'autocomplete', 'manual', 'ocr'
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking college selection: ${e.toString()}';
    }
  }

  // Track interest selection
  Future<void> trackInterestSelection(List<String> interests) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'interest_selection',
        parameters: {
          'interests': interests.join(','),
          'count': interests.length,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking interest selection: ${e.toString()}';
    }
  }

  // Track registration completion
  Future<void> trackRegistrationCompletion({
    required String userId,
    required int totalTimeSeconds,
    required int stepsCompleted,
  }) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'registration_completion',
        parameters: {
          'user_id': userId,
          'total_time_seconds': totalTimeSeconds,
          'steps_completed': stepsCompleted,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value =
          'Error tracking registration completion: ${e.toString()}';
    }
  }

  // Track error
  Future<void> trackError(
    String errorType,
    String errorMessage, {
    String? screen,
  }) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'app_error',
        parameters: {
          'error_type': errorType,
          'error_message': errorMessage,
          'screen': screen,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Error tracking error: ${e.toString()}');
    }
  }

  // Track screen view
  Future<void> trackScreenView(String screenName) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      errorMessage.value = 'Error tracking screen view: ${e.toString()}';
    }
  }

  // Track user property
  Future<void> setUserProperty(String name, String value) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      errorMessage.value = 'Error setting user property: ${e.toString()}';
    }
  }

  // Track custom event
  Future<void> trackCustomEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      errorMessage.value = 'Error tracking custom event: ${e.toString()}';
    }
  }

  // Track performance metric
  Future<void> trackPerformanceMetric(String metricName, int value) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'performance_metric',
        parameters: {
          'metric_name': metricName,
          'value': value,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking performance metric: ${e.toString()}';
    }
  }

  // Track user engagement
  Future<void> trackUserEngagement(String action, {String? details}) async {
    if (!isEnabled.value) return;

    try {
      await _analytics.logEvent(
        name: 'user_engagement',
        parameters: {
          'action': action,
          'details': details,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      errorMessage.value = 'Error tracking user engagement: ${e.toString()}';
    }
  }

  // Enable/disable analytics
  Future<void> setAnalyticsEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      isEnabled.value = enabled;
    } catch (e) {
      errorMessage.value = 'Error setting analytics enabled: ${e.toString()}';
    }
  }

  // Get analytics instance
  FirebaseAnalytics get analytics => _analytics;
}
