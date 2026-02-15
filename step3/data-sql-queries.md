# データ抽出クエリ実行

1. よく見られているエピソードを知りたいです。エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください。

   ```MySQL
   SELECT
     e.title AS `タイトル`,
     SUM(pse.view_count) AS `視聴数`
   FROM program_slot_episodes AS pse
   INNER JOIN episodes AS e
     ON pse.episode_id = e.episode_id
   GROUP BY e.episode_id
   ORDER BY SYN(pse.view_count) DESC
   LIMIT 3;
   ```

1. よく見られているエピソードの番組情報やシーズン情報も合わせて知りたいです。エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください。

   ```MySQL
   SELECT
     p.title AS `番組タイトル`,
     s.season AS `シーズン数`,
     e.episode_count AS `エピソード数`,
     e.title AS `エピソードタイトル`,
     SUM(pse.view_count) AS `視聴数`
   FROM programs AS p
   INNER JOIN seasons AS s
     ON p.program_id = s.program_id
   INNER JOIN episodes AS e
     ON s.season_id = e.season_id
   INNER JOIN program_slot_episodes AS pse
     ON e.episode_id = pse.episode_id
   GROUP BY p.title, s.season, e.episode_count, e.title, e.episode_id
   ORDER BY SUM(pse.view_count) DESC
   LIMIT 3;
   ```

1. 本日の番組表を表示するために、本日、どのチャンネルの、何時から、何の番組が放送されるのかを知りたいです。本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。なお、番組の開始時刻が本日のものを本日方法される番組とみなすものとします。

   ```MySQL
   SELECT
     c.channel_name AS `チャンネル名`,
     ps.start_at AS `放送開始時刻`,
     ps.end_at AS `放送終了時刻`,
     s.season AS `シーズン数`,
     e.episode_count AS `エピソード数`,
     e.title AS `エピソードタイトル`,
     e.episode_details AS `エピソード詳細`
   FROM channels AS c
   INNER JOIN program_slots AS ps
     ON c.channel_id = ps.channel_id
   INNER JOIN program_slot_episodes AS pse
     ON ps.program_slot_id = pse.program_slot_id
   INNER JOIN episodes AS e
     ON pse.episode_id = e.episode_id
   INNER JOIN seasons AS s
     ON e.season_id = s.season_id
   WHERE DATE(ps.start_at) = CURDATE()
   ORDER BY ps.start_at;
   ```

1. ドラマというチャンネルがあったとして、ドラマのチャンネルの番組表を表示するために、本日から一週間分、何日の何時から何の番組が放送されるのかを知りたいです。ドラマのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得してください。

```MySQL
SELECT
  ps.start_at AS `放送開始時刻`,
  ps.end_at AS `放送終了時刻`,
  s.season AS `シーズン数`,
  e.episode_count AS `エピソード数`,
  e.title AS `エピソードタイトル`,
  e.episode_details AS `エピソード詳細`
FROM channels AS c
INNER JOIN program_slots AS ps
  ON c.channel_id = ps.channel_id
INNER JOIN program_slot_episodes AS pse
  ON ps.program_slot_id = pse.program_slot_id
INNER JOIN episodes AS e
  ON pse.episode_id = e.episode_id
INNER JOIN seasons AS s
  ON e.season_id = s.season_id
WHERE c.channel_name = 'ドラマ'
  AND DATE(ps.start_at) BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);
ORDER BY ps.start_at;
```
