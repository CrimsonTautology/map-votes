class Ability
  include CanCan::Ability
  #:read, :create, :update, :destroy

  def initialize(user)

    can :read, Map
    can :read, MapComment
    if user
      can :vote, Map
      can :favorite, Map
      can :unfavorite, Map

      can :update, User, id: user.id

      unless user.banned?
        can :create, MapComment
        can [:destroy, :update], MapComment, user_id: user.id

      end
      if user.moderator?
        can [:destroy, :update], MapComment
        can :update, Map
      end

      if user.admin?
        can :manage, :all
      end
    end
  end
end
