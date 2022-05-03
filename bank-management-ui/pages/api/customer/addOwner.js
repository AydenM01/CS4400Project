import { connection } from "../../../lib/db";

export default function handler(req, res) {
  let requester = null;
  let sharer = null;
  let bankID = null;
  let accountID = null;
  let currDate = '"' + new Date().toISOString().slice(0, 10) + '"';
  if (req.method === "POST") {
    req.body.requester
      ? (requester = '"' + req.body.requester + '"')
      : (requester = null);
    req.body.sharer ? (sharer = '"' + req.body.sharer + '"') : (sharer = null);
    req.body.bankID ? (bankID = '"' + req.body.bankID + '"') : (bankID = null);
    req.body.accountID
      ? (accountID = '"' + req.body.accountID + '"')
      : (accountID = null);
  }

  connection.query(
    "call add_account_access(" +
      requester +
      "," +
      sharer +
      "," +
      "null," +
      bankID +
      "," +
      accountID +
      "," +
      "null,null,null,null,null,null," +
      currDate +
      ");",
    function (error, results, fields) {
      console.log(results);
      if (error) res.status(400).json(error);
      else res.status(200).json(results);
    }
  );
}
