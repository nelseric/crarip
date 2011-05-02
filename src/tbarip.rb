require 'rubygems'
require 'mysql'
require 'tba'

def main

  begin
    tba = TBA.new("e9f1ef17b855b367caac352dcf2bdeeb")
    db = Mysql::new("localhost","root","asn5kc","coderedalliance")
    #teams(tba, db)
  ensure
    db.close
  end
end

def teams(tba, db)
  ins = db.prepare(
  "INSERT INTO `teams`
  (`TeamNumber`, `TeamName`, `TeamShortName`, `YearFounded`, `About`, `Website`, `City`, `State`, `Country`)
  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);")
  puts 'fetching teams'
  teams = tba.get_events(:year=>"2001")
  puts 'done fetching teams'
  i = 0
  teams.each do
    |t|
    i++
    puts("#{i}/#{teams.length}") if i % 100 == 0
    number = 0
    name = ""
    short_name = ""
    year_founded = 1992
    about = ""
    website = ""
    city = ""
    state = ""
    country = "USA"

    number = t[:teamnumber]
    name = t[:name]
    short_name = t[:informalname]
    year_founded = t[:rookieyear]
    website = t[:website]
    city = t[:city]
    state = t[:state]
    country = t[:country]

    ins.execute(number, name, short_name, year_founded, about, website, city, state, country)
  end
  ins.close
end

main