# frozen_string_literal: true
require 'rails_admin/main_controller'

module RailsAdmin

    class MainController < RailsAdmin::ApplicationController
        # rescue for the admins who cannot access  
        rescue_from CanCan::AccessDenied do |exception|
            redirect_to rails_admin.dashboard_path
            flash[:alert] = 'Access denied.'
        end
    end
end
class Ability
    include AdminCurrent
  include CanCan::Ability

  def initialize(admin)
    # Define abilities for the passed in user here. For example:
    #
    if admin.role =="Super Admin"
        can :manage, :all
      elsif admin.role == "Admin"
        can :access, :rails_admin
        can :dashboard ,:all
        can :read, :dashboard
        # can :update,:all
        # can :bulk_update,:all
        can :read,[User,Project]
        
      else
        can :access, :rails_admin
        can :dashboard ,:all
        can :read, :dashboard

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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
