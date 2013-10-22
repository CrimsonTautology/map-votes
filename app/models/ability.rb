class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      unless user.banned?

      end
      if user.moderator?
      end

      if user.admin?
        can :access, :all
      end
    end
  end
end
