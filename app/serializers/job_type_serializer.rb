class JobTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :trade_id, :description
end
