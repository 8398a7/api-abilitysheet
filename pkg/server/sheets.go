package server

import (
	"net/http"

	"github.com/8398a7/api-abilitysheet/pkg/models"
	"github.com/gin-gonic/gin"
)

func (s *Server) getSheets(c *gin.Context) {
	rows, err := s.conn.Query("SELECT sheets.id, sheets.title, sheets.n_ability, sheets.h_ability FROM sheets WHERE sheets.active = true ORDER BY sheets.id")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	sheets := []models.Sheet{}
	for rows.Next() {
		sheet := models.Sheet{}
		err = rows.Scan(&sheet.ID, &sheet.Title, &sheet.NAbility, &sheet.HAbility)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		sheets = append(sheets, sheet)
	}
	c.JSON(http.StatusOK, sheets)
}
