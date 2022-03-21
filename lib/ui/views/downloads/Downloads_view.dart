import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../enums/constants.dart';

class DownLoadView extends StatefulWidget {
  const DownLoadView({Key key}) : super(key: key);

  @override
  _DownLoadViewState createState() => _DownLoadViewState();
}

class _DownLoadViewState extends State<DownLoadView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<DownLoadViewModel>.reactive(
      onModelReady: (model) {
        model.getUser();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Container(
              color:theme.colorScheme.background,
              child: TabBar(
                // TabBar
                controller: _tabController,
                labelColor: Colors.amber,
                indicatorColor: Theme.of(context).accentColor,
                unselectedLabelColor: theme.appBarTheme.iconTheme.color,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white, fontSize: 13),
                tabs: <Widget>[
                  Tab(
                    text: "NOTES",
                  ),
                  Tab(
                    text: "Question Papers",
                  ),
                  Tab(
                    text: "Syllabus",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildNotesDownloadList(model),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => DownLoadViewModel(),
    );
  }

  Widget buildNotesDownloadList(DownLoadViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable:
                Hive.box<Download>(Constants.notesDownloads).listenable(),
            builder: (context, donwloadsBox, widget) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   decoration: AppStateNotifier.isDarkModeOn
                      //       ? Constants.mdecoration.copyWith(
                      //           color: Theme.of(context).colorScheme.background,
                      //           boxShadow: [],
                      //         )
                      //       : Constants.mdecoration.copyWith(
                      //           color: Theme.of(context).colorScheme.background,
                      //         ),
                      //   padding: const EdgeInsets.all(10),
                      //   margin: const EdgeInsets.all(10),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         margin:
                      //             const EdgeInsets.symmetric(horizontal: 15),
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           "Note:",
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .headline6
                      //               .copyWith(color: primary),
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: const EdgeInsets.symmetric(
                      //             horizontal: 15, vertical: 10),
                      //         decoration: BoxDecoration(),
                      //         child: RichText(
                      //           text: TextSpan(
                      //             style: Theme.of(context).textTheme.bodyText2,
                      //             children: [
                      //               TextSpan(
                      //                   text:
                      //                       'Notes which have been opened in the app will be shown here. If you have downloaded the notes by pressing the download icon '),
                      //               WidgetSpan(
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 2.0),
                      //                   child:
                      //                       Icon(Icons.file_download, size: 18),
                      //                 ),
                      //               ),
                      //               TextSpan(
                      //                   text: ' you can find them in your '),
                      //               TextSpan(
                      //                   text: 'Internal Storage > Downloads',
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold)),
                      //               TextSpan(text: ' folder of your mobile'),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: donwloadsBox.length + 1,
                        itemBuilder: (context, index) {
                          bool isLastElem = index == donwloadsBox.length;
                          final download = isLastElem
                              ? null
                              : donwloadsBox.getAt(index) as Download;
                          return isLastElem
                              ? SizedBox(height: 100)
                              : GestureDetector(
                                  onTap: () {
                                    model.navigateToPDFScreen(download);
                                  },
                                  child: FractionallySizedBox(
                                    widthFactor: 0.99,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: AppStateNotifier.isDarkModeOn
                                          ? Constants.mdecoration.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              boxShadow: [],
                                            )
                                          : Constants.mdecoration.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                      child: DownloadListTile(
                                        download: download,
                                        index: index,
                                        onDeletePressed: () {
                                          model.deleteDownload(
                                              index, download.path);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget noDownloadsOverlay(BuildContext context) {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: Lottie.asset('assets/lottie/learn.json'),
      ),
      Positioned(
        top: App(context).appHeight(0.55),
        left: 60,
        right: 50,
        child: Text(
          "Your downloads will appear here",
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
        ),
      ),
    ],
  );
}

class DownloadListTile extends StatelessWidget {
  final Download download;
  final int index;
  final Function onDeletePressed;

  const DownloadListTile(
      {Key key, this.download, this.index, this.onDeletePressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final String title =
        download.title != null ? download.title.toUpperCase() : "title";
    final String author =
        download.author != null ? download.author.toUpperCase() : "author";
    final date = download.uploadDate;
    var format = new DateFormat("dd/MM/yy");
    var dateString = format.format(date);
    final int view = download.view;
    final String size = download.size.toString();
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: theme.primaryColor,
                ),
                onPressed: onDeletePressed,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 25),
                    height: App(context).appScreenHeightWithOutSafeArea(0.11),
                    width: App(context).appScreenWidthWithOutSafeArea(0.2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pdf.png',
                        ),
                        // colorFilter: ColorFilter.mode(
                        //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(maxWidth: 180),
                                child: Text(
                                  title,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Author :$author",
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                letterSpacing: .3)),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Upload Date :$dateString",
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                letterSpacing: .3)),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.remove_red_eye,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          view.toString(),
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          size,
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//legacy code

// Container(
//   margin: const EdgeInsets.symmetric(
//       horizontal: 15, vertical: 10),
//   decoration: BoxDecoration(),
//   child: Text(
//     "Notes which have been opened in the app will be shown here. If you have downloaded the notes by pressing the download icon, you can find them in your Internal Storage > Downloads folder of your mobile",
//     style: Theme.of(context)
//         .textTheme
//         .subtitle1
//         .copyWith(color: primary),
//   ),
// ),
// Container(
//   height: 40,
//   margin: const EdgeInsets.all(10),
//   width: App(context).appWidth(0.45),
//   child: RaisedButton(
//     textColor: Colors.white,
//     color: Colors.teal.shade500,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(30),
//     ),
//     onPressed: () {
//       model.buyPremium();
//     },
//     child: Row(
//       children: [
//         Text("Buy Premium"),
//         SizedBox(
//           width: 10,
//         ),
//         Icon(
//           MdiIcons.crown,
//           color: Colors.amber,
//         ),
//       ],
//     ),
//   ),
// ),
