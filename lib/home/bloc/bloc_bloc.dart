import 'package:drafteame/model/cordenadas.dart';
import 'package:drafteame/model/robot.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart' as blocs;

part 'bloc_event.dart';
part 'bloc_state.dart';

class Bloc extends blocs.Bloc<Event, State> {
  Bloc() : super(const InitialState(Model())) {
    on<SendEvent>(_sendEvent);
  }

  void _sendEvent(SendEvent event, Emitter<State> emit) async {
    emit(
      LoadingState(
        state.model.copyWith(
          nameFile: event.namefil,
        ),
      ),
    );

    try {
      List<Robot>? listrobot = [];
      int maxX = 0;
      int maxY = 0;
      var splitValues = event.text.replaceAll(' ', '\n');

      List<String> splitValuess = splitValues.split("\n");

      int positoned = 0;
      Robot nuevo = Robot();
      for (int i = 0; i < splitValuess.length; i++) {
        if (i == 0) {
          maxX = int.parse(splitValuess[0]);
        }
        if (i == 1) {
          maxY = int.parse(splitValuess[1]);
        }
        if (positoned == 0 && i > 1) {
          nuevo.x = splitValuess[i];
          positoned++;
        } else if (positoned == 1 && i > 1) {
          nuevo.y = splitValuess[i];
          positoned++;
        } else if (positoned == 2 && i > 1) {
          nuevo.direction = splitValuess[i];
          positoned++;
        } else if (positoned == 3 && i > 1) {
          nuevo.cadena = splitValuess[i];
          positoned = 0;
          listrobot.add(nuevo);
          nuevo = Robot();
        }
      }

      for (var element in listrobot) {
        int x = int.parse(element.x);
        int y = int.parse(element.y);
        String position = element.direction;
        if (element.cadena.length < 50) {
          for (int i = 0; i < element.cadena.length; i++) {
            if (element.cadena[i] == 'L') {
              var valor = left(position.toUpperCase());
              position = valor.toUpperCase();
            } else if (element.cadena[i] == 'R') {
              var valor = right(position.toUpperCase());
              position = valor.toUpperCase();
            } else if (element.cadena[i] == 'F') {
              Cordenadas valores = await forward(position, x, y);
              x = valores.x;
              y = valores.y;
            }
          }

          element.x = x.toString();
          element.y = y.toString();

          if ((x >= maxX && position.contains('E')) ||
              (y >= maxY && position.contains('N'))) {
            element.direction = '$position LOST';
          } else {
            element.direction = position;
          }
          emit(
            RobotState(
              state.model.copyWith(listrobot: listrobot),
            ),
          );
        } else {
          emit(
            ValorMaximoState(state.model),
          );
        }
      }
    } catch (e) {
      emit(
        ErrorState(
          state.model,
        ),
      );
    }
  }
}

String left(String position) {
  String result = position;

  if (result.toString().contains('N')) {
    result = 'W';
  } else if (result.toString().contains('E')) {
    result = 'N';
  } else if (result.toString().contains('S')) {
    result = 'E';
  } else if (result.toString().contains('W')) {
    result = 'S';
  }

  return result;
}

String right(String position) {
  String result = position;
  if (result.toString().contains('N')) {
    result = 'E';
  } else if (result.toString().contains('W')) {
    result = 'N';
  } else if (result.toString().contains('S')) {
    result = 'W';
  } else if (result.toString().contains('E')) {
    result = 'S';
  }

  return result;
}

Future<Cordenadas> forward(String position, int x, int y) async {
  if (position.toString().contains('N')) {
    y = y + 1;
    return Cordenadas(x, y);
  } else if (position.toString().contains('W')) {
    x = x - 1;
    return Cordenadas(x, y);
  } else if (position.toString().contains('S')) {
    y = y - 1;
    return Cordenadas(x, y);
  } else if (position.toString().contains('E')) {
    x = x + 1;
    return Cordenadas(x, y);
  }
  return Cordenadas(x, y);
}
