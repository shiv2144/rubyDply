class Ability
  include CanCan::Ability

  def initialize(member)
    # Define abilities for the passed in user here.
    member ||= Member.new # guest member (not logged in)
    if member.manager?
      can :manage, :all
    elsif member.director?
      # can :read, Account
      # can :read, Staff
      can :read, :all
    elsif member.tradesman?
      # can :read, Account
      # can :read, Staff
      can :read, :all
    # else
    #   can :read, :all
    end

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
