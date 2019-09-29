package server

import (
	"net/http"
	"strconv"

	"github.com/8398a7/api-abilitysheet/pkg/models"

	"github.com/gin-gonic/gin"
)

func (s *Server) getUsersCount(c *gin.Context) {
	column := "count"
	err := s.conn.QueryRow("SELECT count(*) FROM users").Scan(&column)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	count, err := strconv.Atoi(column)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(200, gin.H{"users": count})
}

func (s *Server) getUsersRecent(c *gin.Context) {
	rows, err := s.conn.Query("SELECT users.id, users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title FROM users, scores, sheets WHERE users.id = scores.user_id AND scores.state != 7 AND sheets.id = scores.sheet_id ORDER BY scores.updated_at DESC LIMIT 6400")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	results := []models.Recent{}
	for rows.Next() {
		result := models.Recent{}
		err = rows.Scan(&result.ID, &result.Djname, &result.Iidxid, &result.Pref, &result.UpdatedAt, &result.State, &result.Grade, &result.Title)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		results = append(results, result)
	}
	c.JSON(200, results)
}
