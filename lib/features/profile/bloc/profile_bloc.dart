// lib/features/home/bloc/home_bloc.dart
import 'package:bloc_template/features/profile/domain/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    // on<FetchProfile>((event, emit) async {
    //   emit(ProfileLoading());
    //   try {
    //     final imageUrl = await repository.fetchRandomDogImage();
    //     emit(ProfileLoaded(imageUrl));
    //   } catch (e) {
    //     emit(ProfileError(e.toString()));
    //   }
    // });
  }
}
