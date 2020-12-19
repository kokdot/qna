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
        can :destroy, Link, linkable: { user: user }
        can :votes_up, Vote
        can :votes_down, Vote
        can :votes_cancel, Vote
        can :destroy, ActiveStorage::Attachment, record: { user: user }
      end
    else
      can :read, :all
      can :email_get, User
      can :email_post, User
    end
  end
end
