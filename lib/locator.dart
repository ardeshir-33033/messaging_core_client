import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void injectDependencies() {}

void dataInjection() {
  locator.registerLazySingleton<APIHandler>(() => APIHandler());
}

void repositoryInjection(){
  locator.registerLazySingleton<APIHandler>(() => APIHandler());

}
