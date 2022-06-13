part of 'bloc_bloc.dart';

abstract class Event extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends Event {}

class SelectEvent extends Event {
  
  SelectEvent();
}

class SendEvent extends Event {
  final String text;
  final String namefil;
  SendEvent(this.text,this.namefil);
}

