package main

import (
	"database/sql"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"

	"github.com/8398a7/api-abilitysheet/models"
)

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	db, err := sql.Open("postgres", os.Getenv("DB_URL"))
	checkErr(err)

	r := gin.Default()
	r.Use(gin.Logger())
	r.StaticFile("/favicon.ico", "./public/favicon.ico")

	r.GET("/users/count", func(c *gin.Context) {
		column := "count"
		err = db.QueryRow("SELECT count(*) FROM users").Scan(&column)
		checkErr(err)
		count, err := strconv.Atoi(column)
		checkErr(err)
		c.JSON(200, gin.H{"users": count})
	})

	r.GET("/sheets", func(c *gin.Context) {
		rows, err := db.Query("SELECT sheets.id, sheets.title, sheets.n_ability, sheets.h_ability FROM sheets WHERE sheets.active = true ORDER BY sheets.id")
		checkErr(err)

		sheets := []models.Sheet{}
		for rows.Next() {
			sheet := models.Sheet{}
			err = rows.Scan(&sheet.ID, &sheet.Title, &sheet.NAbility, &sheet.HAbility)
			checkErr(err)
			sheets = append(sheets, sheet)
		}
		c.JSON(200, sheets)
	})

	r.GET("/users/recent", func(c *gin.Context) {
		rows, err := db.Query("SELECT users.id, users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title FROM users, scores, sheets WHERE users.id = scores.user_id AND scores.state != 7 AND sheets.id = scores.sheet_id ORDER BY scores.updated_at DESC LIMIT 6400")
		checkErr(err)

		results := []models.Recent{}
		for rows.Next() {
			result := models.Recent{}
			err = rows.Scan(&result.ID, &result.Djname, &result.Iidxid, &result.Pref, &result.UpdatedAt, &result.State, &result.Grade, &result.Title)
			checkErr(err)
			results = append(results, result)
		}
		c.JSON(200, results)
	})

	r.Run()
	defer db.Close()
}
