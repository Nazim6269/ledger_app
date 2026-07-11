import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/database/app_database.dart';
import 'package:ledger_app/features/add-expense/domain/entities/split_type.dart';
import 'package:ledger_app/features/add-expense/domain/entities/member_input.dart';
import 'package:ledger_app/features/add-expense/domain/services/split_calculator.dart';
import 'package:ledger_app/features/add-expense/presentation/providers/expense_provider.dart';
import 'package:ledger_app/features/common/providers/current_user_provider.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';

class ExpenseFormState {
  final double amount;
  final String category;
  final String note;
  final bool isShared;
  final SplitType splitType;
  final Map<String, double> memberInputs; // userId -> raw input value
  final List<HouseholdMember> members;
  final String? error;

  ExpenseFormState({
    this.amount = 0,
    this.category = 'Groceries',
    this.note = '',
    this.isShared = false,
    this.splitType = SplitType.equal,
    this.memberInputs = const {},
    this.members = const [],
    this.error,
  });

  ExpenseFormState copyWith({
    double? amount,
    String? category,
    String? note,
    bool? isShared,
    SplitType? splitType,
    Map<String, double>? memberInputs,
    List<HouseholdMember>? members,
    String? error,
  }) {
    return ExpenseFormState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      isShared: isShared ?? this.isShared,
      splitType: splitType ?? this.splitType,
      memberInputs: memberInputs ?? this.memberInputs,
      members: members ?? this.members,
      error: error,
    );
  }
}

class ExpenseFormNotifier extends StateNotifier<ExpenseFormState> {
  final Ref ref;
  final String householdId;
  final String currentUserId;

  ExpenseFormNotifier(this.ref, this.householdId, this.currentUserId)
    : super(ExpenseFormState()) {
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final members = await ref.read(transactionRepositoryProvider).getMembers(householdId);
    state = state.copyWith(members: members);
  }

  void setAmount(double v) => state = state.copyWith(amount: v, error: null);
  void setCategory(String v) => state = state.copyWith(category: v);
  void setNote(String v) => state = state.copyWith(note: v);
  void setIsShared(bool v) => state = state.copyWith(isShared: v);
  void setSplitType(SplitType v) => state = state.copyWith(splitType: v);

  void setMemberInput(String userId, double value) {
    final updated = Map<String, double>.from(state.memberInputs);
    updated[userId] = value;
    state = state.copyWith(memberInputs: updated, error: null);
  }

  Future<bool> save() async {
    Map<String, double> splits = {};

    if (state.isShared) {
      final result = SplitCalculator.calculate(
        type: state.splitType,
        totalAmount: state.amount,
        members: state.members
            .map(
              (m) => MemberInput(
                userId: m.userId,
                userName: m.userName,
                rawValue: state.memberInputs[m.userId] ?? 0,
              ),
            )
            .toList(),
      );

      if (!result.isValid) {
        state = state.copyWith(error: result.error);
        return false;
      }
      splits = result.amountByUserId;
    }

    await ref
        .read(transactionRepositoryProvider)
        .saveExpense(
          householdId: householdId,
          createdBy: currentUserId,
          amount: state.amount,
          category: state.category,
          note: state.note,
          isShared: state.isShared,
          splits: splits,
        );

    return true;
  }
}

final expenseFormProvider =
    StateNotifierProvider.autoDispose<ExpenseFormNotifier, ExpenseFormState>((
      ref,
    ) {
      final household = ref.watch(currentHouseholdProvider).value;
      final userId = ref.watch(currentUserProvider);
      if (household == null) {
        throw Exception('No household selected');
      }
      return ExpenseFormNotifier(ref, household.id, userId);
    });
