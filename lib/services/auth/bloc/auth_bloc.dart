import 'package:bloc/bloc.dart';
import 'package:jevlis_ka/services/auth/auth_provider.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_state.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;

        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null));
        } else {
          final FirebaseCanteenService canteenService =
              FirebaseCanteenService();

          if (await canteenService.getAdminCanteenId(uid: user.uid)) {
            emit(AuthStateLoggedInCanteen(user: user));
          } else {
            emit(AuthStateLoggedInUser(user: user));
          }
        }
      },
    );

    on<AuthEventEmailLoginUser>(
      (event, emit) async {
        // TODO: check how app behaves if initial state for this event is not provided
        emit(const AuthStateLoading());
        final FirebaseCanteenService canteenService = FirebaseCanteenService();

        try {
          final user = await provider.userLogIn(
              email: event.email, password: event.password);
          if (await canteenService.getAdminCanteenId(uid: user.uid)) {
            emit(AuthStateLoggedInCanteen(user: user));
          } else {
            emit(AuthStateLoggedInUser(user: user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e));
        }
      },
    );

    on<AuthEventGoogleLoginUser>(
      (event, emit) async {
        // TODO: check how app behaves if initial state for this event is not provided
        emit(const AuthStateLoading());
        final FirebaseCanteenService canteenService = FirebaseCanteenService();

        try {
          final user = await provider.signInWithGoogle();

          if (await canteenService.getAdminCanteenId(uid: user.uid)) {
            emit(AuthStateLoggedInCanteen(user: user));
          } else {
            emit(AuthStateLoggedInUser(user: user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e));
        }
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null));
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        emit(const AuthStateLoading());
        final FirebaseCanteenService canteenService = FirebaseCanteenService();

        try {
          final user = await provider.createUser(
              email: event.email, password: event.password);

          await canteenService.addToUsers(uid: user.uid);
          emit(const AuthStateLoggedOut(exception: null));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e));
        }
      },
    );

    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());

      try {
        await provider.userLogOut();
        emit(const AuthStateLoggedOut(exception: null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });
  }
}
