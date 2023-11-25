package com.example

import groovy.sql.Sql

class MySqlHelper {
//   // private Sql sql

//   // MySqlHelper() {
//   //   // データベース接続設定
//   //   String url = 'jdbc:mysql://your-db-url:3306/your-db'
//   //   String user = 'your-username'
//   //   String password = 'your-password'
//   //   // this.sql = Sql.newInstance(url, user, password, 'com.mysql.cj.jdbc.Driver')
//   //   this.sql = null
//   // }

  def executeQuery(String query) {
    if (query.toLowerCase().startsWith('select')) {
      // return this.sql.rows(query)
      return "hoge"
    } else {
      throw new IllegalArgumentException('Query must be a SELECT statement.')
    }
  }

  def executeUpdate(String query) {
    if (!query.toLowerCase().startsWith('select')) {
      return this.sql.execute(query)
    } else {
      throw new IllegalArgumentException('Query must be INSERT, UPDATE, or DELETE.')
    }
  }

  // トランザクション処理のメソッドは必要に応じて追加
}
