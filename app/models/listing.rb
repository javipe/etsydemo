class Listing < ActiveRecord::Base
  if Rails.env.development?
    has_attached_file :image, styles: { medium: "200x", thumb: "100x100>" }, default_url: "missing_:style.png"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  else
    has_attached_file :image, styles: { medium: "200x", thumb: "100x100>" }, default_url: "missing_:style.png",
            :storage => :dropbox,
            :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
            :path => ":style/:id_:filename"
            validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  end

  validates :name, :description, :price, presence: true
  validates :price, numericality: {greater_than: 0}
  validates_attachment_presence :image
  
  def self.search(search)
      if Rails.env.development?
        where("name LIKE ?", "%#{search}%") 
      else
        where("name ILIKE ?", "%#{search}%") 
      end
  end

  belongs_to :user
  has_many :orders
end
