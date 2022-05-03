import Head from "next/head";
import React from "react";
import Image from "next/image";
import styles from "../../styles/Home.module.css";
import { url } from "../../lib/env";
import MyTable from "../../components/MyTable";
import { Button } from "@mui/material";
import Link from "next/link";

export async function getServerSideProps() {
  const res = await fetch(url + `/api/getEmployeeView`);
  const data = await res.json();

  // Pass data to the page via props
  return { props: { data } };
}

export default function employeeView({ data }) {
  return (
    <div className={styles.container}>
      <Head>
        <title>Bank Management UI</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Display Employee Stats</h1>

        <Link href="/admin/statsMenu">
          <Button
            variant="contained"
            color="error"
            fullWidth
            style={{ marginBottom: 20 }}
          >
            Back
          </Button>
        </Link>

        <MyTable
          columns={[
            "Per ID",
            "Tax ID",
            "Name",
            "DOB",
            "Date Joined",
            "Street",
            "City",
            "State",
            "Zip",
            "Number of Banks",
            "Bank Assets",
          ]}
          data={data}
        />
      </main>
    </div>
  );
}