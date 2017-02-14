class Post < ActiveRecord::Base
  extend FriendlyId
  include Voting

  # friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true
  validates :subs, length: { minimum: 1 , message: "please select at least one sub"}
  # validates :slug, presence: true, uniqueness: true

  has_many :postings, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :postings, source: :sub
  # has_many :comments

  def author_name
    self.author.username
  end

  def sub_name
    self.sub.title
  end

  def comments_by_parent(comments=self.comments)
    comments_hash = Hash.new { |h, k| h[k] = []}
    unless comments.nil?
      comments.includes(:author).each do |comment|
        comments_hash[comment.parent_comment_id] << comment
      end
    end

    comments_hash
  end

  def comments_by_parent_with_scores
    comments = Comment.get_scores(self.comments)

    comments_by_parent(comments)
  end

  def video
    return nil if self.url.nil?

    params = Rack::Utils.parse_query URI(self.url).query
    @video = Yt::Video.new id: params["v"]
  end
end
