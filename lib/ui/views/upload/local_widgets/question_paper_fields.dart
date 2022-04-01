import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/dropdownview.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/year_widget.dart';
import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_card.dart';
import 'package:flutter/material.dart';

import '../../../../misc/constants.dart';
import '../../../shared/app_config.dart';
import '../web_upload_document/web_document_edit_viewmodel.dart';

class QuestionPaperFields extends StatefulWidget {
  final int index;
  final WebDocumentEditViewModel model;

  const QuestionPaperFields({Key key, this.model, this.index})
      : super(key: key);

  @override
  State<QuestionPaperFields> createState() => _QuestionPaperFieldsState();
}

class _QuestionPaperFieldsState extends State<QuestionPaperFields> {
  TextEditingController controllerOfYear1 = TextEditingController();
  TextEditingController controllerOfYear2 = TextEditingController();
  List<DropdownMenuItem<String>> dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> dropDownMenuItemForTypeYear;

  QuestionPaper doc;

  String selectedBranch;
  String selectedyeartype;

  @override
  void initState() {
    dropDownMenuItemsofBranch = buildAndGetDropDownMenuItems(CourseInfo.branch);
    dropDownMenuItemForTypeYear =
        buildAndGetDropDownMenuItems(CourseInfo.yeartype);
    selectedBranch = dropDownMenuItemsofBranch[0].value;
    selectedyeartype = dropDownMenuItemForTypeYear[0].value;
    doc = widget.model.documents[widget.index];
    doc.branch = selectedBranch;
    super.initState();
  }

  void updateDocument() {
    widget.model.documents[widget.index] = doc;
    print("updated document with index ${widget.index}");
    QuestionPaper n = widget.model.documents[widget.index];
    print(n.branch);
    print(n.year);
  }

  @override
  Widget build(BuildContext context) {
    double wp = App(context).appWidth(1);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: App(context).appWidth(0.2), vertical: 20),
      decoration: AppStateNotifier.isDarkModeOn
          ? Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [],
            )
          : Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              "File Name : ${widget.model.files[widget.index].name}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: App(context).appScreenHeightWithOutSafeArea(0.15),
                    width: App(context).appScreenWidthWithOutSafeArea(0.1),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pdf.png',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Open",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: wp * 0.4,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YearFieldWidget(
                        controllerOfYear1: controllerOfYear1,
                        controllerOfYear2: controllerOfYear2,
                        typeofyear: selectedyeartype,
                        dropdownofyear: dropDownMenuItemForTypeYear,
                        changedDropDownItemOfYear: changedDropDownItemOfYear,
                        onChangedYearField: onChangedYearField,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      DropDownView(
                        isExpanded: true,
                        title: "Select Branch",
                        value: selectedBranch,
                        items: dropDownMenuItemsofBranch,
                        onChanged: changedDropDownItemOfBranch,
                      ),
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = [];
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Center(child: Text(item))));
    });
    return i;
  }

  void changedDropDownItemOfBranch(String br) {
    setState(() {
      selectedBranch = br;
      doc.branch = br;
      updateDocument();
    });
  }

  void changedDropDownItemOfYear(type) {
    setState(() {
      selectedyeartype = type;
      onChangedYearField(type);
    });
  }

  void onChangedYearField(String value) {
    if (selectedyeartype == CourseInfo.yeartype[0]) {
      doc.year = controllerOfYear1.text;
    } else {
      doc.year = controllerOfYear1.text + '-' + controllerOfYear2.text;
    }
    updateDocument();
  }
}
