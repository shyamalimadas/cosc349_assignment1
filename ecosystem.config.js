module.exports = {
  apps: [{
    name: 'todo-backend',
    script: 'server.js',
    env: {
      NODE_ENV: 'production',
      PORT: 3001,
      DB_HOST: '192.168.56.11',
      DB_USER: 'todouser',
      DB_PASSWORD: 'todopassword',
      DB_NAME: 'todo_app'
    }
  }]
}
