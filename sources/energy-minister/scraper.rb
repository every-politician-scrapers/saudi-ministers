#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

require 'open-uri/cached'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  # decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'ministers'
  end

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h3[.//span[contains(.,'#{header_column}')]][last()]//following-sibling::ol[1]//li[a]")
  end

  class Officeholder < OfficeholderBase
    def combo_date?
      true
    end

    def raw_combo_date
      noko.text[/\((.*?)\)/, 1].tidy
    end

    def name_cell
      noko
    end

    def empty?
      false
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
