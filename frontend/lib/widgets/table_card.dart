import 'package:flutter/material.dart' hide Table;
import 'package:hometasks/models/table.dart';
import 'package:hometasks/routes/dashboard.dart';
import 'package:hometasks/routes/screens/members_list.dart';
import 'package:hometasks/routes/screens/tasks.dart';
import 'package:hometasks/widgets/avatar.dart';
import 'package:hometasks/widgets/edit_table.dart';

class TableCard extends StatefulWidget {
  final Table table;

  const TableCard({
    super.key,
    required this.table,
  });

  @override
  State<TableCard> createState() => _TableCardState();

  static List<Widget> prepareAvatars({required List<String> members, double size = 34.0, double offset = 20.0}) {
    final List<Widget> avatars = [];
    for (int i = 0; i < members.length; i++) {
      String member = members[i];
      if(members.length > 3 && i >= 2) {
        avatars.add(numAvatar(num: members.length - i, offset: i * offset, size: size));
        break;
      } else {
        avatars.add(Avatar(id: member, offset: i * offset, size: size));
      }
    }
    return avatars;
  }
  static Widget numAvatar({required int num, double size = 34.0, double offset = 0.0, double borderSize = 2}) {
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: borderSize),
          color: Colors.grey.shade300,
        ),
        child: Center(
          child: Text(
            '+$num',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _TableCardState extends State<TableCard> {
  @override
  Widget build(BuildContext context) {
    final table = widget.table;
    return GestureDetector(
      onTap: () {
        if(!table.isLoading && table.role == UserRole.owner) {
          showDialog(context: context, builder: (context) =>
            EditTableWidget(table: table, card: this),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 22, top: 22, right: 22, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: 1, blurRadius: 1, offset: Offset(2, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: table.role.backgroundColor,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Icon(
                    table.icon,
                    color: table.role.mainColor,
                    size: 28,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: table.role.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    table.role.value.toUpperCase(),
                    style: TextStyle(
                      color: table.role.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Title
            Text(
              table.title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900
              ),
            ),

            const SizedBox(height: 18),
            GestureDetector(
              onTap: !table.isLoading ? () {
                DashboardPage.globalKey.currentState!.showOverlay(MembersListScreen(table: table));
              } : null,
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Stack(
                      children: TableCard.prepareAvatars(members: table.members.keys.toList()),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Text(
                    '${table.members.length} ${table.members.length != 1 ? "membros" : "membro"}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Divider(color: Colors.grey.shade200),

            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: table.isActive ? Colors.green : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      table.isActive ? 'Ativo' : 'Visualização apenas',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                IconButton(
                  onPressed: !table.isLoading ? () {
                    DashboardPage.globalKey.currentState!.selectedIndex = 1;
                    DashboardPage.globalKey.currentState!.showOverlay(TasksScreen(table: table.id));
                   } : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey.shade500,
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}