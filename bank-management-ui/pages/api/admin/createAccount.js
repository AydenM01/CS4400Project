import { connection } from "../../lib/db";

export default function handler(req, res) {
  let bankID = null;
  let accountID = null;
  let balance = 0;


  if (req.method === "POST") {
    req.body.bankID ? (bankID = '"' + req.body.bankID + '"') : (bankID = null);
    req.body.accountID ? (accountID = '"' + req.body.accountID + '"') : (accountID = null);
    balance = req.body.balance;
  }

  connection.query(
    "call create_Account(" +
      bankID +
      "," +
      accountID +
      "," +
      balance +
      ");",
    function (error, results, fields) {
      if (error) res.status(400).json(error);
      else res.status(200).json(results);
    }
  );

}
