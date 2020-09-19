package server

import (
	"net/http"
	"strconv"

	"github.com/8398a7/api-abilitysheet/pkg/models"

	"github.com/gin-gonic/gin"
)

func (s *Server) getUsersCount(c *gin.Context) {
	column := "count"
	err := s.conn.QueryRow(`SELECT count(*) FROM users`).Scan(&column)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	count, err := strconv.Atoi(column)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"users": count})
}

func (s *Server) getUsersRecent(c *gin.Context) {
	var results []models.Recent
	err := s.conn.Select(&results, "SELECT users.id, users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title FROM users, scores, sheets WHERE users.id = scores.user_id AND scores.state != 7 AND sheets.id = scores.sheet_id ORDER BY scores.updated_at DESC LIMIT 6400")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, results)
}
