class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id

    can :destroy, [Question, Answer], user_id: user.id

    can :rate_up, [Question, Answer]
    can :rate_down, [Question, Answer]

    cannot :rate_up, [Question, Answer], user_id: user.id
    cannot :rate_down, [Question, Answer], user_id: user.id

    can :destroy, [Attachment], attachmentable: { user_id: user.id }

    can :mark_best, Answer, question: { user_id: user.id }

    can :create, Subscription
    can :destroy, Subscription, user_id: user.id
  end
end
