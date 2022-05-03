import Head from "next/head";
import React, { useState } from "react";
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
  const personIDs = await fetch(url + `/api/getPeople`);
  const personIDsJSON = await personIDs.json();

  let personInit = personIDsJSON[0]["perID"];

  // Pass data to the page via props
  return {
    props: { personIDsJSON, personInit },
  };
}

export default function createCustomer(props) {
  const [person, setPerson] = useState(props.personInit);

  const handleCreate = async () => {
    const rawResponse = await fetch(url + "/api/startCustomer", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        person: person,
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
          <h1 className={styles.title}>Create Customer Role</h1>
        </Grid>

        <Grid item xs={2} />
        <Grid item xs={8}>
          <FormControl fullWidth>
            <InputLabel>Person</InputLabel>
            <Select
              label="Person"
              value={person}
              onChange={(e) => setPerson(e.target.value)}
            >
              {props.personIDsJSON.map((obj, i) => {
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
          <Link href="/admin/createRoles">
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