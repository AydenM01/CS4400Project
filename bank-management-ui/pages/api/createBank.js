import { connection } from "../../lib/db";

export default function handler(req, res) {
    let bankID = null;
    let name = null;
    let street = null;
    let city = null;
    let state = null;
    let zip = null;
    let resAssets = null;
    let corpID = null;
    let employee = null;
    let manager = null;

  if (req.method === 'POST') {
     bankID = req.body.bankID;
     name = req.body.name;
     street = req.body.street;
     city = req.body.city;
     state = req.body.state;
     zip = req.body.zip;
     resAssets = req.body.resAssets;
     corpID = req.body.corpID;
     employee = req.body.employee;
     manager = req.body.manager;
  }

  connection.query(
    "call create_bank(\"" + bankID + "\",\"" + name + "\",\"" + street + "\",\"" + city + "\",\"" + state + "\",\"" + zip + "\"," + resAssets + ",\"" + corpID + "\",\"" + manager + "\",\"" + employee + "\");",
    function (error, results, fields) {
      if (error) throw error;
      res.status(200).json(results);
    }
  );
}