import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_variables/reactive_variables.dart';
import 'package:test_work/features/my_home_page/my_home_page_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final class _MyHomePageState extends MyHomePageBloc {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Тестовое приложение'),
        ),
        body: Obs(
            rvList: [rvIsLoading, rvToken, rvPermissionGranted],
            builder: (context) {
              return Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: token));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Текст скопирован: ${token}')),
                                  );
                                },
                                child: Text(
                                  token,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (!permissionGranted)
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.redAccent,
                                    ),
                                    Text(
                                      'Разрешение на приём уведомлений не предоставлено!',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: fetchToken,
                                child: const Text('Обновить'),
                              )
                            ],
                          ),
                        ));
            }),
      ),
    );
  }
}
