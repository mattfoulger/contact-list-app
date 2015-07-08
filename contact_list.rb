require 'pg'
require 'pry'
require_relative 'contact'
require_relative 'help'


@first, @second = ARGV 
running = true


def list(array)
  # array.each { |contact| contact.display }
  array.each do |contact| 
    puts contact.firstname
    puts contact.lastname
    puts contact.email
end


def write_contact(id=nil)
  puts "First name:"
  firstname = STDIN.gets.chomp
  puts "Last name:"
  lastname = STDIN.gets.chomp
  puts "Email:"
  email = STDIN.gets.chomp
  contact = Contact.new(firstname, lastname, email, id)
  contact.save
end

def search(term)
  list(Contact.find_all_by_firstname(term))
  list(Contact.find_all_by_lastname(term))
  list(Contact.find_by_email(term))
end

def show(id)
  contact = Contact.find(id)
  list(contact)
  puts "Update contact? y/n"
  response = STDIN.gets.chomp
  if response == "y"
    write_contact(id)
  end
end


loop do

  case @first
  when "quit"
    break
  when "help"
    Help.new
  when "new"
    write_contact
  when "list"
    list(Contact.all)
  when "show"
    unless @second
      puts "Enter contact ID"
      @second = STDIN.gets.chomp
    end
    show(@second)
  when "search"
    unless @second
      puts "Enter search term:"
      @second = STDIN.gets.chomp
    end
    search(@second)
  end

  puts "--------------------------------"
  puts "Enter a command"
  arg_array = STDIN.gets.chomp.downcase.split(" ")
  @first = arg_array[0]
  @second = arg_array[1]

end