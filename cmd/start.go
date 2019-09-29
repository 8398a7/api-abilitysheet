package main

import (
	"github.com/8398a7/api-abilitysheet/pkg/server"
	"github.com/spf13/cobra"
)

func init() {
	var startCmd = &cobra.Command{
		Use:   "start",
		Short: "Run server",
		Run: func(cmd *cobra.Command, args []string) {
			server.Run()
		},
	}

	rootCmd.AddCommand(startCmd)
}
