puts "Limpiando base de datos..."
User.destroy_all
Customer.destroy_all
Registration.destroy_all

puts "Creando usuarios..."

User.create!(
  username: "admin_user",
  password: "password123",
  password_confirmation: "password123"
)

User.create!(
  username: "test_user",
  password: "secure_password_456",
  password_confirmation: "secure_password_456"
)

Customer.create!(
  person_type: 0,
  full_name: "Juan Perez",
  id_number: "1232312333",
  issue_date: 2.years.ago,
  expiry_date: 3.years.from_now,
  phone_primary: "022334455",
  email: "juanperez@yahoo.com",
  deleted: false,
)

Customer.create!(
  person_type: 1,
  full_name: "Tech Solutions Inc",
  id_number: "1231233",
  issue_date: 2.years.ago,
  expiry_date: 3.years.from_now,
  phone_primary: "022334455",
  phone_secondary: "023123125",
  email: "solutions@msn.com",
  deleted: false,
)

Customer.create!(
  person_type: 0,
  full_name: "Maria Garcia",
  id_number: "12312311",
  issue_date: 2.years.ago,
  expiry_date: 3.years.from_now,
  phone_primary: "022334455",
  phone_secondary: "023123125",
  email: "mariagarcia@gmail.com",
  deleted: true,
)

Registration.create!(
  customer_id: 1,
  user_id: 1,
  registration_date: Date.today,
)

Registration.create!(
  customer_id: 2,
  user_id: 1,
  registration_date: Date.today,
)

Registration.create!(
  customer_id: 3,
  user_id: 2,
  registration_date: Date.today,
)

puts "¡Seeds completados con éxito!"
