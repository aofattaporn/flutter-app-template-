import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../di/injection.dart';
import '../../../../domain/entities/plan.dart';
import '../../../../domain/repositories/plan_repository.dart';

/// Plan Editor page for creating and editing plans
/// Supports both create and edit modes based on whether an existing plan is passed
class PlanEditorPage extends StatefulWidget {
  /// Existing plan to edit (null for create mode)
  final Plan? existingPlan;

  /// Current total of all plan items (for validation)
  final double currentTotalPlanned;

  const PlanEditorPage({
    super.key,
    this.existingPlan,
    this.currentTotalPlanned = 0,
  });

  /// Check if in edit mode
  bool get isEditMode => existingPlan != null;

  @override
  State<PlanEditorPage> createState() => _PlanEditorPageState();
}

class _PlanEditorPageState extends State<PlanEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expectedIncomeController = TextEditingController();
  final PlanRepository _planRepository = getIt<PlanRepository>();

  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  // state usage
  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _setAsActive = true;
  bool _isLoading = false;

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  int get _planDuration {
    return _endDate.difference(_startDate).inDays + 1;
  }

  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  // LIFECYCLE
  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.existingPlan != null) {
      final plan = widget.existingPlan!;
      _nameController.text = plan.name;
      _startDate = plan.startDate;
      _endDate = plan.endDate;
      if (plan.expectedIncome != null) {
        _expectedIncomeController.text =
            plan.expectedIncome!.toStringAsFixed(2);
      }
      _setAsActive = plan.isActive;
    } else {
      // Default name based on month
      final now = DateTime.now();
      _nameController.text = DateFormat('MMMM yyyy').format(now);

      // Default to current month period
      _startDate = DateTime(now.year, now.month, 1);
      _endDate =
          DateTime(now.year, now.month + 1, 0); // Last day of current month
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _expectedIncomeController.dispose();
    super.dispose();
  }

  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  // DIALOG METHODS
  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4D648D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Auto-adjust end date if it's before start date
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4D648D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final expectedIncome = _expectedIncomeController.text.isNotEmpty
          ? double.tryParse(_expectedIncomeController.text)
          : null;

      // Validate: expected income should cover total planned items
      if (expectedIncome != null &&
          widget.currentTotalPlanned > 0 &&
          expectedIncome < widget.currentTotalPlanned) {
        _showValidationError(
          'Insufficient Budget',
          'Your expected income (${CurrencyUtils.formatCurrency(expectedIncome)}) '
              'is less than your total planned items (${CurrencyUtils.formatCurrency(widget.currentTotalPlanned)}). '
              'Please increase your expected income or reduce your plan items.',
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        if (widget.existingPlan != null) {
          // Update existing plan
          final wasActive = widget.existingPlan!.isActive;
          final wantsToBeActive = _setAsActive;

          // First update the plan data (without changing isActive yet if switching to active)
          final updatedPlan = widget.existingPlan!.copyWith(
            name: _nameController.text.trim(),
            startDate: _startDate,
            endDate: _endDate,
            expectedIncome: expectedIncome,
            // If switching from inactive to active, we'll handle it separately
            isActive: wasActive ? _setAsActive : false,
          );
          await _planRepository.updatePlan(updatedPlan);

          // If user wants to set this plan as active (and it wasn't before),
          // use setActivePlan to properly deactivate other plans
          if (wantsToBeActive && !wasActive) {
            await _planRepository.setActivePlan(widget.existingPlan!.id);
          }
        } else {
          // Create new plan - if setting as active, first create then set active
          final createdPlan = await _planRepository.createPlan(
            name: _nameController.text.trim(),
            startDate: _startDate,
            endDate: _endDate,
            expectedIncome: expectedIncome,
            isActive: false, // Create as inactive first
          );

          // If user wants this plan to be active, use setActivePlan
          if (_setAsActive) {
            await _planRepository.setActivePlan(createdPlan.id);
          }
        }

        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          _showValidationError(
            'Error',
            widget.existingPlan != null
                ? 'Failed to update plan: ${e.toString()}'
                : 'Failed to create plan: ${e.toString()}',
          );
        }
      }
    }
  }

  void _showValidationError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  // BUILD - MAIN
  // โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•โ•
  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.existingPlan != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isEditMode),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plan Name
                        _buildNameField(),

                        const SizedBox(height: 24),

                        // Date Range
                        _buildDateRangeSection(),

                        const SizedBox(height: 24),

                        // Expected Income
                        _buildExpectedIncomeField(),

                        const SizedBox(height: 24),

                        // Set as Active Toggle
                        _buildActiveToggle(isEditMode),

                        const SizedBox(height: 24),

                        // Preview Section
                        _buildPreviewSection(),

                        const SizedBox(height: 24),

                        // Helper Note
                        _buildHelperNote(),

                        // Bottom padding for action bar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Action Bar
      bottomNavigationBar: _buildBottomActionBar(isEditMode),
    );
  }

  Widget _buildHeader(bool isEditMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              isEditMode ? 'Edit Plan' : 'Create New Plan',
              style: AppStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Plan Name', style: AppStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: AppStyles.input(hint: 'e.g. January 2025 Budget'),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Please enter a plan name';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Plan Period', style: AppStyles.label),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDateButton(
                label: 'Start Date',
                date: _startDate,
                onTap: _selectStartDate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.arrow_forward, color: AppColors.textTertiary, size: 20),
            ),
            Expanded(
              child: _buildDateButton(
                label: 'End Date',
                date: _endDate,
                onTap: _selectEndDate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('$_planDuration days', style: AppStyles.caption),
      ],
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: AppStyles.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppStyles.caption),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.textTertiary),
                const SizedBox(width: 8),
                Text(_formatDate(date), style: AppStyles.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectedIncomeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Expected Income ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '(Optional)',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _expectedIncomeController,
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixText: 'เธฟ ',
            prefixStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4D648D)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Track your expected income for this period (salary, freelance, etc.)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveToggle(bool isEditMode) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: AppStyles.card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set as Active Plan', style: AppStyles.bodyLarge),
                const SizedBox(height: 4),
                Text(
                  isEditMode ? 'This plan is currently active' : 'Make this your current budget plan',
                  style: AppStyles.caption,
                ),
              ],
            ),
          ),
          Switch(
            value: _setAsActive,
            onChanged: (value) => setState(() => _setAsActive = value),
            activeTrackColor: AppColors.accent,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    final expectedIncome = _expectedIncomeController.text.isNotEmpty
        ? double.tryParse(_expectedIncomeController.text) ?? 0
        : 0.0;

    final hasBudgetIssue = expectedIncome > 0 &&
        widget.currentTotalPlanned > 0 &&
        expectedIncome < widget.currentTotalPlanned;

    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: hasBudgetIssue ? Colors.orange.shade50 : AppColors.surfaceLight,
        border: Border.all(
          color: hasBudgetIssue ? Colors.orange.shade300 : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Preview', style: AppStyles.label),
              if (hasBudgetIssue) ...[
                const Spacer(),
                Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange.shade700),
                const SizedBox(width: 4),
                Text(
                  'Budget Issue',
                  style: AppStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _buildPreviewRow('Plan Name',
              _nameController.text.isEmpty ? '-' : _nameController.text),
          const SizedBox(height: 8),
          _buildPreviewRow('Period',
              '${_formatDate(_startDate)} - ${_formatDate(_endDate)}'),
          const SizedBox(height: 8),
          _buildPreviewRow('Duration', '$_planDuration days'),
          if (expectedIncome > 0) ...[
            const SizedBox(height: 8),
            _buildPreviewRow('Expected Income',
                CurrencyUtils.formatCurrency(expectedIncome)),
          ],
          if (widget.currentTotalPlanned > 0) ...[
            const SizedBox(height: 8),
            _buildPreviewRow(
              'Total Planned Items',
              CurrencyUtils.formatCurrency(widget.currentTotalPlanned),
              valueColor: hasBudgetIssue ? Colors.orange.shade700 : null,
            ),
          ],
          if (expectedIncome > 0 && widget.currentTotalPlanned > 0) ...[
            const SizedBox(height: 8),
            _buildPreviewRow(
              'Remaining Budget',
              CurrencyUtils.formatCurrency(
                  expectedIncome - widget.currentTotalPlanned),
              valueColor:
                  hasBudgetIssue ? AppColors.expense : AppColors.income,
            ),
          ],
          const SizedBox(height: 8),
          _buildPreviewRow('Status', _setAsActive ? 'Active' : 'Inactive'),
          if (hasBudgetIssue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Expected income is less than total planned. Increase income or reduce plan items.',
                      style: AppStyles.caption.copyWith(color: Colors.orange.shade800, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.caption),
        Text(value, style: AppStyles.bodySmall.copyWith(color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildHelperNote() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: AppStyles.card,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About Plans', style: AppStyles.label),
                const SizedBox(height: 4),
                Text(
                  'A plan helps you organize your budget for a specific period. You can have multiple plans but only one can be active at a time.',
                  style: AppStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(bool isEditMode) {
    final isValid = _nameController.text.trim().isNotEmpty && !_isLoading;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                style: AppStyles.secondaryButton,
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isValid ? _submit : null,
                style: AppStyles.primaryButton,
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isEditMode ? 'Save Changes' : 'Create Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}