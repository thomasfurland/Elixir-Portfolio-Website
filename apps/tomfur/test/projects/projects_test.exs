defmodule ProjectsTest do
    use ExUnit.Case
    doctest Tomfur.Projects

    alias Tomfur.Projects

    setup do
        [
            raw_projects: [
                %{
                    "id" => "1",
                    "full_name" => "testrepo/test-project",
                    "svn_url" => "",
                    "description" => "",
                    "homepage" => "",
                    "updated_at" => "2022-01-13T03:02:31Z",
                    "topics" => ["portfolio", "demo"]
                },
                %{
                    "id" => "2",
                    "full_name" => "testrepo/test_project",
                    "svn_url" => "",
                    "description" => "",
                    "homepage" => "",
                    "updated_at" => "2022-01-15T03:02:31Z",
                    "topics" => ["portfolio"]
                },
                %{
                    "id" => "3",
                    "full_name" => "testrepo/TEST-PROJECT",
                    "svn_url" => "",
                    "description" => "",
                    "homepage" => "",
                    "updated_at" => "2022-01-14T03:02:31Z",
                    "topics" => ["portfolio"]
                },
                %{
                    "id" => "4",
                    "full_name" => "testrepo/test-project",
                    "svn_url" => "",
                    "description" => "",
                    "homepage" => "",
                    "updated_at" => "2022-01-16T03:02:31Z",
                    "topics" => []
                },
                %{
                    "id" => "0",
                    "full_name" => "testrepo/TEST_PROJECT",
                    "svn_url" => "",
                    "description" => "",
                    "homepage" => "",
                    "updated_at" => "2022-01-16T03:02:31Z",
                    "topics" => ["portfolio", "demo"]
                }
            ],
            count: 4,
            order: ["0","1","2","3"],
            project_name: "Test Project"
        ]
    end

    test "only projects with portfolio tag processed", fixture do
        p = Projects.process_projects(fixture.raw_projects)
        assert(Enum.count(p) == fixture.count)
    end

    test "project order follows demo(t/f) > last_updated(desc) correctly", fixture do
        p = Projects.process_projects(fixture.raw_projects)
        result_order = Enum.map(p, &(&1.id))
        assert(result_order == fixture.order)
    end

    test "project names formatted with Capitalization, removes hyphen, underscore and repo name", fixture do
        p = Projects.process_projects(fixture.raw_projects)
        Enum.map(p, &(assert(&1.name == fixture.project_name)))
    end

end
