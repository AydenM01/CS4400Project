import Head from "next/head";
import React from "react";
import Image from "next/image";
import styles from "../styles/Home.module.css";
import { url } from "../lib/env";
import MyTable from "../components/MyTable";

export async function getServerSideProps() {
  const res = await fetch(url + `/api/getBankView`);
  const data = await res.json();

  // Pass data to the page via props
  return { props: { data } };
}

export default function bankView({ data }) {
  return (
    <div className={styles.container}>
      <Head>
        <title>Bank Management UI</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Display Bank Stats</h1>
        <MyTable columns={[
            "Bank ID",
            "Corporation Name",
            "Bank Name",
            "Street",
            "City",
            "State",
            "Zip",
            "Number of Accounts",
            "Bank Assets ($)",
            "Total Assets ($)"
          ]} data={data}/>
      </main>
    </div>
  );
}
