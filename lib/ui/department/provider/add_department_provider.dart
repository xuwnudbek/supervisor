
import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/extensions/fime_of_day_extension.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddDepartmentProvider extends ChangeNotifier {
  Map<String, dynamic> _departmentData = {};
  List _userMasters = [];
  List _userSubMasters = [];
  bool _isLoading = false;
  bool _isCreating = false;

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final TextEditingController breakTime = TextEditingController();

  Map<String, dynamic> get departmentData => _departmentData;
  set departmentData(Map<String, dynamic> value) {
    _departmentData = value;
    notifyListeners();
  }

  List get userMasters => _userMasters;
  set userMasters(List value) {
    _userMasters = value;
    notifyListeners();
  }

  List get userSubMasters => _userSubMasters;
  set userSubMasters(List value) {
    _userSubMasters = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isCreating => _isCreating;
  set isCreating(bool value) {
    _isCreating = value;
    notifyListeners();
  }

  AddDepartmentProvider(Map? department) {
    if (department != null) {
      departmentData['name'] = TextEditingController(text: department['name']);

      startTime = department['start_time'].toString().toTimeOfDay;
      endTime = department['end_time'].toString().toTimeOfDay;
      breakTime.text = department['break_time'].toString();

      departmentData['master'] = department['responsible_user'];
      departmentData['groups'] = <Map<String, dynamic>>[
        ...((department['groups'] ?? []) as List).map((group) => {
              "id": group['id'],
              "name": TextEditingController(text: group['name']),
              "submaster": group['responsible_user'],
            }),
      ];
    } else {
      departmentData['name'] = TextEditingController();
      departmentData['master'] = null;
      departmentData['groups'] = <Map<String, dynamic>>[];
    }

    initialize();
  }

  void initialize() async {
    isLoading = true;

    await Future.wait([
      getUserMaster(),
      getUserSubMaster(),
    ]);

    isLoading = false;
  }

  void onSelectEndTime(TimeOfDay time) {
    if (startTime == null || time.hour < startTime!.hour) {
      endTime = startTime;
      notifyListeners();
      return;
    }

    endTime = time;
    notifyListeners();
  }

  void onSelectStartTime(TimeOfDay time) {
    startTime = time;
    notifyListeners();
  }

  void onSelectMaster(int masterId) {
    departmentData['master'] = userMasters.firstWhere((master) => master['id'] == masterId);
    notifyListeners();
  }

  void onSelectSubMaster(
    int submasterId,
    int groupIndex,
  ) {
    Map submaster = userSubMasters.firstWhere((submaster) => submaster['id'] == submasterId);
    departmentData['groups'][groupIndex]['submaster'] = submaster;
    notifyListeners();
  }

  void addGroup(BuildContext context) {
    List groups = departmentData['groups'] ?? [];

    if (groups.isEmpty) {
      groups = [
        <String, dynamic>{
          "name": TextEditingController(),
          "submaster": null,
        }
      ];
    } else {
      if (groups.last['name'].text.isEmpty) {
        CustomSnackbars(context).success("Guruh nomini kiriting");
        return;
      } else if (groups.last['submaster'] == null) {
        CustomSnackbars(context).success("Guruh masterini tanlang");
        return;
      }

      groups.add(<String, dynamic>{
        "name": TextEditingController(),
        "submaster": null,
      });
    }

    departmentData['groups'] = groups;
    notifyListeners();
  }

  void removeGroup(int index) {
    departmentData['groups'].removeAt(index);
    notifyListeners();
  }

  Future<bool?> createDepartment(
    BuildContext context, {
    bool isCreate = true,
    int? departmentId,
  }) async {
    if (isCreating) return null;

    if (departmentData['name'].text.isEmpty) {
      CustomSnackbars(context).warning("Bo'lim nomini kiriting");
      return null;
    }

    if (startTime == null || endTime == null) {
      CustomSnackbars(context).warning("Ish vaqtlarini tanlang");
      return null;
    }

    if (breakTime.text.isEmpty) {
      CustomSnackbars(context).warning("Tanaffus vaqtini kiriting");
      return null;
    }

    if (departmentData['master'] == null) {
      CustomSnackbars(context).warning("Bo'lim masterini tanlang");
      return null;
    }

    List groups = departmentData['groups'] ?? [];
    if (((groups.lastOrNull ?? {}) as Map).isNotEmpty) {
      Map last = groups.last;
      if ((last['name'] as TextEditingController).text.isEmpty || last['submaster'] == null) {
        CustomSnackbars(context).warning("Guruh nomini va masterini kiriting");
        return null;
      }
    }

    isCreating = true;

    Map<String, dynamic> data = {
      "name": departmentData['name'].text.trim(),
      "responsible_user_id": departmentData['master']?['id'],
      "start_time": startTime!.toHM,
      "end_time": endTime!.toHM,
      "break_time": breakTime.text,
      "groups": ((departmentData['groups'] ?? []) as List)
          .map((group) => {
                "id": group['id'],
                "name": group['name'].text.trim(),
                "responsible_user_id": group['submaster']?['id'],
              })
          .toList(),
    };

    if (isCreate) {
      var res = await HttpService.post(department, data);

      isCreating = false;

      if (res['status'] == Result.success) {
        CustomSnackbars(context).success("Bo'lim muvaffaqiyatli yaratildi");
        return true;
      } else {
        CustomSnackbars(context).error("Bo'lim yaratishda xatolik yuz berdi");
        return false;
      }
    } else {
      var res = await HttpService.patch("$department/$departmentId", data);

      isCreating = false;

      if (res['status'] == Result.success) {
        CustomSnackbars(context).success("Bo'lim muvaffaqiyatli yangilandi");
        return true;
      } else {
        CustomSnackbars(context).error("Bo'lim yangilashda xatolik yuz berdi");
        return false;
      }
    }
  }

  Future<void> getUserMaster() async {
    var res = await HttpService.get(userMaster);

    if (res['status'] == Result.success) {
      userMasters = res['data'];
    }
  }

  Future<void> getUserSubMaster() async {
    var res = await HttpService.get(userSubMaster);

    if (res['status'] == Result.success) {
      userSubMasters = res['data'];
    }
  }
}
