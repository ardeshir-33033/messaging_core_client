import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
class ConnectionStatusProvider extends GetxController {
  // final WebSocketConnection webSocketConnection;
  // final ChannelsProvider channelsProvider;
  // final WalletProvider walletProvider;
  // final CallUsecase callUsecase;
  //
  // ConnectionStatusProvider({
  //   required this.webSocketConnection,
  //   required this.channelsProvider,
  //   required this.walletProvider,
  //   required this.callUsecase,
  // });
  //
  // bool hasNetwork = false;
  // bool isConnected = false;
  // bool updated = false;
  // bool retryFailed = false;
  // bool _updateLock = false;
  // bool _connectLock = false;
  //
  // @override
  // void onInit() {
  //   init();
  //   super.onInit();
  // }
  //
  // void resetState() {
  //   hasNetwork = false;
  //   isConnected = false;
  //   updated = false;
  //   retryFailed = false;
  //   _updateLock = false;
  //   _connectLock = false;
  //   update();
  // }
  //
  // void init() {
  //   Connectivity().checkConnectivity().then((result) {
  //     hasNetwork = result != ConnectivityResult.none;
  //     isConnected = hasNetwork && isConnected;
  //     updated = hasNetwork && isConnected && updated;
  //     _handleNewStatus();
  //     notifyListeners();
  //   });
  //
  //   webSocketConnection.addListener(() {
  //     isConnected = webSocketConnection.isConnected;
  //     updated = hasNetwork && isConnected && updated;
  //     _handleNewStatus();
  //     notifyListeners();
  //   });
  //
  //   Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //     hasNetwork = result != ConnectivityResult.none;
  //     isConnected = hasNetwork && isConnected;
  //     updated = hasNetwork && isConnected && updated;
  //     _handleNewStatus();
  //     notifyListeners();
  //   });
  // }
  //
  // _handleNewStatus() {
  //   if (hasNetwork) {
  //     if (isConnected) {
  //       _updateWithRetry();
  //     } else {
  //       _connectWithRetry();
  //     }
  //   }
  // }
  //
  // _updateWithRetry() async {
  //   if (_updateLock) return;
  //   _updateLock = true;
  //   retryFailed = false;
  //   try {
  //     await retry(
  //       () async {
  //         logger.d('retry updating...');
  //         await channelsProvider
  //             .setChannels(channelsProvider.limit, 1)
  //             .timeout(const Duration(seconds: 9));
  //         walletProvider.updateWalletsFromNetwork();
  //         updated = true;
  //       },
  //       maxAttempts: 10,
  //       randomizationFactor: 0,
  //       delayFactor: const Duration(seconds: 10),
  //       maxDelay: const Duration(seconds: 10),
  //       retryIf: (p0) => isConnected && hasNetwork && !updated,
  //     );
  //   } catch (e) {
  //     logger.d('update retry failed.');
  //     retryFailed = true;
  //   } finally {
  //     _updateLock = false;
  //     notifyListeners();
  //   }
  // }
  //
  // _connectWithRetry() async {
  //   if (_connectLock) return;
  //   _connectLock = true;
  //   retryFailed = false;
  //   try {
  //     await retry(
  //       () async {
  //         logger.d('retry connecting...');
  //         await webSocketConnection
  //             .retryConnection()
  //             .timeout(const Duration(seconds: 10));
  //       },
  //       maxAttempts: 10,
  //       randomizationFactor: 0,
  //       delayFactor: const Duration(seconds: 10),
  //       maxDelay: const Duration(seconds: 10),
  //       retryIf: (p0) => !isConnected && hasNetwork,
  //     );
  //   } catch (e) {
  //     logger.d('WebSocket retry failed.', e);
  //     retryFailed = true;
  //   } finally {
  //     _connectLock = false;
  //     notifyListeners();
  //   }
  // }
  //
  // String? status() {
  //   return !hasNetwork
  //       ? 'Waiting for network'
  //       : !isConnected
  //           ? 'Connecting'
  //           : !updated
  //               ? 'Updating'
  //               : null;
  // }
}
