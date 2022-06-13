import 'package:flutter_modular/flutter_modular.dart';
import 'package:drafteame/home/page.dart' as home;

class AppModule extends Module {
  @override
  List<Bind> get binds => [
         Bind((i) => home.Bloc()),
      ];

  @override
  List<ModularRoute> get routes {
    return [
      ChildRoute(
        Modular.initialRoute,
        child: (_, args) =>  const home.Page(),
        transition: TransitionType.fadeIn,
      ),
      
    ];
  }
}




