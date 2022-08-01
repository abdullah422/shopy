import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/models/login_model.dart';
import 'package:shopy/modules/login/cubit/states.dart';
import 'package:shopy/shared/network/end_points.dart';
import 'package:shopy/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  LoginModel? loginModel;

  bool rememberMe = false;
  bool isPassword = true;

  void changeRememberMeCheckBox() {
    rememberMe = !rememberMe;
    emit(ChangeRememberMeCheckBoxState());
  }

  void changeTextFormEditingToPassword() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }
}
