defmodule TimeManagerApi.Workingtimes do
	@moduledoc """
	The Workingtimes context.
	"""

	import Ecto.Query, warn: false
	alias TimeManagerApi.Repo
	alias TimeManagerApi.Workingtimes.WorkingTime

	@doc """
	Returns the list of workingtimes for a given user_id.
	"""
	def list_workingtimes_by_user(user_id, params \\ %{}) do
		query = from w in WorkingTime, where: w.user_id == ^user_id
		query = maybe_filter_start(query, params)
		query = maybe_filter_end(query, params)
		Repo.all(query)
	end

	defp maybe_filter_start(query, %{"start" => start}) when is_binary(start) do
		from w in query, where: w.start >= ^parse_datetime(start)
	end
	defp maybe_filter_start(query, _), do: query

	defp maybe_filter_end(query, %{"end" => endd}) when is_binary(endd) do
		from w in query, where: w.end <= ^parse_datetime(endd)
	end
	defp maybe_filter_end(query, _), do: query

	# Helper to parse ISO8601 datetime string
	defp parse_datetime(str) do
		case DateTime.from_iso8601(str) do
			{:ok, dt, _} -> dt
			_ -> raise ArgumentError, "Invalid datetime format: #{str}"
		end
	end

	@doc """
	Returns the list of workingtimes.
	"""
	def list_workingtimes do
		Repo.all(WorkingTime)
	end

	@doc """
	Gets a single working_time.
	"""
	def get_working_time!(id), do: Repo.get!(WorkingTime, id)

	@doc """
	Creates a working_time.
	"""
	def create_working_time(attrs) do
		%WorkingTime{}
		|> WorkingTime.changeset(attrs)
		|> Repo.insert()
	end

	@doc """
	Updates a working_time.
	"""
	def update_working_time(%WorkingTime{} = working_time, attrs) do
		working_time
		|> WorkingTime.changeset(attrs)
		|> Repo.update()
	end

	@doc """
	Deletes a working_time.
	"""
	def delete_working_time(%WorkingTime{} = working_time) do
		Repo.delete(working_time)
	end

	@doc """
	Returns an `%Ecto.Changeset{}` for tracking working_time changes.
	"""
	def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
		WorkingTime.changeset(working_time, attrs)
	end
end
