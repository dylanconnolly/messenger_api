class MessageSerializer
  include FastJsonapi::ObjectSerializer
  attributes :user, :conversation, :content, :created_at
end
