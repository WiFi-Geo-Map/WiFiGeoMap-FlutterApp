import 'package:flutter/material.dart';
// import 'package:wifi_geo_map/Screens/loading_page.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      isSearching: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: MediaQuery.of(context).size.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomText(
                text: 'List of Access Points',
                size: 40,
              ),
              const CustomSizedBox(height: 0.03, width: 1),
              Table(
                border: TableBorder.symmetric(
                  outside: const BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                children: buildTableRows(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> buildTableRows() {
    List<TableRow> rows = [];

    rows.add(
      TableRow(
        children: const [
          'Name',
          'BSSID',
          'Strength',
        ]
            .map(
              (header) => TableCell(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                    top: MediaQuery.of(context).size.height * 0.015,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: CustomText(
                    text: header,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    for (int i = 1; i <= 25; i++) {
      rows.add(
        TableRow(
          children: List.generate(
            3,
            (j) => TableCell(
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  bottom: MediaQuery.of(context).size.height * 0.008,
                ),
                child: CustomText(
                  text: 'Row ${j * 5 + i}',
                  size: 15,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return rows;
  }
}
