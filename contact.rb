class Contact
 
  attr_accessor :firstname, :lastname, :email
  attr_reader :id


  def initialize(firstname, lastname, email, id=nil)
    @firstname = firstname
    @lastname = lastname
    @email = email
    @id = id
  end
 
  def save
    unless @id
      sql = "INSERT INTO contacts (firstname, lastname, email) VALUES ($1, $2, $3)"
      self.class.connection.exec_params(sql, [@firstname, @lastname, @email])
    else
      sql = "UPDATE contacts SET firstname = $1, lastname = $2, email= $3 WHERE id = $4"
      self.class.connection.exec_params(sql, [@firstname, @lastname, @email, @id])
    end
  end

  def destroy
    if @id
      sql = "DELETE FROM contacts WHERE id = $1"
      self.class.connection.exec_params(sql, [@id])
    end
  end

  def display
    puts "--------------------------------"
    puts "Name: #{@firstname} #{@lastname}"
    puts "Email: #{@email}"
    puts "ID: #{@id}"
  end


  class << self
    
    def connection
      PG.connect(
        host: 'localhost',
        dbname: 'contact_list',
        user: 'development',
        password: 'development'
      )
    end

    def find(id)
      sql = "SELECT * FROM contacts WHERE id = $1"
      contacts = connection.exec_params(sql, [id])
      objectifier(contacts)
    end

    def find_by_email(email)
      sql = "SELECT * FROM contacts WHERE email = $1"
      contacts = connection.exec_params(sql, [email])
      objectifier(contacts)
    end
 
    def find_all_by_lastname(lastname)
      sql = "SELECT * FROM contacts WHERE lastname = $1"
      contacts = connection.exec_params(sql, [lastname])
      objectifier(contacts)
    end

    def find_all_by_firstname(firstname)
      sql = "SELECT * FROM contacts WHERE firstname = $1"
      contacts = connection.exec_params(sql, [firstname])
      objectifier(contacts)
    end

    def all
      sql = "SELECT * FROM contacts"
      contacts = connection.exec(sql)
      objectifier(contacts)
    end

    private
      def objectifier(pgresult)
        array = []
        pgresult.each do |row|
          array << self.new(
            row["firstname"],
            row["lastname"],
            row["email"],
            row["id"]
          )
        end
        array
      end
  end
 
end