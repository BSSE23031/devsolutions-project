const express = require("express");
const app = express();
app.get("/hello", (req, res) => res.json({ msg: "Hello from API service!" }));
app.listen(5000, () => console.log("API running on 5000"));
