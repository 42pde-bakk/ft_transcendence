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
               img_path: "https://static.wikia.nocookie.net/marveldatabase/images/2/2e/Scott_Lang_%28Earth-199999%29_from_Ant-Man_and_the_Wasp_%28film%29_promo_art_001.jpg/revision/latest/top-crop/width/360/height/450?cb=20180707042039",
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
               img_path: "https://upload.wikimedia.org/wikipedia/en/3/39/R2-D2_Droid.png",
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
