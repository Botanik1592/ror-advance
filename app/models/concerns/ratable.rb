module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :ratable
  end

  def show_rate
    ratings.sum(:ratings)
  end

  def rate_up(user)
    rate(user, 1)
  end

  def rate_down(user)
    rate(user, -1)
  end

  def has_minus_rate?(user)
    ratings.find_by(user: user, ratings: -1).present?
  end

  def has_plus_rate?(user)
    ratings.find_by(user: user, ratings: 1).present?
  end

  private

  def has_rate?(user)
    ratings.find_by(user: user).present?
  end

  def del_rate(user)
    ratings.find_by(user: user).try(:destroy)
  end

  def rate(user, vote)
    if user.author_of?(self)
      error = [true, "You can't vote for this!"]
    else
      del_rate(user) if has_rate?(user)
      ratings.create(user: user, ratings: vote)
    end
  end
end
