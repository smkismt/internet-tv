-- seed.sql
-- Internet-TV sample data (Step2)
-- 方針:
-- - program_slots = 「日付込みの放送枠」
-- - program_slot_episodes = 「枠の中でどのエピソードを何時に流したか + 視聴数」
-- - チャンネル名はシンプル、ジャンルは別の概念にする

CREATE DATABASE IF NOT EXISTS internet_tv;
USE internet_tv;

-- =========================
-- リセット（何度でも実行OK）
-- =========================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE program_genres;
TRUNCATE TABLE program_slot_episodes;
TRUNCATE TABLE episodes;
TRUNCATE TABLE seasons;
TRUNCATE TABLE program_slots;
TRUNCATE TABLE genres;
TRUNCATE TABLE programs;
TRUNCATE TABLE channels;
SET FOREIGN_KEY_CHECKS = 1;

START TRANSACTION;

-- =========================
-- 1) channels（シンプル）
-- =========================
INSERT INTO channels (channel_id, channel_name) VALUES
(1, 'アニメ'),
(2, 'アニメ2'),
(3, 'ドラマ'),
(4, 'スポーツ'),
(5, 'ペット');

-- =========================
-- 2) program_slots（テーブル作成順を優先）
--  - 本日分（複数ch）
--  - ドラマは本日から7日分（Step3-4用）
-- =========================
INSERT INTO program_slots (program_slot_id, start_at, end_at, channel_id) VALUES
-- 本日：ペット
(1,  TIMESTAMP(CURDATE(), '09:00:00'), TIMESTAMP(CURDATE(), '10:00:00'), 5),

-- 本日：アニメ
(2,  TIMESTAMP(CURDATE(), '10:00:00'), TIMESTAMP(CURDATE(), '11:00:00'), 1),
(3,  TIMESTAMP(CURDATE(), '11:00:00'), TIMESTAMP(CURDATE(), '12:00:00'), 1),

-- 本日：アニメ2（同じ作品を別チャンネルでも流す＝再放送/別編成の例）
(4,  TIMESTAMP(CURDATE(), '10:00:00'), TIMESTAMP(CURDATE(), '11:00:00'), 2),

-- 本日：スポーツ
(5,  TIMESTAMP(CURDATE(), '19:00:00'), TIMESTAMP(CURDATE(), '20:00:00'), 4),

-- ドラマ：本日から7日分（20:00-21:00）
(6,  TIMESTAMP(CURDATE(), '20:00:00'), TIMESTAMP(CURDATE(), '21:00:00'), 3),
(7,  TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:00:00'),
     TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:00:00'), 3),
(8,  TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '20:00:00'),
     TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '21:00:00'), 3),
(9,  TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:00:00'),
     TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '21:00:00'), 3),
(10, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '20:00:00'),
     TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '21:00:00'), 3),
(11, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY), '20:00:00'),
     TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY), '21:00:00'), 3),
(12, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '20:00:00'),
     TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '21:00:00'), 3);

-- =========================
-- 3) programs
-- =========================
INSERT INTO programs (program_id, title, program_details) VALUES
(1, '鬼滅の刃', '鬼退治の物語。'),
(2, '日常ほのぼの', 'ゆるい日常アニメ。'),
(3, '恋のドラマ', '恋愛ドラマ。'),
(4, 'サッカータイム', '試合ハイライトと解説。'),
(5, 'もふもふ日記', '動物たちの癒し番組。'),
(6, 'ニュース9', '今日の出来事まとめ。');

-- =========================
-- 4) seasons（単発も season=1 として扱う）
-- =========================
INSERT INTO seasons (season_id, season, program_id) VALUES
(1, 1, 1), -- 鬼滅S1
(2, 2, 1), -- 鬼滅S2
(3, 1, 2), -- 日常S1
(4, 1, 3), -- 恋ドラS1
(5, 1, 4), -- サッカーS1
(6, 1, 5), -- もふもふS1
(7, 1, 6); -- ニュース9 S1

-- =========================
-- 5) episodes
-- =========================
INSERT INTO episodes (
  episode_id, episode_count, title, episode_details, video_duration, release_date, season_id
) VALUES
-- 鬼滅S1
(1, 1, '鬼滅の刃 1話', '旅立ち', '00:24:00', '2019-04-06', 1),
(2, 2, '鬼滅の刃 2話', '修行',   '00:24:00', '2019-04-13', 1),
(3, 3, '鬼滅の刃 3話', '試練',   '00:24:00', '2019-04-20', 1),

-- 鬼滅S2
(4, 1, '鬼滅の刃 S2 1話', '新章', '00:24:00', '2021-12-05', 2),
(5, 2, '鬼滅の刃 S2 2話', '激闘', '00:24:00', '2021-12-12', 2),

-- 日常
(6, 1, '日常ほのぼの 1話', '朝',   '00:23:00', '2024-01-01', 3),
(7, 2, '日常ほのぼの 2話', '昼',   '00:23:00', '2024-01-08', 3),

-- 恋ドラ
(8, 1, '恋のドラマ 1話', '出会い',   '00:45:00', '2025-01-01', 4),
(9, 2, '恋のドラマ 2話', 'すれ違い', '00:45:00', '2025-01-08', 4),

-- サッカー（単発扱いでもOK）
(10, 1, 'サッカータイム', 'ハイライト', '01:00:00', '2024-07-01', 5),

-- もふもふ（単発扱いでもOK）
(11, 1, 'もふもふ日記', '犬と猫', '00:30:00', '2024-06-01', 6),

-- ニュース（単発扱いでもOK）
(12, 1, 'ニュース9', '本日のニュース', '00:15:00', '2026-01-01', 7);

-- =========================
-- 6) program_slot_episodes（視聴数はここに持つ）
--  - broadcast_start_time は必ず「枠の中」
-- =========================
INSERT INTO program_slot_episodes (
  program_slot_episode_id, broadcast_start_time, view_count, program_slot_id, episode_id
) VALUES
-- 本日：ペット
(1,  TIMESTAMP(CURDATE(), '09:00:00'),  320, 1, 11),

-- 本日：アニメ（1時間に2本）
(2,  TIMESTAMP(CURDATE(), '10:00:00'), 1500, 2, 1),
(3,  TIMESTAMP(CURDATE(), '10:30:00'),  900, 2, 2),

-- 本日：アニメ（11時枠）
(4,  TIMESTAMP(CURDATE(), '11:00:00'), 1100, 3, 3),
(5,  TIMESTAMP(CURDATE(), '11:30:00'),  700, 3, 6),

-- 本日：アニメ2（別チャンネルで再放送例）
(6,  TIMESTAMP(CURDATE(), '10:00:00'),  800, 4, 1),

-- 本日：スポーツ
(7,  TIMESTAMP(CURDATE(), '19:00:00'),  600, 5, 10),

-- ドラマ：本日から7日分（交互に流す）
(8,  TIMESTAMP(CURDATE(), '20:00:00'), 1200, 6, 8),
(9,  TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:00:00'), 1100, 7, 9),
(10, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '20:00:00'), 1000, 8, 8),
(11, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:00:00'),  900, 9, 9),
(12, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '20:00:00'),  800, 10, 8),
(13, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY), '20:00:00'),  700, 11, 9),
(14, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '20:00:00'),  650, 12, 8);

-- =========================
-- 7) genres（チャンネルとは別の概念）
-- =========================
INSERT INTO genres (genre_id, genre_name) VALUES
(1, 'バトル'),
(2, '恋愛'),
(3, '日常'),
(4, 'サッカー'),
(5, '動物'),
(6, 'ニュース');

-- =========================
-- 8) program_genres（多対多）
-- =========================
INSERT INTO program_genres (program_genre_id, program_id, genre_id) VALUES
(1, 1, 1), -- 鬼滅 -> バトル
(2, 2, 3), -- 日常 -> 日常
(3, 3, 2), -- 恋ドラ -> 恋愛
(4, 4, 4), -- サッカー -> サッカー
(5, 5, 5), -- もふもふ -> 動物
(6, 6, 6); -- ニュース9 -> ニュース

COMMIT;
