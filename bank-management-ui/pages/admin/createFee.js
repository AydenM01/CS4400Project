import Head from "next/head";
import React, { useState } from "react";
import Image from "next/image";
import styles from "../../styles/Home.module.css";
import { url } from "../../lib/env";
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
import Link from "next/link";

export async function getServerSideProps() {
  const accounts = await fetch(url + `/api/admin/getAccounts`);
  const accountsJSON = await accounts.json();

  // Pass data to the page via props
  
  return {
    props: { accountsJSON },
  };
}

export default function createFee(props) {
  const [accounts, setAccounts] = useState(props.accountsJSON);
  const [account, setAccount] = useState("");
  const [feeType, setFeeType] = useState("");

  const handleCreate = async () => {
    let account_parsed = account.split(" / ");
    console.log(account_parsed[1]);
    console.log(account_parsed[0]);
    const rawResponse = await fetch(url + "/api/createFee", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        bank: account_parsed[1],
        account: account_parsed[0],
        feeType: feeType,
      }),
    });

    const response = await rawResponse.json();
    if (rawResponse.status === 400) {
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
          <h1 className={styles.title}>Create Fee</h1>
        </Grid>

        <Grid item xs={2} />
        <Grid item xs={8}>
          <FormControl fullWidth>
            <InputLabel>Account</InputLabel>
            <Select
              label="Account"
              value={account}
              onChange={(e) => setAccount(e.target.value)}
            >
              {accounts.map((obj, i) => {
                let accountID = obj["accountID"];
                let bankID = obj["bankID"]
                let account_combined = accountID + ' / ' + bankID;
                return (
                  <MenuItem key={i} value={account_combined}>
                    {account_combined}
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
            fullWidth
            value={feeType}
            label={"Fee Type"}
            onChange={(e) => {
              setFeeType(e.target.value);
            }}
          ></TextField>
        </Grid>

        <Grid item xs={2} />

        <Grid item xs={2} />

        <Grid item xs={4}>
          <Link href={"/admin/adminMenu"}>
            <Button variant="contained" color="error" fullWidth>
              Cancel
            </Button>
          </Link>
        </Grid>
        <Grid item xs={4}>
          <Button variant="contained" fullWidth onClick={handleCreate}>
            Confirm
          </Button>
        </Grid>
        <Grid item xs={2} />
      </Grid>
    </div>
  );
}
