import 'package:flutter/material.dart';
import 'package:simple_notes/models/note_model.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note, this.onTap});

  final NoteModel note;
  final void Function()? onTap;

  Future<void> pinnedNote() async {
    if (note.isPinned == true) {
      return;
    }
  }

  Future<void> unpinnedNote() async {
    if (note.isPinned == false) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 125),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        note.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Spacer(),
                      if (note.isPinned)
                        Icon(
                          Icons.push_pin_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      note.preview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      note.formattedLastModified,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
