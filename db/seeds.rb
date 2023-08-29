# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

confirmed_at = Time.current - 1.hour
confirmation_sent_at = Time.current - 2.hours

gitta, calvin, jannie, helen = User.create!([
  { name: "Gitta", email: "gitta@mail.com", password: "password", confirmed_at: confirmed_at, confirmation_sent_at: confirmation_sent_at },
  { name: "Calvin", email: "calvin@mail.com", password: "pommes", confirmed_at: confirmed_at, confirmation_sent_at: confirmation_sent_at },
  { name: "Jannie", email: "jannie@mail.com", password: "password", confirmed_at: confirmed_at, confirmation_sent_at: confirmation_sent_at },
  { name: "Helen", email: "helen@mail.com", password: "password", confirmed_at: confirmed_at, confirmation_sent_at: confirmation_sent_at },
])

Connection.create!([
  { sender: gitta, recipient: calvin, connection_status: "connected" },
  { sender: gitta, recipient: jannie, connection_status: "connected" },
  { sender: gitta, recipient: helen, connection_status: "requested" },
  { sender: calvin, recipient: jannie, connection_status: "connected" },
  { sender: calvin, recipient: helen, connection_status: "requested" },
  { sender: jannie, recipient: helen, connection_status: "connected" },
])

Book.create!([
  { title: "Wool", author: "Hugh Howey", owner: calvin },
  { title: "Wool", author: "Hugh Howey", owner: gitta },
  { title: "Oorsprong", author: "Dan Brown", owner: gitta },
  { title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", owner: gitta },
])
