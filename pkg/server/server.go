package server

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"golang.org/x/xerrors"
)

type Server struct {
	conn *sqlx.DB
}

func New(ctx context.Context, dataSourceName string) (*Server, error) {
	conn, err := sqlx.Connect("postgres", dataSourceName)
	if err != nil {
		return nil, xerrors.Errorf("failed to open sql: %w", err)
	}
	return &Server{
		conn,
	}, nil
}

func (s *Server) Run(ctx context.Context) error {
	defer s.conn.Close()

	r := gin.New()
	r.Use(
		gin.LoggerWithWriter(gin.DefaultWriter, "/health_check"),
		gin.Recovery(),
	)
	r.StaticFile("/favicon.ico", "./public/favicon.ico")

	r.GET("/health_check", s.healthCheck)

	r.GET("/users/count", s.getUsersCount)
	r.GET("/users/recent", s.getUsersRecent)

	r.GET("/sheets", s.getSheets)

	if err := r.Run(); err != nil {
		return xerrors.Errorf("failed to run: %w", err)
	}

	return nil
}

func (s *Server) healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "ok"})
}
