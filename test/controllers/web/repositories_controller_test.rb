require "test_helper"

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  include Minitest::PowerAssert::Assertions

  setup do
    @user = users(:one)
    sign_in(@user)
    @access_token = 'fake_access_token'
    @user.update(token: @access_token)
    @repo_id = 123456789
  end
  test "should get index" do
    get repositories_path
    assert_response :success
  end

  # test "should get new" do
  #   stub_request(:get, "https://api.github.com/user/repos?per_page=100&sort=asc&type=owner")
  #     .with(
  #       headers: {
  #         'Accept' => 'application/vnd.github.v3+json',
  #         'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #         'Authorization' => 'token fake_access_token',
  #         'Content-Type' => 'application/json',
  #         'User-Agent' => 'Octokit Ruby Gem 9.2.0'
  #       }
  #     )
  #     .to_return(status: 200, body: "", headers: {})
  #   get new_repository_path
  #   assert_response :success
  # end

  test 'should create repository' do
    repository_data = {
      id: @repo_id,
      name: "test-repo",
      full_name: "octocat/test-repo",
      language: "Ruby",
      clone_url: "https://github.com/octocat/test-repo.git",
      ssh_url: "git@github.com:octocat/test-repo.git"
    }

    stub_request(:get, "https://api.github.com/repositories/#{@repo_id}")
      .with(headers: { 'Authorization' => "token #{@access_token}" })
      .to_return(
        status: 200,
        body: repository_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    post repositories_path, params: { repository: { github_id: @repo_id } }

    assert_redirected_to repository_path(Repository.last)

    repository = Repository.last
    assert { repository.github_id == repository_data[:id].to_s }
    assert { repository.name == repository_data[:name] }
    assert { repository.full_name == repository_data[:full_name] }
    assert { repository.language == repository_data[:language].downcase.to_sym }
    assert { repository.clone_url == repository_data[:clone_url] }
    assert { repository.ssh_url == repository_data[:ssh_url] }
  end
end
