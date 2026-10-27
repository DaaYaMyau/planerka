# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, Story, status: "published"
    can :read, Article
    can :read, Company, status: "published"
    can :read, Review, status: "published"

    return unless user.present?

    can :create, Story
    can [ :show, :update, :destroy ], Story, user_id: user.id

    can :create, Vote
    can :create, Bookmark
    can :create, Comment
    can :destroy, Comment, user_id: user.id

    can [ :show, :update ], Profile, user_id: user.id

    can :create, Company
    can :read, Company, created_by_id: user.id

    can :create, CompanyRepresentative
    can :update, Company, company_representatives: { user_id: user.id, status: "approved" }

    representative = { company: { company_representatives: { user_id: user.id, status: "approved" } } }
    can :create, ReviewReply, review: representative.merge(status: "published")
    can :update, ReviewReply, user_id: user.id, review: representative

    can :create, Review
    can [ :read, :update, :destroy ], Review, user_id: user.id

    return unless user.is_admin?

    can :manage, :all
    can :access, :admin
    cannot [ :create, :update ], ReviewReply
    can :create, ReviewReply, review: representative.merge(status: "published")
    can :update, ReviewReply, user_id: user.id, review: representative
  end
end
