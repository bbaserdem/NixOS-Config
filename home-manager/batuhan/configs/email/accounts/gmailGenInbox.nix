account: [
    {
      name = "├─📥 Inbox──────[${account}]";
      query = "(tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged)";
      limit = 1000;
    } {
      name = "├─🏦 Archive────[${account}]";
      query = "not tag:inbox and not tag:spam";
      limit = 1000;
    } {
      name = "├─🧑 Personal───[${account}]";
      query = "tag:personal";
      limit = 1000;
    } {
      name = "├─🚩 Flagged────[${account}]";
      query = "tag:flagged";
      limit = 1000;
    } {
      name = "├─💸 Promotions─[${account}]";
      query = "tag:promotions";
      limit = 1000;
    } {
      name = "├─🐦 Social─────[${account}]";
      query = "tag:social";
      limit = 1000;
    } {
      name = "└─📤 Sent───────[${account}]";
      query = "tag:sent";
      limit = 1000;
    }
]
