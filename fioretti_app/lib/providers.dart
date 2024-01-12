import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/models/user.dart';
import 'package:fioretti_app/widgets/scaffold.dart';

final userProvider = StateProvider<User?>((ref) => null);

final navigationBarIndexProvider = StateProvider<int>((ref) => 0);
