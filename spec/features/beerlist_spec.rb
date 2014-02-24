require 'spec_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)') 
    expect(page).to have_content "Nikolai"
  end

  it "shows beers orderder by name", :js => true do
    visit beerlist_path
    find('table').find('tbody').find('tr:nth-child(1)').should have_content('Fastenbier')
    find('table').find('tbody').find('tr:nth-child(2)').should have_content('Lechte Weisse')
    find('table').find('tbody').find('tr:nth-child(3)').should have_content('Nikolai')
  end

  it "shows beers orderder by style", :js => true do
    visit beerlist_path
    all('a').select {|a| a.text == "style" }.first.click
    find('table').find('tbody').find('tr:nth-child(1)').should have_content('Lager')
    find('table').find('tbody').find('tr:nth-child(2)').should have_content('Rauchbier')
    find('table').find('tbody').find('tr:nth-child(3)').should have_content('Weizen')
  end

  it "shows beers orderder by brewery", :js => true do
    visit beerlist_path
    all('a').select {|a| a.text == "brewery" }.first.click
    find('table').find('tbody').find('tr:nth-child(1)').should have_content('Ayinger')
    find('table').find('tbody').find('tr:nth-child(2)').should have_content('Koff')
    find('table').find('tbody').find('tr:nth-child(3)').should have_content('Schlenkerla')
  end  

end