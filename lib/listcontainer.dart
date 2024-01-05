import 'package:flutter/cupertino.dart';

class ListContainer extends StatelessWidget {
   ListContainer({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('data'),
          Text('data'),
        ],
      ),
    );
  }
}
