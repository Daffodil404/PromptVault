require "test_helper"
require "stringio"

class ProfileTest < ActiveSupport::TestCase
  test "accepts an image avatar" do
    profile = users(:one).profile || users(:one).create_profile!
    profile.avatar.attach(io: StringIO.new("fake image"), filename: "avatar.png", content_type: "image/png")

    assert_predicate profile, :valid?
  end

  test "rejects a non-image avatar" do
    profile = users(:one).profile || users(:one).create_profile!
    profile.avatar.attach(io: StringIO.new("not an image"), filename: "avatar.txt", content_type: "text/plain")

    assert_not profile.valid?
    assert_includes profile.errors[:avatar], "must be a PNG, JPG, JPEG, WEBP, or GIF"
  end

  test "rejects out-of-range avatar adjustments" do
    profile = users(:one).profile || users(:one).create_profile!
    profile.avatar_zoom = 3.0
    profile.avatar_offset_x = 120
    profile.avatar_offset_y = -10

    assert_not profile.valid?
    assert_predicate profile.errors[:avatar_zoom], :present?
    assert_predicate profile.errors[:avatar_offset_x], :present?
    assert_predicate profile.errors[:avatar_offset_y], :present?
  end
end
