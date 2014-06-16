class Event < ActiveRecord::Base

  # Associations
  belongs_to :company
  belongs_to :job
  belongs_to :member
  belongs_to :account
  belongs_to :address

  # Scopes
  default_scope -> { order('starts_at ASC') }

  # Validations
  validates :starts_at, presence: true
  validates :starts_at, presence: true
  validates :starts_at, :ends_at, overlap: {scope: 'member_id', exclude_edges: ['starts_at', 'ends_at']}

  # Scopes
  scope :range, lambda { |st,et|
    if st && et
      start_time = Time.at(st.to_i).to_s(:db)
      end_time = Time.at(et.to_i).to_s(:db)
      where("starts_at >= '#{start_time}' and starts_at <= '#{end_time}'")
    end
  }

end
