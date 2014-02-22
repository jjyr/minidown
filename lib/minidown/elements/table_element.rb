module Minidown
  class TableElement < Element
    AlignSpecRegexp = /\A\|?\s*([\-:]\-+[\-:]\s*(?:\|\s*[\-:]\-+[\-:]\s*)*)\|?\s*\z/

    def initialize doc, content, raw_head
      super doc, content
      @raw_head = raw_head
      @heads = @raw_head.split('|'.freeze).map! &:strip
      @column_count = @heads.count
    end

    def check_column_spec raw_column_spec
      if @valid.nil?
        @valid = Utils::Regexp[:pipe_symbol] =~ raw_column_spec && AlignSpecRegexp =~ raw_column_spec && (column_spec_str = $1) && (@column_specs = column_spec_str.split('|'.freeze).map! &:strip) && @column_specs.count == @column_count
      else
        @valid
      end
    end

    def parse
      if @valid
        nodes << self
        @bodys = []
        @column_specs.map! do |column_spec|
          if column_spec[0] == column_spec[-1]
            column_spec[0] == ':'.freeze ? 'center'.freeze : nil
          else
            column_spec[0] == ':'.freeze ? 'left'.freeze : 'right'.freeze
          end
        end

        while line = unparsed_lines.shift
          if Utils::Regexp[:table] =~ line && (cells = $1.split('|'.freeze).map! &:strip) && @column_count == cells.count
            @bodys << cells
          else
            unparsed_lines.unshift line
            break
          end
        end
      else
        raise 'table column specs not valid'
      end
    end

    def to_html
      attrs = @column_specs.map do |align|
        {align: align}.freeze if align
      end
      build_tag 'table'.freeze do |table|
        thead = build_tag 'thead'.freeze do |thead|
          tr = build_tag 'tr'.freeze do |tr|
            @heads.each_with_index do |cell, i|
              th = build_tag 'th'.freeze, attrs[i] do |th|
                th << cell
              end
              tr << th
            end
          end
          thead << tr
        end
        table << thead

        tbody = build_tag 'tbody'.freeze do |tbody|
          @bodys.each do |row|
            tr = build_tag 'tr'.freeze do |tr|
              row.each_with_index do |cell, i|
                td = build_tag 'td'.freeze, attrs[i] do |td|
                  td << TextElement.new(doc, cell).to_html
                end
                tr << td
              end
            end
            tbody << tr
          end
        end
        table << tbody
      end
    end
  end
end
