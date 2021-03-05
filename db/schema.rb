# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_04_025548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocked_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "towards_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["towards_id"], name: "index_blocked_users_on_towards_id"
    t.index ["user_id"], name: "index_blocked_users_on_user_id"
  end

  create_table "chatroom_admins", force: :cascade do |t|
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_chatroom_admins_on_chatroom_id"
    t.index ["user_id"], name: "index_chatroom_admins_on_user_id"
  end

  create_table "chatroom_bans", force: :cascade do |t|
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_chatroom_bans_on_chatroom_id"
    t.index ["user_id"], name: "index_chatroom_bans_on_user_id"
  end

  create_table "chatroom_members", force: :cascade do |t|
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_chatroom_members_on_chatroom_id"
    t.index ["user_id"], name: "index_chatroom_members_on_user_id"
  end

  create_table "chatroom_mutes", force: :cascade do |t|
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_chatroom_mutes_on_chatroom_id"
    t.index ["user_id"], name: "index_chatroom_mutes_on_user_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id"
    t.boolean "is_private"
    t.string "password"
    t.boolean "is_subscribed"
    t.bigint "amount_members"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_chatrooms_on_owner_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.boolean "confirmed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.string "name_player1"
    t.string "name_player2"
    t.string "gametype"
    t.integer "room_nb"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player1_id"], name: "index_games_on_player1_id"
    t.index ["player2_id"], name: "index_games_on_player2_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name"
    t.string "anagram"
    t.integer "points", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chatroom_id"
    t.text "msg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean "is_accepted"
    t.string "kind"
    t.string "name_sender"
    t.string "name_receiver"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "img_path", default: "https://img2.cgtrader.com/items/2043799/e1982ff5ee/star-wars-rogue-one-solo-stormtrooper-helmet-3d-model-stl.jpg"
    t.string "token"
    t.integer "guild_id"
    t.boolean "guild_owner", default: false
    t.boolean "guild_officer", default: false
    t.boolean "guild_validated", default: false
    t.boolean "tfa"
    t.boolean "reg_done"
    t.boolean "current"
    t.datetime "last_seen"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "log_token"
    t.string "email"
    t.boolean "admin"
    t.boolean "ban"
    t.boolean "owner"
  end

  add_foreign_key "blocked_users", "users", column: "towards_id"
  add_foreign_key "chatrooms", "users", column: "owner_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
end
