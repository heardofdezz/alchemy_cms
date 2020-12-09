# frozen_string_literal: true

require "rails_helper"

RSpec.describe "The edit elements feature", type: :system do
  let!(:a_page) { create(:alchemy_page) }

  before do
    authorize_user(:as_editor)
  end

  context "Visiting the new element form" do
    context "with a page_id passed" do
      scenario "a form to select a new element for the page appears." do
        visit alchemy.new_admin_element_path(page_id: a_page.id)
        expect(page).to have_selector('select[name="element[name]"]')
      end
    end

    context "with a page_id and parent_element_id passed" do
      let!(:element) do
        create(:alchemy_element, :with_nestable_elements, page: a_page, page_version: a_page.draft_version)
      end

      scenario "a hidden field with parent element id is in the form." do
        visit alchemy.new_admin_element_path(page_id: a_page.id, parent_element_id: element.id)
        expect(page).to have_selector(%(input[type="hidden"][name="element[parent_element_id]"][value="#{element.id}"]))
      end
    end
  end

  context "With an element having nestable elements defined" do
    let!(:element) do
      create(:alchemy_element, :with_nestable_elements, page: a_page, page_version: a_page.draft_version)
    end

    scenario "a button to add an nestable element appears." do
      visit alchemy.admin_elements_path(page_id: element.page_id)
      expect(page).to have_selector(".add-nestable-element-button")
    end
  end

  describe "Copy element", :js do
    let!(:element) { create(:alchemy_element, page: a_page) }

    scenario "is possible to copy element into clipboard" do
      visit alchemy.admin_elements_path(page_id: element.page_id)
      expect(page).to have_selector(".element-toolbar")
      find(".fa-clone").click
      within "#flash_notices" do
        expect(page).to have_content(/Copied Article/)
      end
    end
  end
end
