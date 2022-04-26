import "../styles/globals.css";
import AppContext from "../AppContext";
import { useState } from "react";

function MyApp({ Component, pageProps }) {
  const [userData, setUserData] = useState({ userID: "", userRole: "" });

  return (
    <AppContext.Provider
      value={{
        userData,
        setUserData,
      }}
    >
      <Component {...pageProps} userData={userData} setUserData={setUserData} />
    </AppContext.Provider>
  );
}

export default MyApp;
