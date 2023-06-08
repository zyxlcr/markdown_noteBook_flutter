import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileProvider {
  static String getBaseName(String path) {
    return basename(path);
  }

  static String getEntityName(FileSystemEntity path) {
    return basename(path.path);
  }

  static String getContent(String path) {
    return File(path).readAsStringSync();
  }

  static saveContent(String path, String content) {
    var f = File(path);
    f.writeAsStringSync(
      content,
    );
  }

  static void rename(String path, String newPath) {
    File(path).renameSync(newPath);
  }

  static void delete(String path) {
    File(path).deleteSync();
  }

  static bool isExists(String path) {
    return File(path).existsSync();
  }

  static String joinPath(String path, fileName) {
    return join(path, fileName);
  }

  static creatDir(String path, {bool recursive = false}) {
    Directory(path).createSync(recursive: recursive);
  }

  static String getParentDir(String path) {
    return File(path).parent.toString();
  }

  static getFile() async {
    //final Directory? downloadsDir = await getDownloadsDirectory();
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    //print(appDocumentsDir);
  }

  static Future<Directory?> getDownloadsDir() async {
    //final Directory? downloadsDir = await getDownloadsDirectory();
    final Directory? appDocumentsDir = await getDownloadsDirectory();
    //print(appDocumentsDir);
    return appDocumentsDir;
  }

  static List<File> listFiles(Directory dir) {
    var files = <File>[];
    dir.listSync().forEach((entity) {
      if (entity is File) {
        // 如果是文件，则打印文件名
        //print('File: ${entity.path}');
        //print('File: ${entity.toString()}');
        files.add(entity);
      }
    });
    return files;
  }

  static List<Directory> listDirs(Directory dir) {
    var files = <Directory>[];
    dir.listSync().forEach((entity) {
      if (entity is Directory) {
        {
          // 如果是文件夹，则打印文件夹名并递归遍历该文件夹
          //print('Directory: ${entity.uri}');
          files.add(entity);
        }
      }
    });
    return files;
  }

  // 递归遍历目录中的所有文件和子文件夹
  static void listAllFiles(Directory dir) {
    dir.listSync().forEach((entity) {
      if (entity is File) {
        // 如果是文件，则打印文件名
        print('File: ${entity.path}');
      } else if (entity is Directory) {
        // 如果是文件夹，则打印文件夹名并递归遍历该文件夹
        print('Directory: ${entity.path}');
        listAllFiles(entity);
      }
    });
  }

  // 递归遍历目录中的所有文件和子文件夹
  static void listAllDirs(Directory dir, int fIndex) {
    var m = Map<String, dynamic>();
    var arr = <Map<String, dynamic>>[];
    dir.listSync().forEach((entity) {
      if (entity is Directory) {
        // 如果是文件夹，则打印文件夹名并递归遍历该文件夹
        print('Directory: ${entity.path}');
        listAllFiles(entity);
      }
    });
  }

  static DirNode dirTree(Directory rootDir) {
    var rootNode = DirNode(basename(rootDir.path), rootDir.path, []);

    buildDirTree(rootDir, rootNode);
    return rootNode;
  }

  static void buildDirTree(Directory dir, DirNode parentNode) {
    for (var entity in dir.listSync()) {
      if (entity is Directory) {
        var dirNode = DirNode(basename(entity.path), entity.path, []);
        parentNode.children.add(dirNode);

        buildDirTree(entity, dirNode);
      }
    }
  }

  static void dirListen(Directory dir) {
    final watcher = dir.watch();

    watcher.listen((event) {
      if (event.type == FileSystemEvent.create) {
        if (event.isDirectory) {
          print('New directory created: ${event.path}');
        } else {
          print('New file created: ${event.path}');
        }
      } else if (event.type == FileSystemEvent.delete) {
        if (event.isDirectory) {
          print('Directory deleted: ${event.path}');
        } else {
          print('File deleted: ${event.path}');
        }
      } else if (event.type == FileSystemEvent.modify) {
        if (event.isDirectory) {
          print('Directory modified: ${event.path}');
        } else {
          print('File modified: ${event.path}');
        }
      }
    });
  }
}

class DirNode {
  String name;
  String path;
  List<DirNode> children;
  DirNode(this.name, this.path, this.children);
}
