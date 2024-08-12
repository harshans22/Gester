import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/view/stay/widgets/mobile_pdf_view.dart';
import 'package:pdfx/pdfx.dart';

class KYCAgreementScreen extends StatefulWidget {
  const KYCAgreementScreen({super.key});

  @override
  State<KYCAgreementScreen> createState() => _KYCAgreementScreenState();
}

class _KYCAgreementScreenState extends State<KYCAgreementScreen> {

  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
           appBar: AppBar(
            title: Text(
              "KYC Agreement",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            backgroundColor: AppColor.WHITE,
            surfaceTintColor: Colors.transparent,
            shadowColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
            centerTitle: true,
            elevation: 5,
          ),
           body: const PDFViewMobile(pdfURL: "https://firebasestorage.googleapis.com/v0/b/gester-ae70f.appspot.com/o/User_documents%2Fgester_document.pdf?alt=media&token=df1424a8-0223-4184-987e-5a77e83f945b"),
      
        ),
      ),
    );
  }
}