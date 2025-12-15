package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv" // Nécessaire pour convertir la variable d'environnement IS_MASTER (string) en booléen
)

// Structure pour stocker et organiser les informations
type AppContext struct {
	Env         string
	IsMaster    bool // Stocké comme booléen
	ContainerIP string
	ListenPort  string
}

// Fonction pour lire les variables d'environnement et préparer le contexte
func getAppContext() AppContext {
	ctx := AppContext{
		Env:         os.Getenv("ENV"),
		ContainerIP: os.Getenv("CONTAINER_IP"),
		ListenPort:  os.Getenv("LISTEN_PORT"),
	}

	// 1. Gestion de la variable IS_MASTER (conversion string -> bool)
	// La variable d'environnement doit être "true" ou "false" (ou 1/0, si on gérait le int)
	isMasterStr := os.Getenv("IS_MASTER")
	if isMasterStr != "" {
		// strconv.ParseBool convertit la chaîne "true" ou "false" en booléen.
		val, err := strconv.ParseBool(isMasterStr)
		if err == nil {
			ctx.IsMaster = val
		}
	}

	// 2. Définition des valeurs par défaut si les variables sont vides
	if ctx.Env == "" {
		ctx.Env = "UNKNOWN"
	}
	if ctx.ListenPort == "" {
		ctx.ListenPort = "3000"
	}
	if ctx.ContainerIP == "" {
		ctx.ContainerIP = "127.0.0.1 (No ENV set)"
	}

	return ctx
}

func main() {
	appCtx := getAppContext()
	fmt.Printf("Starting service (ENV: %s) on port %s...\n", appCtx.Env, appCtx.ListenPort)

	addr := fmt.Sprintf(":%s", appCtx.ListenPort)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		handler(w, r, appCtx)
	})
	log.Fatal(http.ListenAndServe(addr, nil))
}

// Le handler prend le contexte de l'application en argument
func handler(w http.ResponseWriter, r *http.Request, ctx AppContext) {
	// Déterminer le statut et la couleur en fonction de IsMaster
	statusText := "Worker"
	statusColor := "#4CAF50" // Vert pour worker
	if ctx.IsMaster {
		statusText = "Master"
		statusColor = "#F44336" // Rouge pour master
	}

	// Construction de la réponse HTML/CSS
	outputHTML := fmt.Sprintf(`
		<!DOCTYPE html>
		<html lang="fr">
		<head>
			<meta charset="UTF-8">
			<title>Service Status - %s</title>
			<style>
				body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f8f8; color: #333; margin: 0; padding: 20px; }
				.container { max-width: 600px; margin: 50px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
				h1 { color: #2C3E50; border-bottom: 2px solid #EEE; padding-bottom: 10px; }
				.status-box { background-color: %s; color: white; padding: 10px; border-radius: 5px; font-weight: bold; text-align: center; margin-bottom: 20px; }
				.detail { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dotted #CCC; }
				.detail-label { font-weight: 600; }
				.detail-value { font-family: monospace; color: #007BFF; }
			</style>
		</head>
		<body>
			<div class="container">
				<h1>Go API Service Details</h1>

				<div class="status-box">
					Conteneur Rôle: %s
				</div>

				<div class="detail">
					<span class="detail-label">Environnement (ENV):</span>
					<span class="detail-value">%s</span>
				</div>

				<div class="detail">
					<span class="detail-label">Adresse IP Conteneur:</span>
					<span class="detail-value">%s</span>
				</div>

				<div class="detail">
					<span class="detail-label">Port d'Écoute Interne:</span>
					<span class="detail-value">%s</span>
				</div>

				<p style="margin-top: 30px; font-size: 0.9em; text-align: center; color: #888;">
					Requête reçue sur le chemin: %s
				</p>
			</div>
		</body>
		</html>
	`, ctx.Env, statusColor, statusText, ctx.Env, ctx.ContainerIP, ctx.ListenPort, r.URL.Path)

	// Envoi de la réponse
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, outputHTML)
}