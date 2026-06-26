namespace :preview do
  desc 'Creates (or reuses) a default SuperAdmin user/account for local preview stacks'
  task seed_admin: :environment do
    email = ENV.fetch('PREVIEW_ADMIN_EMAIL', 'admin@chatwoot.local')
    password = ENV.fetch('PREVIEW_ADMIN_PASSWORD', 'Password1!')

    account = Account.find_or_create_by!(name: 'Preview')

    user = User.find_or_initialize_by(email: email)
    user.assign_attributes(name: 'Preview Admin', password: password, password_confirmation: password, type: 'SuperAdmin')
    user.skip_confirmation!
    user.save!

    AccountUser.find_or_create_by!(account_id: account.id, user_id: user.id) do |account_user|
      account_user.role = :administrator
    end

    puts "Preview admin ready -> #{email} / #{password} (account: #{account.name})"
  end
end
