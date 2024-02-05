import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:messaging_core/features/chat/data/data_sources/chat_data_source.dart';
import 'package:messaging_core/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';

final locator = GetIt.instance;

void injectDependencies() {
  dataInjection();
  repositoryInjection();
  useCaseInjection();
  controllerInjection();
}

void dataInjection() {
  locator.registerLazySingleton<APIHandler>(() => APIHandler());
  locator.registerLazySingleton<ChatDataSource>(
      () => ChatDataSourceImpl(locator()));
}

void repositoryInjection() {
  locator.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(locator()));
}

void useCaseInjection() {
  locator.registerLazySingleton<GetAllChatsUseCase>(
      () => GetAllChatsUseCase(locator()));
}

void controllerInjection() {
  locator
      .registerLazySingleton<ChatController>(() => ChatController(locator()));
}
