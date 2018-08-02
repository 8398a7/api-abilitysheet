package models

import "time"

type Recent struct {
	ID        int       `db:"users.id" json:"id"`
	Djname    string    `db:"users.djname" json:"djname"`
	Iidxid    string    `db:"users.iidxid" json:"iidxid"`
	Pref      int       `db:"users.pref" json:"pref"`
	State     int       `db:"scores.state" json:"state"`
	Grade     int       `db:"users.grade" json:"grade"`
	Title     string    `db:"sheets.title" json:"title"`
	UpdatedAt time.Time `db:"scores.updated_at" json:"updated_at"`
}
