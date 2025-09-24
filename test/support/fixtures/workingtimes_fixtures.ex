defmodule TimeManagerApi.WorkingtimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Workingtimes` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2025-09-23 10:15:00Z],
        start: ~U[2025-09-23 10:15:00Z]
      })
      |> TimeManagerApi.Workingtimes.create_working_time()

    working_time
  end
end
