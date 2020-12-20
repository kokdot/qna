# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        can :manage, :all
      else
        can :read, :all
        can :create, [Question, Answer, Comment]
        can :update, [Question, Answer, Comment], user: user
        can :destroy, [Question, Answer, Comment], user: user
        can :best, Answer, question: { user: user }
        can :manage, Link, linkable: { user: user }
        can [:votes_up, :votes_down], [Answer, Question] do |votable|
          votable.user_id != user.id
        end
        can :destroy, ActiveStorage::Attachment, record: { user: user }
      end
    else
      can :read, :all
      can :email_get, User
      can :email_post, User
    end
  end
end
