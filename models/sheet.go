package models

type Sheet struct {
	ID       int64  `json:"id"`
	Title    string `json:"title"`
	NAbility int16  `db:"n_ability" json:"n_ability"`
	HAbility int16  `db:"h_ability" json:"h_ability"`
}
