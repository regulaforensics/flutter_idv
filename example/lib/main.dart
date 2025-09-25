import 'package:flutter/material.dart';
import 'package:flutter_idv/flutter_idv.dart';
import 'package:flutter/services.dart';

const loginType = Configuration.credentials;
const baseUrl = "https://idv.regula.app";
const username = "username_placeholder";
const password = "password_placeholder";
const tokenUrl = "token_placeholder";
const apiKey = "api_key_placeholder";

var idv = IDV.instance;
var selectedWorkflow = "";
var workflowIds = [];

void init() async {
  var (_, iError) = await idv.initialize();
  if (handleException(iError, tag: "initialize")) return;

  var success = {
    Configuration.credentials: () async => await configureWithCredentials(),
    Configuration.token: () async => await configureWithToken(),
    Configuration.apiKey: () async => await configureApiKey(),
  }[loginType]!;
  if (!await success()) return;

  var (wfs, error) = await idv.getWorkflows();
  if (handleException(error, tag: "getWorkflows")) return;
  if (loginType == Configuration.token) {
    // Not consistent, sometimes wfs and workflowIds don't intersect.
    // May be use prepareWorkflow for each workflowId to get its name instead.
    wfs = wfs!.where((wf) => workflowIds.contains(wf.id)).toList();
  }

  setWorkflows(wfs!);
  setStatus("Ready");
}

Future<bool> configureWithCredentials() async {
  var (success, error) = await idv.configureWithCredentials(
      CredentialsConnectionConfig(baseUrl, username, password));
  handleException(error, tag: "configureWithCredentials");
  return success;
}

Future<bool> configureWithToken() async {
  var (wfIds, error) =
      await idv.configureWithToken(TokenConnectionConfig(tokenUrl));
  if (handleException(error, tag: "configureWithToken")) return false;
  workflowIds = wfIds!;
  return true;
}

Future<bool> configureApiKey() async {
  var (success, error) =
      await idv.configureWithApiKey(ApiKeyConnectionConfig(baseUrl, apiKey));
  handleException(error, tag: "configureWithApiKey");
  return success;
}

void startWorkflow() async {
  if (selectedWorkflow.isEmpty) return;
  setStatus("Preparing Workflow...");

  var (_, prepareError) =
      await idv.prepareWorkflow(PrepareWorkflowConfig(selectedWorkflow));
  if (handleException(prepareError, tag: "prepareWorkflow")) return;

  var (result, error) = await idv.startWorkflow();
  if (handleException(error, tag: "startWorkflow")) return;

  setStatus("Success");
  setDescription("SessionID: ${result?.sessionId}");
}

bool handleException(String? error, {String? tag = ""}) {
  if (error == null) return false;
  setStatus("Error - IDV.$tag()");
  setDescription(error);
  print(error);
  return true;
}

enum Configuration {
  credentials,
  token,
  apiKey,
}

// --------------------------------------------------------------------------------------------------------------------

var status = "Initializing...";
void setStatus(String? s) {
  if (s != null) {
    MyAppState.update(() => status = s);
  }
}

var description = null;
void setDescription(String? s) {
  MyAppState.update(() => description = s);
}

var workflows = <Workflow>[];
void setWorkflows(List<Workflow> data) {
  MyAppState.update(() {
    workflows = data;
    if (workflows.isEmpty) return;
    selectedWorkflow = workflows.first.id;
  });
}

List<Widget> customHeader() => [
      header(
        [label(status)],
      ),
      header(
        top: false,
        visible: description != null,
        [label(description ?? "", small: true)],
      )
    ];

List<Widget> ui() {
  return [
    Expanded(
      child: Container(
        color: Color.fromARGB(5, 0, 0, 0),
        padding: EdgeInsets.only(left: 40),
        child: RadioGroup(
          groupValue: selectedWorkflow,
          onChanged: (value) => MyAppState.update(
            () => selectedWorkflow = value!,
          ),
          child: ListView.builder(
            itemCount: workflows.length,
            itemBuilder: (context, int index) => ListTile(
              leading: Radio(value: workflows[index].id),
              title: Text(workflows[index].name),
              onTap: () => MyAppState.update(
                () => selectedWorkflow = workflows[index].id,
              ),
            ),
          ),
        ),
      ),
    ),
    Row(children: [
      Expanded(
        child: button("Start Workflow", startWorkflow),
      )
    ]),
  ];
}

Widget button(String text, VoidCallback onPressed) => Padding(
    padding: EdgeInsets.all(5),
    child: SizedBox(
      height: 40,
      child: FilledButton(onPressed: onPressed, child: Text(text)),
    ));

Widget label(String text, {bool small = false}) => Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: small ? 15 : 18,
        fontWeight: FontWeight.w600,
      ),
    ));

Widget header(
  List<Widget> children, {
  bool top = true,
  visible = true,
}) =>
    Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.only(top: top ? 70 : 13),
        color: Colors.black.withValues(alpha: 0.03),
        child: Column(children: [
          ...children,
          Container(
            margin: EdgeInsets.only(top: 13),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color.fromRGBO(0, 0, 0, 0.075),
            ),
          ),
        ]),
      ),
    );

// --------------------------------------------------------------------------------------------------------------------

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    instance = this;
    init();
  }

  @override
  Widget build(_) => MaterialApp(
      theme: ThemeData(colorScheme: theme),
      home: Scaffold(
        body: Column(children: [
          ...customHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 35),
              child: Column(children: ui()),
            ),
          ),
        ]),
      ));

  static final theme = ColorScheme.fromSwatch(accentColor: Color(0xFF4285F4));
  static late MyAppState instance;
  static update(VoidCallback state) => {instance.setState(state)};
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MyAppState();
  }
}

void main() => runApp(new MaterialApp(home: new MyApp()));
