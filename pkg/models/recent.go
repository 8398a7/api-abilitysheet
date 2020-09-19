package models

import "time"

type Recent struct {
	ID        int       `db:"id" json:"id"`
	DjName    string    `db:"djname" json:"djname"`
	IidxID    string    `db:"iidxid" json:"iidxid"`
	Pref      int       `db:"pref" json:"pref"`
	State     int       `db:"state" json:"state"`
	Grade     int       `db:"grade" json:"grade"`
	Title     string    `db:"title" json:"title"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}
