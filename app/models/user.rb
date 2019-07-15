class User < ApplicationRecord
	has_secure_password
	before_save :downcase_email
	before_create :generate_confirmation_instructions
	validates_presence_of :email
	validates_uniqueness_of :email, case_sensitive: false
	validates_format_of :email, with: /@/
	validates :username, presence: true, length: { in: 5..16 }
	validates_inclusion_of :age, in: 0..99, numericality: true, message:'Please enter valid'
	validates_inclusion_of :gender, in: %w( m f ), message: "Please mention gender as m/f"
	validates_format_of :date_of_birth, with: %r{\A(\d{4}-\d{2}-\d{2})}, message: 'Please enter DOB as yyyy-mm-dd'


	def downcase_email
		self.email = self.email.delete(' ').downcase
	end

	def generate_confirmation_instructions
		self.confirmation_token = SecureRandom.hex(10)
		self.confirmation_sent_at = Time.now.utc
	end

	def confirmation_token_valid?
		(self.confirmation_sent_at + 30.days) > Time.now.utc
	end

	def mark_as_confirmed!
		self.confirmation_token = nil
		self.confirmed_at = Time.now.utc
		save
	end
end
