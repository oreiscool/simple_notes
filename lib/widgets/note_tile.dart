import 'package:flutter/material.dart';
import 'package:simple_notes/models/note_model.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({super.key, required this.note, this.onTap});

  final NoteModel note;
  final void Function()? onTap;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  Future<void> pinnedNote() async {
    if (widget.note.isPinned == true) {
      return;
    }
  }

  Future<void> unpinnedNote() async {
    if (widget.note.isPinned == false) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.note.isPinned == true) {
      pinnedNote();
    } else {
      unpinnedNote();
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
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            padding: EdgeInsets.all(25),
            height: 110,
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.note.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Spacer(),
                    if (widget.note.isPinned)
                      Icon(
                        Icons.push_pin_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  ],
                ),
                SizedBox(height: 2),
                Flexible(
                  child: Text(
                    widget.note.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
