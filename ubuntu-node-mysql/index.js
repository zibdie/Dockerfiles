const mysql = require("mysql2/promise");
const { Sequelize } = require("sequelize");

async function smoketest() {
  try {
    const connectionInfo = await Sequelize.authenticate();
    const getRows = await connectionInfo.query("SELECT * FROM users");

    console.log(getRows);
  } catch (err) {
    console.log(err);
  }
}

smoketest();
