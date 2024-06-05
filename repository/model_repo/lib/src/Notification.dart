enum NotificationType {
  newRecipe,
  newComment,
  newLike,
  newFollower,
  newMessage,
  newNotification
}

class NotificationModel {
  final String? notificationId;
  final String? title;
  final String? body;
  final String? date;
  final String? userSender;
  final String? userReceiver;
  final NotificationType? type;
  final String? extraData;
  final bool? read;

  NotificationModel({
    this.title,
    this.body,
    this.date,
    this.userSender,
    this.userReceiver,
    this.type,
    this.extraData,
    this.notificationId,
    this.read = false,
  });

  NotificationModel copyWith({
    String? title,
    String? body,
    String? date,
    String? userSender,
    String? userReceiver,
    NotificationType? type,
    String? extraData,
    String? notificationId,
    bool? read,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      userSender: userSender ?? this.userSender,
      userReceiver: userReceiver ?? this.userReceiver,
      type: type ?? this.type,
      extraData: extraData ?? this.extraData,
      notificationId: notificationId ?? this.notificationId,
      read: read ?? this.read,
    );
  }

  NotificationModel.empty()
      : notificationId = '',
        title = '',
        body = '',
        date = '',
        userSender = '',
        userReceiver = '',
        type = NotificationType.newNotification,
        read = false,
        extraData = '';

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'],
      title: map['title'],
      body: map['body'],
      date: map['date'],
      read: map['read'] ?? false,
      userSender: map['userSender'],
      userReceiver: map['userReceiver'],
      type: NotificationType.values
          .firstWhere((element) => element.toString() == map['type']),
      extraData: map['extraData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'read': read,
      'date': date,
      'userSender': userSender,
      'userReceiver': userReceiver,
      'type': type.toString(),
      'extraData': extraData,
    };
  }
}
