class MoveApplicantsToNewUsers < ActiveRecord::Migration
  def up
    applicant_role = ::UserRole.create(name: 'applicant')

    # Add the applicants to the new users table
    execute <<-SQL
      INSERT INTO new_users(email, name, location, user_role_id, archived, created_at, updated_at)
      SELECT email, name, location, #{applicant_role.id}, archived, now(), now()
      FROM applicants
    SQL

    # The applicants have an applied on date, so add a filled application form for them
    execute <<-SQL
      INSERT INTO filled_forms(applicant_id, filler_id, form_type, created_at, updated_at)
      SELECT new_users.id, new_users.id, 'application', applicants.applied_on, applicants.applied_on
      FROM applicants
      JOIN new_users ON new_users.email = applicants.email
    SQL

    # Add the base application fields
    field_ids = execute <<-SQL
      INSERT INTO fields(name, form_type, has_choices)
      VALUES('Website', 'application', false),
            ('Preferred Location', 'application', true),
            ('Position', 'application', true),
            ('Skill Level', 'application', true),
            ('Tell us about yourself', 'application', false),
            ('Why do you love building software', 'application', false),
            ('Why do you want to work here?', 'application', false),
            ('Code School', 'application', true),
            ('College Degree', 'application', true),
            ('CS Degree', 'application', true),
            ('Worked as Dev', 'application', true)
      RETURNING id
    SQL

    field_ids = field_ids.map { |field_id| field_id['id'] }

    # Add choices for the applicable fields
    execute <<-SQL
      INSERT INTO field_choices(name, field_id)
      VALUES('Chicago', #{field_ids[1]}),
            ('London', #{field_ids[1]}),
            ('Los Angeles', #{field_ids[1]}),
            ('Developer', #{field_ids[2]}),
            ('Designer', #{field_ids[2]}),
            ('10+ years', #{field_ids[3]}),
            ('2-9 years', #{field_ids[3]}),
            ('2 years or less', #{field_ids[3]}),
            ('None', #{field_ids[7]}),
            ('App Academy', #{field_ids[7]}),
            ('Bitmaker Labs', #{field_ids[7]}),
            ('Dev Bootcamp', #{field_ids[7]}),
            ('General Assembly', #{field_ids[7]}),
            ('Google SOC', #{field_ids[7]}),
            ('HackBright', #{field_ids[7]}),
            ('Hacker School', #{field_ids[7]}),
            ('Launch Academy', #{field_ids[7]}),
            ('Makers Academy', #{field_ids[7]}),
            ('Mobile Makers', #{field_ids[7]}),
            ('Start Up Institute', #{field_ids[7]}),
            ('Starter League', #{field_ids[7]}),
            ('None', #{field_ids[8]}),
            ('Yes', #{field_ids[8]}),
            ('No', #{field_ids[8]}),
            ('None', #{field_ids[9]}),
            ('Yes', #{field_ids[9]}),
            ('No', #{field_ids[9]}),
            ('None', #{field_ids[10]}),
            ('Yes', #{field_ids[10]}),
            ('No', #{field_ids[10]})
    SQL

    field_map = {
      website: field_ids[0],
      location: field_ids[1],
      discipline: field_ids[2],
      skill_level: field_ids[3],
      about: field_ids[4],
      software_interest: field_ids[5],
      reason: field_ids[6],
      codeschool: field_ids[7],
      college_degree: field_ids[8],
      cs_degree: field_ids[9],
      worked_as_dev: field_ids[10]
    }

    applicants = ::Applicant.find_by_sql <<-SQL
      SELECT applicants.*, new_users.id AS new_user_id, filled_forms.id AS filled_form_id
      FROM applicants
      JOIN new_users ON applicants.email = new_users.email
      JOIN filled_forms ON new_users.id = filled_forms.applicant_id
    SQL

    answers = applicants.map do |applicant|
      [
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:website],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.url
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:location],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:location]} AND name ILIKE '#{applicant.location}'").first[:id],
          answer_text: nil
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:discipline],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:discipline]} AND name ILIKE '#{applicant.discipline}'").first[:id],
          answer_text: nil
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:skill_level],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:skill_level]} AND name ILIKE '#{applicant.skill}'").first[:id],
          answer_text: nil
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:about],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.about
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:software_interest],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.software_interest
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:reason],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.reason
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:codeschool],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:codeschool]} AND name ILIKE '#{applicant.codeschool}'").first[:id],
          answer_text: nil
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:college_degree],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:college_degree]} AND name ILIKE '#{applicant.college_degree}'").first[:id],
          answer_text: nil
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:cs_degree],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:cs_degree]} AND name ILIKE '#{applicant.cs_degree}'").first[:id],
          answer_text: nil
        },
        {
          user_id: applicant.new_user_id,
          field_id: field_map[:worked_as_dev],
          filled_form_id: applicant.filled_form_id,
          field_choice_id: execute("SELECT id FROM field_choices WHERE field_id = #{field_map[:worked_as_dev]} AND name ILIKE '#{applicant.worked_as_dev}'").first[:id],
          answer_text: nil
        }
      ].select { |answer| answer[:field_choice_id].present? || answer[:answer_text].present? }
    end.flatten

    ::Answer.create(answers)
  end

  def down
  end
end
