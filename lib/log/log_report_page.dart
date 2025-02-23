import 'package:flutter/material.dart';
import 'package:flutter_exception_handler/flutter_exception_handler.dart';
import 'package:intl/intl.dart';

import 'exception_log.dart';

class LogReportPage extends StatefulWidget {
  const LogReportPage({Key? key}) : super(key: key);

  @override
  State<LogReportPage> createState() => _LogReportPageState();
}

class _LogReportPageState extends State<LogReportPage> {
  final Map<int, bool> _expandedMessages = {};

  @override
  Widget build(BuildContext context) {
    final logs = ExceptionHandler.logs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Report'),
        actions: [
          IconButton(
            onPressed: () {
              ExceptionHandler.clearLogs();
            },
            icon: Icon(
              Icons.clear,
            ),
          ),
        ],
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No logs recorded yet.'))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final isMessageExpanded = _expandedMessages[index] ?? false;
                const maxChars = 100;
                final message = log.message.length > maxChars && !isMessageExpanded ? '${log.message.substring(0, maxChars)}...' : log.message;

                return ExpansionTile(
                  leading: Icon(
                    Icons.error,
                    color: log.severity == LogSeverity.fatal ? Colors.red : Colors.orange,
                  ),
                  title: Text('${log.severity.name.toUpperCase()} - ${log.exceptionType} - [${DateFormat('MM/dd/yyyy hh:mm a').format(log.timestamp)}]'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText('Message: $message'),
                          if (log.message.length > maxChars) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _expandedMessages[index] = !isMessageExpanded;
                                });
                              },
                              child: Text(isMessageExpanded ? 'See less' : 'See more'),
                            ),
                          ],
                          const SizedBox(height: 8),
                          SelectableText('StackTrace: ${log.stackTrace}'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
