const snowpack = require("snowpack");

let server;

module.exports.start = async (opts) => {
  process.chdir(opts.inputPath);
  const config = await createConfig(opts);

  server = await snowpack.startServer({ config });

  return true;
};

module.exports.stop = async () => {
  if (server) await server.shutdown();
};

module.exports.build = async (opts) => {
  process.chdir(opts.inputPath);
  const config = await createConfig(opts);

  const result = await snowpack.build({ config });

  return result;
};

function createConfig({ inputPath, outputPath, port, hmrPort }) {
  return snowpack.loadConfiguration({
    root: inputPath,
    devOptions: {
      port,
      hmrPort,
      open: "none",
    },
    packageOptions: {
      source: "remote",
    },
    buildOptions: {
      out: outputPath,
    },
  });
}
