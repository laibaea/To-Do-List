class Task {
  int? id;
  String title;
  String description;
  String date;
  String time;
  String priority; // New field

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.priority = 'Medium', // Default value
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'priority': priority,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        date = map['date'],
        time = map['time'],
        priority = map['priority'];
}
