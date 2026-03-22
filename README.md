# habit_mastery

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Habit Mastery League 📱

## 📌 Project Overview

Habit Mastery League is a mobile application designed to help users build and maintain positive habits through consistent tracking, streak monitoring, and progress visualization. The app encourages users to stay disciplined by providing clear feedback on their routines along with simple AI-style motivational insights generated from local data.

Users can create habits such as studying, exercising, drinking water, or sleeping on time, then log their daily progress and track how consistently they follow through.

---

## 🚀 Core Features

* Create, edit, and delete habits
* Log daily habit completion
* Track streaks and long-term consistency
* View dashboard summaries of progress
* Receive AI-style encouragement based on activity history

---

## 🧠 Key Responsibilities

* Designed and implemented **UI screens and widgets**
* Built **navigation system** using bottom navigation bar
* Developed **dashboard layout** for real-time progress visualization

---

## 🗄️ Local Storage Plan

### SQLite

Used for structured and relational data:

* Habits
* Habit completion logs
* Streak and progress history
* Milestone / badge tracking
* AI suggestion or feedback history

### SharedPreferences

Used for lightweight user settings:

* Theme preferences
* Notification / reminder settings

---

## 📱 App Screens & Functionality

### 1. Dashboard

**Purpose:** Provide a quick overview of user progress

**Features:**

* Active habits summary
* Habit completion stats
* Longest streak tracking
* AI encouragement message
* Recent activity preview

---

### 2. Habits Screen

**Purpose:** Manage habits

**Features:**

* Add, edit, delete habits
* Habit list with streak info
* Search and filter functionality

---

### 3. Habit Details / Completion Log

**Purpose:** Focus on a single habit

**Features:**

* Habit info and description
* Streak display
* Completion history
* “Mark Complete” functionality
* Optional notes

---

### 4. Progress / Insights

**Purpose:** Visualize trends and performance

**Features:**

* Completion trends and charts
* Streak summaries
* Milestone tracking
* AI-style performance insights

---

### 5. Settings

**Purpose:** Customize user experience

**Features:**

* Theme toggle
* Reminder preferences
* Persistent settings storage

---

## 🔁 Agile Development Approach

This project follows an **Agile SDLC approach**, where features are developed in iterative sprints. Each iteration focuses on building, testing, and refining a specific part of the application, such as habit creation, tracking, or dashboard visualization. User feedback is used to improve usability, layout, and overall experience.

---

## 🧪 Testing Strategy

### Dashboard

* Verify correct loading of habit data
* Ensure proper handling of empty states

### Habits

* Test habit creation and persistence
* Validate input fields and prevent invalid entries

### Habit Details

* Confirm completion logging works correctly
* Prevent duplicate daily completions

### Progress / Insights

* Validate data integration from multiple tables
* Ensure streak calculations are accurate

### Settings

* Confirm preferences persist after app restart
* Verify correct storage using SharedPreferences

---

## 🔄 Iteration Plan

* Test user navigation between Dashboard and Habits
* Validate habit creation and editing flow
* Ensure streak updates reflect immediately
* Improve UI layout and button placement based on feedback

---

## 🎯 Expected Outcomes

* Help users stay consistent with positive routines
* Provide clear visualization of progress over time
* Deliver motivational insights based on behavior patterns
* Enable quick and easy habit tracking

---

## 🔗 Repository

GitHub: https://github.com/iambrianwalker/project1

---

## 📌 Future Improvements

* Push notifications for reminders
* More advanced analytics and insights
* Cloud sync and backup
* Gamification (levels, rewards, achievements)

---
