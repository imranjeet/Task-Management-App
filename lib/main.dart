import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_management_app/core/constants/string_constants.dart';
import 'core/constants/app_constants.dart';
import 'firebase_options.dart';
import 'views/auth/data/datasources/auth_remote_data_source.dart';
import 'views/auth/data/repositories/auth_repository_impl.dart';
import 'views/auth/domain/usecases/sign_up_usecase.dart';
import 'views/auth/domain/usecases/sign_in_usecase.dart';
import 'views/auth/domain/usecases/sign_out_usecase.dart';
import 'views/auth/domain/usecases/get_current_user_usecase.dart';
import 'views/auth/presentation/bloc/auth_bloc.dart';
import 'views/task/data/datasources/task_remote_data_source.dart';
import 'views/task/data/repositories/task_repository_impl.dart';
import 'views/task/domain/usecases/get_tasks_usecase.dart';
import 'views/task/domain/usecases/create_task_usecase.dart';
import 'views/task/domain/usecases/update_task_usecase.dart';
import 'views/task/domain/usecases/delete_task_usecase.dart';
import 'views/task/domain/usecases/toggle_task_status_usecase.dart';
import 'views/task/presentation/bloc/task_bloc.dart';
import 'views/main_screens/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signUpUseCase: SignUpUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(),
              ),
            ),
            signInUseCase: SignInUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(),
              ),
            ),
            signOutUseCase: SignOutUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(),
              ),
            ),
            getCurrentUserUseCase: GetCurrentUserUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(),
              ),
            ),
          ),
        ),
        
        // Task BLoC
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            getTasksUseCase: GetTasksUseCase(
              TaskRepositoryImpl(
                remoteDataSource: TaskRemoteDataSourceImpl(),
              ),
            ),
            createTaskUseCase: CreateTaskUseCase(
              TaskRepositoryImpl(
                remoteDataSource: TaskRemoteDataSourceImpl(),
              ),
            ),
            updateTaskUseCase: UpdateTaskUseCase(
              TaskRepositoryImpl(
                remoteDataSource: TaskRemoteDataSourceImpl(),
              ),
            ),
            deleteTaskUseCase: DeleteTaskUseCase(
              TaskRepositoryImpl(
                remoteDataSource: TaskRemoteDataSourceImpl(),
              ),
            ),
            toggleTaskStatusUseCase: ToggleTaskStatusUseCase(
              TaskRepositoryImpl(
                remoteDataSource: TaskRemoteDataSourceImpl(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: StringConstants.appName,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: AppConstants.primaryColor,
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: AppConstants.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppConstants.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(color: AppConstants.textLightColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(color: AppConstants.textLightColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
          ),
        ),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

