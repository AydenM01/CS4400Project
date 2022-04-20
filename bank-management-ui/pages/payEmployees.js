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

export default function payEmployees(props) {

  return (
    <div className={styles.container}>
      <Head>
        <title>Bank Management UI</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Grid container spacing={1}>
        <Grid item xs={12}>
          <h1 className={styles.title}>Pay Employees</h1>
        </Grid>

        <Grid item xs={2} />
        <Grid item xs={8}>
          <Button fullWidth variant="contained" >Pay All Employees</Button>
        </Grid>
        
        <Grid item xs={2} />
      </Grid>
    </div>
  );
}
