import 'dart:async';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:chatp/model/book/fileInfo.dart';
import 'package:chatp/store/file.dart';
import 'package:chatp/store/icloud.dart';
import 'package:chatp/widget/expansion_tile_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:super_editor_markdown/super_editor_markdown.dart'
//import 'package:simple_markdown_editor_plus/simple_markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:chatp/widget/toolbar.dart';

class NotebookScreen extends StatefulWidget {
  @override
  _ThreeColumnLayoutState createState() => _ThreeColumnLayoutState();
}

class _ThreeColumnLayoutState extends State<NotebookScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  double leftWidth = 250.0; // 初始左侧栏宽度
  double middleWidth = 150.0; // 初始右侧栏宽度

  var isAddSave = false;

  var dirs = <Directory>[];
  DirNode? _currentDir;
  var files = <FileInfo>[];

  String mdData = "";
  String mdTitle = "";
  String mdFilePath = "";
  String mdSaveFileDirPath = "";
  TextEditingController? titleController; // = TextEditingController();
  FocusNode? _focusNode;
  TextEditingController? contentController;

  Timer? saveTimer;

  TabController? _tabController;

  bool _showLeftPanel = true;
  bool _showMiddlePanel = true;

  String filePathWithSpace =
      '/Users/arick/Library/CloudStorage/OneDrive-个人/md/Quiver.qvlibrary';
  String workDir =
      "/Users/arick/Library/Mobile Documents/iCloud~md~obsidian/Documents";
  // 处理路径中的空格
  String testDir = "/Users/arick/note";

  getFiles(String dir) {
    mdSaveFileDirPath = dir;
    print("saveDirPath: $mdSaveFileDirPath");
    files = [];
    var list = FileProvider.listFiles(Directory(dir));
    list.forEach((element) {
      FileInfo fileInfo = FileInfo(
        name: FileProvider.getBaseName(element.path),
        path: element.path,
      );
      final dateFormatter = DateFormat('yyyy/MM/dd HH:mm:ss');
      fileInfo.updateTime = dateFormatter.format(element.lastModifiedSync());
      setState(() {
        files.add(fileInfo);
      });
    });
  }

  getContent(String path) {
    mdFilePath = path;
    mdTitle = FileProvider.getBaseName(path);
    var arr = mdTitle.split('.');
    mdTitle = arr[0];
    if (arr.last == "md") {
      mdData = FileProvider.getContent(path);
    } else {
      mdData = "";
    }

    titleController?.text = mdTitle;
    contentController?.text = mdData;
  }

  setContent(String path) {
    mdData = contentController?.text ?? "";
    FileProvider.saveContent(path, mdData);
  }

//适用场景 1.新建文件保存  2.打开文件 保存  3.打开文件 重命名 保存
  doRenameSave() {
    print("doRenameSave");
    if (titleController?.text.isEmpty ?? true) {
      EasyLoading.showError("标题不能为空");
      return;
    }

    mdTitle = titleController?.text ?? "";
    if (mdSaveFileDirPath.isEmpty) {
      EasyLoading.showError("存储目录不能为空");
      print("mdSaveFileDirPath: $mdSaveFileDirPath");
      return;
    }
    var filePath = "${FileProvider.joinPath(mdSaveFileDirPath, mdTitle)}.md";
    if (isAddSave) {
      if (FileProvider.isExists(filePath)) {
        //已经存在 不能重命名
        EasyLoading.showError("存在同名文件");
        return;
      } else {
        //FileProvider.rename(mdFilePath, filePath);
        setContent(filePath);
        //刷新列表
        getFiles(mdSaveFileDirPath);
        mdFilePath = filePath;
        EasyLoading.showSuccess("保存成功");
        isAddSave = false;
        return;
      }
    } else {
      // 重命名保存
      if (mdFilePath != filePath) {
        if (FileProvider.isExists(filePath)) {
          //已经存在 不能重命名
          EasyLoading.showError("存在同名文件");
          return;
        } else {
          FileProvider.rename(mdFilePath, filePath);
        }
      }
      setContent(filePath);
      //刷新列表
      getFiles(mdSaveFileDirPath);
      mdFilePath = filePath;
      isAddSave = false;
      EasyLoading.showSuccess("保存成功");
    }
  }

  clearContent() {
    isAddSave = true;
    mdFilePath = "";
    mdTitle = "";
    mdData = "";
    titleController?.text = mdTitle;
    contentController?.text = mdData;
  }

  void startSaveTimer() {
    print('save');
    doRenameSave();
    saveTimer = Timer(Duration(seconds: 3), () {
      saveTimer?.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    // 添加Widgets绑定观察器
    WidgetsBinding.instance.addObserver(this);
    titleController = TextEditingController();
    contentController = TextEditingController();
    _focusNode = FocusNode();
    _tabController = TabController(length: 3, vsync: this);

    final directory = Directory(testDir);
    _currentDir = FileProvider.dirTree(directory);
    dirs = FileProvider.listDirs(directory);
    FileProvider.getDownloadsDir().then((value) {
      //print(value);
      if (value != null) {}
    });
    Icloud.fileList();

    //FileProvider.dirListen(directory);
  }

  @override
  void dispose() {
    // 移除Widgets绑定观察器
    saveTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget leftPanel(double width, ExpandedTileController? controller) {
    var tile = RecursiveExpandedTile(_currentDir!, (String dir) {
      getFiles(dir);
    }, hideHeadOnFirstCall: true, controller: controller);

    return Container(
      alignment: Alignment.topLeft,
      width: _showLeftPanel ? width : 0,
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: _currentDir == null ? Container() : tile,
          )),
          Row(children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(onPressed: () {}, child: Icon(Icons.add)),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.settings),
                ),
              ),
            ),
          ])
        ],
      ),
      //test(_currentDir!), //
    );
  }

  // 中间笔记列表
  Widget middlePanel(double width) {
    return Container(
      width: _showMiddlePanel ? width : 0,
      child: Column(
        children: [
          Row(children: [
            IconButton(
                onPressed: () {
                  clearContent();
                },
                icon: Icon(Icons.add)),
          ]),
          Expanded(
            child: ListView.builder(
              itemCount: files.length, // 笔记数量
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index].name),
                  subtitle: Text(files[index].updateTime ?? ''),
                  onTap: () {
                    // 点击笔记进入编辑页面或显示富文本内容
                    setState(() {
                      getContent(files[index].path);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 右侧富文本编辑器
  Widget rightPanel() {
    final TextEditingController _controller = TextEditingController();

    var toolbar = MarkdownToolbar(
      //spacing: EdgeInsets.only(top: 10),
      useIncludedTextField:
          false, // Because we want to use our own, set useIncludedTextField to false
      controller: contentController, // Add the _controller
      focusNode: _focusNode, // Add the _focusNode
      iconSize: 20,
      width: 40,
      collapsable: false,
    );
    toolbar.onTap = () {
      doRenameSave();
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {
                  _tabController?.animateTo(0);
                },
                child: Text("写")),
            TextButton(
                onPressed: () {
                  setState(() {
                    setContent(mdFilePath);
                  });

                  _tabController?.animateTo(1);
                },
                child: Text("预览")),
            TextButton(
                onPressed: () {
                  setState(() {
                    setContent(mdFilePath);
                  });
                  _tabController?.animateTo(2);
                },
                child: Text("两栏")),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 10),
          child: toolbar,
        ),
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            label: Text("标题"),
            hintText: "请输入标题",
          ),
          onEditingComplete: () {
            //print("object");
            doRenameSave();
            //FocusScope.of(context).nextFocus();
          },
          onSubmitted: (_) => doRenameSave(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      focusNode: _focusNode,
                      minLines: 20,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: '请输入正文',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: MarkdownGenerator().buildWidgets(mdData),
              ),
              Row(
                children: [Center(child: Text("read"))],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
// 左侧文件夹目录
    var controller = ExpandedTileController(isExpanded: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Three Column Layout'),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isMetaPressed &&
              event.logicalKey == LogicalKeyboardKey.keyS) {
            if (saveTimer == null || !saveTimer!.isActive) {
              startSaveTimer();
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final rightWidth = maxWidth - leftWidth - middleWidth - 8;

            return Row(
              children: [
                leftPanel(leftWidth, controller),
                GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      final newLeftWidth = leftWidth + details.delta.dx;
                      if (newLeftWidth >= 0 &&
                          newLeftWidth <= maxWidth - middleWidth - 8) {
                        leftWidth = newLeftWidth;
                      }
                    });
                  },
                  child: Container(
                    width: 4,
                    color: Color.fromARGB(255, 167, 160, 160),
                  ),
                ),
                Container(
                  width: middleWidth,
                  child: middlePanel(middleWidth),
                ),
                GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      final newMiddleWidth = middleWidth + details.delta.dx;
                      if (newMiddleWidth >= 0 &&
                          newMiddleWidth <= maxWidth - leftWidth - 200) {
                        middleWidth = newMiddleWidth;
                      }
                    });
                  },
                  child: Container(
                    width: 4,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    width: rightWidth,
                    child: rightPanel(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showMiddlePanel = !_showMiddlePanel;
          });
        },
        child: Icon(_showMiddlePanel ? Icons.arrow_back : Icons.arrow_forward),
      ),
    );
  }
}

class RecursiveExpandedTile extends StatelessWidget {
  final DirNode node;
  final bool hideHeadOnFirstCall;
  ExpandedTileController? controller;
  void Function(String) onGetFiles;

  RecursiveExpandedTile(
    this.node,
    this.onGetFiles, {
    this.hideHeadOnFirstCall = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tileController =
        controller ?? ExpandedTileController(isExpanded: false);
    return ExpandedTile(
      enabled: false,
      hiddenHead: hideHeadOnFirstCall,
      isExpanded: controller != null ? true : false,
      onTap: () {
        //print("dirNode.name: ${node.name}");
        if (onGetFiles != null) {
          //print("object");
          onGetFiles!(node.path);
        }
      },
      title: Text(node.name),
      leading: node.children.isNotEmpty ? null : Container(),
      content: Column(
        children: node.children
                ?.map((child) => RecursiveExpandedTile(child, onGetFiles))
                ?.toList() ??
            [],
      ),
      controller: tileController,
    );
  }
}
