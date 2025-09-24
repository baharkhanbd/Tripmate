import 'package:go_router/go_router.dart';
import 'package:trip_mate/features/auths/login.dart';
import 'package:trip_mate/features/auths/sign_up.dart';
import 'package:trip_mate/features/auths/forgot_password.dart';
import 'package:trip_mate/features/auths/otp_verification.dart';
import 'package:trip_mate/features/auths/reset_password.dart';
import 'package:trip_mate/features/auths/reset_password_success.dart';
import 'package:trip_mate/features/camera/camera.dart';
import 'package:trip_mate/features/camera/image_view_screen.dart';
import 'package:trip_mate/features/history/history.dart';
import 'package:trip_mate/features/profile/profile.dart';
import 'package:trip_mate/features/booster/booster.dart';
import 'package:trip_mate/features/splash/splash.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/login_page',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/otp_verification',
      builder: (context, state) => const OTPVerificationPage(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: '/reset_password_success',
      builder: (context, state) => const ResetPasswordSuccessPage(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: '/image_view',
      builder: (context, state) {
        final imagePath = state.uri.queryParameters['imagePath'] ?? '';
        return ImageViewScreen(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/history/:id',
      builder: (context, state) {
        final historyId = state.pathParameters['id'] ?? '';
        return HistoryDetailsScreen(historyId: historyId);
      },
    ),
    GoRoute(
      path: '/history_details',
      builder: (context, state) {
        final imagePath = state.uri.queryParameters['imagePath'] ?? '';
        return HistoryDetailsScreen(
          historyId: 'captured',
          capturedImagePath: imagePath,
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/privacy_policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/booster',
      builder: (context, state) => const BoosterScreen(),
    ),
  ],
);