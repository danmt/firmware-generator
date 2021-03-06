const path = require("path");
const { v4: uuid } = require("uuid");
const { promises: fs } = require("fs");
const { runner, Logger } = require("hygen");
const { spawn } = require("child_process");

const initProject = (dir) => {
  return new Promise((resolve, reject) => {
    try {
      const init = spawn("pio", ["init", "-b", "nodemcu-32s", "-d", dir]);

      init.stdout.on("data", (data) => {
        console.log(`stdout: ${data}`);
      });

      init.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
        reject(data);
      });

      init.on("close", () => {
        console.log(`Project instantiated`);
        resolve(true);
      });
    } catch (error) {
      console.error(error);
    }
  });
};

const installLibrary = (dir, library) => {
  return new Promise((resolve, reject) => {
    try {
      const init = spawn("pio", ["lib", "install", library], { cwd: dir });

      init.stdout.on("data", (data) => {
        console.log(`stdout: ${data}`);
      });

      init.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
        reject(data);
      });

      init.on("close", () => {
        console.log(`Library ${library} installed`);
        resolve(true);
      });
    } catch (error) {
      console.error(error);
    }
  });
};

const installLibraries = (dir, libraries) => {
  return Promise.all(libraries.map((library) => installLibrary(dir, library)));
};

const createDirectory = (dir) => {
  return fs.mkdir(dir);
};

const buildFirmware = (dir) => {
  return new Promise((resolve, reject) => {
    try {
      const init = spawn("pio", ["run"], { cwd: dir });

      init.stdout.on("data", (data) => {
        console.log(`stdout: ${data}`);
      });

      init.stderr.on("data", (data) => {
        console.error(`stderr: ${data}`);
        reject(data);
      });

      init.on("close", () => {
        console.log(`Firmware built!`);
        resolve(true);
      });
    } catch (error) {
      console.error(error);
    }
  });
};

const extractBinary = (dir) => {
  return fs.copyFile(
    path.join(dir, ".pio", "build", "nodemcu-32s", "firmware.bin"),
    path.join(dir, "firmware.bin")
  );
};

const generateFirmware = (id, cwd, templates) => {
  return runner(
    [
      "generator",
      "firmware",
      id,
      "--deviceId",
      1,
      "--brokerUser",
      "device-1",
      "--brokerPassword",
      "public",
      "--brokerServer",
      "192.168.1.64",
      "--brokerPort",
      1883,
      "--networkSsid",
      "my-network",
      "--networkPassword",
      "1234",
    ],
    {
      cwd,
      templates,
      logger: new Logger(console.log.bind(console)),
      debug: !!process.env.DEBUG,
      exec: (action, body) => {
        const opts = body && body.length > 0 ? { input: body } : {};
        return require("execa").command(action, { ...opts, shell: true });
      },
      createPrompter: () => require("enquirer"),
    }
  );
};

const init = async () => {
  const id = uuid();
  const dir = path.join(process.cwd(), "src", id);
  const cwd = path.join(process.cwd(), "src");
  const templates = path.join(__dirname, "../_templates");
  const libraries = [
    "knolleary/PubSubClient@^2.8",
    "bblanchon/ArduinoJson@^6.17.3",
  ];

  await createDirectory(dir);
  await initProject(dir);
  const { success } = await generateFirmware(id, cwd, templates);
  await installLibraries(dir, libraries);
  await buildFirmware(dir);
  await extractBinary(dir);
  process.exit(success ? 0 : 1);
};

init();
