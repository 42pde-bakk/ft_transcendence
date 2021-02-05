# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([{
               name: "Ant-Man",
               img_path: "No_Path",
               token: "12345",
               guild_id: 3,
               tfa: true,
               reg_done: false,
               current: false
               },
             {
               name: "R2D2",
               img_path: "No_Path",
               token: "123",
               guild_id: 2,
               tfa: true,
               reg_done: false,
               current: false
             }])