import Head from "next/head";
import React, { useState, useContext } from "react";
import AppContext from "../../AppContext";
import Image from "next/image";
import styles from "../../styles/Home.module.css";
import { url } from "../../lib/env";
import Link from "next/link";
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
  const personIDs = await fetch(url + `/api/getBankIDs`);
  const personIDsJSON = await personIDs.json();

  let personInit = personIDsJSON[0]["bankID"];

  const customerIDs = await fetch(url + `/api/getCustomerIDs`);
  const customerIDsJSON = await customerIDs.json();

  let customerInit = customerIDsJSON[0]["perID"];

  // Pass data to the page via props
  return {
    props: { personIDsJSON, personInit, customerIDsJSON, customerInit },
  };
}

export default function createAccount(props) {
  const [person, setPerson] = useState(props.personInit);
  const [customer, setCustomer] = useState(props.customerInit);
  const [accountType, setAccountType] = useState("checking");
  const [accountID, setAccountID] = useState("");
  const [initialBalance, setInitialBalance] = useState(0);
  const [interestRate, setInterestRate] = useState(0);
  const [minBalance, setMinBalance] = useState(0);
  const [maxWithdrawals, setMaxWithdrawals] = useState(0);
  const { userData, setUserData } = useContext(AppContext);

  const handleCreate = async () => {
    if (initialBalance < 0) {
      alert("Initial Balance Cannot be Negative");
      return;
    }

    if (accountID === "") {
      alert("Account ID cannot be empty");
      return;
    }

    if (
      interestRate < 0 &&
      (accountType === "savings" || accountType === "market")
    ) {
      alert("Interest Bearing Account must have non-negative interest");
      return;
    }

    if (maxWithdrawals < 0 && accountType === "market") {
      alert("maxWithdrawals cannot be negative for Market Account");
      return;
    }

    if (minBalance < 0 && accountType === "savings") {
      alert("minBalance cannot be negative in Savings Account");
      return;
    }
    const rawResponse = await fetch(url + "/api/admin/createAccount", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        requester: userData.userID,
        customer: customer,
        account_type: accountType,
        accountID: accountID,
        bankID: person,
        balance: initialBalance,
        interestRate: interestRate,
        minBalance: minBalance,
        maxWithdrawals: maxWithdrawals,
      }),
    });
    const response = await rawResponse.json();
    console.log(rawResponse);
    if (rawResponse.status !== 200) {
      alert(response.sqlMessage);
    } else if (rawResponse.status === 200) {
      alert("Success");
    }
  };

  return (
    <div className={styles.container}>
      <Head>
        <title>Bank Management UI</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Grid container spacing={1}>
        <Grid item xs={12}>
          <h1 className={styles.title}>Create Account</h1>
        </Grid>

        <Grid item xs={2} />
        <Grid item xs={4}>
          <FormControl fullWidth>
            <InputLabel>Bank</InputLabel>
            <Select
              label="Bank"
              value={person}
              onChange={(e) => setPerson(e.target.value)}
            >
              {props.personIDsJSON.map((obj, i) => {
                let perID = obj["bankID"];
                return (
                  <MenuItem key={i} value={perID}>
                    {perID}
                  </MenuItem>
                );
              })}
            </Select>
          </FormControl>
        </Grid>

        <Grid item xs={4}>
          <FormControl fullWidth>
            <InputLabel>Customer</InputLabel>
            <Select
              label="Customer"
              value={customer}
              onChange={(e) => setCustomer(e.target.value)}
            >
              {props.customerIDsJSON.map((obj, i) => {
                let perID = obj["perID"];
                return (
                  <MenuItem key={i} value={perID}>
                    {perID}
                  </MenuItem>
                );
              })}
            </Select>
          </FormControl>
        </Grid>
        <Grid item xs={2} />
        <Grid item xs={2} />

        <Grid item xs={4}>
          <FormControl fullWidth>
            <InputLabel>Account Type</InputLabel>
            <Select
              label="Account Type"
              value={accountType}
              onChange={(e) => setAccountType(e.target.value)}
            >
              {["checking", "savings", "market"].map((obj, i) => {
                return (
                  <MenuItem key={i} value={obj}>
                    {obj}
                  </MenuItem>
                );
              })}
            </Select>
          </FormControl>
        </Grid>

        <Grid item xs={4}>
          <TextField
            label="Account ID"
            fullWidth
            value={accountID}
            onChange={(e) => setAccountID(e.target.value)}
          />
        </Grid>
        <Grid item xs={2} />

        <Grid item xs={2} />
        <Grid item xs={4}>
          <TextField
            label="Initial Balance"
            type="number"
            fullWidth
            value={initialBalance}
            onChange={(e) => setInitialBalance(e.target.value)}
          />
        </Grid>

        <Grid item xs={4}>
          <TextField
            label="Interest Rate"
            type="number"
            fullWidth
            value={interestRate}
            onChange={(e) => setInterestRate(e.target.value)}
            disabled={accountType === "checking"}
          />
        </Grid>

        <Grid item xs={2} />

        <Grid item xs={2} />
        <Grid item xs={4}>
          <TextField
            label="Min Balance"
            type="number"
            fullWidth
            value={minBalance}
            onChange={(e) => setMinBalance(e.target.value)}
            disabled={accountType === "checking" || accountType === "market"}
          />
        </Grid>

        <Grid item xs={4}>
          <TextField
            label="Max Withdrawals"
            type="number"
            fullWidth
            value={maxWithdrawals}
            onChange={(e) => setMaxWithdrawals(e.target.value)}
            disabled={accountType === "checking" || accountType === "savings"}
          />
        </Grid>
        <Grid item xs={2} />

        <Grid item xs={2} />

        <Grid item xs={4}>
          <Link href="/admin/manageAccountsAdmin">
            <Button
              variant="contained"
              color="error"
              fullWidth
              style={{ marginBottom: 20 }}
            >
              Back
            </Button>
          </Link>
        </Grid>
        <Grid item xs={4}>
          <Button variant="contained" fullWidth onClick={handleCreate}>
            Create
          </Button>
        </Grid>
        <Grid item xs={2} />
      </Grid>
    </div>
  );
}
