class SuggestedTopicSerializer < ListableTopicSerializer

  # need to embed so we have users
  # front page json gets away without embedding
  class SuggestedPosterSerializer < ApplicationSerializer
    attributes :extras, :description
    has_one :user, serializer: BasicUserSerializer, embed: :objects
  end

  attributes :archetype, :like_count, :views, :category_id, :tags, :featured_link, :featured_link_root_domain
  has_many :posters, serializer: SuggestedPosterSerializer, embed: :objects

  def posters
    object.posters || []
  end

  def include_tags?
    SiteSetting.tagging_enabled && (!object.private_message? || scope.user&.staff?)
  end

  def tags
    object.tags.map(&:name)
  end

  def include_featured_link?
    SiteSetting.topic_featured_link_enabled
  end

  def featured_link
    object.featured_link
  end

  def include_featured_link_root_domain?
    SiteSetting.topic_featured_link_enabled && object.featured_link
  end
end
