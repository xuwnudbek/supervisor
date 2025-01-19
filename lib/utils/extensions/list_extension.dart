extension ListExtension on List {
  List qaysiki(List keys, value) {
    // if (value.toString().isEmpty) {
    //   return this;
    // }

    return where((element) {
      String data = "";

      for (var key in keys) {
        if (key.toString().contains("/")) {
          String key1 = key.toString().split("/")[0];
          String key2 = key.toString().split("/")[1];
          data = "${element[key1]?[key2]?.toString().trim().toLowerCase() ?? ""} ";
        } else {
          data = "${element[key].toString().trim().toLowerCase()} ";
        }
      }

      return data.contains(value.toString().trim().toLowerCase());
    }).toList();
  }
}
