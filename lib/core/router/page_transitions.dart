import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class PageTransitions {
  static const _moduleDuration = Duration(milliseconds: 250);
  static const _authDuration = Duration(milliseconds: 200);

  static CustomTransitionPage<void> fade(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: _authDuration,
      reverseTransitionDuration: _authDuration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<void> slide(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: _moduleDuration,
      reverseTransitionDuration: _moduleDuration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }
}
