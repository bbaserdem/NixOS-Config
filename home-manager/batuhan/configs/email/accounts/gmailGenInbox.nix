account: [
    {
      name = "├─📥 Inbox";
      query = "(tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged)";
      limit = 1000;
    } {
      name = "├─🏦 Archive";
      query = "not tag:inbox and not tag:spam";
      limit = 1000;
    } {
      name = "├─🧑 Personal";
      query = "tag:personal";
      limit = 1000;
    } {
      name = "├─🚩 Flagged";
      query = "tag:flagged";
      limit = 1000;
    } {
      name = "├─💸 Promotions";
      query = "tag:promotions";
      limit = 1000;
    } {
      name = "├─🐦 Social";
      query = "tag:social";
      limit = 1000;
    } {
      name = "└─📤 Sent";
      query = "tag:sent";
      limit = 1000;
    }
]
