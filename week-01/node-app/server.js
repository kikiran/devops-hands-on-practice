const express = require("express");
const os = require("os");

const app = express();
const APP_NAME = process.env.APP_NAME || "node-app";
const VERSION = process.env.APP_VERSION || "1.0.0";
const PORT = parseInt(process.env.PORT || "3000", 10);

app.get("/", (req, res) => {
  res.json({
    app: APP_NAME,
    stack: "Node.js 20 + Express",
    version: VERSION,
    hostname: os.hostname(),
    message: "Hello from Node.js!",
  });
});

app.get("/health", (req, res) => res.json({ status: "ok" }));
app.get("/ready", (req, res) => res.json({ status: "ready" }));

const server = app.listen(PORT, "0.0.0.0", () => {
  console.log(`${APP_NAME} listening on :${PORT}`);
});

// Graceful shutdown when Kubernetes sends SIGTERM
process.on("SIGTERM", () => {
  console.log("SIGTERM received, closing server");
  server.close(() => process.exit(0));
});
