import 'package:flutter/material.dart';
import 'package:simple_notes/models/note_model.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note, this.onTap});

  final Note note;
  final void Function()? onTap;

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
                Text(
                  note.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Flexible(
                  child: Text(
                    note.content,
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
