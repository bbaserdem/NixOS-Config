account: email: order: let
  prefix = "${order}.${account}";
in [
  {
    name = "[${prefix}.1] ├─📥 Inbox";
    query = "to:${email} AND ((tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged))";
    limit = 1000;
  } {
    name = "[${prefix}.2] ├─🧑 Personal";
    query = "to:${email} AND (tag:personal)";
    limit = 1000;
  } {
    name = "[${prefix}.3] ├─💸 Promotions";
    query = "to:${email} AND (tag:promotions)";
    limit = 1000;
  } {
    name = "[${prefix}.4] ├─🐦 Social";
    query = "to:${email} AND (tag:social)";
    limit = 1000;
  } {
    name = "[${prefix}.5] ├─📤 Sent";
    query = "to:${email} AND (tag:sent)";
    limit = 1000;
  } {
    name = "[${prefix}.6] ├─🚩 Flagged";
    query = "to:${email} AND (tag:flagged)";
    limit = 1000;
  } {
    name = "[${prefix}.7] └─🏦 Archive";
    query = "to:${email} AND (not tag:inbox and not tag:spam)";
    limit = 1000;
  }
]
