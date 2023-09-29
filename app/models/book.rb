class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :read_counts, dependent: :destroy

  validates :title,presence: true
  validates :body,presence: true,length:{maximum: 200}
  validates :category, presence: true

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  #今日1日で作成した 全Bookを取得
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  #昨日1日で作成した 全Bookを取得
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  #6日前の0:00から今日の23:59までに作成した 全Bookを取得
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
  #2週間前の0:00から1週間前の23:59までに作成した 全Bookを取得

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
