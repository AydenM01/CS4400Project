import { connection } from "../../lib/db";

export default function handler(req, res) {
  let requester = null;
  let customer = null;
  let account_type = null;
  let bankID = null;
  let balance = 0;
  let interestRate = 0
  let minBalance = 0;
  let numWithdrawals = 0;
  let maxWithdrawals = 0;

  if (req.method === "POST") {
    req.body.requester ? (requester = '"' + req.body.requester + '"') : (requester = null);
    req.body.customer ? (customer = '"' + req.body.customer + '"') : (customer = null);
    req.body.account_type ? (account_type = '"' + req.body.account_type + '"') : (account_type = null);
    req.body.bankID ? (bankID = '"' + req.body.bankID + '"') : (bankID = null);
    balance = req.body.balance;
    interestRate = req.body.interestRate;
    minBalance = req.body.minBalance;
    numWithdrawals = req.body.numWithdrawals;
    maxWithdrawals = req.body.maxWithdrawals;
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
