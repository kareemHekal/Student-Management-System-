import 'package:flutter/material.dart';

class Magmo3amodel {
  String? days; // Days the group meets (e.g., "Monday, Wednesday")
  String id; // Unique identifier for the group
  String? grade; // Grade level associated with the group
  TimeOfDay? time; // Time the group meets
  String? userid; // User ID of the group creator

  // Constructor
  Magmo3amodel({
    this.id = "",
    this.grade,
    this.days,
    this.time,
    this.userid,
  });

  /// Factory method to create a `Magmo3amodel` instance from a JSON object.
  factory Magmo3amodel.fromJson(Map<String, dynamic> json) {
    return Magmo3amodel(
      userid: json['userid'],
      days: json["days"], // Expecting a string, e.g., "Monday, Wednesday"
      id: json['id'] ?? "", // Default to an empty string if null
      grade: json["grade"],
      time: json["time"] != null
          ? TimeOfDay(
        hour: json["time"]["hour"] ?? 0, // Default to 0 if null
        minute: json["time"]["minute"] ?? 0, // Default to 0 if null
      )
          : null, // Default to null if `time` is not provided
    );
  }

  /// Converts the `Magmo3amodel` instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      "days": days, // Days as a string, e.g., "Monday, Wednesday"
      "id": id, // Group ID
      "grade": grade, // Grade level
      "time": time != null
          ? {"hour": time?.hour, "minute": time?.minute} // Time as an object
          : null, // Default to null if `time` is not set
    };
  }
}
