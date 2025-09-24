defmodule TimeManagerApi.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2025-09-23 10:15:00Z]
      })
      |> TimeManagerApi.Clocks.create_clock()

    clock
  end
end
