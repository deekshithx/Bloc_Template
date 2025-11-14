// lib/core/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<ConnectivityResult>.broadcast();

  ConnectivityService() {
    // Handle both new (List<ConnectivityResult>) and old (ConnectivityResult) types
    _connectivity.onConnectivityChanged.listen((event) {
      final result = event.isNotEmpty ? event.first : ConnectivityResult.none;
      _controller.add(result);
    });
  }

  Stream<ConnectivityResult> get connectivity$ => _controller.stream;

  Future<ConnectivityResult> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();

    if (result.isNotEmpty) {
      return result.first;
    }
    return ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}

enum ConnectivityStatus { connected, disconnected }

class ConnectivityBloc extends Cubit<ConnectivityStatus> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _subscription;

  ConnectivityBloc(this._connectivityService)
    : super(ConnectivityStatus.connected) {
    _startListening();
  }

  void _startListening() async {
    final initial = await _connectivityService.checkConnectivity();
    if (initial == ConnectivityResult.none) {
      emit(ConnectivityStatus.disconnected);
    }

    _subscription = _connectivityService.connectivity$.listen((result) {
      if (result == ConnectivityResult.none) {
        emit(ConnectivityStatus.disconnected);
      } else {
        emit(ConnectivityStatus.connected);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
