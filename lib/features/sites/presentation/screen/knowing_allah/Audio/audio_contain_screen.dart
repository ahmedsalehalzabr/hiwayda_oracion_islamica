import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/fixed_entities.dart';
import '../../../controller/knowing_allah/knowing_allah_controller.dart';
import '../../../widget/app_bar_custom.dart';
import '../../../widget/inkwell_custom.dart';

class KnowingAllahAudioContainScreen extends StatelessWidget {
  final int itemCount;
  final List<FixedEntities> dataText;
  const KnowingAllahAudioContainScreen({
    super.key,
    required this.itemCount,
    required this.dataText,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(KnowingAllahControllerImp());
    return Scaffold(
        appBar: const AppBarCustom(title: 'Audio').customAppBar(context),
        body: GetBuilder<KnowingAllahControllerImp>(
            builder: ((controller) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return InkwellCustom(
                        catigory: false,
                        dataText: dataText[index].name,
                        onTap: () async {
                          await launchUrl(Uri.parse(dataText[index].content));
                        },
                      );
                    })))));
  }
}
