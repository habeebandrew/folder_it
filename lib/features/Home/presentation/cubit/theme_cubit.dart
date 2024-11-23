import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = light theme, true = dark theme

  static ThemeCubit get(context)=>BlocProvider.of(context);
  
  void toggleTheme() => emit(!state);
}
