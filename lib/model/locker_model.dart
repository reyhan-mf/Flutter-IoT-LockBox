class Locker {
  final int lockerId;
  final int number;
  final String status;

  Locker({required this.lockerId, required this.number, required this.status});

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      lockerId: json['locker_id'],
      number: json['number'],
      status: json['status'],
    );
  }
}
