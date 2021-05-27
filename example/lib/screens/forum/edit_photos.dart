import 'package:getxfire_example/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPotos extends StatefulWidget {
  EditPotos({this.files});
  final List<dynamic> files;
  @override
  _EditPotosState createState() => _EditPotosState();
}

class _EditPotosState extends State<EditPotos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          for (String url in widget.files)
            Stack(
              children: [
                SizedBox(
                  child: Image.network(url),
                  width: 100,
                  height: 100,
                ),
                MaterialButton(
                  onPressed: () async {
                    try {
                      await ff.deleteFile(url);
                      setState(() => widget.files.remove(url));
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.delete,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(4.0),
                  shape: CircleBorder(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
