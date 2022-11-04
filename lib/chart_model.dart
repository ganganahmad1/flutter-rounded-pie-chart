// To parse this JSON data, do
//
//     final chart = chartFromJson(jsonString);

import 'dart:convert';

ChartModel chartFromJson(String str) => ChartModel.fromJson(json.decode(str));

String chartToJson(ChartModel data) => json.encode(data.toJson());

class ChartModel {
  ChartModel({
    this.data,
  });

  Data? data;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.userId,
    this.avgScore,
    this.percentageComplete,
    this.answeredPractices,
    this.totalPractices,
    this.courseData,
  });

  String? userId;
  double? avgScore;
  double? percentageComplete;
  int? answeredPractices;
  int? totalPractices;
  List<CourseDatum>? courseData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"] == null ? null : json["user_id"],
        avgScore:
            json["avg_score"] == null ? null : json["avg_score"].toDouble(),
        percentageComplete: json["percentage_complete"] == null
            ? null
            : json["percentage_complete"].toDouble(),
        answeredPractices: json["answered_practices"] == null
            ? null
            : json["answered_practices"],
        totalPractices:
            json["total_practices"] == null ? null : json["total_practices"],
        courseData: json["course_data"] == null
            ? null
            : List<CourseDatum>.from(
                json["course_data"].map((x) => CourseDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "avg_score": avgScore == null ? null : avgScore,
        "percentage_complete":
            percentageComplete == null ? null : percentageComplete,
        "answered_practices":
            answeredPractices == null ? null : answeredPractices,
        "total_practices": totalPractices == null ? null : totalPractices,
        "course_data": courseData == null
            ? null
            : List<dynamic>.from(courseData!.map((x) => x.toJson())),
      };
}

class CourseDatum {
  CourseDatum({
    this.id,
    this.name,
    this.icon,
    this.backgroundImage,
    this.backgroundColor,
    this.avgScore,
    this.percentageComplete,
    this.answeredPractices,
    this.totalPractices,
  });

  String? id;
  String? name;
  String? icon;
  String? backgroundImage;
  String? backgroundColor;
  double? avgScore;
  double? percentageComplete;
  int? answeredPractices;
  int? totalPractices;

  factory CourseDatum.fromJson(Map<String, dynamic> json) => CourseDatum(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        icon: json["icon"] == null ? null : json["icon"],
        backgroundImage:
            json["background_image"] == null ? null : json["background_image"],
        backgroundColor:
            json["background_color"] == null ? null : json["background_color"],
        avgScore:
            json["avg_score"] == null ? null : json["avg_score"].toDouble(),
        percentageComplete: json["percentage_complete"] == null
            ? null
            : json["percentage_complete"].toDouble(),
        answeredPractices: json["answered_practices"] == null
            ? null
            : json["answered_practices"],
        totalPractices:
            json["total_practices"] == null ? null : json["total_practices"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "icon": icon == null ? null : icon,
        "background_image": backgroundImage == null ? null : backgroundImage,
        "background_color": backgroundColor == null ? null : backgroundColor,
        "avg_score": avgScore == null ? null : avgScore,
        "percentage_complete":
            percentageComplete == null ? null : percentageComplete,
        "answered_practices":
            answeredPractices == null ? null : answeredPractices,
        "total_practices": totalPractices == null ? null : totalPractices,
      };
}
