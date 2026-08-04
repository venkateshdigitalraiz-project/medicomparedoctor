enum PatientFilter { all, completed, waiting, cancelled }

extension PatientFilterLabel on PatientFilter {
  String get label {
    switch (this) {
      case PatientFilter.all:
        return 'All';
      case PatientFilter.completed:
        return 'Completed';
      case PatientFilter.waiting:
        return 'Waiting';
      case PatientFilter.cancelled:
        return 'Cancel';
    }
  }
}
