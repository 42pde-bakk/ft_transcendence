# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Guild.create([{
	              name: "Ants",
	              anagram: "ant",
	              points: 66
              },
              {
	              name: "Lions",
	              anagram: "lio",
	              points: 55
              }])


User.create([{
               name: "Ant-Man",
               img_path: "https://img2.cgtrader.com/items/2043799/e1982ff5ee/star-wars-rogue-one-solo-stormtrooper-helmet-3d-model-stl.jpg",
               token: "12345",
               guild: Guild.find_by(name: "Ants"),
               tfa: true,
               reg_done: false,
               current: false,
               last_seen: DateTime.now,
               admin: false,
               owner: false,
               ban: false,
               email: "42@transcendence.com"
               },
             {
               name: "R2D2",
               img_path: "https://img2.cgtrader.com/items/2043799/e1982ff5ee/star-wars-rogue-one-solo-stormtrooper-helmet-3d-model-stl.jpg",
               token: "123",
               guild_id: nil,
               tfa: true,
               reg_done: false,
               current: false,
               last_seen: DateTime.now,
               admin: false,
               owner: false,
               ban: false,
               email: "42@transcendence.com"
             }])

Chatroom.create([
	                {
		                name: "Global",
		                owner: User.first,
		                is_private: false,
		                amount_members: 0
	                }, {
		                name: "passwordistaco",
		                owner: User.second,
		                is_private: true,
		                password: Base64.strict_encode64("taco"),
		                amount_members: 0
	                }
                ])
