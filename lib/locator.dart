import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_it/get_it.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/core/services/network/websocket/web_socket_connection.dart';
import 'package:messaging_core/core/storage/database.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/data/data_sources/chat_data_source.dart';
import 'package:messaging_core/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:messaging_core/features/chat/data/repositories/contacts_repository_impl.dart';
import 'package:messaging_core/features/chat/data/repositories/storage/chat_storage_repository_impl.dart';
import 'package:messaging_core/features/chat/domain/repositories/chat_repository.dart';
import 'package:messaging_core/features/chat/domain/repositories/contact_repository.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';
import 'package:messaging_core/features/chat/domain/use_cases/create_group_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/delete_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/edit_message_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_all_chats_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_contacts_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:messaging_core/features/chat/domain/use_cases/send_messags_use_case.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/contacts_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/online_users_controller.dart';

final locator = GetIt.instance;

void injectDependencies() {
  useCaseInjection();
  repositoryInjection();
  dataInjection();

  controllerInjection();
}

void dataInjection() {
  locator.registerLazySingleton<APIHandler>(() => APIHandler());
  locator.registerLazySingleton<ChatDataSource>(
      () => ChatDataSourceImpl(locator()));
  locator
      .registerLazySingleton<WebSocketConnection>(() => WebSocketConnection());
  locator
      .registerLazySingleton<MessagingClient>(() => MessagingClient(locator()));
  locator.registerLazySingleton<SQLiteLocalStorage>(() => SQLiteLocalStorage());
}

void repositoryInjection() {
  locator.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(locator()));
  locator
      .registerLazySingleton<ContactsRepository>(() => ContactRepositoryImpl());
  locator.registerLazySingleton<ChatStorageRepository>(
      () => ChatStorageRepositoryImpl(database: locator()));
}

void useCaseInjection() {
  // locator.registerSingleton<GetAllChatsUseCase>(GetAllChatsUseCase(locator()));
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
  locator.registerLazySingleton<DeleteMessageUseCase>(
      () => DeleteMessageUseCase(locator()));
  locator.registerLazySingleton<CreateGroupUseCase>(
      () => CreateGroupUseCase(locator()));
}

void controllerInjection() {
  locator.registerSingleton<ChatController>(Get.put(ChatController(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator())));
  locator.registerSingleton<ContactsController>(
      Get.put(ContactsController(locator())));
  locator.registerSingleton<OnlineUsersController>(
      Get.put(OnlineUsersController()));
  locator.registerSingleton<EmojiController>(Get.put(EmojiController()));
  locator.registerSingleton<CallController>(
      Get.put(CallController(locator(), locator())));
}
