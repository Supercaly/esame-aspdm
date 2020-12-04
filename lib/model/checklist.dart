class Checklist {
  final String title;
  final List<ChecklistItem> items;

  Checklist([this.title, this.items]);
}

class ChecklistItem {
  final String text;
  final bool checked;

  ChecklistItem(this.text, this.checked);
}