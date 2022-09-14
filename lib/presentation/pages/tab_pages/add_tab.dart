import 'package:clean_app/presentation/pages/tab_pages/add_page.dart';
import 'package:flutter/material.dart';

class AddTab extends StatelessWidget {
  const AddTab({Key? key, required this.isNewMarker}) : super(key: key);

  

  final bool isNewMarker;

  @override
  Widget build(BuildContext context) {
    return AddPage(isNewMarker: true);
  }
}
