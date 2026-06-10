# DailyDO

DailyDo isn't a large to-do list storage- it surfaces only what you **need** to handle that day. Newly added tasks, recurring tasks, tasks due the next day: all relevant information, front and center. Everything else stays out of view. The calendar is there when you need the full picture.

Completed tasks clean themselves up automatically after 3 days *(configurable duration coming later)*, and every task has a built-in timer — use it to track time spent, or just as a standalone timer.

---

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/f504424b-9669-40b5-99a0-14ac5f487a00" width="220">
  <img src="https://github.com/user-attachments/assets/68944b3b-0431-4141-9d2b-e84ce21ff890" width="220">
  <img src="https://github.com/user-attachments/assets/4f3b291a-53f1-4c76-b500-7aea845841f0" width="220">
  <img src="https://github.com/user-attachments/assets/969ca70e-b970-4c14-a32e-114e6da44e7b" width="220">
</p>

---

## Features

### Task Management
- Create, edit, and delete tasks
- Mark tasks as completed
- Automatic cleanup of completed tasks
- Optional task descriptions

### Scheduling
- Set due dates and times
- Configure reminder notifications before deadlines
- Create recurring tasks using weekday schedules
- Automatically surface tasks relevant for the current day

### Notifications
- Local notifications using `flutter_local_notifications`
- Scheduled reminders before task deadlines
- Background notification support
- Android notification permission handling

### Calendar View
- Browse tasks by date
- Visual overview of scheduled work
- Integration with recurring and one-time tasks

### Focus Timer
- Dedicated timer page
- Task-linked focus tracking
- Focus duration persistence across app restarts

### Local Persistence
- SQLite database storage
- Task data survives app restarts
- Reminder and schedule information stored locally

---

## Project Structure

```text
lib/
├── backend/
│   ├── database_service.dart
│   └── notification_service.dart
│
├── providers/
│   └── task_provider.dart
│
├── task.dart
├── todo.dart
├── taskexpanded.dart
├── schedulemenu.dart
├── calendar.dart
├── timer.dart
├── settings.dart
└── main.dart
```

---

## Running Locally

```bash
git clone <repository-url>
cd productivity-app

flutter pub get
flutter run
```

---

## Building

### Release APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

---

## Future Improvements

- Multiple reminders per task
- Cloud synchronization
- Backup and restore
- Statistics and productivity analytics
- Task categories and tags
- Cross-device syncing

---

## License

MIT
