import 'package:docs/screens/docs_screen.dart';
import 'package:docs/screens/home_screen.dart';
import 'package:docs/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/':(route) =>  MaterialPage(child: LoginScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/':(route) =>  MaterialPage(child: HomeScreen()),
  '/document/:id' :(route) => MaterialPage(child: DocumentScreen(id: route.pathParameters['id']!)),
});