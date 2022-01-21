defmodule GithubDriverTest do
    use ExUnit.Case
    doctest Tomfur.Projects.GithubDriver

    alias Tomfur.Projects.GithubDriver

    test "test to see auth working" do
        {status, _} = GithubDriver.authUser("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")
        assert status == :ok
    end

    test "Genserver Working" do
        GithubDriver.start_link("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")
        status = GenServer.call(GithubDriver, :projects)
        assert status == :ok
    end

end
