import 'package:icloud_storage/icloud_storage.dart';

class Icloud {
  static fileList() async {
    final fileList = await ICloudStorage.gather(
      containerId: 'iCloud.top.arick.note',
      onUpdate: (stream) {
        var filesUpdateSub = stream.listen((updatedFileList) {
          print('FILES UPDATED');
          updatedFileList.forEach((file) => print('-- ${file.relativePath}'));
        });
      },
    );
    print('FILES GATHERED');
    fileList.forEach((file) => print('-- ${file.relativePath}'));
  }

  static upload() async {
    await ICloudStorage.upload(
      containerId: 'iCloud.top.arick.note',
      filePath: '/localDir/localFile',
      destinationRelativePath: 'destDir/destFile',
      onProgress: (stream) {
        var uploadProgressSub = stream.listen(
          (progress) => print('Upload File Progress: $progress'),
          onDone: () => print('Upload File Done'),
          onError: (err) => print('Upload File Error: $err'),
          cancelOnError: true,
        );
      },
    );
  }

  static download() async {
    await ICloudStorage.download(
      containerId: 'iCloud.top.arick.note',
      relativePath: 'relativePath',
      destinationFilePath: '/localDir/localFile',
      onProgress: (stream) {
        var downloadProgressSub = stream.listen(
          (progress) => print('Download File Progress: $progress'),
          onDone: () => print('Download File Done'),
          onError: (err) => print('Download File Error: $err'),
          cancelOnError: true,
        );
      },
    );
  }

  static del() async {
    await ICloudStorage.delete(
        containerId: 'iCloud.top.arick.note', relativePath: 'relativePath');
  }

  static move() async {
    await ICloudStorage.move(
      containerId: 'iCloud.top.arick.note',
      fromRelativePath: 'dir/file',
      toRelativePath: 'dir/subdir/file',
    );
  }

  static rename() async {
    await ICloudStorage.rename(
      containerId: 'iCloud.top.arick.note',
      relativePath: 'relativePath',
      newName: 'newName',
    );
  }
}
