package main

import (
	"context"
	"log"
	"os"

	"github.com/spf13/cobra"

	"github.com/8398a7/api-abilitysheet/pkg/server"
)

var rootCmd = &cobra.Command{
	Use:   "api-abilitysheet",
	Short: "Manage api-abilitysheet sever.",
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatalf("%+v", err)
	}
}

var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Run server",
	Run: func(cmd *cobra.Command, args []string) {
		ctx := context.Background()
		s, err := server.New(ctx, os.Getenv("DB_URL"))
		if err != nil {
			log.Fatalf("%+v", err)
		}
		if err := s.Run(ctx); err != nil {
			log.Fatalf("%+v", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
}
