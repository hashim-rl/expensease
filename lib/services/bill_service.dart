import 'package:get_storage/get_storage.dart';

class BillService {
  final GetStorage _box = GetStorage();
  final String _key = 'bills';

  List<Map<String, dynamic>> getBills() {
    final data = _box.read<List<dynamic>>(_key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(data);
  }

  void addBill(Map<String, dynamic> bill) {
    final bills = getBills();
    bills.add(bill);
    _box.write(_key, bills);
  }

  void updateBill(int index, Map<String, dynamic> updatedBill) {
    final bills = getBills();
    if (index >= 0 && index < bills.length) {
      bills[index] = updatedBill;
      _box.write(_key, bills);
    }
  }

  void deleteBill(int index) {
    final bills = getBills();
    if (index >= 0 && index < bills.length) {
      bills.removeAt(index);
      _box.write(_key, bills);
    }
  }

  void clearBills() {
    _box.remove(_key);
  }
}
