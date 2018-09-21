module Octopress
  module Tags
    module Quote
      module Utils
        def self.parse_content(content, context)
          path  = context.environments.first['page']['path']
          ext   = File.extname(path[1..-1])[1..-1]
          site  = context.registers[:site]
          mdext = site.config['markdown_ext']
          txext = site.config['textile_ext']

          if mdext.include? ext
            converter = if site.respond_to?(:find_converter_instance)
			  site.find_converter_instance(Jekyll::Converters::Markdown)
			else
			  site.getConverterImpl(Jekyll::Converters::Markdown)
			end
            converter.convert(content)
          elsif txext.include? ext
            converter = if site.respond_to?(:find_converter_instance)
			  site.find_converter_instance(Jekyll::Converters::Textile)
			else
			  site.getConverterImpl(Jekyll::Converters::Textile)
			end
            converter.convert(content)
          else
            "<p>" + content.strip.gsub(/\n\n/, "<p>\n\n</p>") + "</p>"
          end
        end
      end
    end
  end
end
