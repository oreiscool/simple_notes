import 'package:flutter/material.dart';
import 'package:simple_notes/models/note_model.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.note,
    this.onTap,
    required this.heroTagPrefix,
  });

  final NoteModel note;
  final void Function()? onTap;
  final String heroTagPrefix;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${heroTagPrefix}_${note.id}',
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 125),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      if (note.isPinned)
                        Icon(
                          Icons.push_pin_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      note.preview,
                      maxLines: 10,
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
