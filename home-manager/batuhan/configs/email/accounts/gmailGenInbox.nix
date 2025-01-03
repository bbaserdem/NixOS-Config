account: email: [
    {
      name = "📥 Inbox──────[${account}]";
      query = "to:${email} AND ((tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged))";
      limit = 1000;
    } {
      name = "🏦 Archive────[${account}]";
      query = "to:${email} AND (not tag:inbox and not tag:spam)";
      limit = 1000;
    } {
      name = "🧑 Personal───[${account}]";
      query = "to:${email} AND (tag:personal)";
      limit = 1000;
    } {
      name = "🚩 Flagged────[${account}]";
      query = "to:${email} AND (tag:flagged)";
      limit = 1000;
    } {
      name = "💸 Promotions─[${account}]";
      query = "to:${email} AND (tag:promotions)";
      limit = 1000;
    } {
      name = "🐦 Social─────[${account}]";
      query = "to:${email} AND (tag:social)";
      limit = 1000;
    } {
      name = "📤 Sent───────[${account}]";
      query = "to:${email} AND (tag:sent)";
      limit = 1000;
    }
]
