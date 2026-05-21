import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/view/login-register/welcome.dart';
import 'package:restaurants_system/providers/auth_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              ListTile(
                title: Text('Logout', style: TextStyle(fontSize: 18)),
                leading: Icon(Icons.logout, color: Colors.red),
                onTap: () async {
                  if (state.isLoading) {
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    );
                  }
                  ref.watch(authProvider.notifier).logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Welcome()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
