require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []

    doc.css(".student-card").each do |student|
      student_hash ={
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    student_hash = {}

    doc.css(".social-icon-container a").each do |social|
      if social.attr(:href).include?("twitter")
        student_hash[:twitter] = social.attribute("href").value
      elsif social.attr(:href).include?("linkedin")
        student_hash[:linkedin] = social.attribute("href").value
      elsif social.attr(:href).include?("github")
        student_hash[:github] = social.attribute("href").value
      else
        student_hash[:blog] = social.attribute("href").value
      end
    end
  
    student_hash[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text
    student_hash[:bio] = doc.css(".description-holder p").text

    student_hash
  end

end

