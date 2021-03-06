const path = require("path");
const { v4: uuid } = require("uuid");
const { promises: fs } = require("fs");
const { runner, Logger } = require("hygen");
const { spawn } = require("child_process");

const initProject = (dir) => {
  return new Promise((resolve, reject) => {
    try {
      const init = spawn("platformio", [
        "init",
        "-b",
        "nodemcu-32s",
        "-d",
        dir,
      ]);

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

const createDirectory = (dir) => {
  return fs.mkdir(dir);
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

  await createDirectory(dir);
  await initProject(dir);
  const { success } = await generateFirmware(id, cwd, templates);
  process.exit(success ? 0 : 1);
};

init();
