class User < ApplicationRecord

  has_many :microposts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id",
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :favorites, foreign_key: "favorite_user_id", dependent: :destroy
  # user.favorites.map(&:favorite_post)と同じことを、has_many throughが行う
  has_many :favorite_posts, through: :favorites, source: :favorite_post

  has_many :notifications, dependent: :destroy
  has_many :notified_to, class_name: "Notification", foreign_key: "notified_by_id",
                         dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :email_downcase
  before_create :creat_activation_digest

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: {case_sensitive: false},
                    length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true


  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = (:user_id)",
                    user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def favorite(post)
    favorite_posts << post
  end

  def unfavorite(post)
    favorites.find_by(favorite_post_id: post.id).destroy
  end

  def favorite?(post)
    favorite_posts.include?(post)
  end

  def has_unread_notifications?
    notifications.where(read: false).any?
  end

  class << self

    def from_omniauth(auth)
      # facebookの登録emailでuserを取得する
      user = User.where(email: auth.info.email).first

      if user.nil?
        user = User.new
      end

      # facebookログインではパスを要求しないため、パスワードのダミーを生成
      password_dummy = SecureRandom.hex(8)
      user.password = password_dummy
      user.password_confirmation = password_dummy

      user.uid   = auth.uid
      user.provider = auth.provider
      user.name  = auth.info.name
      user.email = auth.info.email
      user.oauth_token      = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      user

    end

    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

    def email_downcase
      self.email.downcase!
    end

    def creat_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
