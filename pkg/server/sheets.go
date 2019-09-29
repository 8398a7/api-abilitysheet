package server

import (
	"net/http"

	"github.com/8398a7/api-abilitysheet/pkg/models"
	"github.com/gin-gonic/gin"
)

func (s *Server) getSheets(c *gin.Context) {
	sheets := []models.Sheet{}
	err := s.conn.Select(&sheets, "SELECT sheets.id, sheets.title, sheets.n_ability, sheets.h_ability FROM sheets WHERE sheets.active = true ORDER BY sheets.id")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, sheets)
}
