import Head from "next/head";
import React, { useState } from "react";
import Image from "next/image";
import styles from "../styles/Home.module.css";
import { url } from "../lib/env";
import {
  Grid,
  Paper,
  TextField,
  Button,
  Typography,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
} from "@mui/material";

export async function getServerSideProps() {
  const bankIDs = await fetch(url + `/api/getBankIDs`);
  const bankIDsJSON = await bankIDs.json();

  const employeeIDs = await fetch(url + `/api/getEmployeeIDs`);
  const employeeIDsJSON = await employeeIDs.json();

  let bankInit = bankIDsJSON[0]["bankID"];
  let employeeInit = employeeIDsJSON[0]["perID"];

  // Pass data to the page via props
  return {
    props: { bankIDsJSON, bankInit, employeeIDsJSON, employeeInit },
  };
}

export default function replaceManager(props) {
  const [employee, setEmployee] = useState(props.employeeInit);
  const [bank, setBank] = useState(props.bankInit);
  const [newSalary, setNewSalary] = useState(0);

  return (
    <div className={styles.container}>
      <Head>
        <title>Bank Management UI</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Grid container spacing={1}>
        <Grid item xs={12}>
          <h1 className={styles.title}>Replace Manager</h1>
        </Grid>

        <Grid item xs={2} />
        <Grid item xs={8}>
          <FormControl fullWidth>
            <InputLabel>Bank</InputLabel>
            <Select
              label="Bank"
              value={bank}
              onChange={(e) => setBank(e.target.value)}
            >
              {props.bankIDsJSON.map((obj, i) => {
                let bankID = obj["bankID"];
                return (
                  <MenuItem key={i} value={bankID}>
                    {bankID}
                  </MenuItem>
                );
              })}
            </Select>
          </FormControl>{" "}
        </Grid>

        <Grid item xs={2} />

        <Grid item xs={2} />
        <Grid item xs={8}>
          <FormControl fullWidth>
            <InputLabel>Employee</InputLabel>
            <Select
              label="Employee"
              value={employee}
              onChange={(e) => setEmployee(e.target.value)}
            >
              {props.employeeIDsJSON.map((obj, i) => {
                let perID = obj["perID"];
                return (
                  <MenuItem key={i} value={perID}>
                    {perID}
                  </MenuItem>
                );
              })}
            </Select>
          </FormControl>{" "}
        </Grid>

        <Grid item xs={2} />

        <Grid item xs={2} />
        <Grid item xs={8}>
          <TextField
            type={"number"}
            label={"New Salary"}
            value={newSalary}
            onChange={(e) => {
              setNewSalary(e.target.value);
            }}
            fullWidth
          >
            {" "}
          </TextField>
        </Grid>

        <Grid item xs={2} />
        <Grid item xs={2} />

        <Grid item xs={4}>
          <Button variant="contained" fullWidth>
            {" "}
            Cancel{" "}
          </Button>
        </Grid>
        <Grid item xs={4}>
          <Button variant="contained" fullWidth>
            {" "}
            Confirm{" "}
          </Button>
        </Grid>
        <Grid item xs={2} />
      </Grid>
    </div>
  );
}
