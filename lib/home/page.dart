// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drafteame/home/bloc/bloc_bloc.dart' as bloc;
export 'package:drafteame/home/bloc/bloc_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("DRAFTEAME"),
        ),
        body: BlocProvider(
          create: (context) => bloc.Bloc(),
          child: BlocListener<bloc.Bloc, bloc.State>(
            listener: (context, state) {
              if (state is bloc.ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Se produjo un error intente mas tarde'),
                  ),
                );
              } else if (state is bloc.ValorMaximoState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Se supero el numero maximo de cordenadas'),
                  ),
                );
              }
            },
            child: const Body(),
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.Bloc, bloc.State>(
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 16, right: 16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        width: 200,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: TextEditingController(
                              text: state.model.nameFile ?? ''),
                          enabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    (state is bloc.LoadingState)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () async {
                              import(context);
                            },
                            child: const Text(
                              'Import',
                            ),
                          ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.model.listrobot?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      child: Text(
                        '${state.model.listrobot![index].x}  ${state.model.listrobot![index].y}  ${state.model.listrobot![index].direction}',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  void import(BuildContext context) async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        allowMultiple: false,
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        Uint8List? bytes;
        if (kIsWeb) {
          bytes = file.bytes;
        } else if (Platform.isAndroid || Platform.isIOS) {
          bytes = File(file.path!).readAsBytesSync();
        }

        context.read<bloc.Bloc>().add(
              bloc.SendEvent(utf8.decode(bytes!), file.name),
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
