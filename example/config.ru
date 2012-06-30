require 'happy'
require './happy-tutorial'

class TutorialMounter < Happy::Controller
  def route
    @examples = HappyTutorial.constants
    serve_examples
    serve_example_index
  end

  def serve_examples
    @examples.each do |example|
      on example.to_s do
        run eval("HappyTutorial::#{example}")
      end
    end
  end

  def serve_example_index
    response.body << html_tag(:h1) { "The Happy Tutorial" }
    response.body << html_tag(:ul) do
      @examples.inject("") do |s, example|
        s << html_tag(:li) { link_to example, example }
      end
    end
    halt!
  end
end

run TutorialMounter
