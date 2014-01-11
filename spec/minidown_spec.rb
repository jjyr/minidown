require 'spec_helper'

describe Minidown do
  it 'Minidown.render should == Parser#render' do
    Minidown.render("hello").should == Minidown::Parser.new.render("hello")
  end

  it 'allow options' do
    options = {}
    Minidown.render("hello", options).should == Minidown::Parser.new(options).render("hello")
  end
end
