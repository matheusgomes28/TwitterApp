require 'cucumber'
runtime = Cucumber::Runtime.new 
runtime.load_programming_language('rb') 
Cucumber::Cli::Main.new([]).execute!(runtime)
