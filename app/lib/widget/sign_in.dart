import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/pref_util.dart' as pref_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/legacy/connect.dart' as legacy;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/connect.dart';
import 'package:nc_photos/widget/expandable_container.dart';
import 'package:nc_photos/widget/home.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/root_picker.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'sign_in.g.dart';
part 'sign_in/bloc.dart';
part 'sign_in/state_event.dart';
part 'sign_in/type.dart';
part 'sign_in/view.dart';

class SignIn extends StatelessWidget {
  static const routeName = "/sign-in";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
        builder: (context) => const SignIn(),
        settings: settings,
      );

  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _Bloc(
        npDb: context.read(),
        prefController: context.read(),
      ),
      child: const _WrappedSignIn(),
    );
  }
}

class _WrappedSignIn extends StatefulWidget {
  const _WrappedSignIn();

  @override
  State<StatefulWidget> createState() => _WrappedSignInState();
}

@npLog
class _WrappedSignInState extends State<_WrappedSignIn>
    with RouteAware, PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context).copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _Background(),
          Scaffold(
            body: MultiBlocListener(
              listeners: [
                _BlocListenerT(
                  selector: (state) => state.connectArg,
                  listener: (context, connectArg) {
                    if (connectArg == null) {
                      return;
                    }
                    if (connectArg.username != null &&
                        connectArg.password != null) {
                      _onLegacyConnect(context, connectArg);
                    } else {
                      final uri = Uri.parse(
                          "${connectArg.scheme}://${connectArg.address}");
                      _onConnect(context, uri);
                    }
                  },
                ),
                _BlocListenerT(
                  selector: (state) => state.isCompleted,
                  listener: (context, isCompleted) {
                    if (isCompleted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Home.routeName,
                        (route) => false,
                        arguments:
                            HomeArguments(context.state.connectedAccount!),
                      );
                    }
                  },
                ),
                _BlocListenerT(
                  selector: (state) => state.error,
                  listener: (context, error) {
                    if (error != null && isPageVisible()) {
                      SnackBarManager().showSnackBarForException(error.error);
                    }
                  },
                ),
              ],
              child: _BlocSelector(
                selector: (state) => state.isConnecting,
                builder: (context, isConnecting) =>
                    isConnecting ? const _ConnectingBody() : const _Body(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onConnect(BuildContext context, Uri connectUri) async {
    var account = await Navigator.pushNamed<Account>(
      context,
      Connect.routeName,
      arguments: ConnectArguments(connectUri),
    );
    if (account == null) {
      // connection failed
      return;
    }
    account = await Navigator.pushNamed<Account>(
      context,
      RootPicker.routeName,
      arguments: RootPickerArguments(account),
    );
    if (account == null) {
      // ???
      return;
    }
    // we've got a good account
    context.addEvent(_SetConnectedAccount(account));
  }

  Future<void> _onLegacyConnect(BuildContext context, _ConnectArg arg) async {
    Account? account = Account(
      id: Account.newId(),
      scheme: arg.scheme,
      address: arg.address,
      userId: arg.username!.toCi(),
      username2: arg.username!,
      password: arg.password!,
      roots: [""],
    );
    _log.info("[_onLegacyConnect] Try connecting with account: $account");
    account = await Navigator.pushNamed<Account>(
      context,
      legacy.Connect.routeName,
      arguments: legacy.ConnectArguments(account),
    );
    if (account == null) {
      // connection failed
      return;
    }
    account = await Navigator.pushNamed<Account>(
      context,
      RootPicker.routeName,
      arguments: RootPickerArguments(account),
    );
    if (account == null) {
      // ???
      return;
    }
    // we've got a good account
    context.addEvent(_SetConnectedAccount(account));
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
