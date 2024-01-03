-- ユーザ作成
-- パスワードは別途設定する
-- ALTER USER 'username'@'%' IDENTIFIED BY 'new_password';

CREATE USER 'selector'@'%';
GRANT SELECT ON databasename.* TO 'selector'@'%';

CREATE USER 'updater'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON databasename.* TO 'updater'@'%';

CREATE USER 'administrator'@'%';
GRANT ALL PRIVILEGES ON databasename.* TO 'administrator'@'%';
