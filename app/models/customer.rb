class Customer < ApplicationRecord
  VALID_NAME_REGEX = /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/
  VALID_ONLY_NUMBERS = /\A[0-9]+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations

  before_validation :normalize_phones
  before_save :downcase_email
  after_create :create_registration_entry

  enum :person_type, { natural: 0, juridica: 1 }

  validates :person_type, :full_name, :id_number, :issue_date, :expiry_date,
            :phone_primary, :email,
            presence: { message: "es un campo obligatorio" }
  validates :full_name,
            format: {
              with: VALID_NAME_REGEX,
              message: "solo permite letras"
            }
  validates :phone_primary,
            format: { with: VALID_ONLY_NUMBERS, message: "solo permite números" }
  validates :phone_secondary,
            format: { with: VALID_ONLY_NUMBERS, message: "solo permite números" },
            allow_blank: true
  validates :email,
            format: { with: VALID_EMAIL_REGEX, message: "no tiene un formato válido" },
            uniqueness: { case_sensitive: false, message: "ya está registrado por otro cliente" }
  validates :id_number, uniqueness: { message: "ya se encuentra registrado" },
            format: { with: VALID_ONLY_NUMBERS, message: "solo permite números" }
  validate :expiry_after_issue

  def issue_date=(value)
    processed_value = value.is_a?(String) ? parse_custom_date(value) : value
    write_attribute(:issue_date, processed_value)
  end

  def expiry_date=(value)
    processed_value = value.is_a?(String) ? parse_custom_date(value) : value
    write_attribute(:expiry_date, processed_value)
  end

  def creator_user
    user = registrations.first&.user
    return nil unless user
    user.as_json(only: [ :id, :username ])
  end

  private

  def normalize_phones
    if phone_primary.is_a?(String)
        self.phone_primary = phone_primary.gsub(/\D/, "")
    end

    if phone_secondary.is_a?(String)
      self.phone_secondary = phone_secondary.gsub(/\D/, "")
    end
  end
  def expiry_after_issue
    return if expiry_date.blank? || issue_date.blank?

    if expiry_date < issue_date
      errors.add(:expiry_date, "debe ser posterior a la fecha de emisión")
    end
  end
  def create_registration_entry
      self.registrations.create(
        registration_date: Date.current,
        user_id: Thread.current[:current_user_id]
      )
  end
  def downcase_email
    self.email = email.downcase if email.present?
  end
  def parse_custom_date(date_value)
    return nil if date_value.blank?
    normalized_date = date_value.gsub("/", "-")
    Date.strptime(normalized_date, "%Y-%m-%d")
  rescue ArgumentError, TypeError
    nil
  end
end
