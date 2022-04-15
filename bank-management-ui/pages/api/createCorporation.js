import { connection } from "../../lib/db";

export default function handler(req, res) {
  let corpID = null;
  let longName = null;
  let shortName = null;
  let resAssets = null;

  if (req.method === 'POST') {
    corpID = req.body.corpID;
    longName = req.body.longName;
    shortName = req.body.shortName;
    resAssets = req.body.resAssets;
  }

  connection.query(
    "call create_corporation(\"" + corpID + "\",\"" + shortName + "\",\"" + longName + "\"," + resAssets + ");",
    function (error, results, fields) {
      if (error) throw error;
      res.status(200).json(results);
    }
  );
}