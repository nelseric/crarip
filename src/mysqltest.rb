require 'rubygems'
require 'mysql'

def main
  my = Mysql::new("localhost","root","asn5kc","coderedalliance")
  res = my.query("SELECT * FROM teams T, alliances A, matches M WHERE T.")
end

main