require 'pg'
require 'pry'
require_relative '../connection'
require_relative 'contact'
require_relative 'help'

@first, @second = ARGV 

def display(contact)
  puts "--------------------------------"
  puts "Name: #{contact.first_name} #{contact.last_name}"
  puts "Email: #{contact.email}"
  puts "ID: #{contact.id}"
end

def list(array)
  array.each do |contact| 
    display(contact)
  end
end


def write_contact
  puts "First name:"
  @firstname = STDIN.gets.chomp
  puts "Last name:"
  @lastname = STDIN.gets.chomp
  puts "Email:"
  @email = STDIN.gets.chomp
  {first_name: @firstname, last_name: @lastname, email: @email}
end

def update(id)
  contact_info = write_contact
  Contact.find(id).update(first_name: contact_info[:first_name], last_name: contact_info[:last_name], email: contact_info[:email])
end

def create
  contact_info = write_contact
  Contact.create(first_name: contact_info[:first_name], last_name: contact_info[:last_name], email: contact_info[:email])
end

def search(term)
  list(Contact.where("first_name = ? OR last_name = ? OR email = ?", term, term, term))
end

def find(id)
  display(Contact.find(id))
  puts "Update contact? y/n"
  response = STDIN.gets.chomp
  if response == "y"
    update(id)
  end
end


loop do

  case @first
  when "quit"
    break
  when "help"
    Help.new
  when "new"
    create
  when "list"
    list(Contact.all)
  when "find"
    unless @second
      puts "Enter contact ID"
      @second = STDIN.gets.chomp
    end
    find(@second)
  when "search"
    unless @second
      puts "Enter search term:"
      @second = STDIN.gets.chomp
    end
    search(@second)
  end

  puts "--------------------------------"
  puts "Enter a command"
  arg_array = STDIN.gets.chomp.split
  @first = arg_array[0]
  @second = arg_array[1]

end