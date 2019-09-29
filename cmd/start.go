package main

import (
	"context"
	"log"
	"os"

	"github.com/8398a7/api-abilitysheet/pkg/server"
	"github.com/spf13/cobra"
)

func init() {
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

	rootCmd.AddCommand(startCmd)
}
