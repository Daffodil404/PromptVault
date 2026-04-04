class MigrateUsersToDevise < ActiveRecord::Migration[8.1]
  class MigrationUser < ApplicationRecord
    self.table_name = "users"
  end

  def up
    add_column :users, :encrypted_password, :string, null: false, default: "" unless column_exists?(:users, :encrypted_password)
    add_column :users, :authentication_token, :string unless column_exists?(:users, :authentication_token)

    MigrationUser.reset_column_information
    MigrationUser.find_each do |user|
      updates = {}
      updates[:encrypted_password] = user.password_digest if user.password_digest.present?
      if user.authentication_token.blank?
        updates[:authentication_token] = loop do
          token = SecureRandom.hex(20)
          break token unless MigrationUser.exists?(authentication_token: token)
        end
      end
      user.update_columns(updates) if updates.any?
    end

    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :authentication_token, unique: true unless index_exists?(:users, :authentication_token)

    remove_column :users, :password_digest, :string if column_exists?(:users, :password_digest)
  end

  def down
    add_column :users, :password_digest, :string unless column_exists?(:users, :password_digest)

    MigrationUser.reset_column_information
    MigrationUser.find_each do |user|
      next if user.encrypted_password.blank?

      user.update_columns(password_digest: user.encrypted_password)
    end

    remove_index :users, :authentication_token if index_exists?(:users, :authentication_token)
    remove_index :users, :email if index_exists?(:users, :email)
    remove_column :users, :authentication_token if column_exists?(:users, :authentication_token)
    remove_column :users, :encrypted_password if column_exists?(:users, :encrypted_password)
  end
end
