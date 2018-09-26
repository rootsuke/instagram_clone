User.create!(full_name: "Tutorial User",
             name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(full_name: name,
               name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each {|user| user.microposts.create!(content: content)}
end

# コメント
users = User.where('id= ? or id= ? or id= ?', 4, 5, 6)
post_id = 295
3.times do
  content = Faker::Lorem.sentence(3)
  users.each do |user|
    user.comments.create!(content: content, micropost_id: post_id)
  end
  post_id += 1
end

# フォロー、フォロワー
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# ふぁぼ
user  = User.first
posts = Micropost.where.not(user_id: user.id).limit(50)
posts.each { |post| user.favorite(post) }
