Given(/^I am signed in as an admin$/) do
  @user = User.new(email: 'admin@example.com', password: 'abcdefghi', password_confirmation: 'abcdefghi')
  @user.admin = true
  @user.save!

  visit '/users/sign_in'

  fill_in 'user_email', with: @user.email
  fill_in 'user_password', with: @user.password

  click_button 'Sign in'
end

Given(/^user@example\.com is registered$/) do
  User.create(email: 'user@example.com', password: 'abcdefghi', password_confirmation: 'abcdefghi')
end
