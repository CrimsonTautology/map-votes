class Ability
  include CanCan::Ability
  #:read, :create, :update, :destroy

  def initialize(user, access_token=nil)

    can :read, Map
    can :read, MapComment

    #Checks for logged in users
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

    #Checks for the api system
    if access_token && ApiKey.authenticate(access_token)
      can :manage, :api
    end
  end
end
