# Ledger 💰

A shared budgeting app for couples, roommates, and households — built with Flutter.

## Problem

Most budgeting apps (Mint, YNAB, Wallet, etc.) are built for a single user. But money in a household is rarely single-user: rent, groceries, utilities, and countless small expenses are shared between two or more people. Existing solutions force awkward workarounds — separate spreadsheets, manual math in a group chat, or apps like Splitwise that only handle "who owes who" without any real budgeting on top.

**Ledger solves this by combining personal budgeting and shared expense splitting in one app**, so a household can:

- Track their own personal spending privately
- Log shared expenses and split them fairly (equal, percentage, or exact amounts)
- See a live running balance of who owes whom
- Settle up without leaving the app

## Who it's for

- Couples managing a shared household budget
- Roommates splitting rent, utilities, and groceries
- Any small group (friends, family) sharing recurring or one-off costs

## Core Features

### ✅ Built so far

- [x] Local-first offline database (Drift/SQLite)
- [x] Household & member data model
- [x] Add expense with category, note, and amount
- [x] Mark expenses as personal or shared
- [x] Split shared expenses three ways:
  - Equal split
  - Percentage split
  - Exact amount split
- [x] Input validation (splits must add up to the total)
- [x] Live-updating transaction list (reactive, no manual refresh)

### 🚧 Planned

- [ ] Settlement view — net balance of who owes whom, with a "Settle Up" action
- [ ] User authentication (Supabase Auth)
- [ ] Real household creation & invite flow (multi-device)
- [ ] Real-time sync across devices (Supabase Realtime)
- [ ] Budget limits per category with progress indicators
- [ ] Spending history & simple analytics/charts
- [ ] Recurring expenses (rent, subscriptions)
- [ ] Push notifications (new shared expense, settlement reminders)
- [ ] Bank account sync (stretch goal)
- [ ] Receipt photo attachments (stretch goal)

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| Framework | Flutter | Cross-platform (iOS/Android) from one codebase |
| State management | Riverpod | Predictable, testable state; scales well for async/real-time data |
| Local database | Drift (SQLite) | Type-safe, reactive local storage; enables offline-first architecture |
| Backend (planned) | Supabase | Postgres + Row-Level Security (fits "shared vs private" data model), built-in Auth & Realtime |
| ID generation | UUID | Safe for records created offline and synced later across devices |

## Architecture

The app follows a layered structure to keep business logic independent of both the UI and the database implementation:

```
lib/
├── models/         # Plain Dart models & enums (e.g. SplitType)
├── database/       # Drift table definitions & raw queries
├── repositories/    # Data access layer — hides Drift from the rest of the app
├── logic/           # Pure business logic (e.g. split calculations) — fully unit-testable
├── providers/       # Riverpod providers & state notifiers
├── screens/         # Full-page UI, wired to providers
└── widgets/         # Reusable UI components
```

**Design principle:** screens render, providers hold state, repositories touch data, logic computes. No layer skips another — this keeps the app testable and makes it possible to swap the backend later without rewriting the UI.

## Data Model

```
households        → id, name, created_by
household_members → id, household_id, user_id, user_name
transactions       → id, household_id, created_by, amount, category, note, is_shared, is_synced
splits             → id, transaction_id, user_id, amount_owed
```

A transaction can have multiple splits — one row per household member owing a portion — which supports equal, percentage, and exact-amount splitting without special-casing queries.

## Getting Started

```bash
git clone <repo-url>
cd ledger_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Status

🔨 Early development — currently a fully functional **offline** expense tracker with splitting logic. Backend sync, auth, and multi-device support are next.

## License

TBD
