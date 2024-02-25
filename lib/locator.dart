import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/core/services/network/websocket/web_socket_connection.dart';
import 'package:messaging_core/features/chat/data/data_sources/chat_data_source.dart';
import 'package:messaging_core/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:messaging_core/features/chat/data/repositories/contacts_repository_impl.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';
import 'package:messaging_core/features/chat/domain/repositories/contact_repository.dart';
import 'package:messaging_core/features/chat/domain/use_cases/create_group_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/edit_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_contacts_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/send_messags_use_case.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/contacts_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';

final locator = GetIt.instance;

void injectDependencies() {
  controllerInjection();
  useCaseInjection();
  repositoryInjection();

  dataInjection();
}

void dataInjection() {
  locator.registerLazySingleton<APIHandler>(() => APIHandler());
  locator.registerLazySingleton<ChatDataSource>(
      () => ChatDataSourceImpl(locator()));
  locator
      .registerLazySingleton<WebSocketConnection>(() => WebSocketConnection());
  locator
      .registerLazySingleton<MessagingClient>(() => MessagingClient(locator()));
}

void repositoryInjection() {
  locator.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(locator()));
  locator
      .registerLazySingleton<ContactsRepository>(() => ContactRepositoryImpl());
}

void useCaseInjection() {
  locator.registerLazySingleton<GetAllChatsUseCase>(
      () => GetAllChatsUseCase(locator()));
  locator.registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(locator()));
  locator.registerLazySingleton<SendMessagesUseCase>(
      () => SendMessagesUseCase(locator()));
  locator.registerLazySingleton<GetContactsUseCase>(
      () => GetContactsUseCase(locator()));
  locator.registerLazySingleton<EditMessagesUseCase>(
      () => EditMessagesUseCase(locator()));
  locator.registerLazySingleton<CreateGroupUseCase>(
      () => CreateGroupUseCase(locator()));
}

void controllerInjection() {
  locator.registerLazySingleton<ChatController>(() => ChatController(
      locator(), locator(), locator(), locator(), locator(), locator()));
  locator.registerLazySingleton<ContactsController>(
      () => ContactsController(locator()));
  locator.registerLazySingleton<EmojiController>(() => EmojiController());
}
