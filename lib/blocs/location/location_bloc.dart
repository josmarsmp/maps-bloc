import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_bloc/blocs/gps/gps_bloc.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;
  final GpsBloc _gpsBloc = GpsBloc();

  LocationBloc() : super(const LocationState()) {
    on<LocationEvent>((event, emit) {});
  }

  Future getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition();
    print(position);
  }

  void startFollowingUser() {
    print('startFollowingUser');
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      print('position: $position');
    });
  }

  void stopFollowingUser() {
    if (!_gpsBloc.state.isAllGranted) return;
    positionStream?.cancel();
    print('stopFollowingUser');
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
