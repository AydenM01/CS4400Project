import Head from "next/head";
import Image from "next/image";
import styles from "../styles/Home.module.css";
import { url } from "../lib/env";
import { TextField, Button } from "@mui/material";
import { useState, useContext } from "react";
import AppContext from "../AppContext";
import Link from "next/link";

const ManagerMenu = () => {
  const { userData, setUserData } = useContext(AppContext);
  console.log(userData);
  return userData.userRole.includes("e") ? (
    <div className={styles.container}>
      <Head>
        <title>Bank Management UI Home</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h2 className={styles.title}>Manager Menu</h2>

        <div className={styles.grid}>
          <Link href={"/payEmployees"}>
            <a className={styles.card}>
              <h2>Pay Employee &rarr;</h2>
            </a>
          </Link>

          <Link href={"/hireWorker"}>
            <a className={styles.card}>
              <h2>Hire Worker &rarr;</h2>
            </a>
          </Link>
          <Link href={"/"}>
            <Button fullWidth color="error" variant="contained">
              Back
            </Button>
          </Link>
        </div>
      </main>
    </div>
  ) : (
    <h1>Not Authorized</h1>
  );
};

export default ManagerMenu;
