require 'octokit'

class Web::RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = current_user.repositories.find(params[:id])
  end

  def new
    @repository = Repository.new
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    all_repos = client.repos({}, query: { type: 'owner', sort: 'asc' })
    @available_repos = all_repos.select { |repo| Repository.language.values.include?(repo.language&.downcase&.to_sym) }
  end

  def create
    repository_id = permitted_params[:github_id].to_i

    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true

    repository_data = client.repository(repository_id)

    if Repository.find(repository_data.id.to_s)
      render :new
    end

    @repository = current_user.repositories.build(
      github_id: repository_data.id.to_s,
      name: repository_data.name,
      full_name: repository_data.full_name,
      language: repository_data.language.downcase.to_sym,
      clone_url: repository_data.clone_url,
      ssh_url: repository_data.ssh_url
    )

    if @repository.save
      redirect_to @repository, notice: t('repositories.actions.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.expect(repository: [:github_id])
  end
end
