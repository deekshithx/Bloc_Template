// lib/features/home/bloc/home_bloc.dart
import 'package:bloc_template/features/home/domain/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<FetchRandomDog>((event, emit) async {
      emit(HomeLoading());
      try {
        final imageUrl = await repository.fetchRandomDogImage();
        emit(HomeLoaded(imageUrl));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
