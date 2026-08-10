enum ConsultationMode { clinic, video, both }

extension ConsultationModeExtension on ConsultationMode {
  String get title {
    switch (this) {
      case ConsultationMode.clinic:
        return "In-Clinic";

      case ConsultationMode.video:
        return "Video Consultation";

      case ConsultationMode.both:
        return "Both";
    }
  }

  String get icon {
    switch (this) {
      case ConsultationMode.clinic:
        return "assets/icons/hospital.png";

      case ConsultationMode.video:
        return "assets/icons/video.png";

      case ConsultationMode.both:
        return "assets/icons/both.png";
    }
  }
}
