import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
} from "@mui/material";

const MyTable = ({ columns, data }) => {
  return (
    <TableContainer sx={{}} component={Paper}>
      <div className="table">
        <Table sx={{ minWidth: 650 }} aria-label="simple table">
          <TableHead>
            <TableRow>
              {columns.map((element, key) => {
                return (
                  <TableCell style={{backgroundColor: '#009999'}} key={key}>
                    <h2 style={{color: 'white'}}>{element}</h2>
                  </TableCell>
                );
              })}
            </TableRow>
          </TableHead>

          <TableBody>
            {data.map((row, i) => {
              return (
                <TableRow
                  key={i}
                  sx={{ "&:last-child td, &:last-child th": { border: 0 } }}
                >
                  {Object.keys(row).map((element, key) => {
                    if (i % 2 === 0) {
                      return (<TableCell style={{backgroundColor: '#CCE5FF'}} key={key}>{<h4>{row[element]}</h4>}</TableCell>);
                    } else {
                      return (<TableCell style={{backgroundColor: '#CCCCFF'}} key={key}>{<h4>{row[element]}</h4>}</TableCell>);
                    }
                  }
                  )}
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </div>
    </TableContainer>
  );
};

export default MyTable;
