# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

gem 'mocha'
require 'mocha'

def create_test_data
  # Create custom fields
  CMI::Loaders::CreateData.load
  field_date_start_planned = ProjectCustomField.find_by_name(DEFAULT_VALUES["date_start_planned"]).id
  field_date_end_planned = ProjectCustomField.find_by_name(DEFAULT_VALUES["date_end_planned"]).id
  field_date_start_real = ProjectCustomField.find_by_name(DEFAULT_VALUES["date_start_real"]).id
  field_quality_meets_planned = ProjectCustomField.find_by_name(DEFAULT_VALUES["quality_meets_planned"]).id
  field_accepted_quantity = ProjectCustomField.find_by_name(DEFAULT_VALUES["project_accepted_field"]).id
  field_project_group = ProjectCustomField.find_by_name(DEFAULT_VALUES["project_group_field"]).id
  field_effort_JP = ProjectCustomField.find_by_name(DEFAULT_VALUES['effort'].gsub('{{type}}',
                                                    DEFAULT_VALUES['expected']).gsub('{{profile}}', 'JP')).id
  field_effort_AF = ProjectCustomField.find_by_name(DEFAULT_VALUES['effort'].gsub('{{type}}',
                                                    DEFAULT_VALUES['expected']).gsub('{{profile}}', 'AF')).id
  field_effort_AP = ProjectCustomField.find_by_name(DEFAULT_VALUES['effort'].gsub('{{type}}',
                                                    DEFAULT_VALUES['expected']).gsub('{{profile}}', 'AP')).id
  field_effort_PS = ProjectCustomField.find_by_name(DEFAULT_VALUES['effort'].gsub('{{type}}',
                                                    DEFAULT_VALUES['expected']).gsub('{{profile}}', 'PS')).id
  field_effort_PJ = ProjectCustomField.find_by_name(DEFAULT_VALUES['effort'].gsub('{{type}}',
                                                    DEFAULT_VALUES['expected']).gsub('{{profile}}', 'PJ')).id
  field_effort_B = ProjectCustomField.find_by_name(DEFAULT_VALUES['effort'].gsub('{{type}}',
                                                   DEFAULT_VALUES['expected']).gsub('{{profile}}', 'B')).id
  status_closed = IssueStatus.find_by_name(DEFAULT_VALUES["issue_status"]["closed"]).id
  field_report_date_end_planned = IssueCustomField.find_by_name(DEFAULT_VALUES["expected_date_end"]).id
  field_report_quality_meets_done = IssueCustomField.find_by_name(DEFAULT_VALUES["quality_meets_done"]).id
  field_report_effort_JP = IssueCustomField.find_by_name(
    DEFAULT_VALUES['report_role_current_effort_planned_field'].gsub('{{role}}', 'JP')).id
  field_report_effort_AF = IssueCustomField.find_by_name(
    DEFAULT_VALUES['report_role_current_effort_planned_field'].gsub('{{role}}', 'AF')).id
  field_report_effort_AP = IssueCustomField.find_by_name(
    DEFAULT_VALUES['report_role_current_effort_planned_field'].gsub('{{role}}', 'AP')).id
  field_report_effort_PS = IssueCustomField.find_by_name(
    DEFAULT_VALUES['report_role_current_effort_planned_field'].gsub('{{role}}', 'PS')).id
  field_report_effort_PJ = IssueCustomField.find_by_name(
    DEFAULT_VALUES['report_role_current_effort_planned_field'].gsub('{{role}}', 'PJ')).id
  field_report_effort_B = IssueCustomField.find_by_name(
    DEFAULT_VALUES['report_role_current_effort_planned_field'].gsub('{{role}}', 'B')).id
  field_user_role = UserCustomField.find_by_name(DEFAULT_VALUES["user_role_field"]).id
  tracker_reports = Tracker.find_by_name(DEFAULT_VALUES["trackers"]["report"]).id
  tracker_bugs = Tracker.find_by_name(DEFAULT_VALUES["trackers"]["bug"]).id
  tracker_features = Tracker.find_by_name(DEFAULT_VALUES["trackers"]["feature"]).id
  # Profile cost info
  HistoryProfilesCost.new(:profile => "JP", :year => 2011, :value => 30).save!
  HistoryProfilesCost.new(:profile => "AF", :year => 2011, :value => 25).save!
  HistoryProfilesCost.new(:profile => "AP", :year => 2011, :value => 20).save!
  HistoryProfilesCost.new(:profile => "PS", :year => 2011, :value => 15).save!
  HistoryProfilesCost.new(:profile => "PJ", :year => 2011, :value => 10).save!
  HistoryProfilesCost.new(:profile => "B", :year => 2011, :value => 5).save!
  # Some users
  Time.stubs(:now).returns(Time.mktime(2011, 1, 1))
  jp = User.new(:firstname => "John",
                :lastname => "Doe",
                :language => "en",
                :admin => false,
                :mail => "jp@example.com",
                :custom_field_values => { field_user_role => "JP" })
  jp.login = "jp"
  jp.save!
  af = User.new(:firstname => "Mike",
                :lastname => "Af",
                :language => "en",
                :admin => false,
                :mail => "af@example.com",
                :custom_field_values => { field_user_role => "AF" })
  af.login = "af"
  af.save!
  ap = User.new(:firstname => "John",
                :lastname => "Ap",
                :language => "en",
                :admin => false,
                :mail => "ap@example.com",
                :custom_field_values => { field_user_role => "AP" })
  ap.login = "ap"
  ap.save!
  ps = User.new(:firstname => "John",
                :lastname => "Ps",
                :language => "en",
                :admin => false,
                :mail => "ps@example.com",
                :custom_field_values => { field_user_role => "PS" })
  ps.login = "ps"
  ps.save!
  pj = User.new(:firstname => "John",
                :lastname => "Pj",
                :language => "en",
                :admin => false,
                :mail => "pj@example.com",
                :custom_field_values => { field_user_role => "PJ" })
  pj.login = "pj"
  pj.save!
  b = User.new(:firstname => "John",
               :lastname => "B",
               :language => "en",
               :admin => false,
               :mail => "b@example.com",
               :custom_field_values => { field_user_role => "B" })
  b.login = "b"
  b.save!
  nonmember = User.new(:firstname => "Not",
                       :lastname => "Member",
                       :language => "en",
                       :admin => false,
                       :mail => "nonmember@example.com",
                       :custom_field_values => { field_user_role => "AF" })
  nonmember.login = "nonmember"
  nonmember.save!
  # Roles
  cmirole = Role.new(:name => "cmi", :permissions => [:view_metrics])
  cmirole.save!
  Role.new(:name => "other", :permissions => []).save!
  # A project...
  Project.destroy_all
  p = Project.new(:id         => 1,
                  :identifier => "cmi",
                  :name       => "CMI test",
                  :is_public  => false,
                  :enabled_module_names => ["issue_tracking", "time_tracking", "cmiplugin"],
                  :custom_field_values => {
                    field_date_start_planned    => "2011-01-01",
                    field_date_end_planned      => "2011-07-01",
                    field_date_start_real       => "2011-02-01",
                    field_quality_meets_planned => "3",
                    field_accepted_quantity     => "123456",
                    field_project_group         => "Otros",
                    field_effort_JP             => "100",
                    field_effort_AF             => "200",
                    field_effort_AP             => "300",
                    field_effort_PS             => "400",
                    field_effort_PJ             => "500",
                    field_effort_B              => "600"
                  })
  p.save!
  # Needed trackers
  p.tracker_ids = [tracker_bugs,
                tracker_features,
                Tracker.find_by_name(DEFAULT_VALUES["trackers"]["change"]).id,
                Tracker.find_by_name(DEFAULT_VALUES["trackers"]["qa"]).id,
                Tracker.find_by_name(DEFAULT_VALUES["trackers"]["risk"]).id,
                Tracker.find_by_name(DEFAULT_VALUES["trackers"]["incidence"]).id,
                Tracker.find_by_name(DEFAULT_VALUES["trackers"]["expense"]).id,
                tracker_reports]
  # Members
  [jp, af, ap, ps, pj, b].each do |user|
    m = Member.new(:user =>    user,
                   :roles =>   [cmirole],
                   :project => p).save!
  end
  # Reports
  r = Issue.new(:project => p,
                :author => jp,
                :tracker_id => tracker_reports,
                :subject    => "Report upto 2/15",
                :start_date => "2011-02-15",
                :status_id  => status_closed)
  r.custom_field_values = { # For some reason it fails if I pass it as a hash to create
                     field_report_date_end_planned   => "2011-07-01",
                     field_report_quality_meets_done => "0",
                     field_report_effort_JP          => "100",
                     field_report_effort_AF          => "300",
                     field_report_effort_AP          => "500",
                     field_report_effort_PS          => "1000",
                     field_report_effort_PJ          => "800",
                     field_report_effort_B           => "600"
                   }
  r.save!
  r = Issue.new(:project => p,
                :author => jp,
                :tracker_id => tracker_reports,
                :subject    => "Report upto 3/15",
                :start_date => "2011-03-15",
                :status_id  => status_closed)
  r.custom_field_values = { # For some reason it fails if I pass it as a hash to create
                     field_report_date_end_planned   => "2011-08-01",
                     field_report_quality_meets_done => "1",
                     field_report_effort_JP          => "150",
                     field_report_effort_AF          => "400",
                     field_report_effort_AP          => "600",
                     field_report_effort_PS          => "1200",
                     field_report_effort_PJ          => "1000",
                     field_report_effort_B           => "600"
                   }
  r.save!
  # Issues
  10.times do |i|
    Issue.new(:project => p,
              :author => jp,
              :tracker_id => tracker_features,
              :subject => "Feature #{i}",
              :status_id => status_closed).save!
  end
  3.times do |i|
    Issue.new(:project => p,
              :author => jp,
              :tracker_id => tracker_bugs,
              :subject => "Bug #{i}",
              :status_id => status_closed).save!
  end
  # Time entries
  Date.new(2011,1,1).upto(Date.new(2011,7,1)) do |date|
    wday = Date::DAYNAMES[date.wday]
    next if ["Saturday", "Sunday"].include?(wday)
    if wday == "Monday"
      # JPs rarely work
      TimeEntry.new(:project => p,
                    :user => jp,
                    :issue => Issue.first(:conditions => ["tracker_id IN (?, ?)",
                                          tracker_features, tracker_bugs ]),
                    :spent_on => date,
                    :activity => TimeEntryActivity.first,
                    :hours => 4).save!
    end
    TimeEntry.new(:project => p,
                  :user => af,
                  :issue => Issue.first(:conditions => ["tracker_id IN (?, ?)",
                                        tracker_features, tracker_bugs ]),
                  :spent_on => date,
                  :activity => TimeEntryActivity.first,
                  :hours => 2.5).save!
    TimeEntry.new(:project => p,
                  :user => ap,
                  :issue => Issue.first(:conditions => ["tracker_id IN (?, ?)",
                                        tracker_features, tracker_bugs ]),
                  :spent_on => date,
                  :activity => TimeEntryActivity.first,
                  :hours => 4).save!
    TimeEntry.new(:project => p,
                  :user => ps,
                  :issue => Issue.first(:conditions => ["tracker_id IN (?, ?)",
                                        tracker_features, tracker_bugs ]),
                  :spent_on => date,
                  :activity => TimeEntryActivity.first,
                  :hours => 8).save!
    TimeEntry.new(:project => p,
                  :user => pj,
                  :issue => Issue.first(:conditions => ["tracker_id IN (?, ?)",
                                        tracker_features, tracker_bugs ]),
                  :spent_on => date,
                  :activity => TimeEntryActivity.first,
                  :hours => 7).save!
    TimeEntry.new(:project => p,
                  :user => b,
                  :issue => Issue.first(:conditions => ["tracker_id IN (?, ?)",
                                        tracker_features, tracker_bugs ]),
                  :spent_on => date,
                  :activity => TimeEntryActivity.first,
                  :hours => 5).save!
  end
  # TODO add some qa, risk, incidence, expense
end
