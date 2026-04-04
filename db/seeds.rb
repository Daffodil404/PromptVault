puts "Seeding PromptVault data..."

def upsert_user!(username:, email:, role:, password:, profile:)
  user = User.find_or_initialize_by(email: email)
  user.username = username
  user.role = role
  user.password = password
  user.password_confirmation = password
  user.save!

  user.profile ||= user.build_profile
  user.profile.update!(profile)
  user
end

def upsert_prompt!(user:, title:, abstract:, content:, status:, tag_names:, change_note:)
  prompt = user.prompts.find_or_initialize_by(title: title)
  prompt.abstract = abstract
  prompt.content = content
  prompt.status = status
  prompt.save!
  prompt.sync_tags_from_names!(tag_names)

  version = prompt.prompt_versions.find_or_initialize_by(version_number: 1)
  version.user = user
  version.content = content
  version.change_note = change_note
  version.save!

  prompt
end

def upsert_review!(user:, prompt:, rating:, comment:)
  review = Review.find_or_initialize_by(user: user, prompt: prompt)
  review.rating = rating
  review.comment = comment
  review.save!
end

alice = upsert_user!(
  username: "alice",
  email: "alice@example.com",
  role: "author",
  password: "password",
  profile: {
    bio: "I write creative and classroom-friendly prompts for writers and students.",
    location: "Hamilton, ON",
    website: "https://alice-prompts.example.com",
    favorite_prompt_style: "creative writing"
  }
)

bob = upsert_user!(
  username: "bob",
  email: "bob@example.com",
  role: "author",
  password: "password",
  profile: {
    bio: "I review prompts for clarity, usefulness, and structure.",
    location: "Toronto, ON",
    website: "https://bob-reviews.example.com",
    favorite_prompt_style: "tutoring"
  }
)

carol = upsert_user!(
  username: "carol",
  email: "carol@example.com",
  role: "admin",
  password: "password",
  profile: {
    bio: "I curate high-quality prompt collections and organize them with tags.",
    location: "Waterloo, ON",
    website: "https://carol-admin.example.com",
    favorite_prompt_style: "productivity"
  }
)

spring_prompt = upsert_prompt!(
  user: alice,
  title: "Write a Poem About Spring",
  abstract: "A creative-writing prompt for generating a short spring poem.",
  content: "Write a 12-line poem about spring that uses vivid imagery, one metaphor, and a hopeful tone.",
  status: "published",
  tag_names: "poetry, creative writing, beginner",
  change_note: "Initial published version"
)

study_prompt = upsert_prompt!(
  user: bob,
  title: "Turn Notes Into a Study Guide",
  abstract: "A learning prompt that converts class notes into a clear study guide.",
  content: "Convert the following notes into a study guide with key terms, a summary, and five practice questions.",
  status: "published",
  tag_names: "education, tutoring, study skills",
  change_note: "Initial published version"
)

planning_prompt = upsert_prompt!(
  user: carol,
  title: "Plan My Week Efficiently",
  abstract: "A productivity prompt for organizing tasks into a realistic weekly plan.",
  content: "Create a one-week schedule from my task list, grouping similar tasks and leaving buffer time for interruptions.",
  status: "draft",
  tag_names: "productivity, planning, organization",
  change_note: "Initial draft version"
)

upsert_review!(
  user: bob,
  prompt: spring_prompt,
  rating: 5,
  comment: "Clear, specific, and easy to use for a quick creative-writing exercise."
)

upsert_review!(
  user: carol,
  prompt: spring_prompt,
  rating: 4,
  comment: "Nice structure and tone constraints. Could be extended with optional difficulty variations."
)

upsert_review!(
  user: alice,
  prompt: study_prompt,
  rating: 5,
  comment: "Very practical for students who need help organizing raw notes into something reviewable."
)

puts "Seeded #{User.count} users, #{Prompt.count} prompts, #{Tag.count} tags, and #{Review.count} reviews."
