import 'package:graphql_flutter/graphql_flutter.dart';
import '../../messages/data/graphql_client.dart';

class MessengerService {
  final GraphQLClient _client = NVSGraphQLClient.client;

  Future<void> sendYo({required String receiverWalletAddress}) async {
    const String mutation = r'''
      mutation SendYo($receiverWalletAddress: String!) {
        sendYo(receiverWalletAddress: $receiverWalletAddress) {
          id
          senderWalletAddress
          receiverWalletAddress
          timestamp
        }
      }
    ''';

    final MutationOptions opts = MutationOptions(
      document: gql(mutation),
      variables: <String, dynamic>{'receiverWalletAddress': receiverWalletAddress},
    );
    await _client.mutate(opts);
  }

  Future<void> sendMessage({
    required String threadId,
    required String content,
    String messageType = 'TEXT',
    String context = 'UNIVERSAL',
  }) async {
    const String mutation = r'''
      mutation SendMessage($threadId: ID!, $content: String!, $messageType: String!, $context: String!) {
        sendMessage(threadId: $threadId, content: $content, messageType: $messageType, context: $context) {
          id
          threadId
          senderWalletAddress
          content
          messageType
          context
          createdAt
        }
      }
    ''';
    final MutationOptions opts = MutationOptions(
      document: gql(mutation),
      variables: <String, dynamic>{
        'threadId': threadId,
        'content': content,
        'messageType': messageType,
        'context': context,
      },
    );
    await _client.mutate(opts);
  }
}




