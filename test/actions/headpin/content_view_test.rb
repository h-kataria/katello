#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'katello_test_helper'

module Katello
  describe ::Actions::Headpin::ContentView do
    include Dynflow::Testing
    include Support::Actions::Fixtures
    include Support::Actions::RemoteAction
    include FactoryGirl::Syntax::Methods

    describe "Create" do
      let(:action_class) { ::Actions::Headpin::ContentView::Create }
      let(:action) { create_action action_class }

      let(:content_view) do
        katello_content_views(:acme_default)
      end

      it 'plans' do
        Katello::Configuration::Node.any_instance.stubs(:use_elasticsearch).returns(true)
        content_view.expects(:save!)
        content_view.expects(:disable_auto_reindex!)
        plan_action(action, content_view)
        assert_action_planed_with(action, ::Actions::ElasticSearch::Reindex, content_view)
      end
    end
  end
end