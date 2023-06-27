import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:mx/date_time_ext.dart';
import 'package:intl/intl.dart';
import 'package:mx/todoitem.dart';
import 'package:mx/utils/sql_helper.dart';

/// screen for creating or viewing created To do item
class CreateTodoScreen extends StatefulWidget{
  final TodoItem item;
  final bool isEditing;
  final int nextid;

  CreateTodoScreen ({
    Key? key,
    required this.isEditing,
    required this.item,
    required this.nextid
}) : super(key: key);

  @override
  _CreateTodoScreen createState() => _CreateTodoScreen();
}

class _CreateTodoScreen extends State<CreateTodoScreen> {
  late bool _value;
  DateTime _cachedDate = DateTime.now();
  late TextEditingController myController;
  bool isSaveButtonActive = true;
  bool isDeleteButtonActive = true;
  String thisPriority = "no";
  DateTime? pickedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    thisPriority = widget.item.priority;
    myController = TextEditingController();
    myController.text = widget.isEditing ? widget.item.description : myController.text;
    myController.addListener(() {
      final isButtonActive = myController.text.isNotEmpty;
      setState(() => this.isSaveButtonActive = isButtonActive);
    });
    pickedDate = widget.item.deadline ?? DateTime.now();
    _value = widget.item.deadline != null;
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(
      id,
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final todo = ref.watch(todoProvider(id));
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 8,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async => Navigator.pop(context),
              splashRadius: 0.1,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: myController.text.isEmpty ? null : () async {
                    if (_value) {
                      final item = TodoItem(
                          id : widget.nextid,
                          description: myController.text,
                          priority: thisPriority,
                          deadline: pickedDate,
                          completed: widget.isEditing ? widget.item.completed : false);
                      Navigator.pop(context, item);
                    } else {
                      final item = TodoItem(
                          id : widget.nextid,
                          description: myController.text,
                          priority: thisPriority,
                          completed: widget.isEditing ? widget.item.completed : false);
                      Navigator.pop(context, item);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.save,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 23),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Form(
                      child: TextFormField(
                        controller: myController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.doSmth
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return AppLocalizations.of(context)!.emptyFieldError;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //'Важность',
                            AppLocalizations.of(context)!.importance,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          PopupMenuButton(itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(value: 0, child: Text(AppLocalizations.of(context)!.no)),
                              PopupMenuItem<int>(value: 1, child: Text(AppLocalizations.of(context)!.low)),
                              PopupMenuItem<int>(value: 2, child: Text(AppLocalizations.of(context)!.high))
                            ];
                          },
                            onSelected: (value) {
                            if (value == 0) {
                              setState(() {
                                thisPriority = "no";
                              });

                            }
                            if (value == 1) {
                              setState(() {
                                thisPriority = "low";
                              });
                            }
                            if (value == 2) {
                              setState(() {
                                thisPriority = "high";
                              });
                            }

                            },
                            child: Text(thisPriority == "no" ? AppLocalizations.of(context)!.no :
                            thisPriority == "low" ? AppLocalizations.of(context)!.low :
                            AppLocalizations.of(context)!.high)
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child:
                    Divider(
                      height: 0,
                      thickness: 0.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.doToDate,
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.bottomLeft,
                              crossFadeState: !_value
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: const SizedBox(
                                width: 100,
                              ),
                              secondChild: Column(
                                children: [
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final newDate = await showDatePicker(
                                        context: context,
                                        initialDate: pickedDate ?? DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                        helpText: '',
                                        cancelText: AppLocalizations.of(context)!.cancel,
                                        confirmText: AppLocalizations.of(context)!.ready,
                                        onDatePickerModeChange: (_) {
                                        },
                                        builder: (context, child) => Theme(
                                          data: Theme.of(context).copyWith(
                                          ),
                                          child: child!,
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          pickedDate = value!;
                                        });
                                      });
                                      if (newDate != null) {
                                        _cachedDate = newDate;
                                      }
                                    },
                                    child: Text(
                                      pickedDate
                                          .getFormattedTime(Intl.getCurrentLocale()),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: _value,
                          onChanged: (bool value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: TextButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Icon(
                              Icons.delete,
                              color: widget.isEditing ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(
                              color: widget.isEditing ? Colors.red : Colors.grey
                            ),
                          )
                        ],
                      ),
                      onPressed: !widget.isEditing ? null : () async {
                        final item = TodoItem(
                            id : 3,
                            description: myController.text,
                            priority: "delete",
                            deadline: pickedDate,
                            completed: widget.isEditing ? widget.item.completed : false);
                        Navigator.pop(context, item);
                      }
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

