# テーブル作成およびデータ挿入

## 手順

1. リポジトリをクローン
   - GitHubからリポジトリをクローンするには、以下のコマンドを使用します。
     `git clone このリポジトリのURL`
   - クローンしたリポジトリのディレクトリに移動します。
     `cd internet-tv/step2`
1. データベースに接続
   - Dockerコンテナを起動します。
     `docker compose up -d`
   - データベースコンテナに接続します。
     `docker compose exec db mysql -u root -proot_password`
1. ユーザーを作成
   - SQLコマンドを実行して、ユーザーを作成します。
     `CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';`
   - 作成したユーザーに必要な権限を付与します。
     `GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';`
   - rootユーザーをログアウトします。
     `exit`
   - 作成したユーザーで再度データベースに接続します。
     `docker compose exec db mysql -u user -ppassword`
1. データベースを作成
   - SQLコマンドを実行して、データベースを作成します。
     `CREATE DATABASE internet_tv;`
   - 作成したデータベースを使用します。
     `USE internet_tv;`
1. テーブルを作成
   - SQLコマンドを実行して、テーブルを作成します。
     - channelsテーブル

     ```MySQL
      CREATE TABLE channels (
      channel_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      channel_name VARCHAR(255) NOT NULL
      );
     ```

     - program_slotsテーブル

     ```MySQL
      CREATE TABLE program_slots (
      program_slot_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      start_at DATETIME NOT NULL,
      end_at DATETIME NOT NULL,
      channel_id BIGINT(20) NOT NULL,
      FOREIGN KEY (channel_id) REFERENCES channels(channel_id),
      UNIQUE (channel_id, start_at),
      INDEX (channel_id)
      );
     ```

     - programsテーブル

     ```MySQL
      CREATE TABLE programs (
      program_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      program_details TEXT
      );
     ```

     - seasonsテーブル

     ```MySQL
      CREATE TABLE seasons (
      season_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      season INT NOT NULL,
      program_id BIGINT(20) NOT NULL,
      FOREIGN KEY (program_id) REFERENCES programs(program_id),
      UNIQUE (program_id, season),
      INDEX (program_id)
      );
     ```

     - episodesテーブル

     ```MySQL
      CREATE TABLE episodes (
      episode_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      episode_count INT NOT NULL,
      title VARCHAR(255) NOT NULL,
      episode_details TEXT,
      video_duration TIME,
      release_date DATE,
      season_id BIGINT(20) NOT NULL,
      FOREIGN KEY (season_id) REFERENCES seasons(season_id),
      UNIQUE (season_id, episode_count),
      INDEX (season_id)
      );
     ```

     - program_slot_episodesテーブル

     ```MySQL
      CREATE TABLE program_slot_episodes (
      program_slot_episode_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      broadcast_start_time DATETIME NOT NULL,
      view_count INT DEFAULT 0,
      program_slot_id BIGINT(20) NOT NULL,
      episode_id BIGINT(20) NOT NULL,
      FOREIGN KEY (program_slot_id) REFERENCES program_slots(program_slot_id),
      FOREIGN KEY (episode_id) REFERENCES episodes(episode_id),
      UNIQUE (program_slot_id, broadcast_start_time),
      INDEX (program_slot_id, episode_id)
      );
     ```

     - genresテーブル

     ```MySQL
      CREATE TABLE genres (
      genre_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      genre_name VARCHAR(255) NOT NULL,
      UNIQUE (genre_name)
      );
     ```

     - program_genresテーブル

     ```MySQL
      CREATE TABLE program_genres (
      program_genre_id BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
      program_id BIGINT(20) NOT NULL,
      genre_id BIGINT(20) NOT NULL,
      FOREIGN KEY (program_id) REFERENCES programs(program_id),
      FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
      UNIQUE (program_id, genre_id),
      INDEX (program_id, genre_id)
      );
     ```

   - テーブルが正常に作成されたことを確認します。
     `SHOW TABLES;`

1. データの挿入
   - SQLコマンドを実行して、テーブルにデータを挿入します。
     - channelsテーブル

     ```MySQL
      INSERT INTO channels (channel_id, channel_name) VALUES
      (1, 'アニメ'),
      (2, 'アニメ2'),
      (3, 'ドラマ'),
      (4, 'スポーツ'),
      (5, 'ペット');
     ```

     - program_slotsテーブル

     ```MySQL
      INSERT INTO program_slots (program_slot_id, start_at, end_at, channel_id) VALUES
      (1, TIMESTAMP(CURDATE(), '09:00:00'), TIMESTAMP(CURDATE(), '10:00:00'), 5),
      (2, TIMESTAMP(CURDATE(), '10:00:00'), TIMESTAMP(CURDATE(), '11:00:00'), 1),
      (3, TIMESTAMP(CURDATE(), '11:00:00'), TIMESTAMP(CURDATE(), '12:00:00'), 1),
      (4, TIMESTAMP(CURDATE(), '10:00:00'), TIMESTAMP(CURDATE(), '11:00:00'), 2),
      (5, TIMESTAMP(CURDATE(), '19:00:00'), TIMESTAMP(CURDATE(), '20:00:00'), 4),
      (6, TIMESTAMP(CURDATE(), '20:00:00'), TIMESTAMP(CURDATE(), '21:00:00'), 3),
      (7, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:00:00'),
      TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:00:00'), 3),
      (8, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '20:00:00'),
      TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '21:00:00'), 3),
      (9, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:00:00'),
      TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '21:00:00'), 3),
      (10, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '20:00:00'),
      TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '21:00:00'), 3),
      (11, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY), '20:00:00'),
      TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY), '21:00:00'), 3),
      (12, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '20:00:00'),
      TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '21:00:00'), 3);
     ```

     - programsテーブル

     ```MySQL
      INSERT INTO programs (program_id, title, program_details) VALUES
      (1, '鬼滅の刃', '鬼退治の物語。'),
      (2, '日常ほのぼの', 'ゆるい日常アニメ。'),
      (3, '恋のドラマ', '恋愛ドラマ。'),
      (4, 'サッカータイム', '試合ハイライトと解説。'),
      (5, 'もふもふ日記', '動物たちの癒し番組。'),
      (6, 'ニュース9', '今日の出来事まとめ。');
     ```

     - seasonsテーブル

     ```MySQL
      INSERT INTO seasons (season_id, season, program_id) VALUES
      (1, 1, 1), -- 鬼滅S1
      (2, 2, 1), -- 鬼滅S2
      (3, 1, 2), -- 日常S1
      (4, 1, 3), -- 恋ドラS1
      (5, 1, 4), -- サッカーS1
      (6, 1, 5), -- もふもふS1
      (7, 1, 6); -- ニュース9 S1
     ```

     - episodesテーブル

     ```MySQL
      INSERT INTO episodes (
        episode_id, episode_count, title, episode_details, video_duration, release_date, season_id
      ) VALUES
      (1, 1, '鬼滅の刃 1話', '旅立ち', '00:24:00', '2019-04-06', 1),
      (2, 2, '鬼滅の刃 2話', '修行',   '00:24:00', '2019-04-13', 1),
      (3, 3, '鬼滅の刃 3話', '試練',   '00:24:00', '2019-04-20', 1),
      (4, 1, '鬼滅の刃 S2 1話', '新章', '00:24:00', '2021-12-05', 2),
      (5, 2, '鬼滅の刃 S2 2話', '激闘', '00:24:00', '2021-12-12', 2),
      (6, 1, '日常ほのぼの 1話', '朝',   '00:23:00', '2024-01-01', 3),
      (7, 2, '日常ほのぼの 2話', '昼',   '00:23:00', '2024-01-08', 3),
      (8, 1, '恋のドラマ 1話', '出会い',   '00:45:00', '2025-01-01', 4),
      (9, 2, '恋のドラマ 2話', 'すれ違い', '00:45:00', '2025-01-08', 4),
      (10, 1, 'サッカータイム', 'ハイライト', '01:00:00', '2024-07-01', 5),
      (11, 1, 'もふもふ日記', '犬と猫', '00:30:00', '2024-06-01', 6),
      (12, 1, 'ニュース9', '本日のニュース', '00:15:00', '2026-01-01', 7);
     ```

     - program_slot_episodesテーブル

     ```MySQL
      INSERT INTO program_slot_episodes (
        program_slot_episode_id, broadcast_start_time, view_count, program_slot_id, episode_id
      ) VALUES
      (1,  TIMESTAMP(CURDATE(), '09:00:00'),  320, 1, 11),
      (2,  TIMESTAMP(CURDATE(), '10:00:00'), 1500, 2, 1),
      (3,  TIMESTAMP(CURDATE(), '10:30:00'),  900, 2, 2),
      (4,  TIMESTAMP(CURDATE(), '11:00:00'), 1100, 3, 3),
      (5,  TIMESTAMP(CURDATE(), '11:30:00'),  700, 3, 6),
      (6,  TIMESTAMP(CURDATE(), '10:00:00'),  800, 4, 1),
      (7,  TIMESTAMP(CURDATE(), '19:00:00'),  600, 5, 10),
      (8,  TIMESTAMP(CURDATE(), '20:00:00'), 1200, 6, 8),
      (9,  TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:00:00'), 1100, 7, 9),
      (10, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '20:00:00'), 1000, 8, 8),
      (11, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:00:00'),  900, 9, 9),
      (12, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '20:00:00'),  800, 10, 8),
      (13, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY), '20:00:00'),  700, 11, 9),
      (14, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '20:00:00'),  650, 12, 8);
     ```

     - genresテーブル

     ```MySQL
      INSERT INTO genres (genre_id, genre_name) VALUES
      (1, 'バトル'),
      (2, '恋愛'),
      (3, '日常'),
      (4, 'サッカー'),
      (5, '動物'),
      (6, 'ニュース');
     ```

     - program_genresテーブル

     ```MySQL
      INSERT INTO program_genres (program_genre_id, program_id, genre_id) VALUES
      (1, 1, 1), -- 鬼滅 -> バトル
      (2, 2, 3), -- 日常 -> 日常
      (3, 3, 2), -- 恋ドラ -> 恋愛
      (4, 4, 4), -- サッカー -> サッカー
      (5, 5, 5), -- もふもふ -> 動物
      (6, 6, 6); -- ニュース9 -> ニュース
     ```

   - データが正常に挿入されたことを確認します。
     `SELECT * FROM channels;`
     `SELECT * FROM program_slots;`
     `SELECT * FROM programs;`
     `SELECT * FROM seasons;`
     `SELECT * FROM episodes;`
     `SELECT * FROM program_slot_episodes;`
     `SELECT * FROM genres;`
     `SELECT * FROM program_genres;`
