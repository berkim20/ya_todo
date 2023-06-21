import 'package:flutter/material.dart';

/// screen for creating or viewing created To do item
class CreateTodoScreen extends StatefulWidget{

  @override
  _CreateTodoScreen createState() => _CreateTodoScreen();
}
class _CreateTodoScreen extends State<CreateTodoScreen> {


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
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "СОХРАНИТЬ",
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
                        initialValue: "Write here",
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
                            'Важность',
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  //const MyDividerWidget(),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
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
