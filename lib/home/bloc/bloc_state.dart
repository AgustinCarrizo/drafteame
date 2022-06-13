part of 'bloc_bloc.dart';

@immutable
abstract class State extends Equatable {
  final Model model;
  const State(this.model);

  @override
  List<Object> get props => [model];
}

class InitialState extends State {
  const InitialState(Model model) : super(model);
}

class LoadingState extends State {
  const LoadingState(Model model) : super(model);
}

class ErrorState extends State {
  const ErrorState(Model model) : super(model);
}

class ValorMaximoState extends State {
  const ValorMaximoState(Model model) : super(model);
}

class RobotState extends State {
  const RobotState(Model model) : super(model);
}

class Model extends Equatable {
  final List<Robot>? listrobot;
  final String? nameFile;

  const Model({this.listrobot, this.nameFile});

  Model copyWith({
    List<Robot>? listrobot,
    String? nameFile,
  }) =>
      Model(
        listrobot: listrobot ?? this.listrobot,
        nameFile: nameFile ?? this.nameFile,
      );

  @override
  List<Object?> get props => [
        listrobot,
        nameFile,
      ];
}
