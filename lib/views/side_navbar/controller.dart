import 'package:get/get.dart';

import '../../models/agent_model.dart';
import '../../models/convo_list.dart' as convo_data;

class SideController extends GetxController {

  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {

    selectedIndex.value = index;
  }

  /// ============================================================
  /// AGENT / ASSIGNMENT STATE
  /// ============================================================

  /// Agents available for conversation assignment.
  final RxList<AgentModel> agents = <AgentModel>[].obs;

  /// True while the agents list is being loaded.
  final RxBool isLoadingAgents = false.obs;

  /// Prevents overlapping assign, reassign, and unassign actions.
  final RxBool isAssigningConversation = false.obs;

  /// ID of the conversation whose assignment action is in progress.
  final RxnString assigningConversationId = RxnString();

  /// Temporary logged-in agent.
  ///
  /// Replace this with the authenticated user when the real API is available.
  final Rxn<AgentModel> currentAgent = Rxn<AgentModel>();

  /// Only active agents are shown in the assignment dropdown.
  List<AgentModel> get activeAgents {
  return agents.where((agent) => agent.isActive).toList();
  }

  /// Current logged-in agent ID.
  int? get currentAgentId {
  return currentAgent.value?.id;
  }

  /// Safe display name for the current logged-in agent.
  String get currentAgentName {
  return currentAgent.value?.displayName ?? 'Current Agent';
  }

  /// Whether a current logged-in agent is available.
  bool get hasCurrentAgent {
  return currentAgent.value != null;
  }

  /// Loads temporary agents until the real agents API is connected.

  /// Assigns an unassigned conversation to the current logged-in agent.


  @override
  void onInit() {
  super.onInit();

  /// ------------------------------------------------------------
  /// VOICE PLAYER LISTENERS
  /// ------------------------------------------------------------

  super.onClose();
  }

  /// ============================================================
  /// SCROLL TO LATEST MESSAGE
  /// ============================================================


  /// ============================================================
  /// OPEN / SELECT CONVERSATION
  /// ============================================================


  Future<void> openChat(convo_data.ConversationModel model) async {
  selectedCenterView.value = model.platform;

  await selectConversation(model);
  }

  void openGmail() {
  if (isVoiceRecording.value ||
  isVoicePaused.value ||
  isVoiceStarting.value) {
  unawaited(cancelVoiceRecording());
  }

  isSelected = !isSelected;

  selectedCenterView.value = 'Gmail';

  convoModel.value = null;

  update();
  }

  /// ============================================================
  /// SELECTED CHAT HELPERS
  /// ============================================================

  bool get hasSelectedConversation {
  return convoModel.value != null;
  }

  convo_data.ConversationModel? get selectedConversation {
  return convoModel.value;
  }


  List<convo_data.ConversationModel> getByPlatform(String platform) {
  final filteredList = filteredConversations
      .where(
  (conversation) =>
  conversation.platform.toLowerCase() == platform.toLowerCase(),
  )
      .toList();

  filteredList.sort((first, second) {
  return second.updatedAt.compareTo(first.updatedAt);
  });

  return filteredList;
  }

  int countByPlatform(String platform) {
  return getByPlatform(platform).length;
  }

  /// ============================================================
  /// DEFAULT PLATFORM MESSAGES
  /// ============================================================





}