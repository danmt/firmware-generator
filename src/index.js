const path = require("path");
const { v4: uuid } = require("uuid");
const { promises: fs } = require("fs");
const { runner, Logger } = require("hygen");

const generateFirmware = (cwd, templates) => {
  const id = uuid();
  const temporalFolderPath = path.join(process.cwd(), "src", id);

  fs.mkdir(temporalFolderPath).then(() => {
    runner(
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
    ).then(({ success }) => process.exit(success ? 0 : 1));
  });
};

const init = () => {
  const cwd = process.cwd();
  const templates = path.join(__dirname, "../_templates");
  generateFirmware(cwd, templates);
};

init();
