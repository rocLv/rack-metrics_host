class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      can :create, Project
      can [:manage], Project, owner_id: user.id
      can [:read, :page_load_last_100, :rpm, :memory, :page_loadm, :metrics], Project do |project|
        project.users.include?(user)
      end
    end
  end
end
