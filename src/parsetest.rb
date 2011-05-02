#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mysql'

def main
  cmpid = 'GT'
  p
  file = open("http://www2.usfirst.org/2011comp/events/#{cmpid}/matchresults.html").read
  match = /<TR.+?<\/TR>/m
  rows = file.scan(match)

  rows.map!{|row| row = Nokogiri::HTML(row)}

  matches = []
  rows.each do
    |row|
    cols = row.css("td")
    cols = cols.to_a.map{|col| col.content}
    if cols.length == 10
      match = {:time => cols[0], :description => 'QF', :num => cols[1],
        :teams => {:red_one=> cols[2], :red_two=> cols[3], :red_three=> cols[4],
        :blue_one=> cols[5], :blue_two=> cols[6], :blue_three=> cols[7]},
        :red_score => cols[8], :blue_score => cols[9]
      }
    else
      match = {:time => cols[0], :description => [1], :match_number => cols[2],
        :red_one=> cols[3], :red_two=> cols[4], :red_three=> cols[5],
        :blue_one=> cols[6], :blue_two=> cols[7], :blue_three=> cols[8],
        :red_score => cols[9], :blue_score => cols[10]
      }
    end
    matches.push match
  end
  db = Mysql::new("localhost","root","asn5kc","coderedalliance")

  matches.each do
    |match|
    match[:teams].each do
      |team|
      if db.query("SELECT * FROM teams WHERE TeamNumber = #{team}").num_rows == 0
        puts "Inserting #{team}"
        db.query("INSERT INTO teams(TeamNumber) VALUES(#{team})")
      end
    end
  end
end

main