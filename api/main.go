package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	_ "github.com/mattn/go-sqlite3" // SQLite driver
)

// I just need it to be global for simplicity ...
var DB *sql.DB

func initDB() {
	var err error
	dbFolder := os.Getenv("DB_FOLDER")
	if len(dbFolder) < 1 {
		dbFolder = "."
	}

	DB, err = sql.Open("sqlite3", filepath.Join(dbFolder, "app.db"))
	if err != nil {
		log.Fatal(err)
	}

	sqlStmt := `
	CREATE TABLE IF NOT EXISTS unique_counter (
		id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		num INTEGER NOT NULL
	);`

	_, err = DB.Exec(sqlStmt)
	if err != nil {
		log.Fatalf("Error creating table: %q: %s\n", err, sqlStmt)
	}
}

func createHandler(num int, w http.ResponseWriter, r *http.Request) {
	if DB == nil {
		http.Error(w, "DB not initialized", http.StatusInternalServerError)
		return
	}

	_, err := DB.Exec("INSERT INTO unique_counter(num) VALUES(?)", num)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("New unique_count created"))
}

func deleteHandler(num int, w http.ResponseWriter, r *http.Request) {
	if DB == nil {
		http.Error(w, "DB not initialized", http.StatusInternalServerError)
		return
	}

	_, err := DB.Exec("DELETE FROM unique_counter WHERE num = ?", num)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("A unique_count deleted"))
}

func getHandler(w http.ResponseWriter, r *http.Request) {
	if DB == nil {
		http.Error(w, "DB not initialized", http.StatusInternalServerError)
		return
	}

	rows, err := DB.Query("SELECT num FROM unique_counter ORDER BY num DESC")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	numbers := []string{}
	for rows.Next() {
		var num string
		if err := rows.Scan(&num); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		numbers = append(numbers, num)
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(strings.Join(numbers, ", ")))
}

func getEnvironment() string {
	tuning := os.Getenv("TUNING")
	debug := os.Getenv("DEBUG")
	externalURL := os.Getenv("EXTERNAL_URL")
	client := os.Getenv("CLIENT")
	interactionMode := os.Getenv("INTERACTION_MODE")
	deviceId := os.Getenv("DEVICE_ID")

	return fmt.Sprintf(
		"Tuning: %s\nDebug: %s\nExternal URL: %s\nClient: %s\nInteraction Mode: %s\nDevice ID: %s\n",
		tuning,
		debug,
		externalURL,
		client,
		interactionMode,
		deviceId,
	)
}

func main() {
	initDB()
	defer DB.Close()

	mux := http.NewServeMux()

	mux.HandleFunc("/environment", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(getEnvironment()))
	})

	mux.HandleFunc("/healtz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	mux.HandleFunc("/count", getHandler)

	mux.HandleFunc("/count/{num}", func(w http.ResponseWriter, r *http.Request) {
		num_param := r.PathValue("num")

		num, err := strconv.Atoi(num_param)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if r.Method == http.MethodPost {
			createHandler(num, w, r)
			return
		} else if r.Method == http.MethodDelete {
			deleteHandler(num, w, r)
			return
		}

		http.Error(w, "Unsupported method", http.StatusBadRequest)
	})

	httpPort := os.Getenv("HTTP_PORT")
	if len(httpPort) < 1 {
		httpPort = "8081"
	}
	if err := http.ListenAndServe(fmt.Sprintf(":%s", httpPort), mux); err != nil {
		panic(err)
	}
}
