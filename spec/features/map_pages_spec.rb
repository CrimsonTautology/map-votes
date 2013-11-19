require 'spec_helper'

describe "Map pages" do
  #raise page.body.to_yaml

  subject { page }

  describe "GET /maps" do
    context "empty database" do
      before(:each) do
        Map.delete_all
        visit maps_path
      end

      its(:status_code) { should eq 200}

    end

    context "populated database" do
      let!(:map) {FactoryGirl.create(:map)}
      before(:each) do
        visit maps_path
      end

      it { should have_link(map.name, href: map_path(map))}
      it { should have_content(map.map_type.name)}
      it { should_not have_link("Edit", href: edit_map_path(map))}

      context "Logged in as admin" do
        let!(:user) {FactoryGirl.create(:admin)}
        before do
          login user
          visit maps_path
        end

        it { should have_link("Edit", href: edit_map_path(map))}
      end
    end

    context "filtering" do
      before do
        FactoryGirl.create(:map_type, name: "King of the Hill", prefix: "koth")
        FactoryGirl.create(:map_type, name: "Control Point", prefix: "cp")
        FactoryGirl.create(:map, name: "cp_badlands")
        FactoryGirl.create(:map, name: "koth_badlands")
        FactoryGirl.create(:map, name: "koth_viaduct")
        visit maps_path
      end

      it { should have_content("King of the Hill") }

      context "by name" do
        before do
          fill_in "search", with: "bad"
          click_on "Search"
        end
        it { should have_content("koth_badlands") }
        it { should_not have_content("koth_viaduct") }
      end

      context "by map type" do
        before do
          click_on "King of the Hill"
        end

        it { should have_content("koth_badlands") }
        it { should_not have_content("cp_badlands") }

      end
    end
  end #/maps

  describe "GET /maps/:id" do
    let!(:map) {FactoryGirl.create(:map)}

    before(:each) do
      visit "/maps/#{map.name}"
    end

    it { should have_content(map.name)}
    it { should have_content(map.description)}
    it { should have_content(map.map_type.name)}
    it { should have_content("All Comments (0)")}
    it { should have_content("You must be logged in to leave a comment")}

    it { should_not have_link("like it", href: vote_map_path(map, type: "up"))}
    it { should_not have_link("hate it", href: vote_map_path(map, type: "down"))}
    it { should_not have_content("like it")}
    it { should_not have_link("", href: favorite_map_path(map))}
    it { should_not have_link("", href: unfavorite_map_path(map))}
    it { should_not have_link("", href: edit_map_path(map))}
    it { should_not have_link("Origin")}
    #it { should_not have_selector()}
    #
    context "with origin" do
      before do
        map.origin = "example.com"
        map.save
        visit map_path(map)
      end

      it { should have_link("Origin", href: map.origin)}
    end

    context "with comments" do
      let!(:comment) {FactoryGirl.create(:map_comment, map: map)}
      before do
        visit map_path(map)
      end

      it { should have_content(comment.comment)}
      it { should have_content(comment.user.nickname)}
      it { should_not have_link("Delete", [map, comment])}

    end

    context "with up votes" do
      let!(:user) {FactoryGirl.create(:user, nickname: "Upvote McGee")}
      let!(:vote) {FactoryGirl.create(:vote, map: map, user: user, value: 1)}

      before do
        visit map_path(map)
      end

      it { should have_content(user.nickname)}
      it { should have_content("Liked by")}
      it { should have_selector('div.up-vote', text: '1')}
    end

    context "with down votes" do
      let!(:user) {FactoryGirl.create(:user, nickname: "Map hater")}
      let!(:vote) {FactoryGirl.create(:vote, map: map, user: user, value: -1)}

      before do
        visit map_path(map)
      end

      it { should have_content(user.nickname)}
      it { should have_content("Hated by")}
      it { should have_selector('div.down-vote', text: '1')}
    end

    context "user logged in" do
      let!(:user) {FactoryGirl.create(:user)}
      before do
        login user
        visit map_path(map)
      end

      it "allows you to favorite a map" do
        expect{click_on "Add to Favorites" }.to change{MapFavorite.count}.from(0).to(1)
      end
      it "allows you to unfavorite a map" do
        click_on "Add to Favorites"
        expect{click_on "Remove from Favorites" }.to change{MapFavorite.count}.from(1).to(0)
      end

      it "allows you to vote" do
        expect{click_on "like it" }.to change{Vote.count}.by(1)
        expect{click_on "hate it" }.to_not change{Vote.count}
      end

      it "won't let you enter blank comments" do
        click_on "Post Comment"
        expect(page).to have_content("Could not add comment")
      end

      context "With comments by other users" do
        let!(:other_user) {FactoryGirl.create(:user)}
        let!(:other_comment) {FactoryGirl.create(:map_comment, map: map, comment: "This is not your comment", user: other_user)}
        before do
          visit map_path(map)
        end

        it { should have_content(other_comment.comment)}
        it { should_not have_link("Delete", [map, other_comment])}

      end

      it "allows you to enter comments" do
        fill_in "map_comment_comment", with: "This is a test comment"
        click_on "Post Comment"
        expect(page).to have_content("This is a test comment")
        expect(page).to have_content(map.name)
      end

      it "allows you to delete your comments" do
        fill_in "map_comment_comment", with: "This is a test comment"
        click_on "Post Comment"
        click_on "Delete"
        expect(page).to_not have_content("This is a test")
      end

      pending "won't let you rapidly enter comments" do
        fill_in "map_comment_comment", with: "This is a test comment"
        click_on "Post Comment"
        fill_in "map_comment_comment", with: "Another comment"
        click_on "Post Comment"
        expect(page).to have_content(map.name)
        expect(page).to have_content("This is a test comment")
        expect(page).to_not have_content("Another comment")
        expect(page).to have_content("Can not add another comment so soon")

      end

    end

    context "banned user logged in" do
      let!(:user) {FactoryGirl.create(:banned)}
      before do
        login user
        visit map_path(map)
      end

      it { should_not have_content("Post Comment", )}
      pending { should have_content("You have been banned")}
    end


    context "user logged in as a moderator" do
      let!(:user) {FactoryGirl.create(:moderator)}
      before do
        login user
        visit map_path(map)
      end

      context "With comments by other users" do
        let!(:other_user) {FactoryGirl.create(:user)}
        let!(:other_comment) {FactoryGirl.create(:map_comment, map: map, comment: "This is not your comment", user: other_user)}
        before do
          visit map_path(map)
        end

        it { should have_content(other_comment.comment)}
        it { should have_link("Delete", [map, other_comment])}
        it { should have_link("Edit Map", href: edit_map_path(map))}
        pending { should have_link("Ban", ban_user_path(:user))}
      end

    end
  end#/maps/:id

  describe "GET /maps/:id/edit" do
    let!(:map) {FactoryGirl.create(:map)}
    let!(:user) {FactoryGirl.create(:user)}
    let!(:admin) {FactoryGirl.create(:admin)}
    let!(:koth) {FactoryGirl.create(:map_type, name: "King of the Hill", prefix: "koth")}

    context "not logged in as admin" do
      before do
        login user
        visit edit_map_path(map)
      end

      its(:status_code) { should eq 403}
    end

    context "logged in as admin" do
      before do
        login admin
        visit edit_map_path(map)
      end

      its(:status_code) { should eq 200}
      it{should have_content(map.name)}
      it "updates map type" do
        select koth.name, from: "map_map_type_id"
        click_on "Update Map"
        map.reload
        expect(map.map_type).to eql(koth)
      end
      it "updates map image" do
        fill_in "Image", with: "http://www.example.com/image"
        click_on "Update Map"
        map.reload
        expect(map.image).to eql( "http://www.example.com/image")
      end
      it "updates map description" do
        fill_in "Description", with: "Blah blah BLAH"
        click_on "Update Map"
        map.reload
        expect(map.description).to eql("Blah blah BLAH")
      end
      it "updates map origin" do
        fill_in "Origin", with: "http://www.example.com/origin"
        click_on "Update Map"
        map.reload
        expect(map.origin).to eql( "http://www.example.com/origin")
      end
    end
  end

  describe "GET /maps/new" do
  end
end
