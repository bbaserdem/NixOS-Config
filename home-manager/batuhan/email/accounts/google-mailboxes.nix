account: email: order: [
  {
    name = "[${account}] 📥 Inbox";
    query = "query:a${order}-${account} AND query:f0-mail";
    limit = 1000;
  }
  {
    name = "[${account}] ├─🧑 Personal";
    query = "query:a${order}-${account} AND query:f1-pers";
    limit = 1000;
  }
  {
    name = "[${account}] ├─💸 Promotions";
    query = "query:a${order}-${account} AND query:f2-prom";
    limit = 1000;
  }
  {
    name = "[${account}] ├─🐦 Social";
    query = "query:a${order}-${account} AND query:f3-socl";
    limit = 1000;
  }
  {
    name = "[${account}] ├─📤 Sent";
    query = "query:a${order}-${account} AND query:f4-sent";
    limit = 1000;
  }
  {
    name = "[${account}] ├─🚩 Flagged";
    query = "query:a${order}-${account} AND query:f5-flag";
    limit = 1000;
  }
  {
    name = "[${account}] └─🏦 Archive";
    query = "query:a${order}-${account} AND query:f6-arch";
    limit = 1000;
  }
]
