import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'model/user_model.dart';

class RemoteJson extends StatefulWidget {
  const RemoteJson({super.key});

  @override
  State<RemoteJson> createState() => _RemoteJsonState();
}

class _RemoteJsonState extends State<RemoteJson> {
  final String _title = 'Remote JSON Processes';
  late final Future<List<UserModel>> getUserList;

  @override
  void initState() {
    super.initState();
    getUserList = getUsersJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: getUserList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> userList = snapshot.data!;
            return ListView.builder(
              itemBuilder: ((context, index) {
                UserModel user = userList[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.address.city),
                  leading: Text(user.id.toString()),
                  trailing: Text(user.username),
                );
              }),
              itemCount: userList.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<UserModel>> getUsersJson() async {
    debugPrint('getUsersJson CALLED');
    String url = 'https://jsonplaceholder.typicode.com/users';

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        var userList = (response.data as List)
            .map((userMap) => UserModel.fromMap(userMap))
            .toList();
        return userList;
      } else {
        return [];
      }
    } on DioError catch (e) {
      debugPrint('getUsersJson RETURNED WITH ERROR!');
      return Future.error(e.message.toString());
    }
  }
}
