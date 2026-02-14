# テーブル設計

## テーブル：channels

| カラム名     | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
| ------------ | ------------ | ---- | ------- | ------ | -------------- |
| channel_id   | bigint(20)   |      | PRIMARY |        | YES            |
| channel_name | varchar(255) |      |         |        |                |

## テーブル：program_slots

| カラム名        | データ型   | NULL | キー    | 初期値 | AUTO INCREMENT |
| --------------- | ---------- | ---- | ------- | ------ | -------------- |
| program_slot_id | bigint(20) |      | PRIMARY |        | YES            |
| start_at        | datetime   |      |         |        |                |
| end_at          | datetime   |      |         |        |                |
| channel_id      | bigint(20) |      | INDEX   |        |                |

- 外部キー制約：channel_id に対して、channels テーブルの channel_id カラムから設定
- ユニークキー制約：(channel_id, start_at) に対して設定

## テーブル：programs

| カラム名        | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
| --------------- | ------------ | ---- | ------- | ------ | -------------- |
| program_id      | bigint(20)   |      | PRIMARY |        | YES            |
| title           | varchar(255) |      |         |        |                |
| program_details | text         |      |         |        |                |

## テーブル：seasons

| カラム名   | データ型   | NULL | キー    | 初期値 | AUTO INCREMENT |
| ---------- | ---------- | ---- | ------- | ------ | -------------- |
| season_id  | bigint(20) |      | PRIMARY |        | YES            |
| season     | int        |      |         |        |                |
| program_id | bigint(20) |      | INDEX   |        |                |

- 外部キー制約：program_id に対して、programs テーブルの program_id カラムから設定
- ユニークキー制約：(program_id, season) に対して設定

## テーブル：episodes

| カラム名        | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
| --------------- | ------------ | ---- | ------- | ------ | -------------- |
| episode_id      | bigint(20)   |      | PRIMARY |        | YES            |
| episode_count   | int          |      |         |        |                |
| title           | varchar(255) |      |         |        |                |
| episode_details | text         |      |         |        |                |
| video_duration  | time         |      |         |        |                |
| release_date    | date         |      |         |        |                |
| season_id       | bigint(20)   |      | INDEX   |        |                |

- 外部キー制約：season_id に対して、seasons テーブルの season_id カラムから設定
- ユニークキー制約：(season_id, episode_count) に対して設定

## テーブル：program_slot_episodes

| カラム名                | データ型   | NULL | キー    | 初期値 | AUTO INCREMENT |
| ----------------------- | ---------- | ---- | ------- | ------ | -------------- |
| program_slot_episode_id | bigint(20) |      | PRIMARY |        | YES            |
| broadcast_start_time    | datetime   |      |         |        |                |
| view_count              | int        |      |         | 0      |                |
| program_slot_id         | bigint(20) |      | INDEX   |        |                |
| episode_id              | bigint(20) |      | INDEX   |        |                |

- 外部キー制約：program_slot_id に対して、program_slots テーブルの program_slot_id カラムから設定
- 外部キー制約：episode_id に対して、episodes テーブルの episode_id カラムから設定
- ユニークキー制約：(program_slot_id, broadcast_start_time) に対して設定

## テーブル：genres

| カラム名   | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
| ---------- | ------------ | ---- | ------- | ------ | -------------- |
| genre_id   | bigint(20)   |      | PRIMARY |        | YES            |
| genre_name | varchar(255) |      |         |        |                |

- ユニークキー制約：genre_name カラムに対して設定

## テーブル：program_genres

| カラム名         | データ型   | NULL | キー    | 初期値 | AUTO INCREMENT |
| ---------------- | ---------- | ---- | ------- | ------ | -------------- |
| program_genre_id | bigint(20) |      | PRIMARY |        | YES            |
| program_id       | bigint(20) |      | INDEX   |        |                |
| genre_id         | bigint(20) |      | INDEX   |        |                |

- 外部キー制約：program_id に対して、programs テーブルの program_id カラムから設定
- 外部キー制約：genre_id に対して、genres テーブルの genre_id カラムから設定
- ユニークキー制約：(program_id, genre_id) に対して設定
