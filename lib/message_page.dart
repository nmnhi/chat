import 'package:flutter/material.dart';
import 'package:real_chat/core/theme.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Message",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Recent",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.all(5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecentContact("Barry", context),
                _buildRecentContact("Perez", context),
                _buildRecentContact("Alvin", context),
                _buildRecentContact("Dan", context),
                _buildRecentContact("Prank", context),
                _buildRecentContact("Peter", context),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.only(top: 12),
              child: ListView(
                children: [
                  _buildMessageTile(
                      "Danny H", "dannyh@gmail.com", "08:35", context),
                  _buildMessageTile(
                      "Bobby H", "dannyh@gmail.com", "08:35", context),
                  _buildMessageTile(
                      "Mike H", "dannyh@gmail.com", "08:35", context),
                  _buildMessageTile(
                      "Fabrice H", "dannyh@gmail.com", "08:35", context),
                  _buildMessageTile(
                      "Fabio H", "dannyh@gmail.com", "08:35", context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageTile(
      String name, String message, String time, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      leading: const CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          "https://cellphones.com.vn/sforum/wp-content/uploads/2024/02/avatar-anh-meo-cute-5.jpg",
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: DefaultColors.whiteText,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Text(
        time,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRecentContact(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              "https://cellphones.com.vn/sforum/wp-content/uploads/2024/02/avatar-anh-meo-cute-5.jpg",
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
